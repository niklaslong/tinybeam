use crate::atoms;
use rustler::{Atom, Encoder, Env, NifStruct, NifTuple, OwnedEnv, ResourceArc, Term};
use std::io::Cursor;
use std::sync::{Arc, Mutex};
use std::{iter::Iterator, thread};
use tiny_http::{Header, Method, Request, Response, Server, StatusCode};

#[derive(NifStruct)]
#[module = "Tinybeam.Server.Config"]
pub struct Config {
    host: String,
}

#[derive(NifStruct)]
#[module = "Tinybeam.Server.Request"]
pub struct Req {
    req_ref: ResourceArc<ReqRef>,
    method: Atom,
    path: String,
    headers: Vec<Head>,
    content: String,
}

#[derive(NifStruct)]
#[module = "Tinybeam.Server.Response"]
pub struct Resp {
    req_ref: ResourceArc<ReqRef>,
    status_code: u16,
    headers: Vec<Head>,
    body: String,
}

struct ReqRef(Mutex<Option<Request>>);

#[derive(NifTuple)]
struct Head {
    field: String,
    value: String,
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
        let pool_size = 10;
        let mut guards = Vec::with_capacity(pool_size);

        for _ in 0..pool_size {
            let pid = Arc::clone(&pid);
            let server = server.clone();

            let guard = thread::spawn(move || loop {
                let mut msg_env = OwnedEnv::new();
                let mut request = server.recv().unwrap();
                let method = request.method().as_atom();
                let path = request.url().to_string();

                let mut headers = Vec::new();

                for h in request.headers().iter() {
                    let header = Head {
                        field: h.field.to_string(),
                        value: h.value.to_string(),
                    };

                    headers.push(header);
                }

                let mut content = String::new();
                request.as_reader().read_to_string(&mut content).unwrap();

                let req = Req {
                    req_ref: ResourceArc::new(ReqRef(Mutex::new(Some(request)))),
                    method: method,
                    path: path,
                    headers: headers,
                    content: content,
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
pub fn handle_request(resp: Resp) -> Atom {
    let mut request_ref = resp.req_ref.0.lock().unwrap();
    let mut headers = Vec::new();

    for h in resp.headers.iter() {
        let field = h.field.as_bytes();
        let value = h.value.as_bytes();

        let header = Header::from_bytes(field, value).unwrap();
        headers.push(header);
    }

    let data: String = resp.body.into();
    let data_len = data.len();

    let response = Response::new(
        StatusCode(resp.status_code),
        headers,
        Cursor::new(data.into_bytes()),
        Some(data_len),
        None,
    );

    if let Some(request) = request_ref.take() {
        let _res = request.respond(response);
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
