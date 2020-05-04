mod atoms;
mod server;

rustler::init!(
    "Elixir.Tinybeam.Native",
    [
      server::start, 
      server::start_request_listener,
      server::handle_request
      ],
    load = server::load
);
