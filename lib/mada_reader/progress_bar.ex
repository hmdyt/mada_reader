defmodule MadaReader.ProgressBar do
  @format_bar  [
    bar_color: [IO.ANSI.magenta],
    blank_color: [IO.ANSI.magenta],
    bar: "█",
    blank: "░",
  ]

  def render_bar(i, n, msg) do
    ProgressBar.render(i, n, @format_bar ++ [left: msg])
  end
end
