#import "@preview/octique:0.1.0": *

#import "../summary_template.typ": conf
#import "../commands.typ": *


#set math.cases(gap: 0.4em)

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
  font-heading: "Alegreya Sans",
  font-paragraph: "Ubuntu Sans",
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207"
)



= DSP

#image("signal_classification.png")

#underline[Pros (3 P's)]: #b[P]rogrammability, #b[P]arametrizability, Re-#b[P]eatability

== Signal Analysis

#columns(
  2
)[
  _Sampling of Analog Signal_
  $
    f_S = 1/T_S quad x(n dot T_S)=x[n]
  $

  causal: #h(3mm) $x[n]=0 "for" n<0$

  _Useful functions_

  #small[unit impulse]
  $
    delta[n] = cases(
      0 : n != 0,
      1 : n = 0
    )
  $
  #colbreak()


  #small[step impulse]
  $
    u[n] = cases(
      0 : n < 0,
      1 : n >= 0
    )
  $
  #small[periodic symbols]
  $
    x[n]=x[n+T_0\/T_S]\ "with" T_0\/T_S=k
  $
]

#columns(2)[
  #small[expected/mean value]
  $
  mu_x=1/N sum^(N-1)_(i=0) x[i]
  $

  #small[quadratic mean value/avg DC power]
  $
  rho^2=1/N sum^(N-1)_(i=0)x[i]^2
  $

  #small[variance/avg AC power]
  $
  sigma^2_x=1/N sum^(N-1)_(i=0)(x[i]-mu_x)^2
  $

  #small[power ratio]
  $
  A_(d\B)=10 dot log_10 (P_1/P_2)
  $
  
  #small[*S*\ignal-to-*N*\oise-ratio]
  $
  "SNR" &=10 dot log_10 (P_("S")/P_("N"))\ &=20 dot log_10 (U_("S")/U_("N"))
  $
  
  #small[power ratio]
  $
  A_(d B)=10 dot log_10 (P_1/P_2)
  $
]

#columns(2)[
  #small[static correlation ($x = y => arrow.t R$)]
  $
  R=1/N sum^(N-1)_(i=0)x[i]y[i]
  $
  
  #small[_linear correlation_ $->$ yields new signal, quantifying the similarty of $x$ and $y$]
  $
  r_(x y)[n]=1/N sum^(N-1)_(i=0)x[i]y[i+n]
  $
  #align(center)[$N_(x y)=N_x+N_y-1$)[*not*]]
  #small[#text(fill:red)[*not*] commutative: $r_(x y)[n] != r_(y x)[n]$]

  #small[(linear) convolution]
  $
    z[n] = sum_(i=-infinity)^infinity x[i]y[n - i] = x[n]*y[n]
  $

  #small[circular convolution]
  $N_X eq N_Y$
  $
    z[n] = x[n] ast.circle_N y[n]
  $
  
  #image("circ_xy.png")
  #image("circular_conv.png")
  #image("circ_z.png",height: 3mm)
]



= Hunziker Teil

#callout(title: "Stationäres Signal?", icon: "info")[
  Bei stationäres Signalen ändert sich der Mittelwert und die Autokorrelation *NICHT* $arrow$ der Inhalt des Signals ist dabei nicht so wichtig.
]


= Optimum Linear Filters

== Wiener Hopf

=== Unconstrained Wiener Filters

== Kalman Filter
