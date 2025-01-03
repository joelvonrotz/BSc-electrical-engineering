#import "@preview/octique:0.1.0": *
#import "@preview/physica:0.9.4": *

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
    $
      P_i(z)=sum_(k=-infinity)^(infinity) p_i [k] z^(-k) = sum_(k=-infinity)^(infinity) h[k M + i] z^(-k), quad i=0,1,dots,M-1
    $
  ]
]


#cimage("polyphase.png", width: 95%)

#cimage("polyphase_responses.png", width: 95%)

#todo[include fourier transform equation by hand!]

== Sampling Rate Conversion


#image("sampling_rate_conversion.png")

#align(center)[$F_X => F_R=I dot F_X => F_V = F_R => F_Y = I \/ D dot F_X = 1 \/ D dot F_V$]

#text(0.9em)[Decimation $=>$ loss of information #h(1fr) Interpolation $=>$ higher intermediate sampling rate]
#columns(2)[

  $ F_H (Omega) = min(pi/I,pi/D) $
  #todo[$"FIR-order" = "FIR-length"$]
  #colbreak()

  $ I / D = underbrace(I dot (1/D), H_I->I->D->H_D)= underbrace((1/D) dot I, I->H->D) $
]

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

=== Hello World

Hello World





/* -------------------------------------------------------------------------- */
/*                                Wassner Teil                                */
/* -------------------------------------------------------------------------- */
#set page(columns: 3) // this creates a new page :)

= Digital Signal Processing (DSP)

DSP concerned in the application of the following methods: #circ[1] *Signal Generation*, \ #v(-2mm) #circ[2] *Signal Analysis*, #circ[3] *Signal Composition*, #circ[4] *Signal Selection*

#image("signal_classification.png")

#highlight[Pros (3 P's)]: #b[P]rogrammability, #b[P]arametrizability, Re-#b[P]eatability

#highlight[Cons]: additional effort for ADC & DAC, No processing of broadband HF, electro-magnetic disturbance
== Signal Analysis

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

== A/D & D/A Conversion

#image("adc_conversion.png")
#image("dac_conversion.png")

_Code/Decode_ z.B. DFT & IDFT ; _Interpolate_ z.B. Tiefpass-Filter

== Sampling & Aliasing

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

    $ x(t) e^(j 2 pi f_0 t) transform X(f- f_0) $

    #small[ergibt]

    $
      X_s (f)=1 / T_S sum_(k=-infinity)^(infinity)X(f-k dot f_S)
    $
  ]

  === Sampling of Band-Pass Signals

  #align(center)[#box(stroke: red + 0.5pt, inset: 4pt, radius: 5pt)[

      *Generalisiertes Abtasttheorem*

      $ -(N+1) / 2 f_S <= f <= -N / 2 f_S quad "and" $

      $ N / 2 f_S <= f <= (N+1) / 2 f_S $
    ]]

]

#columns(2)[

  #line(length: 100%, stroke: (dash: "dashed", paint: gray))
  #small[Wird generalisierten Theorem eingehalten, kann Signal rekonstruiert werden.
    Zum prüfen, ob eine Sampling Frequenz für ein Band-Pass Signal gültig ist:]
  $ 2 dot f_min / N >= f_S >= 2 dot f_max / (N+1) $

  #todo{}

  #colbreak()

  #small[Odd $N$: Verschiebung mit Kosinus $f_S\/2$]

  $ tilde(x)[n] = (-1)^n dot x[n] $

  #align(center)[#small[$(-1)^n = cos(pi dot n) = cos(2 pi f_S\/2 dot n dot T_S)$]]

  #image("sampling_Nodd.png")
]


== Digital Signals in Frequency Domain

=== Fourier Transformation to DFT

#highlight[Transition to Discrete Time]

$
  X(f) = integral_(-infinity)^(infinity) x(t) e^(-j 2 pi f dot t) d t --> X_S (f) = integral_(-infinity)^(infinity) x(t) e^(-j 2 pi f dot n dot T_S) d t \

