defmodule Day6 do
  def part1(input) do
    input
    |> parse()
    |> calculate()
    |> IO.inspect()
  end

  def part2(input) do
    input
    |> parse_kerning()
    |> calculate()
    |> IO.inspect()
  end

  def parse(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split(" ", trim: true)
      |> Enum.drop(1)
      |> Enum.map(fn str ->
        String.to_integer(str)
      end)
    end)
  end

  def parse_kerning(input) do
    input
    |> Enum.map(fn line ->
      number =
        line
        |> String.trim()
        |> String.split(" ", trim: true)
        |> Enum.drop(1)
        |> Enum.join()
        |> String.to_integer()

      [number]
    end)
  end

  def calculate([times, distances]) do
    Enum.zip(times, distances)
    |> Enum.map(fn {time, distance} ->
      Enum.reduce(1..(time - 1), 0, fn t, wins ->
        if (time - t) * t > distance do
          wins + 1
        else
          wins
        end
      end)
    end)
    |> Enum.reduce(1, fn wins, total ->
      total * wins
    end)
  end
end

input = File.stream!("inputs/day-6", [:read, :utf8], :line)

Day6.part1(input)
Day6.part2(input)
