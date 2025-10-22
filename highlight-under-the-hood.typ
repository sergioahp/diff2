#let code-lines = (
  "def encode_batch(x: Float[Tensor, \"b d_in\"]) -> Float[Tensor, \"b d_sae\"]:",
  "    return (x - B_DEC) @ W_ENC - TAU @ W_ENC - TAU",
  "",
  "def encode_batch(x: Float[Array, \"b d_model\"]) -> Float[Array, \"b d_sae\"]:",
  "    return x @ W_ENC^T + BIAS_TOTAL",
)

#let highlighted-lines = (2, (4, rgb("#E5F3FF")))
#let inline-highlights = (
  (line: 1, start: 4, end: 15, fill: blue.lighten(65%)),
  (line: 1, start: 16, end: 22, fill: purple.lighten(80%)),
  (line: 2, start: 11, end: 31, fill: yellow.transparentize(40%), tag: "(A)"),
  (line: 5, start: 15, end: 32, fill: green.transparentize(55%), tag: "(B)"),
)

#let default-line-highlight = luma(235)
#let inline-radius = 0.22em
#let inline-inset = (x: 0.0em, y: 0.0em)
#let inline-outset = (
  top: 0.2em,
  bottom: 0.2em,
  left: 0em,
  right: 0em,
)

#let make-highlight-map(lines, default-color) = {
  let map = (:)
  for item in lines {
    if type(item) == int {
      map.insert(str(item), default-color)
    } else if type(item) == array {
      map.insert(str(item.at(0)), item.at(1))
    }
  }
  map
}

#let highlight-map = make-highlight-map(highlighted-lines, default-line-highlight)

#let collect-inline(line-number) = {
  inline-highlights
    .filter(h => h.line == line-number)
    .sorted(key: h => (h.start, h.end))
}

#let code-font = text.with(font: "DejaVu Sans Mono", size: 10pt)
#let tag-font = text.with(font: "DejaVu Sans Mono", size: 8pt, weight: "semibold")

#let slice-text(line, start, end) = line.slice(start, if end == none { line.len() } else { end })

#let repeat-char(ch, count) = {
  if count <= 0 {
    ""
  } else {
    range(count).map(_ => ch).join()
  }
}

#let pad-left(text, width) = {
  let diff = width - text.len()
  if diff <= 0 {
    text
  } else {
    repeat-char(" ", diff) + text
  }
}

#let build-inline(line, spans) = {
  if spans.len() == 0 {
    return code-font(line)
  }

  let parts = ()
  let cursor = 0

  for span in spans {
    let start = span.start
    let end = if "end" in span { span.end } else { none }
    let end = if end == none { line.len() } else { end }

    if start > cursor {
      parts.push(code-font(slice-text(line, cursor, start)))
    }

    let snippet = code-font(slice-text(line, start, end))
    let box-radius = if "tag" in span {
      (
        top-right: 0pt,
        bottom-right: 0pt,
        rest: inline-radius,
      )
    } else {
      inline-radius
    }

    let highlight = box(
      fill: span.fill,
      radius: box-radius,
      inset: inline-inset,
      outset: inline-outset,
      stroke: span.fill.darken(35%) + 0.2pt,
      snippet,
    )

    if "tag" in span {
      let tag-box = box(
        fill: span.fill,
        radius: (
          top-left: 0pt,
          bottom-left: 0pt,
          rest: inline-radius,
        ),
        inset: inline-inset,
        outset: inline-outset,
        stroke: span.fill.darken(35%) + 0.2pt,
        tag-font(span.tag),
      )
      parts.push([#highlight#h(0pt, weak: true)#tag-box])
    } else {
      parts.push(highlight)
    }

    cursor = end
  }

  if cursor < line.len() {
    parts.push(code-font(slice-text(line, cursor, line.len())))
  }

  parts.join()
}

#let build-line(line-number, raw-line) = {
  let spans = collect-inline(line-number)
  let inlines = build-inline(raw-line, spans)
  let key = str(line-number)
  let line-fill = if key in highlight-map {
    highlight-map.at(key)
  } else {
    none
  }

  let content = if line-fill != none {
    box(
      fill: line-fill,
      inset: (x: 0.3em, y: 0.1em),
      radius: 0.25em,
      inlines,
    )
  } else {
    inlines
  }

  content
}

#let render-lines(lines) = {
  let digits = str(lines.len()).len()
  let rows = lines.enumerate().map(((idx, line)) => {
    let number = idx + 1
    let label = pad-left(str(number), digits)
    (
      box(
        fill: luma(250),
        inset: (x: 0.2em, y: 0.1em),
        radius: 0.2em,
        code-font(label),
      ),
      build-line(number, line),
    )
  })

  grid(
    columns: (auto, 1fr),
    column-gutter: 0.6em,
    row-gutter: 0.15em,
    ..rows.flatten(),
  )
}

= Hand-Rolled Highlights

This document reimplements the core of Codly’s highlight pipeline without importing the package. Each line is rendered manually, echoes the same three stages Codly follows, and exposes the intermediate structures so you can see what happens under the hood.

- compute a per-line fill map from the `highlighted-lines` argument.
- extract the slices determined by `inline-highlights`, carving the raw string into foreground spans.
- wrap the slices in rounded `box` overlays while preserving the untouched text segments.
- finally drop line numbers and code into a two-column grid.

#render-lines(code-lines)
