defmodule MadaReader.Cli do
  def parse(argv) do
    parser()
    |> Optimus.parse!(argv)
    |> check_subcommand_existance()
  end

  defp parser do
    Optimus.new!(
      name: "mada_reader",
      description: "Gigabit Iwakiboard decoder",
      author: "Hamada Yuto",
      allow_unknown_args: false,
      subcommands: subcommands()
    )
  end

  defp subcommands do
    [
      file: file(),
      dir: dir(),
    ]
  end

  defp subcommands_list do
    subcommands()
    |> Enum.map(
      fn {com_name, _com_attr} ->
        com_name |> Atom.to_string()
      end
    )
    |> Enum.join(", ")
  end

  defp file do
    [
      name: "file",
      about: "dump one file",
      args: [
        input: [
          value_name: "INPUT_FILE",
          help: ".mada file",
          required: true,
          parser: :string
        ],
        output: [
          value_name: "OUTPUT_FILE",
          help: ".root file",
          required: true,
          parser: :string
        ]
      ]
    ]
  end

  defp dir do
    [
      name: "dir",
      about: "dump all .mada file in a dir",
      args: [
        dir: [
          value_name: "TARGET_DIR",
          help: "like /path/to/perXXXX",
          requireed: true,
          parser: :string
        ]
      ]
    ]
  end


  defp check_subcommand_existance({[subcom], parse_result}) do
    {[subcom], parse_result}
  end
  defp check_subcommand_existance(_) do
    IO.puts ""
    IO.puts "reqired subcommand: #{subcommands_list()}"
    IO.puts ""
    System.halt(1)
  end
end
