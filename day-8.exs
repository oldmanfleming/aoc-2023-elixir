defmodule Day8 do
  def part1(input) do
    instructions = get_instructions(input)

    map =
      input
      |> get_map()
      |> Enum.reduce(%{}, fn [node, left, right], map ->
        Map.put(map, node, {left, right})
      end)

    traverse_map(instructions, map, "AAA", 0, 0)
    |> IO.puts()
  end

  def part2(input) do
    instructions =
      input
      |> get_instructions()

    {map, start_nodes} =
      input
      |> get_map()
      |> Enum.reduce({%{}, []}, fn [node, left, right], {map, start_nodes} ->
        cond do
          String.match?(node, ~r/[A-Z]{2}A\z/) ->
            {Map.put(map, node, {left, right}), start_nodes ++ [node]}

          true ->
            {Map.put(map, node, {left, right}), start_nodes}
        end
      end)

    traversals =
      Enum.map(start_nodes, fn node ->
        traverse_map(instructions, map, node, 0, 0)
      end)

    traversals
    |> Enum.reduce(1, &lcm/2)
    |> IO.puts()
  end

  defp get_instructions(input) do
    input
    |> Enum.at(0)
    |> String.trim()
    |> String.split("", trim: true)
  end

  defp get_map(input) do
    input
    |> Enum.drop(2)
    |> Enum.map(fn line ->
      Regex.scan(~r/([A-Z]{3})/, String.trim(line))
      |> Enum.map(fn [_, match] -> match end)
    end)
  end

  defp traverse_map(instructions, map, node, instr_steps, steps) do
    if String.match?(node, ~r/[A-Z]{2}Z\z/) do
      steps
    else
      instr_steps =
        if instr_steps >= length(instructions) do
          0
        else
          instr_steps
        end

      direction = Enum.at(instructions, instr_steps)

      {left, right} = Map.get(map, node)

      case direction do
        "L" -> traverse_map(instructions, map, left, instr_steps + 1, steps + 1)
        "R" -> traverse_map(instructions, map, right, instr_steps + 1, steps + 1)
      end
    end
  end

  defp lcm(a, b) do
    div(abs(a * b), gcd(a, b))
  end

  defp gcd(a, 0), do: a
  defp gcd(a, b), do: gcd(b, rem(a, b))
end

input = File.stream!("inputs/day-8", [:read, :utf8], :line)

Day8.part1(input)
Day8.part2(input)
