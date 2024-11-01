
#import "@preview/octique:0.1.0": *

#let conf(
  title: none,
  subtitle:none,
  subject:none,
  author: none,
  source: "",
  place:none,
  accent_color: "425eaf",
  doc
) = {
  set page(
    columns: 2,
    paper: "a4",
    margin: (
      top: 2cm,
      bottom: 2cm,
      left: 1cm,
      right: 1cm 
    ),
    numbering: "1 / 1",
    header: [
      #set text(10pt, font: "Alegreya Sans")
      #grid(
        columns: (20%,1fr),
        rows: (auto),
        row-gutter: 2mm,
        align: (left, right),
        text(place),
        text()[#title - #subtitle],
        grid.cell(
          colspan: 2,
          line(length: 100%, stroke: (cap: "round", thickness: 0.5pt))
        )
      )
    ],
    footer: [
      #set text(10pt, font: "Alegreya Sans")
      #grid(
        columns: (1fr,1fr,1fr),
        rows: (auto),
        row-gutter: 2mm,
        align: (left, center, right),
        grid.cell(
          colspan: 3,
          line(length: 100%, stroke: (cap: "round", thickness: 0.5pt))
        ),
        text(datetime.today().display("[day].[month].[year]")), 
        context counter(page).display("1 of 1", both: true),
        text(subject),
      )
    ]
  )
  show heading: set text(font: "Alegreya Sans")

  show heading.where(level: 1): it => [
    #set text(20pt)
    #block[#text(it.body, rgb(accent_color))
    #box(
      width: 1fr,
      baseline: -2mm,
      inset: (left: 1mm),
      line(length: 100%, stroke: (thickness: 2pt, paint: rgb(accent_color)))
    )]
  ]

  show heading.where(level: 2): it => [
    #set text(16pt)
    #block[#text(it.body)
    #box(
      width: 1fr,
      baseline: -1.5mm,
      inset: (left: 1mm),
      line(length: 100%, stroke: (cap: "round", dash: (0pt,5pt),thickness: 2pt, paint: rgb(accent_color)))
    )]
  ]

  align(center)[
    #set text(12pt, font: "Alegreya Sans")
    #v(5mm)
    // title
    #par(
      leading: 3mm,
      text(24pt,title, weight: "bold")
    )
    #v(-5mm)
    // subtitle
    #text(subtitle, style: "italic")#v(0mm)
    // author + link
    #text(author)#h(2mm)#text(weight: "bold")[/]#h(2mm)
    #link(source)[
        #box(fill: rgb(accent_color).lighten(85%), radius: 6pt, height: 14pt, 
        outset: (x:4pt, y:1pt), 
        inset: (y:2pt), 
        stroke: (dash: "dashed", 
        paint: rgb(accent_color)),
        baseline: 3pt)[
        #text(weight: "bold", rgb(accent_color), baseline: -1pt)[#octique-inline("link", baseline: 0pt, color: rgb(accent_color))#h(1pt) Quelldateien]]
    ]
  ]
  outline(
    indent: 2em,
  )
  doc
}
