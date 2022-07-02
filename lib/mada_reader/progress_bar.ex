defmodule MadaReader.ProgressBar do
  @format_bar  [
    bar_color: [IO.ANSI.magenta],
    blank_color: [IO.ANSI.magenta],
    bar: "█",
    blank: "░",
  ]

  @format_spinner  [
    frames: :braille,
    spinner_color: IO.ANSI.magenta,
    done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Done"],
  ]

  def render_bar(i, n, msg) do
    ProgressBar.render(i, n, @format_bar ++ [left: msg])
  end

  def render_spinner(msg, func) do
    ProgressBar.render_spinner(@format_spinner ++ [text: msg], func)
  end
end
