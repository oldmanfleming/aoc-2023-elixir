defmodule Day9 do
  def part1(input) do
    input
    |> get_report()
    |> predict_last()
    |> IO.puts()
  end

  def part2(input) do
    input
    |> get_report()
    |> predict_first()
    |> IO.puts()
  end

  defp get_report(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)
  end

  defp predict_last(report) do
    report
    |> Enum.map(fn line ->
      parse_line(line, [], fn line -> length(line) - 1 end)
    end)
    |> Enum.map(fn last ->
      last
      |> Enum.reduce(0, fn x, acc ->
        x + acc
      end)
    end)
    |> Enum.sum()
  end

  defp predict_first(report) do
    report
    |> Enum.map(fn line ->
      parse_line(line, [], fn _ -> 0 end)
    end)
    |> Enum.map(fn first ->
      first
      |> Enum.reduce(0, fn x, acc ->
        x - acc
      end)
    end)
    |> Enum.sum()
  end

  defp parse_line(line, sigs, at_fun) do
    if Enum.all?(line, fn x -> x == 0 end) do
      sigs
    else
      sig = Enum.at(line, at_fun.(line))

      line =
        line
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.reduce([], fn [first, second], next ->
          next ++ [second - first]
        end)

      parse_line(line, [sig | sigs], at_fun)
    end
  end
end

input = File.stream!("inputs/day-9", [:read, :utf8], :line)

Day9.part1(input)
Day9.part2(input)
