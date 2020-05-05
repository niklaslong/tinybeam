mod atoms;
mod server;

rustler::init!(
    "Elixir.Tinybeam.Native",
    [server::start, server::handle_request],
    load = server::load
);
