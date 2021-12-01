defmodule Aoc2021 do
  @moduledoc """
  Documentation for `Aoc2021`.
  """

  @doc """
  Common redistributables between the days.
  """

  def read_file(pathname) do
    IO.puts(pathname)
    {:ok, contents} = File.read(pathname)
    contents
  end

  def split_lines(data), do: data |> String.split("\n", trim: true)

  def print_list([]), do: IO.puts("Empty")
  def print_list(list), do: Enum.each(list, fn x -> IO.puts(x) end)

  def string_list_to_integer_list(list), do: Enum.map(list, &String.to_integer/1)


end
