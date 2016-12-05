defmodule TriangleMan do
  def valid({s1, s2, s3}) do
    s1 + s2 > s3 &&
      s2 + s3 > s1 &&
      s3 + s1 > s2
  end
  def valid([]), do: false
end

defmodule Input do
  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split
    |> to_tuple
  end

  defp to_tuple([_s1, _s2, _s3] = list) do
    list
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end
  defp to_tuple([]), do: []

end

File.read!("input.txt")
|> Input.parse
|> Enum.partition(&TriangleMan.valid/1)
|> elem(0)
|> Enum.count
|> IO.inspect
