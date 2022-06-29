defmodule MadaStructure do
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
    out_string = mada_structures
    |> Enum.map(&encode_a_event/1)
    |> Enum.join(" ")
    path |> File.write("", [:write])
    path |> File.write(out_string, [:append])
    path
  end

  def encode_a_event(mada_structure) do
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

defmodule MadaReader.MadaRead do

  def run(path_to_mada \\ "/Users/yuto/sandbox/mada_reader/per0014/GBKB-13_0003.mada") do
    path_to_mada
    |> open_mada_file()
    |> split_in_event()
    |> Enum.map(&parse_one_event/1)
    |> Enum.filter(&(&1 != nil))
  end

  def open_mada_file(file_path) do
    {:ok, file} = File.open(file_path)
    file
  end

  def split_in_event(file) do
    file
    |> IO.binread(:eof)
    |> String.split("uPIC")
  end

  def _encode_to_json(mada_structure) do
    {:ok, res} = mada_structure |> JSON.encode()
    res
  end

  def parse_one_event(
    <<
    0xeb, 0x90,
    0x19, 0x64,
    trigger_counter::size(32),
    clock_counter::size(32),
    input_ch2_counter::size(32),
    fadc::binary-size(8192),
    #fadc::size(65536),
    version_year::size(8), version_month::size(8),
    version_sub::size(4), 0::size(1), encoding_clock_depth::size(11),
    hit::binary-size(20460),
    #hit::size(163680),
    >>
  ) do
    %MadaStructure{
      trigger_counter: trigger_counter,
      clock_counter: clock_counter,
      input_ch2_counter: input_ch2_counter,
      fadc: fadc |> parse_fadcs(%{ch0: [], ch1: [], ch2: [], ch3: []}),
      version_year: version_year,
      version_month: version_month,
      version_sub: version_sub,
      encoding_clock_depth: encoding_clock_depth,
      hit: hit |> parse_hits([])
    }
  end
  def parse_one_event(_), do: nil

  def parse_fadcs(
      <<
      0x4::size(4), 0::size(2), ch0::size(10),
      0x5::size(4), 0::size(2), ch1::size(10),
      0x6::size(4), 0::size(2), ch2::size(10),
      0x7::size(4), 0::size(2), ch3::size(10),
      remain::binary
      >>,
      fadcs_map
    ) do
      fadcs_map = %{fadcs_map | ch0: [ch0 | fadcs_map.ch0]}
      fadcs_map = %{fadcs_map | ch1: [ch1 | fadcs_map.ch1]}
      fadcs_map = %{fadcs_map | ch2: [ch2 | fadcs_map.ch2]}
      fadcs_map = %{fadcs_map | ch3: [ch3 | fadcs_map.ch3]}
      parse_fadcs(remain, fadcs_map)
  end
  def parse_fadcs(_, fadcs_map) do
    fadcs_map = %{fadcs_map | ch0: Enum.reverse(fadcs_map.ch0)}
    fadcs_map = %{fadcs_map | ch1: Enum.reverse(fadcs_map.ch1)}
    fadcs_map = %{fadcs_map | ch2: Enum.reverse(fadcs_map.ch2)}
    fadcs_map = %{fadcs_map | ch3: Enum.reverse(fadcs_map.ch3)}
    fadcs_map
  end

  def parse_hits(<<_header::size(32), hit::size(128), remain::binary>>, hits_list) do
    parse_hits(remain, [hit | hits_list])
  end
  def parse_hits(_, hit_list) do
    hit_list
    |> Enum.reverse()
    |> Enum.map(&parse_a_hit/1)
  end

  def parse_a_hit(hit) do
    use Bitwise
    0..127
    |> Enum.map(
      fn i ->
        ((hit >>> i) &&& 1 ) == 1
      end
    )
    |> Enum.map(&bool_to_01/1)
  end

  defp bool_to_01(true), do: 1
  defp bool_to_01(false), do: 0
end
