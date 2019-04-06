defmodule Toksomanio.Handlers.Api.Task.TSort do
  @base :digraph
  @utils :digraph_utils

  def apply(tasks) do
    graph = @base.new

    Enum.each(tasks, fn task ->
      add_task_to_graph(graph, task)
    end)

    if result = @utils.topsort(graph) do
      {:ok, result}
    else
      {:error, nil}
    end
  end

  defp add_task_to_graph(graph, %{"name" => name, "requires" => dependencies}) do
    add_vertex(graph, name)

    Enum.each(dependencies, fn dependency -> add_dependency(graph, name, dependency) end)
  end

  defp add_task_to_graph(graph, %{"name" => name }) do
    add_vertex(graph, name)
  end

  defp add_vertex(graph, task) do
    @base.add_vertex(graph, task)
  end

  defp add_dependency(_graph, task, task), do: :ok
  defp add_dependency(graph, task, dependency) do
    @base.add_vertex(graph, dependency)
    @base.add_edge(graph, dependency, task)
  end
end

