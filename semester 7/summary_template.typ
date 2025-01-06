
#import "@preview/octique:0.1.0": *

#let conf(
  title: none,
  subtitle: none,
  subject: none,
  author: none,
  source: "",
  place: none,
  accent_color: "425eaf",
  fontsize: 10pt,
  font-paragraph: "Ubuntu Sans",
  font-heading: "Ubuntu Sans",
  show-outline: false,
  compact_spacing: false,
  flipped: false,
  doc,
) = {
  // set globally the font size and the paragraph sizing
  set text(fontsize, font: font-paragraph)
  set page(
    paper: "a4",
    flipped: flipped,
    margin: (
      top: 1.1cm,
      bottom: 1.1cm,
      left: 0.6cm,
      right: 0.6cm,
    ),
    numbering: "1 / 1",
    header: [
      #set text(0.9em, font: font-paragraph)
      #grid(
        columns: (20%, 1fr),
        rows: auto,
        row-gutter: 0.4em,
        align: (left, right),
        text(place),
        text()[#title - #subtitle],
        grid.cell(
          colspan: 2,
          line(length: 100%, stroke: (cap: "round", thickness: 0.5pt)),
        )
      )
    ],
    footer: [
      #set text(0.9em, font: font-paragraph)
      #grid(
        columns: (1fr, 1fr, 1fr),
        rows: auto,
        row-gutter: 0.4em,
        align: (left, center, right),
        grid.cell(
          colspan: 3,
          line(length: 100%, stroke: (cap: "round", thickness: 0.5pt)),
        ),
        text(datetime.today().display("[day].[month].[year]")),
        context counter(page).display("1 of 1", both: true),
        text(subject),
      )
    ],
  )
  show heading: set text(font: font-heading)

  show heading.where(level: 1): it => [
    #set text(1.4em)

    #let space_above = 1.0em
    #let space_below = 0.6em
    #if (compact_spacing) { space_above = space_below }

    #block(below: space_below, above: space_above)[
      #text(it.body, 0.8em, rgb(accent_color))
      #box(
        width: 1fr,
        baseline: -0.25em,
        inset: (left: 0pt),
        line(length: 100%, stroke: (thickness: 2pt, paint: rgb(accent_color))),
      )]

  ]

  show heading.where(level: 2): it => [
    #set text(1.3em)

    #let space_above = 0.9em
    #let space_below = 0.6em
    #if (compact_spacing) { space_above = space_below }

    #block(below: space_below, above: space_above)[
      #text(it.body, 0.8em)
      #box(
        width: 1fr,
        baseline: -0.25em,
        inset: (left: 1mm),
        line(length: 100%, stroke: (cap: "round", dash: (0pt, 5pt), thickness: 2pt, paint: rgb(accent_color))),
      )]

  ]

  show heading.where(level: 3): it => [
    #set text(1.1em)


    #let space_above = 0.7em
    #let space_below = 0.6em
    #if (compact_spacing) { space_above = space_below }
    #block(below: space_below, above: space_above)[
      #rect(
        width: 100%,
        inset: (
          x: 0pt,
          y: 0.5em,
        ),
        stroke: (
          y: (cap: "round", dash: (3pt, 3pt), thickness: 0.5pt, paint: gray),
        ),
      )[
        #text(it.body)
      ]
    ]

  ]


  // Display inline code in a small box
  // that retains the correct baseline.
  show raw.where(block: false): box.with(
    fill: luma(240),
    inset: (x: 2pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Display block code in a larger block
  // with more padding.
  show raw.where(block: true): block.with(
    fill: luma(240),
    width: 100%,
    breakable: true,
    inset: 5pt,
    radius: 4pt,
  )

  [
    // [TITLEBLOCK] --------------------------------------------------
    #align(center)[
      #set text(1.1em, font: font-heading)
      #v(2em)
      // title
      #par(
        leading: 3mm,
        text(2em, title, weight: "bold"),
      )
      #v(-1em)
      // subtitle
      #text(subtitle, style: "italic")#v(0mm)
      // author + link
      #text(author)#h(2mm)#text(weight: "bold")[/]#h(2mm)
      #link(source)[
        #box(
          fill: rgb(accent_color).lighten(85%),
          radius: 4pt,
          height: 1.1em,
          outset: (x: 0.2em, y: 0.1em),
          inset: (y: 0.15em),
          stroke: (
            dash: "dashed",
            paint: rgb(accent_color),
          ),
          baseline: 0.25em,
        )[
          #text(
            weight: "bold",
            rgb(accent_color),
            baseline: -1pt,
          )[#octique-inline("link", baseline: 0pt, color: rgb(accent_color))#h(1pt) Quelldateien]]
      ]
    ]

    #if (show-outline) {
      heading(outlined: false)[
        Table of Contents
      ]
      context {
        let sections = query(
          heading
            .where(
              level: 1,
              outlined: true,
            )
            .or(
              heading.where(
                level: 2,
                outlined: true,
              ),
            )
            .or(
              heading.where(
                level: 3,
                outlined: true,
              ),
            ),
        )

        for chapter in sections {
          let loc = chapter.location()
          let page = numbering(
            loc.page-numbering(),
            ..counter(page).at(loc),
          )
          let spacing = 1.5em * (chapter.level - 1)
          let level1_line_spacing = -1em
          if (compact_spacing) {
            level1_line_spacing = -0.6em
          }

          if (chapter.level == 1) {
            [#v(0.5em)#text(weight: "bold")[#h(spacing)#chapter.body #h(1fr) #page]\
              #v(level1_line_spacing)#line(length: 100%, stroke: 0.5pt)]
          } else {
            [#v(-0.2em)#h(spacing)#chapter.body #box(width: 1fr)[#line(
                  length: 100%,
                  stroke: (dash: (0pt, 3pt), thickness: 1pt, cap: "round", paint: black),
                )]#h(1pt)#page \ ]
          }
        }
      }
    }

    #doc

  ]
}


