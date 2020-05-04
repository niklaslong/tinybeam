mod server;
mod atoms;

rustler::init!("Elixir.Tinybeam.Native", [server::start]);
