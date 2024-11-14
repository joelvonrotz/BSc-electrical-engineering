#import "../summary_template.typ": conf
#import "../commands.typ": *

#import "@preview/octique:0.1.0": *
#import "@preview/cetz:0.3.1" as cetz
#import "@preview/fletcher:0.5.2" as fletcher: node, edge, shapes


#let accent="425eaf"

#set text(lang: "de", font: "Ubuntu Sans", 10pt)

#show: conf.with(
  title: [Concurrent Distributed Systems],
  subtitle: [Zusammenfassung],
  subject: [CDS],
  author: [Joel von Rotz],
  accent_color: "425eaf",
  place: [HSLU T&A],
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207"
)


#pagebreak()

= #octique-inline("repo") Git

#image("Git_operations_curved.svg")


== Configuration

```bash
git config user.name "[name]"
git config user.email "[email]"
```

== Starting a Project

```bash
git init
git clone [url]
```

== Day-To-Day

```bash
git status
```

Zeigt den *Status des Working Directory* relativ zum aktuellen Branch an. 

```bash
git add [file]
```

```bash
git diff [file]
```

```bash
git diff --staged [file]
```


= C\# / .NET

```cs
string str = $"Create string with directly concatting {variables} into it!";
```

== Threads

== Streams

= MVVM

#align(center)[
#fletcher.diagram(
  spacing: (10mm,7mm),
  node-corner-radius: 3pt,
  node-outset: 2mm,
  label-size: 8pt,

  node((0,0), [View(s)], fill: green.lighten(80%), stroke: green.mix((black, 30%)), height: 4em, width: 4em),
  node((2,0), [View Model], fill: red.lighten(80%), stroke: red.mix((black, 30%)), height: 4em, width: 4em),
  node((4,0), [Model], fill: blue.lighten(80%), stroke: blue.mix((black, 30%)), height: 4em, width: 4em),
  edge((0,0),(2,0), "-solid", stroke: 1pt, bend: 20deg)[User Action],
  edge((2,0),(0,0), "-solid", stroke: 1pt, bend: 20deg)[`Binding`],
  edge((2,0),(4,0), "-solid", stroke: 1pt, bend: 20deg)[Update Model],
  edge((4,0),(2,0), "-solid", stroke: 1pt, bend: 20deg)[Model Changed],

  edge((-0.5,1),(2.5,1),"|-|", stroke: 1pt, label-anchor: "center", label-sep: 0pt, label-fill: white, label-size: 9pt)[*Frontend*],
  edge((3.5,1),(4.5,1),"|-|", stroke: 1pt, label-anchor: "center", label-sep: 0pt, label-fill: white, label-size: 9pt)[*Backend*]
)]

Die _Model-Viewmodel-View_-Struktur erstellt 

== View
#v(-2mm)
#small[_What to display, Flow of interaction_]


== View Model
#v(-2mm)
#small[_Business Logic, Data Objects_]


== Model
#v(-2mm)
#small[_How to display information_]

#pagebreak()

