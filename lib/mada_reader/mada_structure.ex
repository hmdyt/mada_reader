defmodule MadaReader.MadaStructure do
  defstruct trigger_counter: 0,
  clock_counter: 0,
  input_ch2_counter: 0,
  fadc: 0,
  version_year: 0,
  version_month: 0,
  version_sub: 0,
  encoding_clock_depth: 0,
  hit: 0

  def write(mada_structures, path) do
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
    path |> File.write("", [:write])
    path |> File.write(out_string, [:append])
    path
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
end
