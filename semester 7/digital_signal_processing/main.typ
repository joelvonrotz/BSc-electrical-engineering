#import "@preview/octique:0.1.0": *

#import "../summary_template.typ": conf
#import "../commands.typ": *


#set math.cases(gap: 0.4em)

#set highlight(fill: rgb("#bcd9ff"), top-edge: "baseline")

#let color_redish = rgb("#cb4154")
#let color_yellowish = rgb("#e79925")
#let color_green = rgb("#025809")
#let color_blue = rgb("#2549e7")
#set text(lang: "de")
#set par(leading: 1em, spacing: 0.9em, justify: true)

#show: conf.with(
  title: [Digital Signal Processing],
  subtitle: [Zusammenfassung],
  subject: [DSP],
  author: [Joel von Rotz],
  accent_color: "425eaf",
  place: [HSLU T&A],
  fontsize: 8pt,
  show-outline: true,
  font-heading: "Alegreya Sans",
  font-paragraph: "Ubuntu Sans",
  compact_spacing: true,
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207",
)

#colbreak(weak: true)
#colbreak()
#colbreak()

= Sampling Rate Conversion

== Decimation
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Reducing sampling rate by an *Integer Factor $D$*]


#columns(2, gutter: 0pt)[
  #cimage("decimation_block.png", width: 100%)
  #v(-2mm)
  #cimage("decimation_graph.png", width: 100%)


  #colbreak()
  #image("decimation.png")

  #box(stroke: red + 1pt, inset: 4pt, radius: 2pt, width: 100%)[
    #columns(2, gutter: 0pt)[
      #text(fill: red, 0.8em)[*Sampling Theorem*\ Don't forget!]
      #colbreak()
      $ f_max < f_s / 2 $
    ]
  ]

  $ H(z) = cases(1 "if" Omega in [-pi\/D, pi\/D], 0 "otherwise") $

  #align(center)[For $Omega in [-pi, pi]$]
]

#align(center)[Decimated Frequency:#h(2mm)
  #box(
    stroke: red + 0.5pt,
    inset: (y: 4pt, x: 2pt),
    radius: 2pt,
    baseline: 30%,
  )[ $F_Y = F_X\/D space arrow.long.l.r space Omega_Y = Omega_(X,V)\/D$]]

#columns(2)[
  #highlight[Ideally filtered]
  $ Y(z) = 1 / D sum^(D-1)_(d=0) V(Omega / D-2pi dot d / D) $
  #colbreak()
  #h(1fr)#highlight[General Formula]
  $ Y(z) = 1 / D sum^(D-1)_(d=0) V(Omega / D-2pi dot d / D) $
]

#columns(2)[
  #highlight[Direct Implementation]

  #text(0.9em)[FIR Filter of order $M$ produces full signal $v[n]$ + downsampler discards $D-1$ samples afterwards $arrow$ #highlight(top-edge: 1.0em)[*inefficient!*]]

  #colbreak()
  #h(1fr)#highlight[Efficient Implementation]

  #text(0.9em)[Downsampling beforehand allows the multiplier to operate at the reduced sampling rate $arrow$ #highlight(top-edge: 1.0em)[*much better!*]]
]

#cimage("decimation_implementation.png", width: 90%)


== Interpolation
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Increase sampling rate by an *Integer Factor $I$*]



#columns(2, gutter: 0pt)[
  #image("interpolation_block.png", width: 100%)
  #image("interpolation.png")



  #image("interpolation_graph.png", width: 105%)


]

#columns(2)[

  $ r[n] = cases(y[n\/I] "if" n in [0, plus.minus I, plus.minus 2 I ,dots], 0 "otherwise") $

  #colbreak()
  #align(center)[Interpolated Frequency:

    #box(
      stroke: red + 0.5pt,
      inset: (y: 4pt, x: 2pt),
      radius: 2pt,
      baseline: 30%,
    )[ $F_(Z,R) = I dot F_Y space arrow.long.l.r space Omega_(Z,R) = I dot Omega_(Y)$]]
]

#columns(2)[
  #highlight[Ideally filtered]

  $
    R(Omega) &= sum_(n=-infinity)^infinity r[n] e^(-j Omega dot n) = \ &=sum_(n=-infinity)^infinity y[m] e^(-j Omega dot I dot m) = Y(I Omega)
  $

  #colbreak()
  For $Omega in [-pi, pi]$#h(1fr)#highlight[Low Pass Filter]


  $ H(z) = cases(I "if" Omega in [-pi\/I, pi\/I], 0 "otherwise") $


  Lowpass-filter uses #box(fill: color.lighten(color_green, 60%), inset: 1.5pt, baseline: 15%)[$Omega$] and *NOT* #box(fill: color.lighten(color_blue, 60%), inset: 1.5pt, baseline: 15%)[$Omega$] !
]

#columns(2)[
  #highlight[Direct Implementation]

  #text(0.9em)[FIR or IIR Filter ; $I-1$ out of $I$ $r[n]$ samples are zero $arrow$ #highlight(top-edge: 1.0em)[*inefficient!*]]

  #colbreak()
  #h(1fr)#highlight[Efficient Implementation]

  #text(0.9em)[Upsampling after filtering $arrow$ multiplier operates at *reduced* sampling rate ($F_Y$) $arrow$ #highlight(top-edge: 1.0em)[*much better!*]]
]

#cimage("interpolation_implementation.png", width: 100%)



== Polyphase Filter Structure
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Efficient filter implementation]

#todo[Relearn]

Split filter into $M$ *downsampled* variants of the impulse resonse $h[k]$. Every variant $p_i[k]$ holds only every $M$-th coefficient ("sum" of variants = $h[k]$)

#align(center)[
  #block(
    stroke: red + 0.5pt,
    inset: (y: 4pt, x: 4pt),
    radius: 2pt,
  )[
    $ p_i [k]=h[k M+i], quad i=0,1,dots,M-1 space space | space space H(z) = sum_(i=0)^(M-1) z^(-1)P_i (z^M) $
    $ P_i(z)=sum_(k=-infinity)^(infinity) p_i [k] z^(-k) = sum_(k=-infinity)^(infinity) h[k M + i] z^(-k), quad i=0,1,dots,M-1 $
  ]
]


#cimage("polyphase.png", width: 95%)

#cimage("polyphase_responses.png", width: 95%)

== Sampling Rate Conversion

#todo[]

= Filter Banks

#todo[]

== Quadrature Mirror Filters

#todo[]

== DFT Filter Banks

#todo[]

= Random Signals

#todo[]

== Autocorrelation and Spectrum

#todo[]

== Spectral Shaping

#todo[]

== Linear Models for Stochastic Processes

#todo[]

== Spectral Density Estimation

#todo[]

= Wiener Filters

#todo[]

== Unconstrained Wiener Filters

#todo[]

== The Principle of Orthogonality

#todo[]

= Kalman Filter

#todo[]

= Linear Predictive Coding

#todo[]

= LMS Algorithm

#todo[]

== The LMS Algorithm

#todo[]

== Acoustic Echo Cancellation

#todo[]
















































