ExUnit.start()

defmodule Tinybeam.TestRouter do
  use Tinybeam.Router

  get "/", do: "yay"
end
