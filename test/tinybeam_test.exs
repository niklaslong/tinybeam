defmodule TinybeamTest do
  use ExUnit.Case
  alias Mint

  require IEx
  doctest Tinybeam

  test "gets a response from the server" do
    response = send_request("GET", "/")

    assert response.status == 200
    assert response.data == "yay"
  end

  defp send_request(method, path, headers \\ [], body \\ "") do
    host = Application.get_env(:tinybeam, :host)
    port = Application.get_env(:tinybeam, :port)

    {:ok, conn} = Mint.HTTP.connect(:http, host, port)
    {:ok, conn, req_ref} = Mint.HTTP.request(conn, method, path, headers, body)

    receive do
      message -> handle_response(conn, message, req_ref)
    end
  end

  defp handle_response(conn, message, req_ref) do
    {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)

    destructure = fn
      {type, ^req_ref, data} -> {type, data}
      {type, ^req_ref} -> {type, req_ref}
    end

    Map.new(responses, &destructure.(&1))
  end
end
