defmodule Toksomanio.IntegrationTest do
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
    input = FileSupport.read_and_decode("input")
    expected_output = FileSupport.read_and_decode("output")

    result = conn(:post, "/api/tasks", input)
             |> put_req_header("accept", "application/json")
             |> Router.call(@opts)

    assert result.state == :sent
    assert result.status == 200
    assert Poison.decode!(result.resp_body) == expected_output
  end

  test "it establishes the execution order given a json input and returns a text" do
    input = FileSupport.read_and_decode("input")
    expected_output = FileSupport.read("output", "text")

    result = conn(:post, "/api/tasks", input)
             |> put_req_header("accept", "text/plain")
             |> Router.call(@opts)

    assert result.state == :sent
    assert result.status == 200
    assert result.resp_body == expected_output
  end

  test "it returns an error if there's a circular dependency when its text" do
    input = FileSupport.read_and_decode("circular_dependencies_input")
    expected_output = FileSupport.read("output_error", "text")

    result = conn(:post, "/api/tasks", input)
             |> put_req_header("accept", "text/plain")
             |> Router.call(@opts)

    assert result.state == :sent
    assert result.status == 422
    assert result.resp_body == expected_output
  end

  test "it returns an error if there's a circular dependency" do
    input = FileSupport.read_and_decode("circular_dependencies_input")
    expected_output = FileSupport.read_and_decode("error")

    result = conn(:post, "/api/tasks", input)
             |> put_req_header("accept", "application/json")
             |> Router.call(@opts)

    assert result.state == :sent
    assert result.status == 422
    assert Poison.decode!(result.resp_body) == expected_output
  end


  test "it not acceptable when its a unknown data type" do
    input = FileSupport.read_and_decode("input")

    result = conn(:post, "/api/tasks", input)
             |> put_req_header("accept", "text/klingon")
             |> Router.call(@opts)

    assert result.state == :sent
    assert result.status == 406
    assert result.resp_body == "Not acceptable"
  end
end
