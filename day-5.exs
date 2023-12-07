defmodule Day5 do
  def part1(input) do
    seeds_line = Enum.at(input, 0)

    seeds =
      seeds_line
      |> String.trim()
      |> String.split(":", trim: true)
      |> Enum.at(1)
      |> String.split(" ", trim: true)
      |> Enum.map(fn seed ->
        String.to_integer(seed)
      end)

    {seeds, _} =
      input
      |> Enum.drop(2)
      |> Enum.concat(["\n"])
      |> Enum.reduce({seeds, []}, fn line, {seeds, map} ->
        code = :binary.first(line)

        case code do
          10 ->
            seeds =
              seeds
              |> Enum.map(fn seed ->
                {seed, _} =
                  map
                  |> Enum.reduce({seed, false}, fn [source_start, source_end, dest_offset],
                                                   {seed, done} ->
                    if seed >= source_start and seed <= source_end and not done do
                      {seed + dest_offset, true}
                    else
                      {seed, done}
                    end
                  end)

                seed
              end)

            {seeds, []}

          _ when code > 47 and code < 58 ->
            [dest_start, source_start, range] =
              line
              |> String.trim()
              |> String.split(" ", trim: true)
              |> Enum.map(fn str ->
                String.to_integer(str)
              end)

            {seeds, map ++ [[source_start, source_start + range - 1, dest_start - source_start]]}

          _ ->
            {seeds, map}
        end
      end)

    seeds
    |> Enum.sort()
    |> Enum.at(0)
    |> IO.puts()
  end

  def part2(input) do
    seeds_line = Enum.at(input, 0)

    seeds =
      seeds_line
      |> String.trim()
      |> String.split(":", trim: true)
      |> Enum.at(1)
      |> String.split(" ", trim: true)
      |> Enum.map(fn seed ->
        String.to_integer(seed)
      end)
      |> Enum.chunk_every(2, 2, :discard)
      |> Enum.map(fn [start, range] ->
        start..(start + range - 1)
      end)

    {maps, _} =
      input
      |> Enum.drop(2)
      |> Enum.concat(["\n"])
      |> Enum.reduce({[], []}, fn line, {maps, map} ->
        code = :binary.first(line)

        case code do
          10 ->
            {maps ++ [map], []}

          _ when code > 47 and code < 58 ->
            [dest_start, source_start, range] =
              line
              |> String.trim()
              |> String.split(" ", trim: true)
              |> Enum.map(fn str ->
                String.to_integer(str)
              end)

            {maps, map ++ [{source_start, source_start + range - 1, dest_start - source_start}]}

          _ ->
            {maps, map}
        end
      end)

    seeds =
      seeds
      |> Enum.map(fn range ->
        range
        |> Enum.map(fn seed ->
          maps
          |> Enum.reduce(seed, fn map, seed ->
            {seed, _} =
              map
              |> Enum.reduce({seed, false}, fn {source_start, source_end, dest_offset},
                                               {seed, done} ->
                if seed >= source_start and seed <= source_end and not done do
                  {seed + dest_offset, true}
                else
                  {seed, done}
                end
              end)

            seed
          end)
        end)
        |> Enum.reduce(nil, fn seed, lowest ->
          if lowest == nil or seed < lowest do
            seed
          else
            lowest
          end
        end)
      end)
      |> Enum.reduce(nil, fn seed, lowest ->
        if lowest == nil or seed < lowest do
          seed
        else
          lowest
        end
      end)

    IO.inspect(seeds, charlists: :as_lists)
  end
end

almanac = File.stream!("inputs/day-5", [:read, :utf8], :line)

Day5.part1(almanac)
Day5.part2(almanac)
