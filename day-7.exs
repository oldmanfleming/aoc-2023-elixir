defmodule Day7 do
  def part1(input) do
    input
    |> parse()
    |> calculate()
    |> IO.inspect()
  end

  def part2(input) do
    input
    |> parse_with_jacks()
    |> calculate()
    |> IO.inspect()
  end

  def parse(input) do
    input
    |> Enum.map(fn line ->
      [cards, bid] =
        line
        |> String.trim()
        |> String.split(" ", trim: true)

      strength =
        cards
        |> String.split("", trim: true)
        |> Enum.map(fn card ->
          case card do
            "A" -> 14
            "K" -> 13
            "Q" -> 12
            "J" -> 11
            "T" -> 10
            _ -> String.to_integer(card)
          end
        end)

      type =
        cards
        |> String.split("", trim: true)
        |> Enum.reduce(%{}, fn card, map ->
          Map.update(map, card, 1, fn count ->
            count + 1
          end)
        end)
        |> Map.values()
        |> Enum.sort(:desc)
        |> Enum.take(2)
        |> get_type()

      {cards, type, strength, String.to_integer(bid)}
    end)
  end

  def get_type(cards) do
    case cards do
      [5] -> 7
      [4, 1] -> 6
      [3, 2] -> 5
      [3, _] -> 4
      [2, 2] -> 3
      [2, _] -> 2
      [1, _] -> 1
    end
  end

  def parse_with_jacks(input) do
    input
    |> Enum.map(fn line ->
      [cards, bid] =
        line
        |> String.trim()
        |> String.split(" ", trim: true)

      {strength, jacks} =
        cards
        |> String.split("", trim: true)
        |> Enum.reduce({[], 0}, fn card, {strength, jacks} ->
          {s, j} =
            case card do
              "J" -> {1, 1}
              "A" -> {13, 0}
              "K" -> {12, 0}
              "Q" -> {11, 0}
              "T" -> {10, 0}
              _ -> {String.to_integer(card), 0}
            end

          {strength ++ [s], jacks + j}
        end)

      type =
        cards
        |> String.split("", trim: true)
        |> Enum.reduce(%{}, fn card, map ->
          if card == "J" do
            map
          else
            Map.update(map, card, 1, fn count ->
              count + 1
            end)
          end
        end)
        |> Map.values()
        |> Enum.sort(:desc)
        |> Enum.take(2)
        |> get_type_with_jacks(jacks)

      {cards, type, strength, String.to_integer(bid)}
    end)
  end

  def get_type_with_jacks(counts, jacks) do
    type =
      case(counts) do
        [5] -> :five_kind
        [4, 1] -> :four_kind
        [3, 2] -> :full_house
        [3, _] -> :three_kind
        [2, 2] -> :two_pair
        [2, _] -> :one_pair
        [1, _] -> :high_card
        [4] -> :four_kind
        [3] -> :three_kind
        [2] -> :one_pair
        [1] -> :high_card
        [] -> :none
        _ -> IO.inspect({counts, jacks}, charlists: :as_lists)
      end

    type =
      case({type, jacks}) do
        {:four_kind, 1} -> :five_kind
        {:three_kind, 2} -> :five_kind
        {:three_kind, 1} -> :four_kind
        {:two_pair, 1} -> :full_house
        {:one_pair, 3} -> :five_kind
        {:one_pair, 2} -> :four_kind
        {:one_pair, 1} -> :three_kind
        {:high_card, 4} -> :five_kind
        {:high_card, 3} -> :four_kind
        {:high_card, 2} -> :three_kind
        {:high_card, 1} -> :one_pair
        {:none, 5} -> :five_kind
        _ -> type
      end

    case type do
      :five_kind -> 7
      :four_kind -> 6
      :full_house -> 5
      :three_kind -> 4
      :two_pair -> 3
      :one_pair -> 2
      :high_card -> 1
    end
  end

  def calculate(list) do
    list
    |> Enum.sort(fn {_, type1, strength1, _}, {_, type2, strength2, _} ->
      if type1 == type2 do
        winner2 =
          Enum.zip(strength1, strength2)
          |> Enum.reduce(nil, fn {s1, s2}, winner2 ->
            if winner2 != nil do
              winner2
            else
              cond do
                s1 == s2 -> nil
                s1 < s2 -> true
                s1 > s2 -> false
                true -> winner2
              end
            end
          end)

        if winner2 == nil do
          true
        else
          winner2
        end
      else
        type1 < type2
      end
    end)
    |> Enum.with_index()
    |> Enum.map(fn {{_, _, _, bid}, rank} ->
      bid * (rank + 1)
    end)
    |> Enum.sum()
  end
end

input = File.stream!("inputs/day-7", [:read, :utf8], :line)

Day7.part1(input)
Day7.part2(input)
