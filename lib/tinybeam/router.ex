defmodule Tinybeam.Router do
  alias Tinybeam.Server.Response

  defmacro __using__(_options) do
    quote do
      import Tinybeam.Router
      alias Tinybeam.Server.Response

      def match(type, route, request) do
        do_match(type, route, request)
      end
    end
  end

  defmacro get(route, body) do
    quote do
      defp do_match(:get, unquote(route), var!(request)) do
        unquote(body[:do])
      end
    end
  end

  defmacro post(route, body) do
    quote do
      defp do_match(:post, unquote(route), var!(request)) do
        unquote(body[:do])
      end
    end
  end

  def match(:get, "/", request),
    do:
      Response.new(request.req_ref, 200, "hi, welcome to tinybeam!", [
        {"Content-Type", "text/plain"}
      ])
end
