#import "@preview/octique:0.1.0": *
#import "@preview/physica:0.9.4"
#import "../symbols.typ": *

#import "../summary_template.typ": conf
#import "../commands.typ": *


#set math.cases(gap: 0.4em)


#show image: set align(center) // default image alignments

#set highlight(fill: rgb("#bcd9ff"), top-edge: "baseline")

#let color_redish = rgb("#cb4154")
#let color_yellowish = rgb("#e79925")
#let color_green = rgb("#025809")
#let color_blue = rgb("#2549e7")
#set text(lang: "de")
#set par(leading: 1em, spacing: 0.9em, justify: true)
#set enum(numbering: (it => strong[#it.]))


#set columns(gutter: 4mm)
#set page(columns: 3)

#show: conf.with(
  title: [Digital Signal Processing],
  subtitle: [Zusammenfassung],
  subject: [DSP],
  author: [Joel von Rotz],
  accent_color: "425eaf",
  place: [HSLU T&A],
  fontsize: 7pt,
  show-outline: true,
  font-heading: "Alegreya Sans",
  font-paragraph: "Ubuntu Sans",
  compact_spacing: true,
  flipped: true,
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207",
)
#colbreak(weak: true)
#v(20em)
#align(center)[
  #callout(width: 80%, color: color_redish, title: "Achtung, Achtung!")[
    #set align(left)
    Anstatt über die Fehler in der Zusammenfassung zu meckern, wäre ein _Pull Request_ sehr töfte!
    #v(-6.5mm)#h(1fr)#box(
      text(color_blue)[#link(
          "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207",
          [#octicon("repo", color: color_blue) Github Repo Link],
        )],
      baseline: 50%,
      stroke: (thickness: 0.5pt, paint: color_blue, dash: (3pt, 3pt), cap: "round"),
      inset: 2pt,
      radius: 4pt,
    )]
]
#v(20em)
#[
  #show image: set align(right)
  #image("meme.png", width: 130%)
]
#colbreak(weak: true)


/* -------------------------------------------------------------------------- */
/*                                Hunziker Part                               */
/* -------------------------------------------------------------------------- */

= Sampling Rate Conversion

== Decimation
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Reducing sampling rate by an *Integer Factor $D$*]


#columns(2, gutter: 0pt)[
  #image("decimation_block.png", width: 100%)
  #v(-2mm)
  #image("decimation_graph.png", width: 100%)

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

#image("decimation_implementation.png", width: 90%)


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

#highlight[Interpolation Formula]

$
  R(Omega) &= sum_(n=-infinity)^infinity r[n] e^(-j Omega dot n) =sum_(n=-infinity)^infinity y[m] e^(-j Omega dot I dot m) = Y(I Omega)
$

#grid(column-gutter: 0pt, columns: (0.5fr, 1fr, 0.6fr))[

  #highlight[Low Pass Filter]

  For $Omega in [-pi, pi]$
][
  $ H(z) = cases(I "if" Omega in [-pi\/I, pi\/I], 0 "otherwise") $
][
  Lowpass-filter uses\ #box(fill: color.lighten(color_green, 60%), inset: 1.5pt, baseline: 15%)[$Omega$] and *NOT* #box(fill: color.lighten(color_blue, 60%), inset: 1.5pt, baseline: 15%)[$Omega$] !
]




#columns(2)[
  #highlight[Direct Implementation]

  #text(0.9em)[FIR or IIR Filter ; $I-1$ out of $I$ $r[n]$ samples are zero $arrow$ #highlight(top-edge: 1.0em)[*inefficient!*]]

  #colbreak()
  #h(1fr)#highlight[Efficient Implementation]

  #text(0.9em)[Upsampling after filtering $arrow$ multiplier operates at *reduced* sampling rate ($F_Y$) $arrow$ #highlight(top-edge: 1.0em)[*much better!*]]
]

#image("interpolation_implementation.png", width: 100%)



== Polyphase Filter Structure
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Efficient filter implementation]

Split filter into $M$ *downsampled* variants of the impulse resonse $h[k]$. Every variant $p_i[k]$ holds only every $M$-th coefficient ("sum" of variants = $h[k]$)

#align(center)[
  #block(
    stroke: red + 0.5pt,
    inset: (y: 4pt, x: 4pt),
    radius: 2pt,
  )[
    $ p_i [k]=h[k M+i], quad i=0,1,dots,M-1 space space | space space H(z) = sum_(i=0)^(M-1) z^(-1)P_i (z^M) $
    $
      P_i(z)=sum_(k=-infinity)^(infinity) p_i [k] z^(-k) = sum_(k=-infinity)^(infinity) h[k M + i] z^(-k), quad i=0,1,dots,M-1
    $
  ]
]


#image("polyphase.png", width: 95%)

#image("polyphase_responses.png", width: 95%)


== Sampling Rate Conversion


#image("sampling_rate_conversion.png")

#align(center)[$F_X => F_R=I dot F_X => F_V = F_R => F_Y = I \/ D dot F_X = 1 \/ D dot F_V$]

#text(0.9em)[Decimation $=>$ loss of information #h(1fr) Interpolation $=>$ higher intermediate sampling rate]
#columns(2)[
  $ F_H (Omega) = min(pi/I,pi/D) $

  #colbreak()

  $ I / D = underbrace(I dot (1/D), H_I->I->D->H_D)= underbrace((1/D) dot I, I->H->D) $
]

= Filter Banks

== Quadrature Mirror Filters

#small[QMF: compensate loss of information caused by decimation]

#image("quadrature_mirror_filters.png", width: 90%)

$ Y_i (Omega) = 1 / 2 (H_i (Omega / 2) dot X(Omega / 2) + H_i (Omega / 2-pi) dot X(Omega / 2-pi)) $

$H_0 (z), G_0(z)$ : lowpass filter ; $H_1 (z), G_1(z)$ : highpass filter

$
  hat(X) (Omega) &= 1 / 2 (H_0 (Omega) dot G_0 (Omega) + H_1 (Omega) dot G_1 (Omega)) dot X(Omega)\
  &+ underbrace( 1/2 (H_0 (Omega - pi) dot G_0 (Omega) + H_1 (Omega - pi) dot G_1 (Omega)) dot X(Omega - pi) ,"alias term")
$



#grid(columns: (1fr, 0.9fr))[
  Condition for $hat(x)[n]$ free of aliasing:

  $ H_0(Omega - pi) dot G_0(Omega) + H_1(Omega - pi) dot G_1(Omega) = 0 $

  #line(length: 100%, stroke: 0.5pt + gray)

  #small[For getting rid of aliasing and manage #u[perfect reconstruction]:]

  $
    H_0(Omega) = H(Omega) quad H_1(Omega) = H(Omega - pi) \
    G_0(Omega) = H(Omega) quad G_1(Omega) = -H(Omega - pi)
  $
][
  #image("quadrature_mirror_filters_funnygraph.png")
]

#colbreak()

#callout(title: "Perfect Reconstruction", color: color.lighten(color_green, 30%))[
  Synthesized signal $hat(x)[n]$ is identical to input signal $x[n]$ except for *arbitrary delay* and *scaling* by a #u[constant] factor.
]

#image("subbandencoding.png")
#v(-5em)
#columns(2, gutter: 10pt)[
  #v(5em)

  $R_"in"$: Abtastrate

  #colbreak()

  #image("subband_encoder.png")
]

#image("delays.png")

#highlight[Example with $d=5$ sample delays]\
$ D_1 = 5 quad ; quad D_2 = d + 2 dot D_1 = 15 quad ; quad D_3 = d + 2 dot D_2 = 35 $

#small[- $D_3$ is viewed from outside, therefore the sample rate is halved leading to $35$ spl delay]

== DFT Filter Banks

- QMFB (Quadrature-$M$-Filter-Banks) $->$ downsamples the sampling frequency by $M$
  - _critical sampling_ $->$ $"channels" = "downsampling factor" D$ #small[(over: $C > D$ ; under: $C <D$)]
  - slightly imperfect reconstruction with critical sampling $->$ oversampling (longer)

#image("qmfb_filterbank.png")

$
  H_(ell) (z) = H(z dot e^(-j 2 pi ell \/ M)) #h(0.5em)\;#h(0.5em) H_(ell) (Omega) = H(Omega - 2 pi ell\/M) #h(0.5em)\;#h(0.5em) l=0,1,dots, M-1
$

