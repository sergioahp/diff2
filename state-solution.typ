// for some reason width auto or too small breaks the background color of code
#set page(height:auto, margin:4em, width: 40em)

// Inline highlighting helpers
#let build-inline-with-highlights(line-body, line-text, spans) = {
  if spans.len() == 0 {
    return line-body
  }

  // Extract styled children from line.body (it's a sequence)
  let children = line-body.children
  let parts = ()
  let char-pos = 0

  for child in children {
    // Each child is a styled element with .child field containing text
    let child-content = child.child
    let child-text = if type(child-content) == content {
      child-content.text
    } else {
      str(child-content)
    }
    let child-len = child-text.len()
    let child-start = char-pos
    let child-end = char-pos + child-len

    // Check if this child overlaps with any highlight span
    let overlapping-span = none
    for span in spans {
      let span-start = span.start
      let span-end = if "end" in span { span.end } else { line-text.len() }

      if child-start >= span-start and child-end <= span-end {
        overlapping-span = span
        break
      }
    }

    if overlapping-span != none {
      // Wrap this styled child in a highlight box
      parts.push(box(
        fill: overlapping-span.fill,
        radius: 0.2em,
        inset: (x: 0.1em, y: 0.0em),
        outset: (x: 0.0em, y: 0.15em),
        child,
      ))
    } else {
      // Keep styled child as-is
      parts.push(child)
    }

    char-pos = child-end
  }

  parts.join()
}

#let diff(before, after, before-inline: (), after-inline: ()) = {
  let before-state = state("before-lines", ())
  let after-state = state("after-lines", ())

  // Collect before lines
  [
    #show raw.line: it => {
      before-state.update(s => s + (it,))
    }
    #before
  ]

  // Collect after lines
  [
    #show raw.line: it => {
      after-state.update(s => s + (it,))
    }
    #after
  ]

  // Build grid inside context block
  context {
    let before-lines = before-state.get()
    let after-lines = after-state.get()

    let rows = ()

    // Helper to get inline highlights for a line
    let collect-inline = (highlights, line-num) => {
      highlights.filter(h => h.line == line-num)
    }

    // Add before lines (removed lines)
    for (idx, line) in before-lines.enumerate() {
      let line-num = idx + 1
      let bg-color = red.transparentize(80%)
      let spans = collect-inline(before-inline, line-num)

      // Preserve syntax highlighting when no inline highlights
      let content = if spans.len() == 0 {
        text(font: "DejaVu Sans Mono", line.body)
      } else {
        text(font: "DejaVu Sans Mono", build-inline-with-highlights(line.body, line.text, spans))
      }

      rows.push((
        box(
          inset: (
            left: 0.2em,
            right: 0.8em,
            top: 0.20em,
            bottom: 0.20em
          ),
          text(font: "DejaVu Sans Mono", [#line-num])
        ),
        box(
          fill: bg-color,
          inset: (
            left: 0.1em,
            right: 0.1em,
            top: 0.25em,
            bottom: 0.25em
          ),
          content
        )
      ))
    }

    // Add after lines (added lines)
    for (idx, line) in after-lines.enumerate() {
      let line-num = idx + 1
      let bg-color = green.transparentize(80%)
      let spans = collect-inline(after-inline, line-num)

      // Preserve syntax highlighting when no inline highlights
      let content = if spans.len() == 0 {
        text(font: "DejaVu Sans Mono", line.body)
      } else {
        text(font: "DejaVu Sans Mono", build-inline-with-highlights(line.body, line.text, spans))
      }

      rows.push((
        box(
          inset: (
            left: 0.2em,
            right: 0.8em,
            top: 0.20em,
            bottom: 0.20em
          ),
          text(font: "DejaVu Sans Mono", [#line-num])
        ),
        box(
          fill: bg-color,
          inset: (
            left: 0.1em,
            right: 0.1em,
            top: 0.25em,
            bottom: 0.25em
          ),
          content
        )
      ))
    }

    // Return the grid
    grid(
      columns: (auto, 1fr),
      row-gutter: 0.0em,
      ..rows.flatten(),
    )
  }
}


= Diff Output

#diff(
  ```py
  def cool_function():
    """
    Returns: A number
    """
    return 2
  print(f"{k+5=}")
  ```,
  ```py
  print(f"{5+6=}")
  print(f"{9+5=}")
  print(f"{10+5=}")
  ```,
  before-inline: (
    (line: 1, start: 4, end: 17, fill: red.darken(20%)),
  ),
  after-inline: (
    (line: 3, start: 0, end: 5, fill: green.darken(30%)),
  ),
)