Omega = 2 pi f T_s = 2 pi f/f_S ==> #box(stroke: (paint: red, thickness: 0.5pt), inset: (x: 3pt, y: 6pt), baseline: 6.5pt, radius: 5pt)[$X(Omega) = sum_(n=-infinity)^infinity x[n] e^(-j Omega n)$]
$

$==> space X(Omega)$: *Discrete-Time Fourier Transform (DTFT)*

$Omega$: normalized angular frequency

#grid(columns: (1fr, 0.7fr), column-gutter: 3mm)[
  #v(3mm)
  #image("dft_circled.png")
][
  #image("dft_unitcircle.png")
]

#highlight[Transition to Finite Measurement Level]

Fourier has $infinity$ long measurement time $->$ Confine to $N$ sample points, which leads to a discrete frequency range.

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
  *Discrete Fourier Transform (DFT)*
 
  $ X[k]= sum_(n=0)^(N-1) x[n] dot e^(-j 2 pi n k / N) $

  $ "with" k=0,1,2,dots,N-1 $ #h(1fr)
  #colbreak()
  *Inv. Discrete Fourier Transform (IDFT)*

  #small[_synthesis equation_: $x[n]$ is periodic at $T_S dot N$]
  $ x[n]=1 / N sum_(k=0)^(N-1) X[k] dot e^(j 2 pi n k / N) $ $ "with" n=0,1,2,dots,N-1 $

]

#cimage("fourier_method_comparison.png", width: 60%)

=== DFT Intuitive


$ X[k] &= sum_(n=0)^(N-1) x[n] dot e^(-j 2 pi n k / N)\ 
       &= sum_(n=0)^(N-1) x[n] cos(-2 pi n k/N) + j dot sum_(n=0)^(N-1) x[n] sin(-2 pi n k/N) \
       &= underbrace(sum_(n=0)^(N-1) x[n] cos(2pi n k/N), Re(X[k])) + j dot underbrace(sum_(n=0)^(N-1) x[n] (-1) sin(2pi n k/N), Re(X[k]))
$

#callout(title: "Static Correlation")[
  Every DFT coefficient $X[k]$ is equal to the _static_ correlation between the signal $x[n]$ and discrete sine and cosine functions of frequency $k f_S\/N$.
]


=== Properties of the DFT

/ Periodicity: DFT works with #highlight[discrete time signal samples], the spectrum is $f_S$ periodic.

$ "DFT": X[k] = X[k+N] quad quad "IDFT": x[n]=x[n+N] "with" T = N T_S $

/ Symmetry: DFT of a real-valued signal is #highlight[symmetric] around the point $k=N\/2$

$ X[N/2 + m] = X^* [N/2 - m] $

/ Time/Frequency Shifting: Shifting a periodic time sequence corresponds to a linear phase offset to all spectral values

$ x [n+n_0] quad quad e$

/ Modulation: 
/ Parseval Theorem:
/ Correspondence of Convolution and Multiplication:
/ Range of Validity of the DFT:



#todo[Important DFT Properties | Range of Validity of the DFT]

=== Practical Application Aspects of the DFT

#todo[Choice of Measurement Interval| DFT and Zero-padding | DFT and Windowing | Choice of Windowing Function]


=== Short-Time DFT

=== Fast Fourier Transformation (FFT)

#todo[Complexity of the FFT | Properties of the Twiddle Factors | Radix-2 decimation-in-time FFT | Efficient FFT Implementation]

=== The Goertzel Algorithm

== Digital LTI Systems

#todo[Definition of LTI Systems | Descriptions of LTI systems]

=== System Descriptions in the Time Domain

#todo[Impulse Response | Difference Equation | Signal-Flow Diagram]

=== System Descriptions in the Frequency Domain

#todo[Transfer Function | Pol/Zero-Plot | Frequency Response | Relation between frequency response and transfer function]

== Design of Digital Filters

#todo[Introduction]

=== FIR Filter

#todo[Definition and Properties | Symmetric FIR Filters | Window Design Method]
