defmodule Tinybeam.Router do
  defmacro __using__(_options) do
    quote do
      import Tinybeam.Router

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

  def match(:get, "/"), do: "hi, welcome to tinybeam!"
end
