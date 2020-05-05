use crate::atoms;
use rustler::{Atom, Encoder, Env, OwnedEnv, ResourceArc, Term};
use std::sync::{Arc, Mutex};
use std::thread;
use tiny_http::{Request, Response, Server};

struct ReqRef {
    request: Mutex<Option<Request>>,
}

pub fn load(env: Env, _: Term) -> bool {
    rustler::resource!(ReqRef, env);
    true
}

#[rustler::nif()]
fn start(env: Env, _term: Term) -> Atom {
    let server = Server::http("127.0.0.1:8000").unwrap();
    let addr = server.server_addr();
    let pid = Arc::new(env.pid());

    std::thread::spawn(move || {
        let server = Arc::new(server);
        let mut guards = Vec::with_capacity(4);

        for _ in 0..10 {
            let pid = Arc::clone(&pid);
            let server = server.clone();

            let guard = thread::spawn(move || loop {
                let mut msg_env = OwnedEnv::new();
                let request = server.recv().unwrap();

                let req_ref = ResourceArc::new(ReqRef {
                    request: Mutex::new(Some(request)),
                });

                msg_env.send_and_clear(&pid, |env| (atoms::hi(), req_ref).encode(env));
            });

            guards.push(guard);
        }
    });

    println!("Server started, listening on port {:?}", addr);
    atoms::ok()
}

#[rustler::nif]
fn handle_request(request_ref: ResourceArc<ReqRef>, response: String) -> Atom {
    let mut request_ref = request_ref.request.lock().unwrap();
    let response = Response::from_string(response);

    if let Some(request) = request_ref.take() {
        let _res = request.respond(response);
    }

    atoms::ok()
}
