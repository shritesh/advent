defmodule Advent.Day22 do
  defmodule Combat do
    def new(input) do
      for deck <- String.split(input, "\n\n", trim: true) do
        String.split(deck, "\n", trim: true)
        |> Enum.drop(1)
        |> Enum.map(&String.to_integer/1)
        |> :queue.from_list()
      end
      |> List.to_tuple()
    end

    def next({player_1, player_2}) do
      case {:queue.out(player_1), :queue.out(player_2)} do
        {{{:value, card_1}, player_1}, {{:value, card_2}, player_2}} ->
          if card_1 > card_2 do
            player_1 = :queue.in(card_1, player_1)
            player_1 = :queue.in(card_2, player_1)
            {player_1, player_2}
          else
            player_2 = :queue.in(card_2, player_2)
            player_2 = :queue.in(card_1, player_2)
            {player_1, player_2}
          end
      end
    end

    defp calculate_score(queue) do
      queue
      |> :queue.to_list()
      |> Enum.reverse()
      |> Enum.with_index(1)
      |> Enum.map(fn {n, i} -> n * i end)
      |> Enum.sum()
    end

    def score_win?({player_1, player_2}) do
      cond do
        :queue.is_empty(player_1) -> calculate_score(player_2)
        :queue.is_empty(player_2) -> calculate_score(player_1)
        true -> nil
      end
    end
  end

  def part_1(input) do
    Combat.new(input)
    |> Stream.iterate(&Combat.next/1)
    |> Enum.find_value(&Combat.score_win?/1)
  end
end
