defmodule Toksomanio.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Hello from toksomanio!")
  end

  post "/api/tasks" do
    send_resp(conn, 200, "testing")
  end
end
