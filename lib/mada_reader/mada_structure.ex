defmodule MadaReader.MadaStructure do
  @tmp_dir Application.fetch_env!(:mada_reader, :tmp_dir)

  defstruct trigger_counter: 0,
  clock_counter: 0,
  input_ch2_counter: 0,
  fadc: 0,
  version_year: 0,
  version_month: 0,
  version_sub: 0,
  encoding_clock_depth: 0,
  hit: 0

  def write(mada_structures, path_to_mada) do
    perpare_tmp_dir()
    mada_filename = path_to_mada
    |> Path.basename
    |> String.replace(".mada", ".tmp")
    path_to_tmp = "#{@tmp_dir}/#{mada_filename}"
    n_iter = mada_structures |> length()
    out_string = mada_structures
    |> Enum.with_index()
    |> Enum.map(
      fn {x, i} ->
        MadaReader.ProgressBar.render_bar(i, n_iter - 1, "writing tmp file: ")
        encode_a_event(x)
      end
    )
    |> Enum.join(" ")
    path_to_tmp |> File.write("", [:write])
    path_to_tmp |> File.write(out_string, [:append])
    path_to_tmp |> IO.inspect()
  end

  defp encode_a_event(mada_structure) do
    [
      mada_structure.trigger_counter,
      mada_structure.clock_counter,
      mada_structure.input_ch2_counter,
      mada_structure.version_year,
      mada_structure.version_month,
      mada_structure.version_sub,
      mada_structure.encoding_clock_depth,
      mada_structure.fadc.ch0 |> Enum.join(" "),
      mada_structure.fadc.ch1 |> Enum.join(" "),
      mada_structure.fadc.ch2 |> Enum.join(" "),
      mada_structure.fadc.ch3 |> Enum.join(" "),
      mada_structure.hit |> List.flatten() |> Enum.join(" ")
    ]
    |> Enum.join(" ")
  end

  defp perpare_tmp_dir do
    File.mkdir(@tmp_dir)
  end
end
