ExUnit.start()

defmodule Tinybeam.TestRouter do
  use Tinybeam.Router

  get "/", do: Response.new(request.req_ref, 200, "yay", [{"Content-Type", "text/plain"}])
end
