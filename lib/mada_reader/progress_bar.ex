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

  def render_count_bar(i, n, msg) do
    try do
      ProgressBar.render(i, n, @format_bar ++ [left: msg, suffix: :count])
    rescue
      _ -> 0
    end
  end

  def render_bytes_bar(i, n, msg) do
    try do
      ProgressBar.render(i, n, @format_bar ++ [suffix: :bytes, left: msg])
    rescue
      _ -> 0
    end
  end

  def render_spinner(msg, func) do
    format = [text: msg, done: [IO.ANSI.green, "✓", IO.ANSI.reset, " Done [#{msg}]"]]
      ++ @format_spinner
    ProgressBar.render_spinner(format ++ [text: msg], func)
  end
end