#columns(2, gutter: 0pt)[
  #image("dftfilterbank.png")

  #colbreak()

  #highlight([Example])

  #set par(leading: 0.8em)
  #[following describes a filter bank with\ $M = 4 "chls"$ and $"oversmpl'ing factor" D=2$]

  #image("transferfunction_4channelbank.png", width: 79%)

  #h(2mm)
  $arrow.l.double$ input: $h[0], h[1],dots, h[M-1]$
]
#v(-7em)
#grid(columns: (1.1fr, 1fr), gutter: 4pt)[
  #image("4channel_filterbank.png", width: 90%)
][
  #v(5em)
]

#small(
  callout(title: "Some Basics")[
    *deterministic*: value can be determined at any time #h(3em) *transient*: limited time duration


    #line(length: 100%, stroke: 0.5pt + gray)
    #columns(2)[
      #set math.cancel(cross: true, stroke: 0.4pt + red)

      / Finite Impulse Response (always stable):
      - Impulse response is infinite
      - No feedback ($y[n space cancel(-m) space]$)

      $ y[n] = sum_(a=0)^(N-1) b_a dot x[n-a] $

      #colbreak()

      / Infinite Impulse Response (un-/stable):
      - Impulse response infinite due to feedback
      - Feedback of signals ($y[n -m]$)
      $ y[n] = sum_(n=0)^(N-1) b_n dot x[k-n] - sum_(m=1)^(M) a_m dot y[n-m] $

    ]


    / Levinson-Durbin-Rekursion:
    - efficient algo for solving linear equation systems with the _Toeplitz_-Matrix
    - instead of inverting matrices, the TM is used to iteratively determine the solution.

    #columns(2)[
      / (linear) convolution: $ z[n] = sum_(i=-infinity)^infinity x[i]y[n - i] = x[n]*y[n] $
        #colbreak()
        #h(-6em)*Linear Correlation*
        #v(-2em)
        $ r_(x y)[n]=1 / N sum^(N-1)_(i=0)x[i]y[i+n] $
      $ N_(x y)=N_x+N_y-1 quad r_(x y)[n] != r_(y x)[n] $
    ]
  ],
)

= Random Signals
#[
  #set par(leading: 0.8em)
  #small[
    #grid(columns: (1fr, 1.2fr))[

      - Characterization
        - first-order statistic: *Mean value*
        - second-order statistic: *Autocorrelation*
    ][
      - Stationary Signals
        - no change in mean value ($dot(m)_x=dot(gamma)_(x x)=0$)
        - infinite energy $->$ no fourier transform ($underbrace(X_(["n1","n2"])(Omega),"ranged DTFT")$)
    ]
    #v(-1em)
    ($gamma_(x x)$ #highlight(top-edge: "ascender")[higher $->$ more determinable/similar ; more fluctuating $->$ narrower the $gamma_(x x)$])
  ]
]

== Autocorrelation $gamma$ and Spectrum

#columns(2, gutter: 5pt)[
  #highlight[Mean value]
  $ m_x & = E{x[n]} \ dot(m)_x &= 0 "for stationary signals" $

  #[#highlight[Autocovariance] (for signals with $m_x != 0$)]

  $ c_(x x)[m]=E{(x[n]-m_x)^* dot (x[n+m] - m_x)} $

  $c_(x x)[0]$: #small[Variance of signal ($E{abs(x[n]-m+x)^2}$)]

  #line(length: 100%, stroke: 0.5pt + gray)

  Power: $P=gamma_(x x)[0]$


  #colbreak()

  #highlight[Autocorrelation]

  $ gamma_(x x)[m] = E{x^*[n] dot x[n+m]} $

  $
    gamma_(x x)[m] = gamma_(x x)^*[-m] "for real random" \
    dot(gamma)_(x x) = 0 "for stationary signals"
  $

  #align(center)[$m$: distance between two samples]

  #small(callout(title: [stationary time $!=$ stationary frequency])[A stationary random signal has fluctuating $f$ ])
]

=== Power Density Spectrum
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Power cannot be negative! Squared Amplitude Spectrum]

- Reveals Spectral composition of a stationary process ("where energy is")
- Mirrored on Y-axis (range $Omega in [0, pi]$ suffices) #h(2mm) #sym.bullet #h(2pt) $Gamma_(x x) = transform.fourier (gamma_(x x))$

$
  Gamma_(x x) (Omega) = sum_(m=-infinity)^(infinity) gamma_(x x)[m] dot e^(-j Omega m) quad ; quad P_x=1 / (2 pi) integral_(-pi)^pi Gamma_(x x) (Omega) d Omega
$

#highlight[White Noise]

#columns(2)[
  #small[White noise has a *constant* spectrum, as they represent all noises at the same time!]

  #colbreak()
  #v(-1em)
  $
    gamma_(w w)[m] = cases(sigma^2  "if" m = 0, 0  "if" m != 0) #h(0.5em) ; #h(0.5em) Gamma_(w w) (Omega) = sigma_w^2
  $
]

#grid(columns: (1fr, 1fr), align: horizon)[


  #highlight[Wiener-Khinchin-Theorem]

  #small[
    Power Spectrum Density corresponds to the DTFT of the autocorrelation sequence (of stat. rand. sig)
  ]
][

  $ Gamma_(x x)(Omega) = sum_(m=-infinity)^(infinity) gamma_(x x)[m] dot e^(-j Omega m) $
]

== Spectral Shaping
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Stationary random in, stationary random out]

#grid(columns: (1fr, 1.5fr), column-gutter: 4pt)[
  #image("spectralshaping.png")

][
  $
    y[n] = sum_(k=-infinity)^(infinity) h[k] dot x[n-k] quad #small[$H(Omega) = sum_(k=-infinity)^(infinity) h[k] dot e^(-j Omega k)$]
  $
  $
    m_y &= H(0) dot m_x quad | quad
    gamma_(y y) &= h^*[-i] convolve gamma_(x x)[m] convolve h[k]
  $
]

#small[for auto correlation one $h[n]$ is mirrored and complex conjugated! $ quad quad i = -infinity, dots, -1, 0, 1, dots, infinity$]

$
  Gamma_(y y)(Omega) = H^*(Omega) dot Gamma_(x x)(Omega) dot H(Omega) = abs(H(Omega))^2 dot Gamma_(x x)(Omega) = undershell(abs(H(Omega))^2 dot sigma_(w)^2, "white noise")
$

== Linear Models for Stochastic Processes
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[#small[Include noise in simulations!]]

#grid(columns: (1.2fr, 1fr))[
  $ Gamma_(w w)(z) = sum_(m=-infinity)^(infinity) gamma_(w w)[m] dot z^(-m) = sigma_w^2 $

  #small[#imageIcon("arrow-narrow-down.svg") Stable when all poles and zeroes inside unit circle #imageIcon("arrow-narrow-down.svg")]
  #v(-1mm)

][
  $
    Gamma_(y y) &= H(z^(-1)) dot Gamma_(x x)(z) dot H(z)\
    &= sigma_w^2 (z) dot H(z) dot H(z^(-1))
  $

]
#grid(columns: (3fr, 1fr), align: horizon)[

  $
    H(z) = B(z) / A(z) = (sum b_k z^(-k)) / (1 + sum a_k z^(-k)) ==> Gamma_(y y)(z) = sigma_w^2 dot (B(z) dot B(z^(-1))) / (A(z) dot A(z^(-1)))
  $
][
  #set par(leading: 0.8em)
  #text(0.8em)[white no. provides complete random portion]
]

#[
  #set par(leading: 0.5em)
  #highlight[Noise Whitening]: reverse operation #formula(inset: (x: 1pt, y: 2pt), stroke: gray + 0.5pt, baseline: 20%)[$H_w (Omega) = 1\/(H(Omega))$] reverses the generated random noise back to white noise. $w[n]$: "innovations process" of $y[n]$.
]

$
  w[n] = 1 / b_0 dot (y[n] + sum_(k=1)^(N) a_k y[n-k] - sum_(k=1)^(M) b_k w[n-k])
$

example: Pre-Filter for making calculation of wiener-filters easier.

=== Moving Average (MA) model
#v(-2.1em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[#small[Wideband applications]]

- White noise + FIR-Filter $H(z)$ with $M$th order ($M$ delays + no poles)

#columns(2)[
  $ y[n] = sum_(k=0)^(M) b_k w[n-k] $
  #colbreak()

  $H(z)$ : FIR filter \ $1\/H(z)$: IIR Filter
]


- $b_0 = b_1 = dots = (M+1)^(-1)$: every output sample = avg, over sliding window $M+1$
- different coefficients result in selective combinations of white noise input
- _World Representation_: every stat. stoc. process $=>$ infinite moving average process

