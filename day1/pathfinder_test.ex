ExUnit.start

defmodule Pathfinder do

  def move(heroine, "L" <> amount) do
    heroine
    |> turn_left
    |> walk(String.to_integer(amount))
  end
  def move(heroine, "R" <> amount) do
    heroine
    |> turn_right
    |> walk(String.to_integer(amount))
  end

  def compute_distance(%{duplicate: duplicate} = heroine) do
    %{total_distance: abs(heroine.x) + abs(heroine.y),
      distance_to_duplicate_location: abs(elem(duplicate, 0)) + abs(elem(duplicate, 1))}
  end
  def compute_distance(heroine) do
    %{total_distance: abs(heroine.x) + abs(heroine.y)}
  end

  defp turn_left(%{heading: :north} = heroine) do
    %{heroine | heading: :west}
  end
  defp turn_left(%{heading: :south} = heroine) do
    %{heroine | heading: :east}
  end
  defp turn_left(%{heading: :east} = heroine) do
    %{heroine | heading: :north}
  end
  defp turn_left(%{heading: :west} = heroine) do
    %{heroine | heading: :south}
  end

  defp turn_right(%{heading: :north} = heroine) do
    %{heroine | heading: :east}
  end
  defp turn_right(%{heading: :south} = heroine) do
    %{heroine | heading: :west}
  end
  defp turn_right(%{heading: :east} = heroine) do
    %{heroine | heading: :south}
  end
  defp turn_right(%{heading: :west} = heroine) do
    %{heroine | heading: :north}
  end

  defp walk(heroine, 0), do: heroine
  defp walk(%{x: x, y: y, heading: :north} = heroine, amount) do
    %{heroine | y: y + 1, history: [{x,y} | heroine.history]}
    |> check_duplicates
    |> walk(amount - 1)
  end
  defp walk(%{x: x, y: y, heading: :south} = heroine, amount) do
    %{heroine | y: y - 1, history: [{x,y} | heroine.history]}
    |> check_duplicates
    |> walk(amount - 1)
  end
  defp walk(%{x: x, y: y, heading: :east} = heroine, amount) do
    %{heroine | x: x + 1, history: [{x,y} | heroine.history]}
    |> check_duplicates
    |> walk(amount - 1)
  end
  defp walk(%{x: x, y: y, heading: :west} = heroine, amount) do
    %{heroine | x: x - 1, history: [{x,y} | heroine.history]}
    |> check_duplicates
    |> walk(amount - 1)
  end

  defp check_duplicates(%{duplicate: _duplicate} = heroine), do: heroine
  defp check_duplicates(%{x: x, y: y, history: history} = heroine) do
    case Enum.find(history, fn (coord) -> coord == {x,y} end) do
      nil -> heroine
      duplicate -> Map.put_new(heroine, :duplicate, duplicate)
    end
  end

end

defmodule PathfinderTest do
  use ExUnit.Case, async: true

  test "can move a heroine left when heading north" do
    fearless_heroine = %{x: 0, y: 0, heading: :north, history: []}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == -2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :west
  end

  test "can move a heroine left when heading south" do
    fearless_heroine = %{x: 0, y: 0, heading: :south, history: []}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == 2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :east
  end

  test "can move a heroine left when heading east" do
    fearless_heroine = %{x: 0, y: 0, heading: :east, history: []}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == 2
    assert fearless_heroine.heading == :north
  end

  test "can move a heroine left when heading west" do
    fearless_heroine = %{x: 0, y: 0, heading: :west, history: []}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == -2
    assert fearless_heroine.heading == :south
  end

  test "can move a heroine right when heading north" do
    fearless_heroine = %{x: 0, y: 0, heading: :north, history: []}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == 2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :east
  end

  test "can move a heroine right when heading south" do
    fearless_heroine = %{x: 0, y: 0, heading: :south, history: []}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == -2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :west
  end

  test "can move a heroine right when heading east" do
    fearless_heroine = %{x: 0, y: 0, heading: :east, history: []}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == -2
    assert fearless_heroine.heading == :south
  end

  test "can move a heroine right when heading west" do
    fearless_heroine = %{x: 0, y: 0, heading: :west, history: []}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == 2
    assert fearless_heroine.heading == :north
  end

end

"L5, R1, R3, L4, R3, R1, L3, L2, R3, L5, L1, L2, R5, L1, R5, R1, L4, R1, R3, L4, L1, R2, R5, R3, R1, R1, L1, R1, L1, L2, L1, R2, L5, L188, L4, R1, R4, L3, R47, R1, L1, R77, R5, L2, R1, L2, R4, L5, L1, R3, R187, L4, L3, L3, R2, L3, L5, L4, L4, R1, R5, L4, L3, L3, L3, L2, L5, R1, L2, R5, L3, L4, R4, L5, R3, R4, L2, L1, L4, R1, L3, R1, R3, L2, R1, R4, R5, L3, R5, R3, L3, R4, L2, L5, L1, L1, R3, R1, L4, R3, R3, L2, R5, R4, R1, R3, L4, R3, R3, L2, L4, L5, R1, L4, L5, R4, L2, L1, L3, L3, L5, R3, L4, L3, R5, R4, R2, L4, R2, R3, L3, R4, L1, L3, R2, R1, R5, L4, L5, L5, R4, L5, L2, L4, R4, R4, R1, L3, L2, L4, R3"
|> String.split(", ")
|> Enum.map_reduce(%{x: 0, y: 0, heading: :north, history: []}, fn (movement, heroine) -> {movement, Pathfinder.move(heroine, movement)} end)
|> elem(1)
|> Pathfinder.compute_distance
|> IO.inspect
