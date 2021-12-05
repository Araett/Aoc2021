defmodule Aoc2021.Day4 do

  def part1(pathname) do
    input = Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    [draws | tables] = input
    draws = parse_draws(draws)
    tables = parse_tables(IO.inspect(tables))
    {table, draws} = find_first_winning_table(draws, tables, [])
    find_table_score(List.flatten(table), draws) * List.first(draws)
  end

  def part2(pathname) do
    input = Aoc2021.read_file(pathname)
    |> Aoc2021.split_lines
    [draws | tables] = input
    draws = parse_draws(draws)
    tables = parse_tables(tables)
    {table, draws} = find_last_winning_table(draws, tables)
    find_table_score(List.flatten(table), draws) * List.first(draws)
  end

  defp find_last_winning_table(draws, [table | []]), do: find_first_winning_table(draws, [table], [])
  defp find_last_winning_table(draws, tables) do
    {winning_table, _} = find_first_winning_table(draws, tables, [])
    find_last_winning_table(draws, Enum.filter(tables, fn x -> x != winning_table end))
  end

  defp find_first_winning_table([draw | draws], tables, drawn) do
    case check_tables([draw | drawn], tables, []) do
      {true, table, draws} -> {List.first(table), draws} 
      {false, _, current_draws} -> find_first_winning_table(draws, tables, [draw | current_draws])
    end
  end

  defp find_table_score(all_members, []), do: Enum.sum(all_members)
  defp find_table_score(all_members, [draw | draws]) do
    Enum.filter(all_members, fn x -> x != draw end)
    |> find_table_score(draws)
  end

  defp check_tables(draws, [], won_tables) when length(won_tables) > 0, do: {true, won_tables, draws}
  defp check_tables(draws, [], []), do: {false, [], draws}
  defp check_tables(draws, [table | tables], won_tables) do
    case did_table_win?(table, draws) do
      true -> check_tables(draws, tables, [table | won_tables])
      false -> check_tables(draws, tables, won_tables)
    end
  end

  defp did_table_win?(table, draws) do
    possibilites = table ++ generate_table_columns(table, [], length(table))
    Enum.map(possibilites, fn x -> did_line_win?(x, draws) end)
    |> Enum.member?(true)
  end

  def generate_table_columns(_, columns, 0), do: columns
  def generate_table_columns(table, columns, n) do
     column = for x <- table, do: Enum.at(x, n - 1) 
     generate_table_columns(table, [column | columns], n - 1)
  end

  defp did_line_win?([], _), do: true
  defp did_line_win?(_, []), do: false
  defp did_line_win?(line, [draw |draws]) do
    case Enum.member?(line, draw) do
      true -> did_line_win?(Enum.filter(line, fn x -> x != draw end), draws)
      false -> did_line_win?(line, draws)
    end
  end

  defp parse_draws(draws), do: Enum.map(String.split(draws, ","), &String.to_integer/1)

  defp parse_tables(tables) do
    Enum.map(tables, &String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Enum.chunk_every(5)
  end

end
