
#import "@preview/octique:0.1.0": *

#let conf(
  title: none,
  subtitle:none,
  subject:none,
  author: none,
  source: "",
  place:none,
  accent_color: "425eaf",
  fontsize: 10pt,
  font-paragraph: "Ubuntu Sans",
  font-heading: "Ubuntu Sans",
  show-outline: false,
  doc
) = {
  // set globally the font size and the paragraph sizing
  set text(fontsize, font: font-paragraph)
  set page(
    columns: 3,
    paper: "a4",
    flipped: true,
    margin: (
      top: 1.1cm,
      bottom: 1.1cm,
      left: 0.6cm,
      right: 0.6cm 
    ),
    numbering: "1 / 1",
    header: [
      #set text(0.9em, font: font-paragraph)
      #grid(
        columns: (20%,1fr),
        rows: (auto),
        row-gutter: 0.4em,
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
      #set text(0.9em, font: font-paragraph)
      #grid(
        columns: (1fr,1fr,1fr),
        rows: (auto),
        row-gutter: 0.4em,
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
  show heading: set text(font: font-heading)

  show heading.where(level: 1): it => [
    #set text(1.4em)
    #block[#text(it.body, rgb(accent_color))
    #box(
      width: 1fr,
      baseline: -2mm,
      inset: (left: 1mm),
      line(length: 100%, stroke: (thickness: 2pt, paint: rgb(accent_color)))
    )]
  ]

  show heading.where(level: 2): it => [
    #set text(1.3em)
    #block[#text(it.body)
    #box(
      width: 1fr,
      baseline: -1.5mm,
      inset: (left: 1mm),
      line(length: 100%, stroke: (cap: "round", dash: (0pt,5pt),thickness: 2pt, paint: rgb(accent_color)))
    )]
  ]

  


  // Display inline code in a small box
  // that retains the correct baseline.
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Display block code in a larger block
  // with more padding.
  show raw.where(block: true): block.with(
    fill: luma(240),
    width: 100%,
    breakable: true,
    inset: 7pt,
    radius: 4pt,
  )

  // [TITLEBLOCK] --------------------------------------------------

  align(center)[
    #set text(1.1em, font: font-heading)
    #v(2em)
    // title
    #par(
      leading: 3mm,
      text(2em,title, weight: "bold")
    )
    #v(-1em)
    // subtitle
    #text(subtitle, style: "italic")#v(0mm)
    // author + link
    #text(author)#h(2mm)#text(weight: "bold")[/]#h(2mm)
    #link(source)[
        #box(fill: rgb(accent_color).lighten(85%), radius: 4pt, height: 1.1em, 
        outset: (x:0.2em, y:0.1em), 
        inset: (y:0.15em), 
        stroke: (dash: "dashed", 
        paint: rgb(accent_color)),
        baseline: 0.25em)[
        #text(weight: "bold", rgb(accent_color), baseline: -1pt)[#octique-inline("link", baseline: 0pt, color: rgb(accent_color))#h(1pt) Quelldateien]]
    ]
  ]
  if(show-outline){
    outline(
      indent: 1.5em,
    )
  }
  doc
}
