defmodule Day3 do
  def part1(input) do
    input
    |> get_schematic()
    |> get_symbols()
    |> get_parts_near_symbols()
    |> Enum.sum()
    |> IO.puts()
  end

  def part2(input) do
    input
    |> get_schematic()
    |> get_parts()
    |> get_gear_ratios()
    |> IO.puts()
  end

  def get_schematic(input) do
    input
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.map(fn char ->
        [char_code] = to_charlist(char)

        case char do
          "." -> {:empty, char}
          "\n" -> {:newline, char}
          "*" -> {:gear, char}
          char when char_code > 47 and char_code < 58 -> {:part, char}
          _ -> {:symbol, char}
        end
      end)
    end)
  end

  def get_symbols(schematic) do
    {coords, _} =
      schematic
      |> Enum.reduce({%{}, 0}, fn line, {coords, y} ->
        {row_coords, _} =
          line
          |> Enum.reduce({%{}, 0}, fn {type, char}, {row_coords, x} ->
            case type do
              :symbol ->
                {Map.put(row_coords, {x, y}, char), x + 1}

              :gear ->
                {Map.put(row_coords, {x, y}, char), x + 1}

              _ ->
                {row_coords, x + 1}
            end
          end)

        {Map.merge(coords, row_coords), y + 1}
      end)

    {coords, schematic}
  end

  def get_parts_near_symbols({coords, schematic}) do
    {_, parts} =
      schematic
      |> Enum.reduce({0, []}, fn line, {y, parts} ->
        {_, _, _, row_parts} =
          line
          |> Enum.reduce({"", false, 0, []}, fn {type, char},
                                                {prev_num, prev_valid, x, row_parts} ->
            curr_num =
              case type do
                :part -> prev_num <> char
                _ -> ""
              end

            curr_valid =
              case type do
                :part when not prev_valid ->
                  [
                    {x + 1, y},
                    {x - 1, y},
                    {x, y + 1},
                    {x, y - 1},
                    {x + 1, y + 1},
                    {x - 1, y - 1},
                    {x + 1, y - 1},
                    {x - 1, y + 1}
                  ]
                  |> Enum.map(fn {sx, sy} ->
                    Map.has_key?(coords, {sx, sy})
                  end)
                  |> Enum.any?()

                :part when prev_valid ->
                  true

                _ ->
                  false
              end

            row_parts =
              if curr_num == "" and prev_num != "" and prev_valid do
                row_parts ++ [String.to_integer(prev_num)]
              else
                row_parts
              end

            {curr_num, curr_valid, x + 1, row_parts}
          end)

        {y + 1, parts ++ row_parts}
      end)

    parts
  end

  def get_parts(schematic) do
    {coords, _} =
      schematic
      |> Enum.reduce({%{}, 0}, fn line, {coords, y} ->
        {row_coords, _, _} =
          line
          |> Enum.reduce({%{}, 0, ""}, fn {type, char}, {row_coords, x, prev_num} ->
            curr_num =
              case type do
                :part -> prev_num <> char
                _ -> ""
              end

            char_coords =
              if curr_num == "" and prev_num != "" do
                num_len = String.length(prev_num)
                num = String.to_integer(prev_num)

                {char_coords, _} =
                  prev_num
                  |> String.split("", trim: true)
                  |> Enum.reduce({%{}, x - num_len}, fn _, {char_coords, x_offset} ->
                    {Map.put(char_coords, {x_offset, y}, num), x_offset + 1}
                  end)

                char_coords
              else
                %{}
              end

            {Map.merge(row_coords, char_coords), x + 1, curr_num}
          end)

        {Map.merge(coords, row_coords), y + 1}
      end)

    {coords, schematic}
  end

  def get_gear_ratios({coords, schematic}) do
    {_, gear_ratio} =
      schematic
      |> Enum.reduce({0, 0}, fn line, {y, total_gear_ratio} ->
        {_, line_gear_ratio} =
          line
          |> Enum.reduce({0, 0}, fn {type, char}, {x, line_gear_ratio} ->
            parts =
              case type do
                :gear ->
                  [
                    {x + 1, y},
                    {x - 1, y},
                    {x, y + 1},
                    {x, y - 1},
                    {x + 1, y + 1},
                    {x - 1, y - 1},
                    {x + 1, y - 1},
                    {x - 1, y + 1}
                  ]
                  |> Enum.reduce(%{}, fn {sx, sy}, parts ->
                    if Map.has_key?(coords, {sx, sy}) do
                      Map.put(parts, Map.get(coords, {sx, sy}), char)
                    else
                      parts
                    end
                  end)

                _ ->
                  %{}
              end

            gear_ratio =
              if :maps.size(parts) == 2 do
                [left, right] = Map.keys(parts)
                left * right
              else
                0
              end

            {x + 1, line_gear_ratio + gear_ratio}
          end)

        {y + 1, total_gear_ratio + line_gear_ratio}
      end)

    gear_ratio
  end
end

input = File.stream!("inputs/day-3", [:read, :utf8], :line)

Day3.part1(input)
Day3.part2(input)
