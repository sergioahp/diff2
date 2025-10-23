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

  let styled-elem = line.body

  [= The .styles field]
  [Type of styles: #type(styled-elem.styles)]
  linebreak()
  [Styles repr: #repr(styled-elem.styles)]
  linebreak()
  linebreak()

  [= Can we use .func() with .styles?]
  let style-func = styled-elem.func()
  let styles = styled-elem.styles

  // Try calling the function with styles parameter
  // style-func might need (child: ..., styles: ...)
  [Trying to reconstruct...]
  linebreak()
  linebreak()

  [= Try using style() constructor]
  // Maybe we can use the style() function?
  let word = "test"

  // Attempt 1: Can we call style-func somehow?
  // style-func(child: [#word], styles: styles)

  [= Reconstruct using fields]
  // Create new styled elements with the same styles
  let full-text = styled-elem.child.text
  let before = full-text.slice(0, 20)
  let highlighted = full-text.slice(20, 24)
  let after = full-text.slice(24)

  // Try to manually build new styled elements
  // If we can access the styled() constructor...
  text(font: "DejaVu Sans Mono", [
    Attempting reconstruction with positional args:
    #styled-elem.func()([#before], styled-elem.styles)
  ])
  linebreak()
  linebreak()

  [= Full reconstruction with highlight]
  text(font: "DejaVu Sans Mono", [
    #styled-elem.func()([#before], styled-elem.styles)#box(
      fill: yellow.lighten(50%),
      radius: 0.2em,
      inset: (x: 0.1em),
      outset: (y: 0.15em),
      styled-elem.func()([#highlighted], styled-elem.styles)
    )#styled-elem.func()([#after], styled-elem.styles)
  ])
}
