defmodule Toksomanio.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Toksomanio.Router
  alias Toksomanio.Support.File, as: FileSupport

  @opts Toksomanio.Router.init([])

  test "it returns hello" do
    conn = conn(:get, "/")

    result = Router.call(conn, @opts)

    assert result.state == :sent
    assert result.status == 200
    assert result.resp_body == "Hello from Toksomanio!"
  end

  test "it establishes the execution order given a json input and returns a json" do
    input = FileSupport.read("input")
    expected_output = FileSupport.read_and_decode("output")

    result = conn(:post, "/api/tasks", input)
             |> put_req_header("accept", "application/json")
             |> Router.call(@opts)

    assert result.state == :sent
    assert result.status == 200
    assert result.resp_body == expected_output
  end

  test "it establishes the execution order given a json input and returns a text" do
    input = FileSupport.read("input")
    expected_output = FileSupport.read("output", "text")

    result = conn(:post, "/api/tasks", input)
             |> put_req_header("accept", "text/plain")
             |> Router.call(@opts)

    assert result.state == :sent
    assert result.status == 200
    assert result.resp_body == expected_output
  end
end
