#import "@preview/octique:0.1.0": *

#import "../summary_template.typ": conf
#import "../commands.typ": *

#import "@preview/octique:0.1.0": *

#let accent = "425eaf"
#let color_redish = rgb("#cb4154")
#let color_alert = color_redish
#let color_caution = rgb("#e79925")
#let color_links = rgb("#2549e7")
#let color_green = rgb("#025809")

#set columns(gutter: 4mm)
#set page(columns: 2)
#set highlight(top-edge: "baseline", fill: rgb("#9ed0ff"))
#set enum(numbering: (it => strong[#it.]))
#set text(lang: "de", font: "Ubuntu Sans", 10pt)
#set par(justify: true)



#show table: set align(center)
#show table: set text(0.85em)

#show image: set align(center) // default image alignments
#show link: set text(fill: color_links)
#show raw: set text(ligatures: false, font: "Cascadia Code", size: 1.1em)
#show raw.where(block: true): set text(size: 0.8em)
#show raw.where(block: true): set block(above: 1em, below: 1em)

#show: conf.with(
  title: [Industrial Automation],
  subtitle: [Zusammenfassung],
  subject: [IAUT],
  author: [Joel von Rotz],
  accent_color: "425eaf",
  place: [HSLU T&A],
  show-outline: true,
  flipped: true,
  fontsize: 10pt,
  font-heading: "Alegreya Sans",
  font-paragraph: "Ubuntu Sans",
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207",
)

= Automatisierung

- *Maschinenautomatisierung*
  - (Biegemaschine, Wasserstrahlschneider, Industrieroboter, usw.)
- *Anlagenautomatisierung*
  - (Fertigungsanlagen, Kraftwerke, Chemieanlagen, Postverteilanlagen, usw.)
- *Gebäudeautomatisierung*
  - (Einfamilienhaus, Einkaufszentrum, Stadion, Bürogebäude, Hotel, usw.)
- *Geräteautomatisierung*
  - (Medizinische Geräte, Telefone, Computer, Haushaltsgeräte, usw.)

== Automatisierungspyramide


== Sicherheit

== Überblick - Maschinenautomatisierung

== SPS

== HMI

== Allgemeine...

=== ...Aufgaben

=== ...Anforderungen

= Diskretisierung

== Differenzengleichung

== Euler

=== Rückwärts

=== Vorwärts

=== Trapezoidal

== PID Regler

=== Proportionalität

=== Integration

=== Differential

== Anti-Windup

== Gefiltertes Differential

= Digitale Regelung

#callout(title: "Wichtig!", icon: "alert", color: rgb("#f09c00"))[
  Hello World
]

Digitales Integrieren

_Mittelpunkt_ Riemann-Summe

$
  integral_0^t e(t) dot d t approx sum cases(
    e[k] dot Delta T ,
    e[k-1] dot Delta T,
    (e[k] + e[k-1])\/2 dot Delta T
  )
$

== PID Diskretisierung



$
  u(t) = u_"k,a"(e(t))+ u_"i,a"(e(t))+ u_"d,a"(e(t))
$



= TwinCAT

== Datentypen

#table(
  columns: 5,
  inset: (x: 3pt),
  table.header(
    table.cell(fill: color.lighten(gray, 60%))[*Type*],
    table.cell(fill: color.lighten(gray, 60%))[*Lower*],
    table.cell(fill: color.lighten(gray, 60%))[*Upper*],
    table.cell(fill: color.lighten(gray, 60%))[*Bits*],
    table.cell(fill: color.lighten(gray, 60%))[*Note*],
  ),

  [`BOOL`], [$0$], [$1$], [$8$], [>1 are invalid values],
  [`BYTE`], [$0$], [$255$], [$8$], [],
  [`WORD`], [$0$], [$65535$], [$16$], [],
  [`DWORD`], [$0$], [$4294967295$], [$32$], [],
  [`SINT`], [$-128$], [$127$], [$8$], [],
  [`USINT`], [$0$], [$255$], [$8$], [],
  [`INT`], [$-32768$], [$32767$], [$16$], [],
  [`UINT`], [$0$], [$65535$], [$16$], [],
  [`DINT`], [$-2147483648$], [$2147483647$], [$32$], [],
  [`UDINT`], [$0$], [$4294967295$], [$32$], [],
  [`REAL`], [$-3.402823 times 1038$], [$3.402823 times 1038$], [$64$], [],
  [`LREAL`], [$tilde -1.79769 " E"$+$308$], [$tilde 1.79769 " E"$+$308$], [$64$], [],
  [`STRING`], [$-$], [$-$], [n+1], [Appends `\0`],
  [`TIME`], [`T#0ms`], [`T#71582m47s295ms`], [$32$], [],
  [`TOD`], [`TOD#00:00`], [`TOD#1193:02:47.295`], [$32$], [],
  [`DATE`], [`D#1970-01-01`], [`D#2106-02-06`], [$32$], [],
  [`DT`], [`DT#1970-01-01-00:00`], [`DT#2106-02-06-06:28:15`], [$32$], [],
)


