#import "@preview/octique:0.1.0": *

#let small(body) = {
  text(0.8em)[#body]
}

#let b(body) = {
  text(weight: "bold")[#body]
}



#let callout(color: rgb("#7a9bfd"), title: "Callout", title-color: white, icon: "info", body, ..args) = {
  block(..args, stroke: (paint: color), radius: 5pt, above: 1.5em, below: 1.5em)[
    #if (body!=[]) {
      block(fill: color, radius: (top: 5pt), below: 0pt)[
        #grid(
          columns: (2em,1fr),
          rows: 2em,
          align: (center + horizon, left + horizon),
          octique-inline(icon, color: title-color, width: 1.2em),
          box(inset: (left: 0.15em))[#text(title, 1.2em, weight: "bold", title-color)]
        )
      ]
    } else {
      block(fill: color, radius: 5pt, below: 0pt)[
        #grid(
          columns: (2em,1fr),
          rows: 2em,
          align: (center + horizon, left + horizon),
          octique-inline(icon, color: title-color, width: 1.2em),
          box(inset: (left: 0.15em))[#text(title, 1.2em, weight: "bold", title-color)]
        )
      ]
    }
    #if (body!=[]) {
      block(inset: (x:0.6em, y: 0.7em))[#body]
    }
  ]
}
