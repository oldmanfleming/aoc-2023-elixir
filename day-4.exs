defmodule Day4 do
  def part1(input) do
    input
    |> get_numbers()
    |> Enum.sum()
    |> IO.puts()
  end

  def part2(input) do
    input
    |> get_card_counts()
    |> Enum.sum()
    |> IO.puts()
  end

  def get_numbers(input) do
    input
    |> Enum.map(fn line ->
      [_, card] =
        line
        |> String.split(":", trim: true)

      [winning, player] =
        card
        |> String.split("|", trim: true)

      winning_map =
        Regex.scan(~r/\b\d+\b/, winning)
        |> Enum.reduce(%{}, fn [num], acc ->
          Map.put(acc, String.to_integer(num), true)
        end)

      Regex.scan(~r/\b\d+\b/, player)
      |> Enum.reduce(0, fn [str_num], score ->
        num = String.to_integer(str_num)

        if Map.has_key?(winning_map, num) do
          if score == 0 do
            1
          else
            score * 2
          end
        else
          score
        end
      end)
    end)
  end

  def get_card_counts(input) do
    {counts, _} =
      input
      |> Enum.reduce({%{}, 1}, fn line, {counts, card_num} ->
        [_, card] =
          line
          |> String.split(":", trim: true)

        [winning, player] =
          card
          |> String.split("|", trim: true)

        winning_map =
          Regex.scan(~r/\b\d+\b/, winning)
          |> Enum.reduce(%{}, fn [num], acc ->
            Map.put(acc, String.to_integer(num), true)
          end)

        score =
          Regex.scan(~r/\b\d+\b/, player)
          |> Enum.reduce(0, fn [str_num], score ->
            num = String.to_integer(str_num)

            if Map.has_key?(winning_map, num) do
              score + 1
            else
              score
            end
          end)

        counts =
          if score > 0 do
            counts = Map.update(counts, card_num, 1, fn count -> count + 1 end)
            card_count = Map.get(counts, card_num, 1)

            Enum.to_list((card_num + 1)..(card_num + score))
            |> Enum.reduce(counts, fn num, acc ->
              Map.update(acc, num, card_count, fn count -> count + card_count end)
            end)
          else
            counts = Map.update(counts, card_num, 1, fn count -> count + 1 end)
          end

        {counts, card_num + 1}
      end)

    Map.values(counts)
  end
end

input = File.stream!("inputs/day-4", [:read, :utf8], :line)

Day4.part1(input)
Day4.part2(input)