$
  gamma_(y y)[m] = cases(sigma_w^2 sum_(k=m)^(M) b_k dot b_(k-m)^* &"if" 0 <= m <= M, 0 &"if" m > M , gamma_(y y)^*[-m] &"if" m<0)
$

=== Autoregressive (AR) model
#v(-2.1em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[#small[Narrowband applications (Human Vocal Tract: all pole filter)]]

#grid(columns: (1fr, 1.1fr))[
  #v(1mm)
  - $B(dots)=1$: no zeroes, only poles

  $ y[n] = w[n] - sum_(k=1)^(N) a_k dot y[n-k] $


][
  $
    gamma_(y y)[m] = cases(
  - sum_(k=1)^(N) a_k dot gamma_(y y)[m-k] &"if" m > 0,
  sigma_m^2 - sum_(k=1)^(N) a_k dot gamma_(y y)[-k] &"if" m=0,
  gamma_(y y)^*[-m] &"if" m<0
)
  $
]

- weighted sum older values + noise $=>$ staionary not guaranteed
#small[_Yule-Walker equations_:]
$
  mat(gamma_(y y)[0], gamma_(y y)[-1], dots.c, gamma_(y y)[-N];
     gamma_(y y)[1], gamma_(y y)[0], dots.c, gamma_(y y)[-N+1];
     dots.v,  dots.v,   , dots.v;
     gamma_(y y)[N], gamma_(y y)[N-1], dots.c, gamma_(y y)[0]) dot mat(1; a_1 ; dots.v ; a_N)= mat(sigma_w^2; 0; dots.v ; 0)
$

#colbreak()

=== ARMA model

#columns(2)[

  - Generalization of MA & AR
  - $B(dots): M >= 1$ and $A(dots): N >= 1$
  #colbreak()
  - More suitable for random processes due to having fewer coefficients for "same" accuracy.

]

== Spectral Density Estimation

=== Nonparametric Method

#callout(title: small[Big no-no: periodogram])[
  #grid(columns: (1fr, 1.4fr))[
    $"DTFT"^2$ = _periodogram_
    $ hat(Gamma)_(x x) (Omega) = 1 / N abs(sum_(n=0)^(N-1) x[n] dot e^(-j Omega n))^2 $
  ][
    #small[

      #octicon("x-circle", color: red): any $Omega_0 ->$ $hat(Gamma) (Omega_0)$ has large variance

      #[
        #set par(leading: 0.5em)
        #octicon("x-circle", color: red): variance does not decrease with increasing sample basis
      ]
    ]
  ]

]

#columns(2)[
  #highlight[Biased Autocorrelation Estimator]
  #colbreak()

  #highlight[Unbiased Autocorrelation Estimator]
]
$ "for" m "between" 0 "and" N-1 quad \/ quad =0,1,dots,N-1 $

#columns(2)[

  $ hat(gamma)_(x x) [m] = 1 / N sum_(n=0)^(N-m-1) x^*[n] dot x[n+m] $

  #small[
    #set list(marker: text(color_green)[*$+$*])
    - Easy to calculate

    #set list(marker: text(color_redish)[*$-$*])
    - Distorts result, as higher $m$ leads to less data in the sum
    - same problem as periodogram
  ]


  #colbreak()


  $ hat(gamma)_(x x) [m] = 1 / (N-m) sum_(n=0)^(N-m-1) x^*[n] dot x[n+m] $

  #small[
    #set list(marker: text(color_green)[*$+$*])
    - No distortion $->$ corrected by $1\/(N m)$

    #set list(marker: text(color_redish)[*$-$*])
    - a bit complexer to calculate
    - High variance at $abs(m)approx N ->$ few summands
    - does not guarantee $hat(Gamma)_(x x)(Omega) >= 0$ (big nono)
  ]
]

#small[
  #[*Possible estimator corrections*]
  - Bartlett's method: segmentation and averaging
  - Windowing: smooth spectral density $->$ deceases variance at cost of resolution]

=== Parametric Method

#small[
  - Structure of a noise source is known (to some degree) $->$ build on specific model tuned by a fixed number of parameters
    - ARMA models are populars, due few parameters with tight fitting to real sources
    #columns(2)[

      #set list(marker: text(color_green)[*$+$*])
      - High accuracy

      #colbreak()
      #set list(marker: text(color_redish)[*$-$*])
      - Complexer to calculate
      - improper parameters leads to instability]

]

#columns(2)[
  #highlight[Yule-Walker] (using AR model)
  #small[

    Substituting $gamma_(x x)[m]$ in the equations with $hat(gamma)_(x x)[m]$


    #set list(marker: text(color_redish)[*$-$*])
    - unbiased variant can lead to unstable AR

  ]
  #highlight[Burg's Method]

  #small[
    Uses forward and backwards prediction similar to Levinson-Durbin recursion.

    #set list(marker: text(color_green)[*$+$*])
    - Better results, even with fewer samples
    - More efficient, as forward and backwards error is minimized
  ]
  #colbreak()

  #highlight[Least Square model fitting] (with AR)

  #small[Fitting via square error. $hat(y)=$ interpreted as forward prediction from the preceding $N$ samples]

  $ hat(y) = -sum_(k=1)^(N) a_k dot y[n-k] $

  #small[prediction error:]#h(2mm) $w[n]= y[n]-hat(y)[n]$

  #small[- might lead to same values as Yule-Walker]
]

#small[*Use Case of AR model*: nuclear reactors. AR model fitted to reactor noise during normal operation. Deviating noise leads to sudden increase in prediction error $abs(y[n] - hat(y)[n])$.]

= Optimal Linear Filters

Perfect reconstruction might not be possible in presence of noise $->$ approximate original signal as accurately as possible. _Estimation_ is interpreted in various different ways, but _mean squared error_ is generally used (also used for power/energy calc.).

#[
  #set list(marker: text(color_green)[*$+$*])
  - Simple structure
  - Linear filters are preferred: (almost) as powerful as complex nonlinear estimators.
]

#[#set list(marker: text(color_redish)[*$-$*])
  - MSE: strong deviations are heavily weighted by squaring
]

== Wiener Filters
- For discrete & continuous #u[stationary] signals/noise
- Efficient implementation using Levinson-Durbin recursion
- $s[n]$ & $v[n]$ are independent, zero-mean stationary random signals
- Calculate filter coefficients $w_0, w_1, dots, w_M$ to keep MSE low
  - difficult if SNR is low

#grid(columns: (1fr, 0.6fr), gutter: 5pt)[
  #image("wiener_filter.png", width: 100%)
  #align(center)[
    #v(-2.7em)
    #h(2.8em)#small[*FIR Filter $M$th order*]
    #v(1em)
  ]

][

  #v(-6mm)
  #image("wienerfilter_flow.png")
  #text(color_green)[*current*], #text(orange)[*observed samples*]
]
#grid(columns: (1fr, 1.4fr))[
  #highlight[Estimated signal $hat(s)$ with $D$ delays]:

  $ hat(s) [n+D] = sum_(i=0)^(M) omega_i dot y[n-i] $
][

  _Smoothing_ $D<0$: eliminate noise \
  _filtering_ $D=0$: (almost) recover signal in real time \
  _prediction_ $D>0$: forecast the future course
]

#columns(2)[


  #v(1em)
  $ epsilon_"MSE" = E{abs(hat(s)[n+D]-s[n+D])^2} $
  #v(
    -0.8em,
  )#h(3.5%)#small[*mean*#imageIcon("arrow-narrow-up.svg")]#h(44%)#small[#imageIcon("arrow-narrow-up.svg")*original*]
  #v(-4.4em)#h(36%)#small[#imageIcon("arrow-narrow-down.svg")*prediction*]

  #colbreak()
  #highlight[optimal coefficients]:

  $ tilde(underline(w)) = arg min_underline(w) (epsilon_"MSE" (underline(w))) => "derivative = 0" $
]

=== Wiener Hopf Equation

$
  R_(y y) = mat(gamma_(y y)[0], gamma_(y y)[-1], dots.c, gamma_(y y)[-M];
                gamma_(y y)[1], gamma_(y y)[0], dots.c, gamma_(y y)[1-M];
                dots.v, dots.v,,dots.v;
                gamma_(y y)[M], gamma_(y y)[M-1], dots.c, gamma_(y y)[0]) quad r_(s y)=mat(gamma_(s y)[D]; gamma_(s y)[D+1]; dots.v; gamma_(s y)[D+M]) quad tilde(w)=mat(tilde(w)_0;tilde(w)_1; dots.v ; tilde(w)_M)
