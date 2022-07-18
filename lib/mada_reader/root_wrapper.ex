defmodule MadaReader.RootWrapper do
  @make_tree_binary Application.fetch_env!(:mada_reader, :make_tree_binary)

  def call_make_tree({path_to_tmp_file, i_iter}, path_to_output_file, show_spinner?) do
    make_tree(path_to_tmp_file, path_to_output_file, i_iter, show_spinner?)
    |> make_tree_handler()
  end

  defp make_tree(path_to_tmp_file, path_to_output_file, n_iter, true) do
    MadaReader.ProgressBar.render_spinner(
      "calling make_tree.cxx",
      fn -> System.cmd(@make_tree_binary, [path_to_tmp_file, path_to_output_file, n_iter |> Integer.to_string]) end
    )
  end

  defp make_tree(path_to_tmp_file, path_to_output_file, n_iter, false) do
    System.cmd(@make_tree_binary, [path_to_tmp_file, path_to_output_file, n_iter |> Integer.to_string])
  end

  defp make_tree_handler({_ret, 0}), do: 0
  defp make_tree_handler({ret, status_code}) do
    IO.puts """
    make_tree.cxx error
    status code: #{status_code}
    ret: #{ret}
    """
    System.halt(1)
  end
end
