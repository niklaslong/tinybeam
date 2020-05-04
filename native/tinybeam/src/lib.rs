mod atoms;
mod server;

rustler::init!(
    "Elixir.Tinybeam.Native",
    [
      server::start, 
      server::request_listener,
      server::handle_request
      ],
    load = server::load
);
