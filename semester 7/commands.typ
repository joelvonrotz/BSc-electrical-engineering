#import "@preview/octique:0.1.0": *
#import "@preview/cetz:0.3.1"

#let small(body) = {
  text(0.85em)[#body]
}

#let b(body, color: black) = {
  text(weight: "bold", fill: color)[#body]
}

#let circ(body, ..args) = {
  box(stroke: black + 0.4pt, width: 1.2em, height: 1.2em, radius: 50%, inset: 1pt, baseline: 0.25em, ..args)[#align(center+horizon)[#body]]
}

#let u(body) = {
  underline(body)
}

#let mc(body, color) = {
  text(fill: color)[$#body$]
}

/* ------------------------------- Math Stuff ------------------------------- */

#let formula(body, boxalign: none, ..args) = {
  if(boxalign == none) {
    box(
      stroke: red + 0.5pt,
      radius: 2pt,
      ..args,
    )[#body]
  } else {
    align(boxalign,
    box(
      stroke: red + 0.5pt,
      radius: 4pt,
      ..args,
    )[#body])
  }
  
}

// Transformation handle

/* ---------------------------------- Misc ---------------------------------- */

#let tc(body, color) = {
  text(fill: color)[#body]
}

#let octicon(icon, color: black, baseline: 15%) = {
  octique-inline(icon, baseline: baseline, color: color)
}

#let cimage(..args) = {
  align(center,image(..args))
}

#let todo(body) = {
  rect(inset: (x: 4pt, y: 5pt), radius: 5pt, stroke: (paint: red, dash: (4pt, 4pt)))[
    #text(fill: red)[#b(color: red)[TODO]~#body]
  ]
}

#let imageIcon(..icon, baseline: 0.2em) = {
  box(align(center + horizon, image(..icon, fit: "cover", width: 1.2em)), width: 0.8em, height: 1.2em, baseline: baseline)
}



#let callout(color: rgb("#7a9bfd"), title: "Callout", title-color: white, icon: "info", body, ..args) = {
  block(..args, stroke: (paint: color), radius: 5pt, above: 1em, below: 1em)[
    #if (body != []) {
      block(fill: color, radius: (top: 5pt), below: 0pt)[
        #grid(
          columns: (2em, 1fr),
          rows: 2em,
          align: (center + horizon, left + horizon),
          octique-inline(icon, color: title-color, width: 1.2em),
          box(inset: (left: 0.15em))[#text(title, weight: "bold", title-color)],
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
      block(inset: (x: 0.6em, y: 0.7em), width: 100%)[#body]
    }
  ]
}
