defmodule MadaReader do
  @make_tree_binary Application.fetch_env!(:mada_reader, :make_tree_binary)

  def main(argv) do
    argv
    |> parse_args()
  end

  def parse_args(argv) do
    argv
    |> parse_args_helper()
    |> run()
  end

  defp parse_args_helper([inputfile]), do: [inputfile]
  defp parse_args_helper([inputfile, outputfile]), do: [inputfile, outputfile]
  defp parse_args_helper(_) do
    IO.puts "Usage: mada_reader <input.mada> [output.root]"
    System.halt(1)
  end

  def run([path_to_mada]) do
    path_to_mada
    |> MadaReader.MadaRead.run
    |> MadaStructure.write(path_to_mada |> String.replace(".mada", ".tmp"))
    |> make_tree()
  end
  def run([path_to_mada, path_to_output]) do
    path_to_mada
    |> MadaReader.MadaRead.run()
    |> MadaStructure.write(path_to_output)
    |> make_tree(path_to_output)
  end

  def make_tree(path_to_tmp_file) do
    path_to_out_file = path_to_tmp_file |> String.replace(".tmp", ".root")
    {ret, _status} = System.cmd(@make_tree_binary, [path_to_tmp_file, path_to_out_file])
    IO.puts ret
  end
  def make_tree(path_to_tmp_file, path_to_output_file) do
    {ret, _status} = System.cmd(@make_tree_binary, [path_to_tmp_file, path_to_output_file])
    IO.puts ret
  end
end