$

Autocorrelation of filter input: #h(1fr) $gamma_(y y)[m] = E{y[n] dot y^*[n-m]}$\ #v(0.5em)
Autocorrelation of white noise: #h(1fr) $display(gamma_(v v)[m] = delta[m] = cases(1 & "if" m = 0, 0 &"if" m != 0))$\ #v(0.5em)
Crosscorrelation of filter input and desired response: #h(1fr) $gamma_(s y)[m] = E{s[n] dot y^*[n-m]}$

$
  R_(y y) dot tilde(w) = r_(s y) quad ==> quad tilde(w) = R_(y y)^(-1) dot r_(s y)
$

#highlight[*Special Case*] undistorted signal of interest appears superimposed
by additive noise:

$ gamma_(y y)[m] = gamma_(s s)[m] + gamma_(v v)[m] quad quad gamma_(s y)[m] = gamma_(s s)[m] $


=== Unconstrained Wiener Filters

Neglecting the constraints imposing causality and finite length. Obtain optimal, non-causal IIR filter with the impulse response $dots,tilde(w)_(-1),tilde(w)_0, tilde(w)_1,dots$ setting $D=0$.

#v(1mm)
#grid(columns: (1fr, 1.2fr))[


  $
    sum_(i=0)^(M) tilde(w)_i dot gamma_(y y)[m-i]=gamma_(s y)[m+D] \
  #rotate(90deg,[#h(-5mm)$original$])
  $
  #v(-2mm)
  $ tilde(W)(z) dot Gamma_(y y)(z) = Gamma_(s y)(z) $
][
  #small[
    with $Gamma_(y y)(z) = Gamma_(s s)(z) + Gamma_(v v)(z)$ and $Gamma_(s y)(z) = Gamma_(s s)(z)$:]

  $
    tilde(W)(z) = (Gamma_(s s)(z)) / (Gamma_(s s)(z) + Gamma_(v v)(z)) \ tilde(W)(Omega) = (Gamma_(s s)(Omega)) / (Gamma_(s s)(Omega) + Gamma_(v v)(Omega))
  $
]

- At frequencies $Omega$ with very low noise power density $tilde(W)(Omega) approx 1$\
  $space arrow.r.curve$ #sym.dots with very high noise power density $tilde(W)(Omega) approx 0$
- The higher the noise power density, the greater the attenuation imposed on the spectrum input

#octicon("alert", color: orange) #u[Filter need to be causal]
#[#set list(marker: ([$arrow.r.curve$], [$arrow.r.curve$]))
  - Method of omitting anti-causal values is *suboptimal*
    - *Special case*: white noise $->$ apply _noise whitening_ before filter
]

=== The Principle of Orthogonality

- necessary condition for optimality
- estimation error is orthogonal (thus uncorrelated) to the filter input
  - error does not contribute to the estimation
  - not meeting the condition leads to suboptimal filter

#image("orthogonal.png")

$ E{hat(s)_"MMSE" [n+D] - s[n+D]} = 0$ to achieve minimum mean square error!

== Kalman Filter
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[#small[for discrete systems ; for continuous it's called _Kalman Bucy_-filter]]

- "Improvement" over Wiener Filter
- Can be employed in dynamic systems $->$ not stationary signals needed
  - due to generic character/nature can be used for various applications (such as coordinate tracking of aircraft or spacecraft)
- Wiener filter has finite order $=>$ Kalman algorithm has a recursive nature and thus represents an *infinite-length filter*
- Iterative error reduction (error starts high, reduced over time)

$ "Prediction" arrows.lr "Correction" $


#image("kalman_filter_block.png")

#highlight[Measurement equation]#h(1fr)#highlight[Process equation]\
#h(1fr)#small[$t_k$ contains all information of the system state at time $k$]

#columns(2)[

  $ y_k = H_k dot t_k + v_k $
  #colbreak()
  $ t_k = B_k dot t_(k-1) + q_k $
]

#image("kalman_filter_state_model.png", width: 90%)

#[
  #set list(marker: text(color_green)[*$+$*])
  - No limit on filter order (it's recursive, therefore infinite)
  - Dynamic adaptation in time-variant systems
  - Supports systems with stochastic and determinable components
]

#image("kalman_filter_conventionalalgorithm.png", width: 90%)

#text(1.2em)[#align(center)[$hat(x)$: real estimation$quad ; quad overline(x)$: predictive estimation]]

= Adaptive Filters

- Wiener & Kalman filters are optimal filters under the assumption, the statistics of the processes are known $->$ Rarely met in practice :(
- Filters which adapt to #u[unknown] and #u[possibly varying] environmental conditions are known as *adaptive filters*
  - _Example application_: wireless radio receivers to compensate for signal distortions in the channel
- *Optimal Linear Filters*: estimate the necessary autocorrelation and crosscorrelation sequences to derive filter coefficients
- *Filters with minimization of a cost function*: typically LMS deviation of the filter output from the desired response

== Linear Predictive Coding
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[#small[For speech coding]]

- estimate the necessary autocorrelation and crosscorrelation sequences to derive filter coefficients

- *Vocoders* $->$ built on certain speech synthesis model and extract the model parameters
  - transmitting only necessary parameters requires less bandwidth than transmitting the sampled waveform directly!
  - _Code Excited Linear Prediction_ (CELP) compresses speech into a 13kbit/s signal.
  - _LPC-10e_ compresses with 2400bit/s at the cost of reduced audio quality
- *Waveform coders* $->$ aim to preserve the signal waveform
  - usually requires high bandwidth

=== Example: Human Vocal Tract
Approximation of the human vocal tract as an all-pole filter:

#columns(2)[

  $ H(z) = g / (1-sum_(k=1)^P a_k dot z^(-k)) $

  #colbreak()

  *$P$*: filter order #h(2em) *$g$*: gain\
  *$a_k$* coefficients
]

The vocoder determines following parameters: filter coefficients $a_1, dots, a_10$, gain $g$, voiced or unvoiced $v[n]$ and the voiced period $T_0$.

#image("vocoder_graph.png", width: 80%)

- *unvoiced* (noise-like): consonants such as "f"
- *voiced* (show periodical signals): vocals and some consonants
- lower $k$ coefficients ($a_1, dots, a_4$) carry more information, than "loud" coefficients ($a_9, a_10$)

#image("vocoder_model.png", width: 80%)

== LMS Algorithm
#v(-1em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[#small[Least mean square -- tries to minimize its cost function (sample-by-sample)]]

#[
  #set list(marker: text(color_green)[*$+$*])
  - Less complex (steps until sufficent optimum) than Recursive Least Square (RLS)

  #set list(marker: text(color_redish)[*$-$*])
  - Slow convergence than RLS
  - More issues with non-stationary signals than RLS
]

#line(length: 100%, stroke: 0.5pt + gray)

