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

  [= Original styled element]
  text(font: "DejaVu Sans Mono", line.body)
  linebreak()
  linebreak()

  [= Explore the styled element]
  let styled-elem = line.body
  [Type: #type(styled-elem)]
  linebreak()
  [Fields: #styled-elem.fields().keys()]
  linebreak()
  [Has .func(): #("func" in styled-elem.fields())]
  linebreak()
  [.child: #repr(styled-elem.child)]
  linebreak()
  linebreak()

  [= Try to call the function on new content]
  // The styled element has a .func() that should recreate it
  let style-func = styled-elem.func()
  [style-func type: #type(style-func)]
  linebreak()

  // Can we just apply this to arbitrary text?
  // text(font: "DejaVu Sans Mono", style-func("test"))
  [Attempting to use style function...]
  linebreak()
  linebreak()

  [= Alternative: Rebuild styled with same properties]
  // What if we use the metadata from the styled element?
  [Styled fields available: ]
  for (key, value) in styled-elem.fields() {
    [#key: #repr(type(value)), ]
  }
  linebreak()
  linebreak()

  [= Try text() with fill extracted from somewhere]
  // The gray color must be stored somewhere in the styled element
  // Let's see if we can find it
  [Looking for color information...]
  linebreak()

  [= Approach: Slice and reconstruct styled elements]
  // What if we create three styled elements from the original?
  let full-text = styled-elem.child.text

  // Try to manually create styled elements
  // We know it's styled(...) but what are the params?
  [Can we access styled constructor? Probably not directly...]
}
