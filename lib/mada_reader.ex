defmodule MadaReader do
  def main(argv) do
    argv
    |> MadaReader.Cli.parse()
    |> cli_handler()
  end

  defp cli_handler({[:dir], _parse_result}) do
    0
  end
  defp cli_handler({[:file], parse_result}) do
    run_file([parse_result.args.input, parse_result.args.output])
  end

  def run_file([path_to_mada, path_to_output]) do
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
