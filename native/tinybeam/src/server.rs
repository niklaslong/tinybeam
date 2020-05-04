use crate::atoms;
use rustler::{Atom, Env, NifMap, ResourceArc, Term};
use std::sync::{Arc, Mutex, RwLock};
use std::thread;
use tiny_http::{Server, Response, Request};

struct ServerRef {
    server: Server,
}

struct ReqRef {
  request: Mutex<Option<Request>>,
}

pub fn load(env: Env, _: Term) -> bool {
    rustler::resource!(ServerRef, env);
    rustler::resource!(ReqRef, env);
    true
}

#[rustler::nif()]
fn start() -> ResourceArc<ServerRef> {
    let server = Server::http("127.0.0.1:8000").unwrap();
    let addr = server.server_addr();

    println!("Server started, listening on port {:?}", addr);

    let server_ref = ResourceArc::new(ServerRef { server: server });
    server_ref
}

#[rustler::nif()]
fn start_request_listener(server_ref: ResourceArc<ServerRef>) -> ResourceArc<ReqRef> {
    let server = &server_ref.server;
    let request = server.recv().unwrap();

    let req_ref = ResourceArc::new(ReqRef{request: Mutex::new(Some(request))});
    req_ref
}

#[rustler::nif]
fn handle_request(request_ref: ResourceArc<ReqRef>, response: String) -> Atom {
  let mut request_ref = request_ref.request.lock().unwrap();
  let response = Response::from_string(response);
    
    if let Some(request) = request_ref.take()  {
      let _res = request.respond(response); 
    }

    atoms::ok()
}
