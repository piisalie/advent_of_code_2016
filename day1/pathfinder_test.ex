ExUnit.start

defmodule Pathfinder do

  def move(heroine, "L" <> amount), do: move_left(heroine, amount)
  def move(heroine, "R" <> amount), do: move_right(heroine, amount)

  def compute_distance({_movements, heroine}) do
    abs(heroine.x) + abs(heroine.y)
  end

  defp move_left(%{x: x, y: y, heading: :north}, count) do
    %{x: x - String.to_integer(count),
      y: y,
      heading: :west
    }
  end
  defp move_left(%{x: x, y: y, heading: :south}, count) do
    %{x: x + String.to_integer(count),
      y: y,
      heading: :east
    }
  end
  defp move_left(%{x: x, y: y, heading: :east}, count) do
    %{x: x,
      y: y + String.to_integer(count),
      heading: :north
    }
  end
  defp move_left(%{x: x, y: y, heading: :west}, count) do
    %{x: x,
      y: y - String.to_integer(count),
      heading: :south
    }
  end

  defp move_right(%{x: x, y: y, heading: :north}, count) do
    %{x: x + String.to_integer(count),
      y: y,
      heading: :east
    }
  end
  defp move_right(%{x: x, y: y, heading: :south}, count) do
    %{x: x - String.to_integer(count),
      y: y,
      heading: :west
    }
  end
  defp move_right(%{x: x, y: y, heading: :east}, count) do
    %{x: x,
      y: y - String.to_integer(count),
      heading: :south
    }
  end
  defp move_right(%{x: x, y: y, heading: :west}, count) do
    %{x: x,
      y: y + String.to_integer(count),
      heading: :north
    }
  end

end

defmodule PathfinderTest do
  use ExUnit.Case, async: true

  test "can move a heroine left when heading north" do
    fearless_heroine = %{x: 0, y: 0, heading: :north}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == -2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :west
  end

  test "can move a heroine left when heading south" do
    fearless_heroine = %{x: 0, y: 0, heading: :south}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == 2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :east
  end

  test "can move a heroine left when heading east" do
    fearless_heroine = %{x: 0, y: 0, heading: :east}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == 2
    assert fearless_heroine.heading == :north
  end

  test "can move a heroine left when heading west" do
    fearless_heroine = %{x: 0, y: 0, heading: :west}
    |> Pathfinder.move("L2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == -2
    assert fearless_heroine.heading == :south
  end

  test "can move a heroine right when heading north" do
    fearless_heroine = %{x: 0, y: 0, heading: :north}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == 2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :east
  end

  test "can move a heroine right when heading south" do
    fearless_heroine = %{x: 0, y: 0, heading: :south}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == -2
    assert fearless_heroine.y == 0
    assert fearless_heroine.heading == :west
  end

  test "can move a heroine right when heading east" do
    fearless_heroine = %{x: 0, y: 0, heading: :east}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == -2
    assert fearless_heroine.heading == :south
  end

  test "can move a heroine right when heading west" do
    fearless_heroine = %{x: 0, y: 0, heading: :west}
    |> Pathfinder.move("R2")

    assert fearless_heroine.x == 0
    assert fearless_heroine.y == 2
    assert fearless_heroine.heading == :north
  end

end

"L5, R1, R3, L4, R3, R1, L3, L2, R3, L5, L1, L2, R5, L1, R5, R1, L4, R1, R3, L4, L1, R2, R5, R3, R1, R1, L1, R1, L1, L2, L1, R2, L5, L188, L4, R1, R4, L3, R47, R1, L1, R77, R5, L2, R1, L2, R4, L5, L1, R3, R187, L4, L3, L3, R2, L3, L5, L4, L4, R1, R5, L4, L3, L3, L3, L2, L5, R1, L2, R5, L3, L4, R4, L5, R3, R4, L2, L1, L4, R1, L3, R1, R3, L2, R1, R4, R5, L3, R5, R3, L3, R4, L2, L5, L1, L1, R3, R1, L4, R3, R3, L2, R5, R4, R1, R3, L4, R3, R3, L2, L4, L5, R1, L4, L5, R4, L2, L1, L3, L3, L5, R3, L4, L3, R5, R4, R2, L4, R2, R3, L3, R4, L1, L3, R2, R1, R5, L4, L5, L5, R4, L5, L2, L4, R4, R4, R1, L3, L2, L4, R3"
|> String.split(", ")
|> Enum.map_reduce(%{x: 0, y: 0, heading: :north}, fn (movement, heroine) -> {movement, Pathfinder.move(heroine, movement)} end)
|> Pathfinder.compute_distance
|> IO.inspect
