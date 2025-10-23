#set page(height: auto, margin: 2em, width: 30em)

// Character-based highlighting using the test file approach
#let highlight-chars-in-body(line-body, start, end, fill) = {
  // Get the text from the styled body
  let text-str = line-body.child.text

  // Build character by character like the test file does
  let parts = ()

  for (i, c) in text-str.clusters().enumerate() {
    if i >= start and i < end {
      // Highlighted character - but how to keep styling?
      // Just wrap in box, the cluster inherits context
      parts.push(box(
        fill: fill,
        radius: 0.2em,
        inset: (x: 0.05em, y: 0.0em),
        outset: (y: 0.15em),
        c
      ))
    } else {
      // Regular character
      parts.push(c)
    }
  }

  parts.join()
}

#let test-state = state("test-lines", ())

[
  #show raw.line: it => {
    test-state.update(s => s + (it,))
  }
  ```py
  """
  This is a multiline test string
  with multiple lines here
  """
  ```
]

#context {
  let lines = test-state.get()

  // Skip first line, show lines 1-3
  let visible-lines = lines.slice(1, 4)

  [= Original (no highlight)]

  for (idx, line) in visible-lines.enumerate() {
    [Line #(idx + 1): ]
    text(font: "DejaVu Sans Mono", line.body)
    linebreak()
  }

  [= With "test" highlighted (char 20-24)]

  for (idx, line) in visible-lines.enumerate() {
    [Line #(idx + 1): ]

    if idx == 0 {
      // Highlight "test" in the string (characters 20-24)
      text(font: "DejaVu Sans Mono",
        highlight-chars-in-body(line.body, 20, 24, yellow.lighten(50%))
      )
    } else {
      text(font: "DejaVu Sans Mono", line.body)
    }

    linebreak()
  }

  [= Debug info]
  [Line 1 text: #repr(lines.at(1).text)]
  linebreak()
  [Line 1 body type: #repr(type(lines.at(1).body))]
  linebreak()
  [Line 1 body.func: #repr(lines.at(1).body.func())]
}
