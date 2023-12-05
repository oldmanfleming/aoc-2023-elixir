defmodule Day1 do
  def process() do
    File.stream!("inputs/day-1", [:read, :utf8], :line)
    |> Enum.reduce(0, fn line, acc ->
      case Day1.process_line(line) do
        {nil, nil} -> acc
        {first, nil} -> acc + first * 10 + first
        {first, last} -> acc + first * 10 + last
      end
    end)
    |> IO.puts()
  end

  def process_line(line) do
    Regex.scan(
      ~r/(?:[1-9]|nineight|oneight|twone|sevenine|fiveight|threeight|eighthree|eightwo|one|two|three|four|five|six|seven|eight|nine)/i,
      line
    )
    |> Enum.reduce({nil, nil}, fn [substr], {first, last} ->
      case String.to_charlist(substr) do
        [char] ->
          case {first, last} do
            {nil, nil} -> {char - 48, nil}
            {_, _} -> {first, char - 48}
          end

        word ->
          values = convert_word(word)

          case values do
            [x] ->
              case {first, last} do
                {nil, nil} -> {x, nil}
                {_, _} -> {first, x}
              end

            [x, y] ->
              case {first, last} do
                {nil, nil} -> {x, y}
                {_, _} -> {first, y}
              end
          end
      end
    end)
  end

  def convert_word(word) do
    case word do
      ~c"nineight" -> [9, 8]
      ~c"oneight" -> [1, 8]
      ~c"twone" -> [2, 1]
      ~c"sevenine" -> [7, 9]
      ~c"fiveight" -> [5, 8]
      ~c"threeight" -> [3, 8]
      ~c"eighthree" -> [8, 3]
      ~c"eightwo" -> [8, 2]
      ~c"one" -> [1]
      ~c"two" -> [2]
      ~c"three" -> [3]
      ~c"four" -> [4]
      ~c"five" -> [5]
      ~c"six" -> [6]
      ~c"seven" -> [7]
      ~c"eight" -> [8]
      ~c"nine" -> [9]
    end
  end
end

Day1.process()
