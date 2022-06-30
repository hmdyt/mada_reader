defmodule MadaReader do
  @make_tree_binary Application.fetch_env!(:mada_reader, :make_tree_binary)

  def main(argv) do
    argv
    |> Enum.at(0)
    |> run
  end

  def run(path_to_mada \\ "/Users/yuto/sandbox/mada_reader/per0014/GBKB-13_0003.mada") do
    path_to_mada
    |> MadaReader.MadaRead.run
    |> MadaStructure.write(path_to_mada |> String.replace(".mada", ".tmp"))
    |> make_tree()
  end

  def make_tree(path_to_tmp_file) do
    path_to_out_file = path_to_tmp_file |> String.replace(".tmp", ".root")
    {ret, _status} = System.cmd(@make_tree_binary, [path_to_tmp_file, path_to_out_file])
    IO.puts ret
  end
end

# TODO
# - docker
# - [DONE] root macro compile (make)
# - elixir single binary
# - delete hardcode
# - multi threading (on perXXXX)
