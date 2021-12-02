defmodule Aoc2021.Day2 do

  def split_input_by_spaces(list), do: Enum.map(list, &String.split(&1, " ", trim: true)) 

  def part1(pathname) do
    {x, y} = Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> split_input_by_spaces
    |> convert_course_numbers_to_integers
    |> commence_submarine_swim
    x * y
  end

  def part2(pathname) do
    {x, y} = Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    |> split_input_by_spaces
    |> convert_course_numbers_to_integers
    |> commence_aimed_submarine_swim
    x * y
  end

  defp convert_course_numbers_to_integers(list) do
    Enum.map(list, fn [x, y] -> [x, String.to_integer(y)] end)
  end

  defp commence_submarine_swim(course), do: swim(0, 0, course)

  defp swim(x, y, []), do: {x, y}
  defp swim(x, y, [["forward", n] | course]), do: swim(x + n, y, course)
  defp swim(x, y, [["up", n] | course]), do: swim(x, y - n, course)
  defp swim(x, y, [["down", n] | course]), do: swim(x, y + n, course)

  defp commence_aimed_submarine_swim(course), do: aimed_swim(0, 0, 0, course)

  defp aimed_swim(x, y, _, []), do: {x, y}
  defp aimed_swim(x, y, d, [["forward", n] | course]) do
    aimed_swim(x + n, y + (d * n), d, course)
  end
  defp aimed_swim(x, y, d, [["up", n] | course]) do
    aimed_swim(x, y, d - n, course)
  end
  defp aimed_swim(x, y, d, [["down", n] | course]) do
    aimed_swim(x, y, d + n, course)
  end
end
