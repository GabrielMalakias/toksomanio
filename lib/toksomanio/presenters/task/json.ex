defmodule Toksomanio.Presenters.Task.Json do
  def call(tasks) do
    tasks
    |> Enum.map(&format/1)
    |> Poison.encode!
  end

  def error do
    Poison.encode!(%{"error" => "Circular Dependency"})
  end

  defp format(%{"command" => command, "name" => name}) do
    %{command: command, name: name}
  end
end
