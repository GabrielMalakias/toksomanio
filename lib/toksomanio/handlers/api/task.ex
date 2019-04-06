defmodule Toksomanio.Handlers.Api.Task do

  alias Toksomanio.Handlers.Api.Task.TSort, as: TopologicalSort
  alias Toksomanio.Handlers.Api.Task.Sort, as: Sort
  alias Toksomanio.Presenters.Task.Json, as: JsonPresenter
  alias Toksomanio.Presenters.Task.Text, as: TextPresenter

  def call(params, ["text/plain"]) do
    result = params["tasks"]
    |> tsort()
    |> sort(params["tasks"])
    |> to_text()
  end

  def call(params, ["application/json"]) do
    result = params["tasks"]
    |> tsort()
    |> sort(params["tasks"])
    |> to_json
  end

  def call(params, _unknown) do
    {406, "Not acceptable"}
  end


  defp to_text(:error) do
    body = TextPresenter.error

    {422, body}
  end

  defp to_text(tasks) do
    body = TextPresenter.call(tasks)

    {200, body}
  end

  defp to_json(:error) do
    body = JsonPresenter.error

    {422, body}
  end

  defp to_json(tasks) do
    body = JsonPresenter.call(tasks)

    {200, body}
  end

  defp tsort(tasks) do
    TopologicalSort.apply(tasks)
  end

  defp sort({:error, tasks}, input), do: :error

  defp sort({:ok, tasks}, input) do
    Sort.apply(tasks, input)
  end
end
