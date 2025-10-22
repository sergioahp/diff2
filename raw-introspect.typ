#set text(12pt)

#show raw.line: it => figure(kind: "__introspect-line", numbering: none, caption: none)[#it]

= Raw Line Introspection

The raw block is rendered below. Afterwards, we query the synthesized `raw.line` elements and inspect them with `repr`.

#let code-block = ```python
# Suggested change
def encode_batch(x: Float[Tensor, "b d_in"]) -> Float[Tensor, "b d_sae"]:
    return (x - B_DEC) @ W_ENC - TAU @ W_ENC - TAU
def encode_batch(x: Float[Array, "b d_model"]) -> Float[Array, "b d_sae"]:
    return x @ W_ENC^T + BIAS_TOTAL
```

#code-block

== Captured `raw.line`s

#context {
  let lines = query(figure.where(kind: "__introspect-line"))
  for line in lines {
    [line.number = #line.body.number; repr = #repr(line.body)]
  }
}

Inline raw example:

#let inline = raw("Inline `code`\nacross two lines", block: true)

#inline

== Captured `raw.line`s (full document)

#context {
  let lines = query(figure.where(kind: "__introspect-line"))
  for line in lines {
    [line.number = #line.body.number; repr = #repr(line.body)]
  }
}
