#import "@preview/octique:0.1.0": *

#let small(body) = {
  text(0.85em)[#body]
}

#let b(body, color: black) = {
  text(weight: "bold", fill: color)[#body]
}

#let u(body) = {
  underline(body)
}

#let mc(body, color) = {
  text(fill: color)[$#body$]
}

#let tc(body, color) = {
  text(fill: color)[#body]
}

#let octicon(icon, color: black) = {
  octique-inline(icon, baseline: 15%, color: color)
}

#let cimage(..args) = {
  align(center,image(..args))
}

#let todo(body) = {
  rect(inset: (x: 4pt, y: 5pt), radius: 5pt, stroke: (paint: red, dash: (4pt, 4pt)))[
    #text(fill: red)[#b(color: red)[TODO]~#body]
  ]
}

#let callout(color: rgb("#7a9bfd"), title: "Callout", title-color: white, icon: "info", body, ..args) = {
  block(..args, stroke: (paint: color), radius: 5pt, above: 1.5em, below: 1.5em)[
    #if (body != []) {
      block(fill: color, radius: (top: 5pt), below: 0pt)[
        #grid(
          columns: (2em, 1fr),
          rows: 2em,
          align: (center + horizon, left + horizon),
          octique-inline(icon, color: title-color, width: 1.2em),
          box(inset: (left: 0.15em))[#text(title, 1.2em, weight: "bold", title-color)],
        )
      ]
    } else {
      block(fill: color, radius: 5pt, below: 0pt)[
        #grid(
          columns: (2em, 1fr),
          rows: 2em,
          align: (center + horizon, left + horizon),
          octique-inline(icon, color: title-color, width: 1.2em),
          box(inset: (left: 0.15em))[#text(title, 1.2em, weight: "bold", title-color)],
        )
      ]
    }
    #if (body != []) {
      block(inset: (x: 0.6em, y: 0.7em))[#body]
    }
  ]
}
