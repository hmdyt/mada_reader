defmodule MadaReader.ProgressBar do
  @format [
    bar_color: [IO.ANSI.green_background],
    blank_color: [IO.ANSI.red_background],
    bar: " ",
    blank: " ",
    left: " ",
    right: " ",
  ]

  def render(i, n) do
    ProgressBar.render(i, n, @format)
  end
end
