defmodule Toksomanio.Support.File do
  @moduledoc """
  This modules defines a easier way to read mocks which can be used on tests
  """
  def read(file_name) do
    file_path = "#{:code.priv_dir(:toksomanio)}/mocks/#{file_name}.json"

    File.read!(file_path)
  end

  def read(file_name, extension) do
    file_path = "#{:code.priv_dir(:toksomanio)}/mocks/#{file_name}.#{extension}"

    File.read!(file_path)
  end

  def read_and_decode(file_name) do
    file_name
    |> read()
    |> Poison.decode!()
  end
end
