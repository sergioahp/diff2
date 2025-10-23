#set page(height: auto, margin: 2em, width: 35em)

#let test-state = state("test-lines", ())

[
  #show raw.line: it => {
    test-state.update(s => s + (it,))
  }
  ```py
  """
  This is a multiline test string
  """
  ```
]

#context {
  let lines = test-state.get()
  let line = lines.at(1) // "This is a multiline test string"

  [= Original full line]
  text(font: "DejaVu Sans Mono", line.body)
  linebreak()
  linebreak()

  [= Try using clusters from original styled body]
  // Use the outside-styling test approach
  let full-text = line.body.child.text

  let parts = ()
  for (i, c) in full-text.clusters().enumerate() {
    if i >= 20 and i < 24 {
      // Highlight this character
      parts.push(box(
        fill: yellow.lighten(50%),
        radius: 0.2em,
        inset: (x: 0.05em),
        outset: (y: 0.15em),
        c
      ))
    } else {
      parts.push(c)
    }
  }

  // Now wrap the whole thing in the styled function manually
  // But we can't call .func() easily...
  // Let's try a different approach
  text(font: "DejaVu Sans Mono", parts.join())
  [ ← Lost gray]
  linebreak()
  linebreak()

  [= What if we just show the parts inside a show rule context?]
  // Maybe the styling is context-dependent?
  [Trying: ]
  {
    show raw.line: it => it // dummy show rule
    parts.join()
  }
}
