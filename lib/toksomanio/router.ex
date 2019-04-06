defmodule Toksomanio.Router do
  use Plug.Router

  plug Plug.Logger

  plug(:match)

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)

  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Hello from Toksomanio!")
  end

  post "/api/tasks" do
    params = conn.body_params
    accepts = get_req_header(conn, "accept")

    {status_code, response} =
      Toksomanio.Handlers.Api.Task.call(params, accepts)

    send_resp(conn, status_code, response)
  end
end
