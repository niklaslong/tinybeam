ExUnit.start()

defmodule Tinybeam.TestRouter do
  use Tinybeam.Router

  get "/get", do: Response.new(request.req_ref, 200, "yay", [{"Content-Type", "text/plain"}])

  post "/post",
    do: Response.new(request.req_ref, 201, request.content, [{"Content-Type", "text/plain"}])
end
