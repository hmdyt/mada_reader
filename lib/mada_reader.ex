defmodule MadaReader do
  def main(argv) do
    argv[0] |> run
  end

  def run(path_to_mada \\ "/Users/yuto/sandbox/mada_reader/per0014/GBKB-13_0003.mada") do
    path_to_mada
    |> MadaReader.MadaRead.run
    |> MadaStructure.write(path_to_mada |> String.replace(".mada", ".tmp"))
    |> make_tree()
  end

  def make_tree(path_to_tmp_file) do
    project_root = System.get_env("PROJECT_ROOT")
    opt = "#{project_root}/rootmacro/make_tree.C(\"#{path_to_tmp_file}\", \"#{path_to_tmp_file |> String.replace(".tmp", ".root")}\")"
    IO.puts opt
    "/opt/root/v6.20_06/bin/root" |> System.cmd([opt, "-q", "-b", "-l"]) |> IO.inspect()
  end
end