1. Calculate gradient (iterative process) usingmean-squared error $epsilon_"MSE"$
  - Large step size $mu$ overshoots the target and oscillates around it
  - Small $mu$ leads to slow *convergence speed* ($prop#[]^(-1)$ iterations)

$
  epsilon_"MSE" (underline(w)) = E{(underline(w)^"T" dot underline(y)_n - s[n])^2} ==> gradient epsilon_"MSE" (underline(w)) = E{2 dot (underline(w)^"T" dot underline(y)_n - s[n]) dot underline(y)_n }
$

#grid(columns: (1.6fr, 1fr), gutter: 0pt)[
  2. Update values for next steps\ #small[$(n)$ indicates the iteration count + $underline(w)^((0))= 0_(M+1)$]


  $
    underline(w)^((n+1)) = underline(w)^((n)) + underbrace(mu dot (s[n] - (underline(w)^((n)))^T dot underline(y)_n) dot underline(y)_n, #text(1.3em, $=underline(w)_Delta^((n))$))
  $

  #small[$(-1)$ due to going against the gradient (go to *local* minima)]
][
  #image("gradient.png")
]

#line(length: 100%, stroke: 0.5pt + gray)



#image("lms_algorithm.png", width: 85%)


/ P1: #highlight[Training]: data is known $->$ for calibration and distortion
#image("lms_algo_preamble.png", width: 70%)

/ P2: #highlight[Decision Directed Operation]: Filter is checked and adjusted

#image("lms_algorithm_example.png")

=== Acoustic Echo Cancellation (AEC)

- AEC's task is to remove far end components from signal delivered by microphone.
- Filter adjusts itself to transmitted time variant sample
- reproduce echo & subtract from microphone-sample
- mode detection: speaker A, speaker B, both speakers, none
  - None: switch with ambient noise to protect the adaptive filter from its own degradation (when exposed to ambient noise)

#image("acoustic.png", width: 80%)



#image("echo_cancellation.png", width: 80%)





/* -------------------------------------------------------------------------- */
/*                                Wassner Teil                                */
/* -------------------------------------------------------------------------- */
#set page(columns: 3) // this creates a new page

= Digital Signal Processing (DSP)

DSP concerned in the application of the following methods: #circ[1] *Signal Generation*, \ #v(-2mm) #circ[2] *Signal Analysis*, #circ[3] *Signal Composition*, #circ[4] *Signal Selection*

#image("signal_classification.png")

#highlight[Pros (3 P's)]: #b[P]rogrammability, #b[P]arametrizability, Re-#b[P]eatability

#highlight[Cons]: additional effort for ADC & DAC, No processing of broadband HF, electro-magnetic disturbance

= Signal Analysis

#columns(3, gutter: 2mm)[

  #highlight(top-edge: "ascender")[Sampling an Analog Signal]

  $
    f_S = 1 / T_S quad x(n dot T_S)=x[n]
  $


  #highlight(top-edge: "ascender")[Other Functions]

  #small[causal: $space x[n]=0 "for" n<0$\
    $T_S$: Always known!]

  #small[#highlight[unit impulse]]
  $
    delta[n] = cases(
      0 : n != 0,
      1 : n = 0
    )
  $

  #small[#highlight[step impulse]]
  $
    u[n] = cases(
      0 : n < 0,
      1 : n >= 0
    )
  $
  #small[#highlight[periodic symbols ($k=T_0\/T_S$)]]
  $
    &x[n] =x[n+T_0\/T_S]\
    &= hat(X) dot e^(j underbracket(2 pi dot f_0 dot n dot T_S))\
    &= hat(X)(C(underbracket(space space))+j dot S(underbracket(space space)))
  $

  #small[#highlight[expected/mean value]]
  $ mu_x=1 / N sum^(N-1)_(i=0) x[i] $


  #small[#highlight[$("mean value")^2$ / avg DC power]]
  $
    rho^2=1 / N sum^(N-1)_(i=0)x[i]^2
  $

  #small[#highlight[variance/avg AC power]]
  $
    sigma^2_x=1 / N sum^(N-1)_(i=0)(x[i]-mu_x)^2
  $
  #par(justify: false, leading: 0.5em)[
    #small[Acoustic signals: corresponds to audible power content]
  ]

  #small[#highlight[power ratio]]
  $
    A_(d\B)=10 dot log_10 (P_1 / P_2)
  $

  #small[#highlight[Signal-to-Noise-ratio]]
  $
    "SNR" &=10 dot log_10 (P_("S") / P_("N"))\ &=20 dot log_10 (U_("S") / U_("N"))
  $

  #small[#highlight[power ratio]]
  $
    A_(d B)=10 dot log_10 (P_1 / P_2)
  $
  #small[#highlight[static correlation] ($x = y => arrow.t R$)]

  #small[ $=>$ yields new signal, quantifying the similarty of $x$ and $y$]

  $
    R=1 / N sum^(N-1)_(i=0)x[i]y[i]
  $

  #small[#highlight[_linear correlation_]]

  $ r_(x y)[n]=1 / N sum^(N-1)_(i=0)x[i]y[i+n] $
  $ N_(x y)=N_x+N_y-1 $

  $ r_(x y)[n] != r_(y x)[n] $

  #small[#highlight[(linear) convolution]]
  $
    z[n] &= sum_(i=-infinity)^infinity x[i]y[n - i] \
    &= x[n]*y[n]
  $

  #small[#highlight[circular convolution]]

  $ N_X eq N_Y $
  $
    z[n] = x[n] ast.circle_N y[n]
  $

  #text(0.9em)[#small[#u[Example]:]]

  #align(center)[#small[$x=underbrace({0.5,1},=a+0.5) " & " y=underbrace({#text(fill: red)[1],#text(fill: blue)[-1]}, =-b+1)$]]

  #v(1mm)

  #small[$
      mat(#text(fill: red)[1]  , 0                    , #text(fill: blue)[-1] ;
        #text(fill: blue)[-1], #text(fill: red)[1]  , 0                     ;
        0                    , #text(fill: blue)[-1], #text(fill: red)[1])
      dot mat(0.5;1;0) = mat(0.5;0.5;-1)
    $

    $
      z[n] = {0.5,0.5,-1} \
      x dot y |_(b=a) = -a^2 + 0.5 a + 0.5
    $
  ]

]

= A/D & D/A Conversion

#image("adc_conversion.png", width: 80%)
#image("dac_conversion.png", width: 80%)

_Code/Decode_ z.B. DFT & IDFT ; _Interpolate_ z.B. Tiefpass-Filter

= Sampling & Aliasing

#columns(2, gutter: 1mm)[
  $
    x_s (t) = sum^infinity_(n=-infinity)x(t) dot delta(t-n T_S)
  $

  #callout(title: "Aliasing", color: color_yellowish, icon: "alert")[
    Bei #box(stroke: red + 0.5pt, inset: (x: 0.5em, y: 0.5em), baseline: 0.5em, radius: 4pt)[$f_max >f_S\/2$] ensteht Aliasing.

    #image("aliasing.png")

    #highlight[Wenn Theorem nicht möglich ist.]

    #image("anti_aliasing_filter.png")

    $ f_"Pass" >= f_"Desired" quad f_"Stop" >= f_S - f_"Desired" $
  ]

  #colbreak()

  #align(center)[#box(
      stroke: red + 0.5pt,
      inset: (x: 0.5em, y: 1em),
      radius: 4pt,
    )[Sampling Theorem! $display([f_(max) < f_S/2])$]]
  #v(-1.1mm)
  #callout(title: "Sampling", color: color_yellowish, icon: "alert")[
    #image("sampling.png")
    #small[period. Spektrum mit $f_s$-vielfachen _Spiegelbilder_. Mit spektraler Verschiebung]

    $ x(t) e^(j 2 pi f_0 t) image X(f- f_0) $

    #small[ergibt]

    $
      X_s (f)=1 / T_S sum_(k=-infinity)^(infinity)X(f-k dot f_S)
    $
  ]

  === Sampling of Band-Pass Signals

  #align(center)[#box(stroke: red + 0.5pt, inset: 4pt, radius: 5pt)[

      generalized sampling theorem:

      $ -(N+1) / 2 f_S <= f <= -N / 2 f_S quad "and" $

      $ N / 2 f_S <= f <= (N+1) / 2 f_S $
    ]]

]

#columns(2)[

  #line(length: 100%, stroke: (dash: "dashed", paint: gray))
  #small[Wird generalisierten Theorem eingehalten, kann Signal rekonstruiert werden.
    Zum prüfen, ob eine Sampling Frequenz für ein Band-Pass Signal gültig ist:]
  $ 2 dot f_min / N >= f_S >= 2 dot f_max / (N+1) $

  #image("bandpass_evenN.png")

  #colbreak()

  #small[Odd $N$: Verschiebung mit Kosinus $f_S\/2$]

  $ tilde(x)[n] = (-1)^n dot x[n] $

  #align(center)[#small[$(-1)^n = cos(pi dot n) = cos(2 pi f_S\/2 dot n dot T_S)$]]

  #image("sampling_Nodd.png")
]


= Digital Signals in Frequency Domain

== Fourier Transformation to DFT

=== Discrete-Time Fourier Transform (DTFT)

#highlight[Transition to Discrete Time]

$
  X(f) = integral_(-infinity)^(infinity) x(t) e^(-j 2 pi f dot t) d t --> X_S (f) = integral_(-infinity)^(infinity) x(t) e^(-j 2 pi f dot n dot T_S) d t \

Omega = 2 pi f T_s = 2 pi f/f_S ==> #box(stroke: (paint: red, thickness: 0.5pt), inset: (x: 3pt, y: 6pt), baseline: 6.5pt, radius: 5pt)[$X(Omega) = sum_(n=-infinity)^infinity x[n] e^(-j Omega n)$]
$

$==> space X(Omega)$: *Discrete-Time Fourier Transform (DTFT)*

$Omega$: normalized angular frequency

#grid(columns: (1fr, 0.6fr), column-gutter: 3mm)[
  #v(3mm)
  #image("dft_circled.png")
][
  #image("dft_unitcircle.png")
]

#highlight[Transition to Finite Measurement Level]

