defmodule MadaReader.BinaryParser do
  def run(path_to_mada \\ "/Users/yuto/sandbox/mada_reader/per0014/GBKB-13_0003.mada") do
    path_to_mada
    |> open_mada_file()
    |> split_in_event()
    |> parse_all_events()
    |> Stream.filter(&(&1 != nil))
  end

  defp open_mada_file(file_path) do
    put_memory_usage("start at open_mada_file")
    {:ok, file} = File.open(file_path)
    file
  end

  defp split_in_event(file) do
    put_memory_usage("start at split_in_event")
    file
    |> binread_wrapper()
    |> String.split("uPIC")
  end

  defp binread_wrapper(file) do
    try do
      IO.binread file, :eof
    rescue
      _ -> IO.binread file, :all
    end
  end

  defp parse_one_event(
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
    IO.puts ""
    put_memory_usage("start at parse_one_event")
    %MadaReader.MadaStructure{
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
  defp parse_one_event(_), do: nil

  defp parse_all_events(splited_events) do
    put_memory_usage("start at parse_all_events")
    # n_events = splited_events |> length()
    splited_events
    |> Stream.map(&parse_one_event/1)
  end

  defp parse_fadcs(
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
  defp parse_fadcs(_, fadcs_map) do
    fadcs_map = %{fadcs_map | ch0: Enum.reverse(fadcs_map.ch0)}
    fadcs_map = %{fadcs_map | ch1: Enum.reverse(fadcs_map.ch1)}
    fadcs_map = %{fadcs_map | ch2: Enum.reverse(fadcs_map.ch2)}
    fadcs_map = %{fadcs_map | ch3: Enum.reverse(fadcs_map.ch3)}
    fadcs_map
  end

  defp parse_hits(<<_header::size(32), hit::size(128), remain::binary>>, hits_list) do
    parse_hits(remain, [hit | hits_list])
  end
  defp parse_hits(_, hit_list) do
    hit_list
    |> Enum.reverse()
    |> Enum.map(&parse_a_hit/1)
  end

  defp parse_a_hit(hit) do
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

  defp put_memory_usage(msg) do
    allocated = :recon_alloc.memory(:allocated) / 1000_000
    |> Float.floor
    IO.puts "memory usage: #{allocated} MB  #{msg}"
  end
end
