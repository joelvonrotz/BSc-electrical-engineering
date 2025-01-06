#import "@preview/octique:0.1.0": *
#import "@preview/physica:0.9.4": *

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
#colbreak(weak: true)
#colbreak()


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

#todo[Relearn]

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

#todo[include fourier transform equation by hand!]

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
  #small[following describes a filter bank with\ $M = 4 "channels"$ and $"oversampling factor" D=2$]

  #image("transferfunction_4channelbank.png", width: 79%)
]

#v(-5em)
#grid(columns: (1.1fr, 1fr), gutter: 4pt)[
  #image("4channel_filterbank.png", width: 100%)
  #small[input: $h[0], h[1],dots, h[M-1]$]
][
  #v(5em)
]

#small(
  callout(title: "Some Basics")[
    / deterministic: value can be determined at any time
    / transient: begrenzte Zeitdauer


    #line(length: 100%, stroke: 0.5pt + gray)
    #columns(2)[
      #set math.cancel(cross: true, stroke: 0.4pt + red)

      / Finite Impulse Response:
      - Impulse response is infinite
      - No feedback ($y[n space cancel(-m) space]$)
      - always stable

      $ y[n] = sum_(a=0)^(N-1) b_a dot x[n-a] $

      #todo[grafisch Falten]

      #colbreak()

      / Infinite Impulse Response:
      - Impulse response infinite due to feedback
      - Feedback of signals ($y[n -m]$)
      - not necessarily stable

      $ y[n] = sum_(n=0)^(N-1) b_n dot x[k-n] - sum_(m=1)^(M) a_m dot y[n-m] $
      
      #todo[Levinson-Durbin-Rekursion]
    ]

  ],
)

= Random Signals

== Autocorrelation $gamma$ and Spectrum

#columns(2, gutter: 5pt)[
  #highlight[first-order statistic: *Mean value*]
  $ m_x & = E{x[n]} \ dot(m)_x &= 0 "for stationary signals (time)" $

  #[#highlight[autocovariance] (for signals with $m_x != 1$)]

  $ c_(x x)[m]=E{(x[n]-m_x)^* dot (x[n+m] - m_x)} $

  $c_(x x)[0]$: #small[Variance of signal ($E{abs(x[n]-m+x)^2}$)]

  #colbreak()

  #highlight[second-order statistic: *Autocorrelation*]

  $ gamma_(x x)[m] = E{x^*[n] dot x[n+m]} $

  $ gamma_(x x)[m] = gamma_(x x)^*[-m] $



]

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
  $ y[n] &= sum_(k=0)^(N) b_k space z^(-k) dot X(z) - sum_(k=1)^(M) a_k space z^(-k) dot Y(z) $
][
  #highlight[z-Transfer-Function]

  $
    H(z)=Y(z) / X(z)=(product_(n=0)^(N) b_n z^(-n)) / (product_(m=0)^(M) a_m z^(-m))
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
  #set table(
    stroke: (x, y) => {
      // draw "border"
      if y == 0 {
        (bottom: 0.25pt, top: 0.25pt)
      }
      if x == 0 or x == 5 {
        (right: 0.25pt)
      }

      if x == 0 {
        (left: 0.25pt)
      }

      // draw special lines
      if (x > 1 and x < 5) and (y == 1 or y == 3) {
        (bottom: (thickness: 0.25pt, paint: gray))
      }
      if (x >= 2 and x <= 5) {
        (left: (thickness: 0.25pt, dash: (1pt, 4pt), paint: gray))
      }

      if ((y == 2 or (y == 1 and (x == 1 or x == 5))) or (y == 4 or (y == 3 and (x == 1 or x == 5)))) {
        (bottom: 0.25pt)
      }
    },
  )
  #table(
    columns: (3.1em, 2.1cm, 1fr, 1fr, 1.2fr, 2cm),
    align: (center + horizon),
    inset: (x: 2pt),
    [Type], [Symmetry], [Order $N$], [$abs(H(f=0))$], [$abs(H(f=f_S\/2))$], [$H(Omega)$#text(red)[$#[]^1$]],
    [1], table.cell(rowspan: 2)[$ h[n]=h[N-n] $ #small[(symmetric)]], [even], [any], [any], table.cell(rowspan: 2)[$
        e^(-j Omega N / 2) dot H_"zp"(Omega)
      $],
    [2], [odd], [any], [$ 0 $],
    [3], table.cell(rowspan: 2)[$ h[n]=-h[N-n] $ #small[(anti-symmetric)]], [even], [0], [0], table.cell(rowspan: 2)[$
        e^(-j (Omega N / 2 - pi / 2)) dot H_"zp"(Omega)
      $],
    [4], [odd], [0], [any]
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
  #set table(
    stroke: (x, y) => {
      if y == 0 { (bottom: 0.25pt, top: 0.25pt) }
      if x == 0 or x == 4 { (right: 0.25pt) }
      if x == 0 { (left: 0.25pt) }
      if (x >= 2 and x <= 5) { (left: (thickness: 0.25pt, dash: (2pt, 4pt), paint: gray)) }
      if (y > 0) { (bottom: 0.25pt) }
    },
  )
  #table(
    columns: (2.6em, auto, auto, auto, auto),
    align: (center + horizon),
    inset: (x: 2pt, y: 3pt),
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
