defmodule Toksomanio.Presenters.Task.Text do
  def call(tasks) do
    tasks
    |> Enum.map(&format/1)
    |> append_bash_line
    |> Enum.join("\n")
  end

  def error do
    "Circular dependency error"
  end

  defp format(%{"command" => command, "name" => name}) do
    command
  end

  def append_bash_line(lines) do
    bash = "#!/usr/bin/env bash"

    [bash | lines]
  end
end
