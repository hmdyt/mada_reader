defmodule MadaReader do
  def main(argv) do
    argv
    |> parse_args()
  end

  defp parse_args(argv) do
    argv
    |> parse_args_helper()
    |> IO.inspect()
    |> run()
  end

  defp parse_args_helper([inputfile]), do: [inputfile, inputfile |> String.replace(".mada", ".tmp")]
  defp parse_args_helper([inputfile, outputfile]), do: [inputfile, outputfile]
  defp parse_args_helper(_) do
    IO.puts "Usage: mada_reader <input.mada> [output.root]"
    System.halt(1)
  end

  defp run([path_to_mada, path_to_output]) do
    path_to_mada
    |> MadaReader.BinaryParser.run()
    |> MadaReader.MadaStructure.write(path_to_output)
    |> MadaReader.RootWrapper.call_make_tree(path_to_output)
  end
end
