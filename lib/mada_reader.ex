defmodule MadaReader do
  def main(argv) do
    argv
    |> parse_args()
    |> run()
  end

  defp parse_args([inputfile, outputfile]), do: [inputfile, outputfile]
  defp parse_args(_) do
    IO.puts "Usage: mada_reader <input.mada> <output.root>"
    System.halt(1)
  end

  def run([path_to_mada, path_to_output]) do
    put_run_msg [path_to_mada, path_to_output]
    path_to_mada
    |> MadaReader.BinaryParser.run()
    |> MadaReader.MadaStructure.write(path_to_mada)
    |> MadaReader.RootWrapper.call_make_tree(path_to_output)
  end

  defp put_run_msg([path_to_mada, path_to_output]) do
    IO.puts("#{path_to_mada} -> #{path_to_output}")
  end
end