#small[Fourier has $infinity$ long measurement time $->$ Confine to $N$ sample points, which leads to a discrete frequency range.]

#v(1mm)

#columns(2, gutter: 5pt)[
  Discrete frequency range:
  $ 0, f_S / N, 2 f_S / N, dots , (N-1) f_S / N $


  Measurement Interval: $T = N dot T_S$

  #colbreak()
  #callout(title: "Lowest capturable frequency")[
    #small[(With exception of any DC component)]
    $ f_min = f_1 = 1 / T=1 / (N dot T_S) = f_S / N $
  ]
]

#columns(2, gutter: 0pt)[
  === Discrete Fourier Transform (DFT)

  #formula(boxalign: center, inset: (x: 2pt, y: 2pt))[
    $ X[k]= sum_(n=0)^(N-1) x[n] dot e^(-j 2 pi n k / N) $
  ]

  $ "with" k=0,1,2,dots,N-1 $ #h(1fr)
  #colbreak()
  === Inv. Discrete Fourier Transform (IDFT)

  #small[_synthesis equation_: $x[n]$ is periodic at $T_S dot N$]

  #formula(boxalign: center, inset: (x: 2pt, y: 2pt))[$ x[n]=1 / N dot sum_(k=0)^(N-1) X[k] dot e^(j 2 pi n k / N) $]

  $ "with" n=0,1,2,dots,N-1 $

]

#small[Either DFT or IDFT require the normalization factor $1\/N$ to re-obtain the original signal. $=>$ IDFT has the normalization factor above.]

#image("fourier_method_comparison.png", width: 55%)

- periodicity in time $->$ discrete line spectra in frequency (Fourier & DFT)
- sampling in time $->$ periodic in frequency (DFT, DTFT)



== DFT Intuitive


$
  X[k] &= sum_(n=0)^(N-1) x[n] dot e^(-j 2 pi n k / N)\
  &= sum_(n=0)^(N-1) x[n] cos(-2 pi n k/N) + j dot sum_(n=0)^(N-1) x[n] sin(-2 pi n k/N) \
  &= underbrace(sum_(n=0)^(N-1) x[n] cos(2pi n k/N), Re(X[k])) + j dot underbrace(sum_(n=0)^(N-1) x[n] (-1) sin(2pi n k/N), Im(X[k]))
$

#callout(title: "Static Correlation")[
  Every DFT coefficient $X[k]$ is equal to the _static_ correlation between the signal $x[n]$ and discrete sine and cosine functions of frequency $k f_S\/N$.

  #v(2mm)

  #highlight[*Meaning*]: the DFT indicates how similar the signal is to harmonic oscillations with frequency k
]


== Properties of the DFT

=== Important Properties

/ Periodicity: DFT works with #highlight[discrete time signal samples], the spectrum is $f_S$ periodic.

$ "DFT": X[k] = X[k+N] quad quad "IDFT": x[n]=x[n+N] "with" T = N T_S $

/ Symmetry: DFT of a real-valued signal is #highlight[symmetric] around the point $k=N\/2$

$ X[N / 2 + m] = X^* [N / 2 - m] $

/ Time/Frequency Shifting: Shifting a periodic time sequence corresponds to a linear phase offset to all spectral values

$ x[n+n_0] quad original quad e^(j 2 pi dot n_0 k / N) dot X[k] $

The inverse is also true $->$ mult. complex exp. in time leads to frequency shift

$ e^(j 2 pi dot n_0 k / N) dot x[n] quad original quad X[k-k_0] $


/ Modulation: Direct consequence of frequency shift $->$ modulation property

$ cos(2 pi k_0 n/N) dot x[n] quad image quad 1 / 2 (X[k+k_0] + X[k-k_0]) $

/ Parseval Theorem: left side equals to energy of signal $->$ right side has use for SNR (separate noise frequency from signal frequency)

$ 1 / N sum_(n=0)^(N-1) x[n]^2 = sum_(n=0)^(N-1) abs(X[k]/N)^2 $

/ Correspondence of Conv. and Multi.: #highlight[fast conv.] $->$ $"IDFT"("DFT"(x[n] dot "DFT"(y[n])))$

$ x[n] ast.circle_N y[n] quad original quad X[k] dot Y[k] quad (k=0,1,dots N-1) $

=== Range of Validity of the DFT

/ aperiodic $x[n]$: all signal values $x[n]$ are zero outside the range $0 <= n <= N$. DFT samples the DTFT at discrete points of normalized angular frequency:

$ X[k] = X(Omega)|_(Omega = 2 pi k / N) $

#text(fill:red)[*IF NOT*] (range outside $ != 0$) $->$ DFT = approximation of DTFT $->$ solution: _windowing_

#v(2mm)

/ periodic $x[n]$: measurement interval $N dot T_S$ is an integer multiple of the period duration of $x[n]$

== OFDM Principle
#v(-2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Orthogonal Frequency Division Multiplexing]

Bits are spread across different frequencies.

#circ[1] bits are converted to phase (QPSK) #v(-0.5em)#circ[2] the result $->$ IDFT #circ[3] $x[n] -> x(t)$ via DAC

#image("ofdm_synthesis.png", width: 85%)
#image("ofdm_waves.png", width: 55%)
#image("ofdm_analyse.png", width: 85%)



== Practical Application Aspects of the DFT

=== DFT and Zero-padding

- Extending signal$(t)$ with zeros $->$ better interpolation (thinner frequency _bins_)
- does not modify DTFT $X[Omega]$, but provides additional sample points along $Omega$
- Rectangular window of length $N$ $->$ convolution of $X[k]$ with $sin(x)\/x$ (lobes)
- Important lobe-structure characteristics
  - *Width of the main lobe* (example: $approx 0.03$ cycles per sample)
  - *Attenuation of the first side lobe* relative to main lobe ($approx 12"dB"$)
#v(-2mm)

#image("dft_zeropadding_p1.png", width: 100%)
#image("dft_zeropadding_p2.png", width: 100%)


=== Choice of Measurement Interval & Leakage Effect

Example: $N=64, f_0=f_S\/4, T=N dot T_S = 16 dot T_0$ (peak at $k=16$ & $k=48$)

#image("interval_good.png", width: 80%)

Example: $f_0=f_S\/4 + f_S\/128 ->$ measurement interval no integer multiple of the period duration: *Leakage effect*:

#image("interval_bad.png", width: 80%)

=== DFT and Windowing
- DFT applies rectangular window $N$ samples
- Applying the _Blackman Window_ and afterwards appending zeros
  - Reduces virtual periodic continuation of the signal "outside" of signal, thus reducing the leakage effect.


=== Choice of Windowing Function


#small[#callout(
    title: "Choice Compromise",
  )[Choice of Window function leads to a compromise between the attenuation of leakage and spectral resolution in the spectrum $X[k]$ ]]

- *Narrow main lobe*: higher the spectral resolution for $X[k]$
- *Higher the side lobe attenuation*: better suppression of leakage in $X[k]$

$==>$ *Ideal*: DC-function $->$ indefinitely small main lobe, no side lobes ($N->infinity$)

#image("window_comparison.png", width: 80%)

== Short-Time DFT

- continuous evaluation of the frequency spectrum of short signal sections
  - Allows the observation of frequency spectrum over time
  - *BUT* more computation required $->$ solution: FFT

#image("dft_shorttime.png")

== Fast Fourier Transformation (FFT)
#v(-2.0em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Fast DFT]




=== Complexity of the FFT
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Divide-and-Conquer principle]

- *Divided* get either $N$ sample values (*decimation-in-time*) or $N$ spectral values (*decimation-in-frequency*)
  - Split values recursively into $r$ sub-sequences ($r$: radix) $->$ radix-2 algo often used

$ N = 2^L "where" L "is some integer" $

- $N$ almost always a power of two

$
  "DFT"&: quad quad [N^2]_("cpl.Mul.") &&+ [N^2 - N]_("cpl.Add.") \
  "FFT"&: quad quad [N / 2 dot log_2(N)]_("cpl.Mul.") &&+ [N dot log_2(N)]_("cpl.Add.")
$

#grid(columns: (1fr, 1.1fr), align: horizon)[
  assuming $T_"compute,Add"=T_"compute,Mul"$:
][
  $ "speedup factor"_"FFT" = (8N-2) / (5 dot log_2(N)) approx 1.5N / (log_2(N)) $
]

=== Properties of the Twiddle Factors

In order to reduce the computational effort we introduce the *twiddle factor* $W_N = e^(−j 2 pi/N)$ and can write the DFT new:

