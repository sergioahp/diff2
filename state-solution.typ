// for some reason width auto or too small breaks the background color of code
#set page(height:auto, margin:4em, width: 40em)

// Character-level inline highlighting
//
// Supports highlighting specific character ranges within a line
// while preserving syntax highlighting colors.
//
// Works for both:
// - Multi-token lines: e.g., "def cool_function():"
// - Single-token lines: e.g., long strings or comments
//
// Assumption: Spans on the same line do NOT overlap
//
// Algorithm:
// 1. Extract style-func and styles from styled element
// 2. Sort spans by start position
// 3. Build parts: unhighlighted → highlighted → unhighlighted → ...
// 4. Reconstruct each part with style-func([#text], styles)
// 5. Wrap highlighted parts in colored boxes

#let build-inline-char-level(styled-elem, spans) = {
  if spans.len() == 0 {
    return styled-elem  // No highlights, return as-is
  }

  let style-func = styled-elem.func()
  let styles = styled-elem.styles
  let full-text = styled-elem.child.text

  // Filter out invalid spans that are out of bounds
  let valid-spans = spans.filter(s => s.start < full-text.len() and s.end <= full-text.len())

  if valid-spans.len() == 0 {
    return styled-elem  // No valid highlights
  }

  // Sort spans by start position
  let sorted-spans = valid-spans.sorted(key: s => s.start)

  let parts = ()
  let cursor = 0

  for span in sorted-spans {
    // Add unhighlighted text before span
    if span.start > cursor {
      let before-text = full-text.slice(cursor, span.start)
      parts.push(style-func([#before-text], styles))
    }

    // Add highlighted span
    let highlight-text = full-text.slice(span.start, span.end)
    parts.push(box(
      fill: span.fill,
      radius: 0.2em,
      inset: (x: 0.1em, y: 0.0em),
      outset: (x: 0.0em, y: 0.15em),
      style-func([#highlight-text], styles)
    ))

    cursor = span.end
  }

  // Add remaining text after last span
  if cursor < full-text.len() {
    let after-text = full-text.slice(cursor)
    parts.push(style-func([#after-text], styles))
  }

  parts.join()
}

#let build-inline-multitoken(line-body, line-text, spans) = {
  let children = line-body.children
  let parts = ()
  let char-pos = 0

  for child in children {
    // Extract text from child - it might be styled or plain text
    let child-text = if "child" in child.fields() {
      child.child.text
    } else if type(child) == content {
      child.text
    } else {
      str(child)
    }
    let child-start = char-pos
    let child-end = char-pos + child-text.len()

    // Find spans that actually overlap this child
    let child-spans = ()
    for span in spans {
      // Check if span overlaps with this child's range
      let overlap-start = calc.max(span.start, child-start)
      let overlap-end = calc.min(span.end, child-end)

      if overlap-start < overlap-end {
        // There's actual overlap
        child-spans.push((
          start: overlap-start - child-start,
          end: overlap-end - child-start,
          fill: span.fill
        ))
      }
    }

    if child-spans.len() > 0 and "styles" in child.fields() {
      // This child has highlights and is a styled element
      parts.push(build-inline-char-level(child, child-spans))
    } else {
      // No highlights or not a styled element, keep as-is
      parts.push(child)
    }

    char-pos = child-end
  }

  parts.join()
}

#let build-inline-smart(line-body, line-text, spans) = {
  if spans.len() == 0 {
    return line-body  // No highlights needed
  }

  // Check if single styled element or sequence
  if "children" in line-body.fields() {
    // Multi-token: line.body is sequence of styled elements
    return build-inline-multitoken(line-body, line-text, spans)
  } else {
    // Single token: line.body is one styled element
    return build-inline-char-level(line-body, spans)
  }
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

      // Apply character-level highlights while preserving syntax highlighting
      let content = text(font: "DejaVu Sans Mono",
        build-inline-smart(line.body, line.text, spans))

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

      // Apply character-level highlights while preserving syntax highlighting
      let content = text(font: "DejaVu Sans Mono",
        build-inline-smart(line.body, line.text, spans))

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


= Test 1: Multi-token line with highlight

#diff(
  ```py
  def cool_function():
  ```,
  ```py
  def better_function():
  ```,
  before-inline: (
    (line: 1, start: 4, end: 17, fill: red.darken(20%)),  // "cool_function"
  ),
  after-inline: (
    (line: 1, start: 4, end: 18, fill: green.darken(30%)), // "better_function"
  )
)

= Test 2: Single-token string with highlight

#diff(
  ```py
  """
  This is a multiline test string
  """
  ```,
  ```py
  """
  This is a multiline demo string
  """
  ```,
  before-inline: (
    (line: 2, start: 20, end: 24, fill: red.darken(20%)),  // "test"
  ),
  after-inline: (
    (line: 2, start: 20, end: 24, fill: green.darken(30%)), // "demo"
  )
)

= Test 3: Multiple highlights per line

#diff(
  ```py
  result = calculate_total(a, b)
  ```,
  ```py
  output = compute_sum(x, y)
  ```,
  before-inline: (
    (line: 1, start: 0, end: 6, fill: red.darken(20%)),    // "result"
    (line: 1, start: 9, end: 24, fill: red.darken(20%)),   // "calculate_total"
  ),
  after-inline: (
    (line: 1, start: 0, end: 6, fill: green.darken(30%)),  // "output"
    (line: 1, start: 9, end: 20, fill: green.darken(30%)), // "compute_sum"
  )
)
