use crate::atoms;
use rustler::{Atom, Encoder, Env, NifStruct, OwnedEnv, ResourceArc, Term};
use std::sync::{Arc, Mutex};
use std::thread;
use tiny_http::{Method, Request, Response, Server};

#[derive(NifStruct)]
#[module = "Tinybeam.Server.Config"]
pub struct Config {
    host: String,
}

struct ReqRef(Mutex<Option<Request>>);

#[derive(NifStruct)]
#[module = "Tinybeam.Server.Request"]
pub struct Req {
    req_ref: ResourceArc<ReqRef>,
    method: Atom,
}

#[derive(NifStruct)]
#[module = "Tinybeam.Server.Response"]
pub struct Resp {
    req_ref: ResourceArc<ReqRef>,
    body: String,
}

pub fn load(env: Env, _: Term) -> bool {
    rustler::resource!(ReqRef, env);
    true
}

#[rustler::nif()]
pub fn start(env: Env, config: Config) -> Atom {
    let server = Server::http(config.host).unwrap();
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
                let method = request.method().as_atom();

                let req = Req {
                    req_ref: ResourceArc::new(ReqRef(Mutex::new(Some(request)))),
                    method: method,
                };

                msg_env.send_and_clear(&pid, |env| (atoms::request(), req).encode(env));
            });

            guards.push(guard);
        }
    });

    println!("Server started, listening on port {:?}", addr);
    atoms::ok()
}

#[rustler::nif]
pub fn handle_request(response: Resp) -> Atom {
    let mut request_ref = response.req_ref.0.lock().unwrap();
    let payload = Response::from_string(response.body);

    if let Some(request) = request_ref.take() {
        let _res = request.respond(payload);
    }

    atoms::ok()
}

trait AsAtom {
    fn as_atom(&self) -> Atom;
}

impl AsAtom for Method {
    fn as_atom(&self) -> Atom {
        match self {
            Method::Get => atoms::get(),
            Method::Head => atoms::head(),
            Method::Post => atoms::post(),
            Method::Put => atoms::put(),
            Method::Delete => atoms::delete(),
            Method::Connect => atoms::connect(),
            Method::Options => atoms::options(),
            Method::Trace => atoms::trace(),
            Method::Patch => atoms::patch(),
            _ => atoms::non_standard(),
        }
    }
}
