defmodule MadaReader do
  def main(argv) do
    argv
    |> parse_args()
    |> IO.inspect()
    |> run()
  end

  defp parse_args([inputfile]), do: [inputfile, inputfile |> String.replace(".mada", ".tmp")]
  defp parse_args([inputfile, outputfile]), do: [inputfile, outputfile]
  defp parse_args(_) do
    IO.puts "Usage: mada_reader <input.mada> [output.root]"
    System.halt(1)
  end

  def run([path_to_mada, path_to_output]) do
    path_to_mada
    |> MadaReader.BinaryParser.run()
    |> MadaReader.MadaStructure.write(path_to_output)
    |> MadaReader.RootWrapper.call_make_tree(path_to_output)
  end
end
