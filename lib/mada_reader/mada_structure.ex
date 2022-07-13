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
    path_to_tmp_file = prepare_tmp_file(path_to_mada)
    # n_iter = mada_structures |> length()
    n_iter = mada_structures
    |> Stream.map(&encode_a_event/1)
    |> Stream.map(fn x -> write_an_event(x, path_to_tmp_file) end)
    |> Enum.to_list()
    |> length
    {path_to_tmp_file, n_iter}
  end

  defp prepare_tmp_file(path_to_mada) do
    perpare_tmp_dir()
    mada_filename = path_to_mada
    |> Path.basename
    |> String.replace(".mada", ".tmp")
    path_to_tmp_file = "#{@tmp_dir}/#{mada_filename}"
    path_to_tmp_file |> File.write("", [:write])
    path_to_tmp_file
  end

  defp encode_a_event(mada_structure) do
    add_enter = &(&1 <> "\n")
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
    |> add_enter.()
  end

  defp write_an_event(encoded_mada_structure, path_to_tmp_file) do
    :ok = path_to_tmp_file |> File.write(encoded_mada_structure, [:append])
  end

  defp perpare_tmp_dir do
    File.mkdir(@tmp_dir)
  end
end
