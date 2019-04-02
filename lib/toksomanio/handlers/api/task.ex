defmodule Toksomanio.Handlers.Api.Task do
  def call(params, ["text/plain"]) do
    {200, "test"}
  end

  def call(params, ["application/json"]) do
    {200, "test"}
  end

  def call(params, _unknown) do
    {406, "Not acceptable"}
  end
end
