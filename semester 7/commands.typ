#import "@preview/octique:0.1.0": *

#let small(body) = {
  text(0.8em)[#body]
}


// Display inline code in a small box
// that retains the correct baseline.
#show raw.where(block: false): box.with(
  fill: luma(240),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

// Display block code in a larger block
// with more padding.
#show raw.where(block: true): block.with(
  fill: luma(240),
  inset: 8pt,
  radius: 4pt,
  width: 100%,
  stroke: (cap: "round", dash: (0pt,2.5pt),thickness: 1pt, paint: gray)
)


#let callout(body, color: red, title: "Callout", icon: "") = {
  block(body)
}