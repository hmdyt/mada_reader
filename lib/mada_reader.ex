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
    |> make_tree_handler()
  end
  def run([path_to_mada, path_to_output]) do
    path_to_mada
    |> MadaReader.MadaRead.run()
    |> MadaStructure.write(path_to_output)
    |> make_tree(path_to_output)
  end

  def make_tree(path_to_tmp_file) do
    path_to_out_file = path_to_tmp_file |> String.replace(".tmp", ".root")
    System.cmd(@make_tree_binary, [path_to_tmp_file, path_to_out_file])
  end
  def make_tree(path_to_tmp_file, path_to_output_file) do
    System.cmd(@make_tree_binary, [path_to_tmp_file, path_to_output_file])
  end

  defp make_tree_handler({ret, 0}), do: IO.puts ret
  defp make_tree_handler({ret, status_code}) do
    IO.puts """
    make_tree.cxx error
    status code: #{status_code}
    ret: #{ret}
    """
    System.halt(1)
  end
end
