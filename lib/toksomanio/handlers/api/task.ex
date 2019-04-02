defmodule Toksomanio.Handlers.Api.Task do
  require IEx
  def call(_params, ["text/plain"]) do
    {200, "test"}
  end

  def call(params, ["application/json"]) do
    sort(params["tasks"])

    {200, "test"}
  end

  def call(params, _unknown) do
    {406, "Not acceptable"}
  end

  defp non_dependent(commands) do
    Enum.filter(commands, fn c ->
      c["requires"] == nil
    end)
  end

  defp dependent(commands) do
    Enum.filter(commands, fn c ->
      c["requires"] != nil
    end)
  end

  def sort(commands) do
    dependent_commands = dependent(commands)
    non_dependent_commands = non_dependent(commands)

    IO.inspect(dependent_commands)
    IO.inspect(non_dependent_commands)

    sort(dependent_commands, non_dependent_commands)
  end

  def sort(remaining, executed) do
    [first | tail] = remaining

    sort(tail, [first | executed])
  end

  def sort([], executed) do
    executed
  end
end
