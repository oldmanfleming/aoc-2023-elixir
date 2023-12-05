defmodule Day2 do
  def part_1(games) do
    games
    |> Enum.map(fn game -> game_info(game) end)
    |> Enum.reduce([], fn {id, results}, acc ->
      case possible(results) do
        :possible -> [id | acc]
        :not_possible -> acc
      end
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def part_2(games) do
    games
    |> Enum.map(fn game ->
      {_, results} = game_info(game)
      find_power(results)
    end)
    |> Enum.sum()
    |> IO.puts()
  end

  def game_info(line) do
    [game, info] = String.split(line, ":")
    [_, str_id] = Regex.run(~r/Game (\d+)/, game)
    id = String.to_integer(str_id)

    results =
      Regex.scan(~r/(\d+)\s*([a-zA-Z]+)/, info)
      |> Enum.map(fn [_, str_num, color] ->
        {color, String.to_integer(str_num)}
      end)

    {id, results}
  end

  def possible(results) do
    results
    |> Enum.reduce(:possible, fn {color, num}, acc ->
      case acc do
        :not_possible ->
          :not_possible

        :possible ->
          case color do
            "red" when num > 12 -> :not_possible
            "red" -> :possible
            "green" when num > 13 -> :not_possible
            "green" -> :possible
            "blue" when num > 14 -> :not_possible
            "blue" -> :possible
          end
      end
    end)
  end

  def find_power(results) do
    results
    |> Enum.reduce(%{"red" => 0, "blue" => 0, "green" => 0}, fn {color, num}, acc ->
      red = acc["red"]
      green = acc["green"]
      blue = acc["blue"]

      case color do
        "red" when num > red -> %{acc | "red" => num}
        "green" when num > green -> %{acc | "green" => num}
        "blue" when num > blue -> %{acc | "blue" => num}
        _ -> acc
      end
    end)
    |> get_power()
  end

  def get_power(map) do
    map["red"] * map["green"] * map["blue"]
  end
end

games = File.stream!("inputs/day-2", [:read, :utf8], :line)
Day2.part_1(games)
Day2.part_2(games)