$ X[k] = sum_(n = 0)^(N-1) x[n] dot W_N^(n dot k), quad k={0, 1, 2,dots, N-1} $

#columns(2)[

  #highlight[Periodicity]
  #small[$W_N^k$ can evaluate to $N$ different numbers only]

  $ W_N^(k+N) = W_N^(k) $


  #highlight[Symmetry]
  #small[Apart from sign, every $W_N^k$ takes on only $N\/2$ different values within each period.]

  $ W_N^(k+N\/2) = -W_N^k $

  #v(1em)
  MCU only requires $N/2 dot 2 space (Re \& Im)$ space.
  #colbreak()

  #image("twiddlefactor_circle.png", width: 90%)


]

=== Radix-2 decimation-in-time FFT

#small[Splitting the twiddle-factor DFT up into $"odd"$ and $"even"$ yields two new sequences of length $N\/2$]:

$
  X[k] = underbrace(sum_(n=0)^(N\/2-1) x_1[n] W_N^(2 n k), x_1 space -> space n "even") + underbrace(sum_(n=0)^(N\/2-1) x_2[n] W_N^((2 n + 1) k), x_2 space -> space n "odd")\
  "introducing" W_N^2 = W_(N\/2): quad = underbrace(sum_(n=0)^(N\/2-1) x_1[n] W_(N\/2)^(n k), display(X_1[tilde(k)])) + W_(N)^(k) dot underbrace(sum_(n=0)^(N\/2-1) x_2[n] W_(N\/2)^(n k), display(X_2[tilde(k)]))
$

$=>$ $X_1[tilde(k)]$, $X_2[tilde(k)]$: $N\/2$-point DFT $-->$ $tilde(k) = k mod N\/2$ (limit $k$-range to meaningful $N\/2$ )

Recursively applying the splitting procedure leads to $N/2$ $2$-point DFTs:

$
  X[k] = sum_(n=0)^(0) x_1 [n] W_2^(n k) + W_2^k dot sum_(n=0)^(0) x_2 [n] W_2^(n k) = underline(x_1[0] + W_2^k dot x_2[0]), quad quad k = {0,1}
$

#image("butterfly_radix2.png", width: 90%)

- Butterfly structure requires $log_2(N)$ processing stages ($N=8 -> 3 "stages"$)


#small(
  callout(title: [Efficient FFT Implementation])[
    1. As soon as the butterfly operation has been performed, input pair can be re-used to store the calculated output-pair, thus performing the entire FFT *in-place*.
    2. Order of input values is *bit-reversed*: 0 (`000`), 4 (`001`$->$`100`), 2 (`010`), 6 (`110`), 1, 5, 3, 7.
  ],
)
#small[Matlab command `bitrevorder` for bit-reversed order]

#image("fft_3stage_radix2_butterfly.png")

== The Goertzel Algorithm

Goertzel is used, if only an individual $X[k]$ of all $N$ spectral components is required:

#grid(columns: (1fr, 1fr))[

  $
    s[n] &= x[n] + a dot s[n-1] - s[n-2]\
    y_k[n] &= s[n] - W_N^k dot s[n-1]
  $

  $ P_k = 2 abs(X[k]/N)^2= 2 / N^2 (Re^2 + Im^2) $

  $ f_k = k f_S / N $

  $ a = 2 dot cos(2 pi k/N), quad W_N^k = e^(-j dot 2pi k\/N) $
][
  #image("goertzel.png")
]

= Digital LTI Systems

#image("lti_block.png", height: 1.2cm)

- *Definition* of LTI Systems
  - *Linearity*: $quad y[n] = k_1 dot S{x_1} + k_2 dot S{x_2} = S{k_1 dot x_1 + k_2 dot x_2}$
  - *Time-Invariance*: $quad x[n] -> y[n] quad ==> quad x[n-d] -> y[n-d]$
- Allowed *Operations*
  - Multiplication of a signal with a #u[constant]: $quad x[n] dot a$
  - Addition of two signals: $quad x[n] + y[n]$
  - Time delay of a signal by $k dot T_s$: $quad x[n - k dot T_S]$

== System Descriptions in the Time Domain

=== Impulse Response
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[System Identification, Measurement]

#image("lit_impulse_response.png", width: 70%)

$ y[n] = sum_(i=-infinity)^(infinity) x[i] dot h[n-i] = x[n] ast h[n] -> "Linear Convolution" $

#image("lit_step_response.png", width: 70%)

$ h[n] = g[n] - g[n-1] quad <==> quad g[n] = sum_(k=0)^n h[k] $

=== Difference Equation
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[System Implementation (algorithm)]

$ y[n] = sum_(k=0)^(N) b_k dot x[n-k] - sum_(k=1)^(M) a_k dot y[n-k] $

#columns(2, gutter: 10pt)[
  #box(width: 100%, stroke: (right: (thickness: 0.5pt, dash: (4pt, 3pt), paint: gray)), outset: (right: 5pt))[
    #highlight[System Order]

    System order is defined by $max(N,M) $
  ]

  #colbreak()

  #highlight[Recursive]

  A system is recursive, when $M >= 1$.
]

=== Signal-Flow Diagram
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[System Implementation (architecture)]

#columns(2, gutter: 0pt)[
  #align(center)[#highlight[Direct Form 1]]
  #image("signalflow_directform1.png")

  #align(center)[#highlight[Tranposed Direct Form 1]]
  #image("signalflow_transposeddirectform1.png")

  #colbreak()

  #align(center)[#highlight[Direct Form 2]]
  #image("signalflow_directform2.png")

  #align(center)[#highlight[Transposed Direct Form 2]]
  #image("signalflow_transposeddirectform2.png")
]


== System Descriptions in the Frequency Domain

=== Transfer Function
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Coupling Analysis and Implementation]

#grid(columns: (1.2fr, 1fr), column-gutter: 0pt)[
  $ y[n] &= sum_(k=0)^(N) b_k dot x[n-k] - sum_(k=1)^(M) a_k dot y[n-k] $
  #v(-0.8em)
  $ #rotate(-90deg)[$image$] $
  #v(-0.8em)
  $ Y(z) &= sum_(k=0)^(N) b_k space z^(-k) dot X(z) - sum_(k=1)^(M) a_k space z^(-k) dot Y(z) $
][
  #highlight[z-Transfer-Function]

  $
    H(z)=Y(z) / X(z)=(sum_(n=0)^(N) b_n z^(-n)) / (sum_(m=0)^(M) a_m z^(-m))
  $
]

=== Pol/Zero-Plot
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Intuitive Analysis and Design]

#grid(columns: (1fr, 0.3fr))[
  $ H(z) = K_0 dot ((z-z_1)(z-z_2)dots(z-z_N)) / ((z-p_1)(z-p_2)dots(z-p_M)) dot z^(M-N) $
][
  #small[$z_i$ zeros ; $p_i$ poles\ $K_0$ gain]
]


#formula(inset: (x: 1pt, y: 3pt), baseline: 0.4em)[$(M > N) and b_0 != 0$] $-> M - N$ additional zeros at $z=0$ & only this case holds $K_0 = b_0$

#formula(inset: (x: 1pt, y: 3pt), baseline: 0.4em)[$N > M$] $-> N - M$ additional poles at $z=0$

#small[*Causal LTI System* is stable if $abs(p_i) < 1, i=1, dots, M$ (all poles within the unit circle of z-plane)]

=== Frequency Response
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[System Identification, Analysis and Design]

$
  h[n] original H[Omega] quad ; quad H(Omega) = abs(H(Omega)) dot e^(j dot phi(H(Omega))) quad ; quad abs(H(Omega))_"dB" = 20 dot log_10 (abs(H(Omega)))
$

#small[$abs(H(Omega))$: amplitude response ; $phi(H(Omega))$ phase response ; ]

- Frequency components in input are delayed differently, the output suffers from distortions $->$ Therefore, linear phase response $phi(H(Omega)) = -K dot Omega$ is desirable, since only then all frequency components are delayed: *group delay*

$ tau_g = - (d phi(H(Omega))) / (d Omega) $

Any LTI system reacts to a sinusoidal input signal with a sinusoidal output signal of the #u[same frequency]:

$ x[n] = cos(2 pi f_0 dot n dot T_S) ==> y[n] = |H(Omega_0)| dot cos(2 pi f_0 dot n dot T_S + phi(H(Omega_0))) $

The phase and amplitude can be extracted through:

$ abs(Y(Omega)) = abs(X(Omega)) dot abs(H(Omega)) quad ; quad phi(Y(Omega)) = phi(X(Omega)) + phi(H(Omega)) $


