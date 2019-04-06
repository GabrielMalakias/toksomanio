defmodule Toksomanio.Handlers.Api.Task.Sort do
  def apply({:error, _result}, _input), do: :error
  def apply(tasks, input) do
    result = Enum.reduce(tasks, [], fn name, acc ->
      [find_task(input, name) | acc]
    end)

    Enum.reverse(result)
  end

  defp find_task(tasks, name) do
    Enum.find(tasks, fn task ->
      task["name"] == name
    end)
  end
end