== EN 61131-3

#table(
  columns: 4,
  inset: (x: 3pt),
  align: (center, left, center, left),
  table.header(
    table.cell(colspan: 2, fill: color.lighten(gray, 60%))[*Englisch*],
    table.cell(colspan: 2, fill: color.lighten(gray, 60%))[*Deutsch*],
  ),

  [*IL*], [Instruction List], [*AWL*], [Anweisungsliste],
  [*LD*], [Ladder Diagram], [*KOP*], [Kontaktplan],
  [*FBD*], [Function Block Diagram], [*FBS*], [Funktionsbaustein-Sprache],
  [*ST*], [Structured Text], [*ST*], [Strukturierter Text],
  [*SFC*], [Sequential Function Chart], [*AS*], [Ablaufsprache],
)

#columns(2)[
  === AWL (IL): Anweisungsliste

  #image("lang_awl.png")
  #small[- Assembler für SPS
    - Urmutter der SPS Programmierung
    - Geeignet für einfachen sequentiellen Programme (keine Schleife)]


  === KOP (LD): Kontaktplan

  #image("lang_kop.png")
  #small[
    - Gut für Ersatz für eine verdrahtete Logik
    - Nicht geeignet für komplexe Programme
  ]


  === FBS (FBD): Funktionsbaustein-Sprache

  #image("lang_fbs.png")
  #small[
    - Wird gerne bei Bit-Verknüpfungen verwendet
    - Datenfluss übersichtlich
    - Geeignet für einfachen sequentiellen Programme (keine Schleife)
  ]

  === ST: Strukturierter Text

  #image("lang_st.png")
  #small[
    - Hochsprache (C, Pascal)
    - Schleifenprogrammierung auch ohne Sprungbefehl möglich
    - In Europa sehr oft gewählt
  ]


  === AS (SFC): Ablaufsprache

  #image("lang_as.png")
  #small[
    - Grafisch
    - Zustandsautomaten
    - Gut lesbar
    - Geeignet für übergeordneter Zustandsabläufe
      - *Beispiel*: Programm einer Operationsmanager-SPS wird mit AS geschrieben und die Arbeiter-SPS in ST
  ]

]

== Syntax

=== Deklaration & Implementation

#grid(columns: (1fr, 0.4fr), gutter: 10pt)[


  Die Umgebung eines Programmes, Funktionsblockes oder Funktion ist immer in zwei Bereichen aufgeteilt:

  - Deklaration
  - Implementation

  In der Deklaration, werden alle Inputs, Outputs, Putputs deklariert und allenfalls direkt initialisiert. In der Implementation wird der eigentliche Code geschrieben.

  Die Deklaration wird einmal zu Beginn ausgeführt, die Implementation wird im konfigurierten Zyklus wiederholt.
][
  #image("twincat_env.png")
]

#highlight[*Deklaration*]

Bei Programmen gibt es nur den `VAR` (& resp. `END_VAR`) Bereich.

```c
VAR
  <name> : <type> := <inital-value>
	bTrig  : BOOL := FALSE;
  rValue : REAL := 0.0;
END_VAR
```

Bei Funktionsblöcken und Funktionen gibt es zusätzlich noch `VAR_INPUT`, `VAR_OUTPUT` und `VAR_IN_OUT`

```c
VAR_INPUT
	bTrig  : BOOL := FALSE;
END_VAR
```

=== Workspace

=== If-Else

=== For

=== Switch Case

=== Hardware Verknüpfen


=== Casting

=== Programm, Funktion & Funktionsblock

== AMS Net ID



