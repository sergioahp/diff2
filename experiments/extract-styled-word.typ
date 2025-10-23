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

  [= Approach 1: Extract via .child.text slice]
  let extracted = line.body.child.text.slice(20, 24) // "test"
  text(font: "DejaVu Sans Mono", extracted)
  [ ← Lost gray color]
  linebreak()
  linebreak()

  [= Approach 2: Wrap in styled function]
  let styled-func = line.body.func()
  let extracted2 = line.body.child.text.slice(20, 24)

  // Can we call styled-func on just the substring?
  // styled-func(extracted2)
  [Attempt: #repr(styled-func)]
  linebreak()
  linebreak()

  [= Approach 3: Check if we can construct styled]
  [Type of line.body: #type(line.body)]
  linebreak()
  [Has .func(): #("func" in line.body.fields())]
  linebreak()
  [line.body.func() returns: #repr(type(line.body.func()))]
  linebreak()
  linebreak()

  [= Approach 4: Try to manually style]
  // Maybe we can use text() with the same color?
  let word = "test"
  text(fill: luma(150), font: "DejaVu Sans Mono", word)
  [ ← Manually colored gray]
  linebreak()
  linebreak()

  [= Debug: Full line.body structure]
  repr(line.body)
}
