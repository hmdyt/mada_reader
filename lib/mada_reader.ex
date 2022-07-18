defmodule MadaReader do
  @target_input_extern ".mada"
  @target_output_extern ".root"
  def main(argv) do
    argv
    |> MadaReader.Cli.parse()
    |> cli_handler()
  end

  defp cli_handler({[:file], parse_result}) do
    run_file([parse_result.args.input, parse_result.args.output], true, true, true)
  end
  defp cli_handler({[:dir], parse_result}) do
    run_dir(parse_result.args.dir, parse_result.args.procs |> String.to_integer)
  end

  def run_file([path_to_mada, path_to_output], show_progress?, show_spinner?, put_msg?) do
    if put_msg? do
      put_run_msg [path_to_mada, path_to_output]
    end
    path_to_mada
    |> MadaReader.BinaryParser.run(show_progress?)
    |> MadaReader.MadaStructure.write(path_to_mada)
    |> MadaReader.RootWrapper.call_make_tree(path_to_output, show_spinner?)
  end

  defp put_run_msg([path_to_mada, path_to_output]) do
    IO.puts("#{path_to_mada} -> #{path_to_output}")
  end

  def run_dir(path_to_dir, nprocs) do
    run_file_local = fn input_file ->
      run_file(
        [
          input_file,
          input_file |> String.replace(@target_input_extern, @target_output_extern)
        ],
        false,
        false,
        false
      )
    end
    target_files = path_to_dir
    |> Path.join("*#{@target_input_extern}")
    |> Path.wildcard()
    n_target_files = target_files |> length()
    target_files
    |> Enum.chunk_every(nprocs)
    |> Enum.with_index()
    |> Enum.map(
      fn {inputs, i} ->
        MadaReader.ProgressBar.render_count_bar(nprocs * i, n_target_files, "dumping mada files ")
        inputs
        |> Enum.map(&(Task.async(fn -> run_file_local.(&1) end)))
        |> Enum.map(&(Task.await(&1, 1000_000_000)))
      end
    )
  end
end