=== Relation between frequency response and transfer function

- DTFT and z-transform relation $quad => z = r dot e^(j Omega) $
- Frequency response = DTFT of impulse response $quad => H(Omega) = H(z)|_(z=e^(j Omega))$
- To obtain frequency response by evaluating:
#columns(2, gutter: 0pt)[
  #highlight[Amplitude response]

  $ abs(H(z)) = abs(K) (product_(n=1)^(N) abs(z-z_n)) / (product_(m=1)^(M) abs(z-p_M)) abs(z)^(M-N) $

  #colbreak()

  #highlight[Phase response]

  $ phi(H(Omega)) = &sum_(k=1)^(N) phi(z-z_k) - sum_(k=1)^(M) phi(z-p_k)\ &+sum_(k=N+1)^(M) phi(z) $
]

= Design of Digital Filters

#image("filterdesign.png", width: 80%)

$
  a_k, b_k --> "filter coefficients" #h(5em)  N, M --> "filter order"
$

== FIR Filter

=== Definition and Properties

FIR filter of order $N$ has the transfer function & impulse response:

$
  H(z) = b_0 + b_1 z^(-1) + dots + b_N z^(-N)\
  h[n] = {b_0, b_1, dots, b_N, 0,0, dots} #h(3em) "size" N+1
$

with $N + 1$ coefficients.

- *Stability* per definition, all poles are at $z=0$
- *Linear Phase*: easier to realize a linear-phase transfer characteristics (group delay)
- *Implementation*: easy implementation on HW and SW

#small[
  *Disadvantages*: higher order requires more computational effort.

  *Other names*: all-zero filter, transversal filter, moving-average filter
]

=== Symmetric FIR Filters

A FIR filter is symmetric when #formula(inset:(x: 1pt, y: 3pt), baseline: 0.4em)[$b_i = plus.minus b_(N-1), quad i = 0,0,dots, N$]
- #highlight[in case of $+$]: (mirror-)symmetric
- #highlight[in other cases]: anti-symmetric

#callout(title: "Lineare Phase Response for all symmetric FIR filters")[
  #grid(columns: (1fr, 0.7fr))[
    #small[1
      All symmetric FIR filters feature a linear phase response within their *pass* band (group delay):
    ]
  ][
    $ tau_g = N / 2 dot T_S $
  ]
]


#image("fir_linear_phase_types.png", width: 90%)

#[
#show table.cell.where(x: 0): it => small(strong(it))
#show table.cell.where(y: 0): it => small(strong(it))
#table(
  columns: (3.1em, 2.1cm, 1fr, 1fr, 1.2fr, 2cm),
  align: (center + horizon),
  inset: (x: 2pt),
  stroke: none, // clear frame

  // Draw minor lines
  table.hline(stroke: .25pt + gray, y: 2, start: 2, end: 5),
  table.hline(stroke: .25pt + gray, y: 4, start: 2, end: 5),
  table.vline(stroke: (thickness: .25pt, dash: (3pt, 3pt), paint: gray), x: 2),
  table.vline(stroke: (thickness: .25pt, dash: (3pt, 3pt), paint: gray), x: 5),

  // Draw Frame (overwrites minor lines)
  table.hline(stroke: .25pt, y: 0),
  table.hline(stroke: .25pt, y: 1),
  table.hline(stroke: .25pt, y: 3),
  table.hline(stroke: .25pt, y: 5),
  table.vline(stroke: .25pt, x: 0),
  table.vline(stroke: .25pt, x: 1),
  table.vline(stroke: .25pt, x: 6),

  [Type], [Symmetry], [Order $N$], [$abs(H(f=0))$], [$abs(H(f=f_S\/2))$], [$H(Omega)$#text(red)[$#[]^1$]],
  [1], table.cell(rowspan: 2)[$ h[n]=h[N-n] $ #small[(symmetric)]], [even], [any], [any], table.cell(rowspan: 2)[$
      e^(-j Omega N / 2) dot H_"zp"(Omega)
    $],
  [2], [odd], [any], [$ 0 $],
  [3], table.cell(rowspan: 2)[$ h[n]=-h[N-n] $ #small[(anti-symmetric)]], [even], [0], [0], table.cell(rowspan: 2)[$
      e^(-j (Omega N / 2 - pi / 2)) dot H_"zp"(Omega)
    $],
  [4], [odd], [0], [any],
)
]

#[
  #set par(leading: 0.8em)
  #small[#text(red)[*$#[]^1$*]: transfer function of symm. FIR are the product of a #highlight[linear-phase term] and some #highlight[real-valued transfer function] $H_"zp"(Omega)$ (*$"zp"$*: #highlight[zero-phase filter])]
]
#small[$==>$ anti-symmetric: constant $90 degree$ phase offset]


#small[
  #callout(title: [Stop Band $180 degree$ Jump])[
    In the stop band of a symm. FIR filter there can be $180 degree$-phase-jumps. Such discontinuities in phase response occur at a #highlight[pair of complex-conj. zeros at the unit circle]. This are often tolerated in #highlight[favor of sufficient attenuation in the stop band]
  ]
]

#[
  #set align(center)
  #show table.cell: it => small(it)
  #show table.cell.where(x: 0): it => small(strong(it))
  #show table.cell.where(y: 0): it => small(strong(it))
  #table(
    columns: (2.6em, auto, auto, auto, auto),
    align: (center + horizon),
    inset: (x: 2pt, y: 3pt),
    stroke: none,
    // Draw minor lines
    table.vline(stroke: (thickness: .25pt, dash: (3pt, 3pt), paint: gray), x: 2),
    table.vline(stroke: (thickness: .25pt, dash: (3pt, 3pt), paint: gray), x: 3),
    table.vline(stroke: (thickness: .25pt, dash: (3pt, 3pt), paint: gray), x: 4),

    // Draw Frame (overwrites minor lines)
    table.hline(stroke: .25pt, y: 0),
    table.hline(stroke: .25pt, y: 1),
    table.hline(stroke: .25pt, y: 2),
    table.hline(stroke: .25pt, y: 3),
    table.hline(stroke: .25pt, y: 4),
    table.hline(stroke: .25pt, y: 5),
    table.vline(stroke: .25pt, x: 0),
    table.vline(stroke: .25pt, x: 1),
    table.vline(stroke: .25pt, x: 5),
  
    [Type], [low-pass (LP)], [high-pass (HP)], [band-pass(BP)], [band-stop (BS)],
    [1], [yes], [yes], [yes], [yes],
    [2], [yes], [--], [yes], [--],
    [3], [--], [--], [yes], [--],
    [4], [--], [yes], [yes], [--],
  )
]

#colbreak()

=== Window Design Method
#v(-2.2em)
#h(1fr)#box(
  fill: white,
  inset: (y: 2pt, left: 2pt),
  outset: (right: 1pt),
)[Matlab: #raw("fir1",lang: "matlab")]

The _Window Design Method_ always yields low pass filters $->$ other filters are done via sum and difference of low-pass filters at different cut-off frequencies.

Start of with a desired frequency response $H_d(Omega)$ of an ideal TP-filter with cutoff at $f_C$:

$ h_(d"TP")[n] = (sin(Omega_C dot n)) / (pi dot n) image "rectangular signal in freq. domain" $

- #b[Restrictions]: finite length ideal impulse response (corresponds to multiplication with $square$-window *\/* convolution with sinc-function) $->$ overshoot at edges of pass and stop bands
  - persists for $N -> infinity$ (only helps to reduce the width of the transition band)
  - Solution: use different windowing functions to smooth the overshoot at a cost of wider transition bands

#small(
  callout(title: "Example High-Pass Filter", color: color.lighten(color_green, 20%), icon: "repo")[
    TP with cutoff at $f_S\/2$ minus TP with cutoff at $f_C$:

    $
      h_(d"HP")[n] &= (sin(pi dot n)) / (pi dot n) - sin(Omega_C dot n) / (pi dot n) \
      &= {dots, -h_(d"TP")[-2], -h_(d"TP")[-1], 1-h_(d"TP")[0], -h_(d"TP")[1], -h_(d"TP")[2], dots}
    $

  ],
)

#columns(2, gutter: 0pt)[
  #image("window_part1.png")
  #colbreak()
  #image("windowing_part2.png")
]

#[
  #set par(leading: 0.5em)
  #small[Steps of the window design method for FIR filters: Ideal low-pass frequency response #circ[1], ideal low-pass impulse response #circ[2], windowed #circ[3] and shifted #circ[4] practical low-pass impulse response.]
]
