#import "@preview/octique:0.1.0": *
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()




#import "../summary_template.typ": conf
#import "../commands.typ": *

#codly(enabled: true, smart-indent: true, number-format: it => [#text(0.8em, color.darken(gray, 20%))[#h(-2pt)#it]], inset:2pt, annotations: none, lang-format: none)

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
#show raw.where(block: true): set text(size: 0.9em)
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


#pagebreak()

#counter(page).update(1)

= Automatisierung

Automatisierung (DIN 19222): Das Ausrüsten einer Einrichtung, so dass sie ganz oder teilweise ohne Mitwirkung des Menschen geschieht.

- *Maschinenautomatisierung*
  - *Beispiele*: Werkzeugmaschinen, Druckmaschinen, Textilmaschinen, Papiermaschinen, Biegemaschine, Wasserstrahlschneider, Industrieroboter (Stäubli), usw.
- *Anlagenautomatisierung*
  - *Beispiele*: Fertigungsanlagen, Kraftwerke, Chemieanlagen, Postverteilanlagen, usw.
- *Gebäudeautomatisierung*
  - *Beispiele*: Einfamilienhaus, Einkaufszentrum, Stadion, Bürogebäude, Hotel, usw.
- *Geräteautomatisierung*
  - *Beispiele*: Medizinische Geräte, Telefone, Computer, Haushaltsgeräte, usw.

== Überblick - Maschinenautomatisierung

#image("overview_automation.png", width: 50%)

== Überblick - Gebäudeautomatisierung

#image("overview_buildingautomation.png")

== Automatisierungspyramide

#image("automation_pyramid.png")

== Allgemeine...



=== ...Aufgaben

#image("general_tasks.png", width: 70%)

=== ...Anforderungen

#image("general_requirements.png", width: 70%)

== Bauformen

#table(
  columns: (1fr, 0.655fr),
  stroke: none,
  inset: 2pt,
  align: top + center,
  image("controlpanel.png"), table.cell(rowspan: 2)[#image("compact_controller.png")],
  image("compact_rail_controller.png"), image("rack_controller.png"), image("rack_drawer.png", height: 28%)
)



== SPS

/ SPS: Speicherprogrammierbare Steuerung
/ PLC: Programmable Logic Controller

$->$ Wenn-dann-Regel

=== Prinzip

#image("plc_principle.png")

*Reihenfolge* #circ(1) Sensoren auslesen ; #circ(2) Werte Zwischenspeichern ; #circ(3) Logische Verknüpfungen anwenden ; #circ(4) Aktoren setzen

=== SPS vs Mikrocontroller

- In Automation möchte man etwas möglichst standardisiertes anwenden, anstatt eine Eigenlösung zu brauchen.
  - Aufwand ist kleiner
  - Die wichtigsten Funktionen sind bereits auf dem SPS implementiert
- Modularität
  - Die SPS ist erweiterbar durch Module (z.B. Motor-Modul, Encoder-Model)

- _It's also a bit like asking why would someone buy a PC when they could build their own._ [#link("https://electronics.stackexchange.com/questions/48704/why-use-plc-instead-of-microcontroller","Link")]

=== Numerische Steuerung

#grid(columns: (1fr, 0.7fr), column-gutter: 3mm)[
  Als Numerische Steuerung bezeichnet man ein Gerät zur Steuerung von Maschinen, das Steuerbefehle liest, die als Code auf einem Datenträger vorliegen, und in Arbeits- bzw. Bewegungsabläufe umsetzt. #link("https://de.wikipedia.org/wiki/Numerische_Steuerung", "Wiki")


  #v(3em)
  #h(1fr)Lustige Biegemaschine $-->$
][
  #image("numeric_controller.png")
]

- Regelungsaufgabe
- Steuerungsaufgabe
- Importieren von CAD Dateien (IGES, DXF, usw.)
- HMI (Human Machine Interface)
- Prozessabläufe (SPS like)

*Beispiele*: Koordinaten-basierte Maschinen wie Laser Cutter oder CNC Fräsmaschinen, *Industrie-PCs*

== Zentralisiert / Feldbus

Ein Feldbus verbindet in einer Anlage Feldgeräte wie Messfühler (Sensoren) und Stellglieder (Aktoren) zwecks Kommunikation mit einem Steuerungsgerät

#grid(columns: (1fr, 2.8fr))[
  #image("centralised.png")
  #v(-2.5em)
  #h(5pt)Zentralisiert
][
  #image("fieldbus.png")
  #v(-2.5em)
  #h(5pt)Feldbus
]

#columns(2)[

  #text(fill: color_green)[#octicon("check-circle", color: color_green) *Vorteile*]

  - geringerer Verkabelungsaufwand
  - Erweiterungen oder Änderungen

  #colbreak()
  #text(fill: color_redish)[#octicon("x-circle", color: color_redish) *Nachteile*]

  - Komplexität
  - Preis
  - Aufwendige Messgeräte (analyzer)
  - Längere Reaktionszeit

]

== Spezifizität

- *Gebäude*: LON, EIB, usw.
- *Anlage/Maschine*: CAN/CANOpen, Profibus, Profinet, EtherCAT, Varan, Ethernet/IP, SERCOS, usw.

= Direkter/ Indirekter Reglerentwurf

== Analog vs Digitaler Regelkreis

#image("analog_closedloop.png", width: 80%)

#image("digital_closed_loop.png")

== Direkt vs Indirekt

#grid(columns: (1fr, 1fr), column-gutter: 10pt)[
  #image("direct_indirect.png", width: 100%)
][

  #text(fill: color_green)[#octicon("check-circle", color: color_green) *Vorteile*]

  - Keine neuen Methode notwendig
  - Intuitivit¨at, Intepretation

  #text(fill: color_redish)[#octicon("x-circle", color: color_redish) *Nachteile*]

  - Auf analogen Regler beschr¨ankt (PID)
  - Keine explizite Ber¨ucksichtigung der Discretizierung

]

== Regelungsaufgabe

Ein wichtiger Aspekt eines digitalen Reglers ist die Dauer einer Reglersequenz: AD Umsetzung, PID Regelalgorithmus, DA Umwandlung. Das alles benötigt Zeit!

#image("regelungsaufgabe.png")

#[
  #set text(1.2em)
  #formula(boxalign: center, inset: 4pt)[$ (T_"AD" + T_"C" + T_"DA") << T $]
]


#colbreak()

= Diskretisierung


== Euler

#columns(2)[
  === Rückwärts-Recht.

  #grid(columns: (1fr, 0.5fr), align: horizon)[


    $ integral_0^(T) e[tau] d tau approx sum_(i=0)^(T) e[k] dot T $
  ][
    $ s= (z-1) / (T z) $
  ]

  #image("backwards.png", width: 78.4%)

  #colbreak()

  === Trapezoidal-Recht.


  #grid(columns: (1fr, 0.3fr))[

    $ &integral_0^(T) e[tau] d tau approx sum_(i=0)^(T) (e[k] + e[k-1]) / 2 dot T $

  ][
    #v(1cm)
    $ s= (z-1) / (T z) $

  ]
  #v(-0.7cm)
  #image("trapezoid.png", width: 70%)
]


== Differenzengleichung

$
  H(z) = Y(z)/X(z) = U(z)/E(z) = (sum_(m=0)^(M) b_m dot z^(-m))/(sum_(n=0)^(N) b_n dot z^(-n))
$

== Prozesse

=== PT1 Prozess

$ G(s) = Y(s)/U(s) = 1/(1+ tau dot s) -> s=(1-z^(-1))/T ->  #formula(inset: (x: 4pt, y: 3pt), baseline: 0.5em, boxalign: center)[$ y[k] = (1+T\/tau) dot u[k] + (1 + tau\/T) dot y[k-1] $] $

  === PT2 Prozess
  
  $ G(s) = Y(s)/U(s) = K/((1 + tau_1 s) (1 + tau_2 s)) -> s=(1-z^(-1))/T -> H(z) = (b_0)/(1 + a_1 dot z^(-1) + a_2 dot z^(-2)) $

  $ alpha_1 = T + tau_1 quad ; quad alpha_2 = T + tau_2 quad ; quad b_0 = (K dot T^2)/(alpha_1 alpha_2) quad a_1 = -(tau_1 / alpha_1 + tau_2 / alpha_2 ) quad ; quad a_2 = (tau_1 tau_2)/(alpha_1 alpha_2) $

  
  #formula(inset: (x: 4pt, y: 3pt), baseline: 1.2em, boxalign: center)[$ y[k] = -a_1 dot y[k-1] - a_2 dot  y[k-2] + b_0 dot u[k] $]


== PID Regler

#image("pid_all.png")


$
  u(t) = u_"k,a"(e(t))+ u_"i,a"(e(t))+ u_"d,a"(e(t)) = K_a (e(t) + 1/(T_(i,a)) integral_(0)^(t) e(tau) space d tau + T_(d,a) dot dot(e)(t))
$


#image("pid_danteil_alternative.png")

=== Proportionalität

#grid(columns: (1fr, 1fr), align: horizon)[
  #formula(inset: (x: 4pt, y: 3pt), baseline: 1.2em, boxalign: center)[$
      u_p [k] = K_d dot e[k]
    $]
][
  $K_d$ ist equivalent zur analogen Version $K_a$
]


=== Integration

$
  sum_(0)^(k)#[] = sum_(0)^(k-1)#[] + space alpha (k) quad ==> quad &#formula(inset: (x:4pt, y:3pt), baseline: 1.2em)[$ u_(i,d) [k] = u_i [k-1] + K_a/T_i dot (e[k] + e[k-1])/2 dot T $] <- "Trapez"\
&#formula(inset: (x:4pt, y:3pt), baseline: 1.2em)[$ u_(i,d) [k] = u_i [k-1] + K_a/T_(i,d) dot e[k] dot T $] <- "Rückwärts"
$

#v(-3.5em)

- $T_(i,d)$ ist equivalent zur\ analogen Version $T_(i,a)$

#v(1em)

=== Differential

#grid(columns: (1fr, 1fr), align: horizon)[
  #formula(inset: (x: 4pt, y: 3pt), baseline: 1.2em, boxalign: center)[$
      u_(d,d) [k] = (e[k] - e[k-1]) / T dot K_d dot T_(d,d)
    $]
][

  $T_(d,d)$ ist equivalent zur analogen Version $T_(d,a)$

]

== Antireset-Windup

Der Wandel von Digital zu Analog führt zu Overshoots im $u[]$ Anteil, da die Diskretisierung Tod-Zeiten einführt, wo der Regler nicht reagiert!


#columns(2)[

=== Ohne ARW

$ u_i [k] = u_i [k-1] + K_a T/T_i dot (e[k] + e[k-1])/2 $

#v(3em)

$ u_"nosat" [k] = u_p [k] + u_i [k] + u_d [k] $

$
  u[k] = cases(
    u_"sat,max" quad quad & "if" u_"nosat" [k] > u_"sat,max",
    u_"sat,min" & "if" u_"nosat" [k] < u_"sat,min",
    u_"nosat" [k] & "else"
  )
$

#colbreak()
=== Mit ARW

$ u_i [k] &= u_i [k-1] + K_a T/T_i dot (e[k] + e[k-1])/2\ 
  &+ T/T_r (u[k] - u_"nosat" [k]) $

$ u_"nosat" [k] = u_p [k] + u_i [k-1] + u_d [k] $

$
  u[k] = cases(
    u_"sat,max" quad quad & "if" u_"nosat" [k] > u_"sat,max",
    u_"sat,min" & "if" u_"nosat" [k] < u_"sat,min",
    u_"nosat" [k] & "else"
  )
$
]

== D-Anteil gefiltert

$ 
  u_d = (T_d dot s)/(T_d / N dot s + 1) -> s = (1-z^(-1))/T
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


== EN 61131-3 (IEC 1131)

Ist die einzige weltweit gültige Norm für Programmiersprachen von speicherprogrammierbaren Steuerungen. Sie definiert die folgenden fünf Sprachen:

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

#grid(columns: (1fr, 0.45fr), gutter: 10pt)[


  Die Umgebung eines Programmes, Funktionsblockes oder Funktion ist immer in zwei Bereichen aufgeteilt:

  - Deklaration
  - Implementation

  In der Deklaration, werden alle Inputs, Outputs, Putputs deklariert und allenfalls direkt initialisiert. In der Implementation wird der eigentliche Code geschrieben.

  Die Deklaration wird einmal zu Beginn ausgeführt, die Implementation wird im konfigurierten Zyklus wiederholt.
][
  #image("twincat_env.png")
]
#v(-1mm)
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

VAR_OUTPUT
  bMotoerEnable : BOOL := TRUE;
END_VAR

VAR_IN_OUT
  sString : STRING:= TRUE;
END_VAR
```

#callout(title: "Namenskonvention")[
  Auch für die SPS gibst eine Namenskonvention, welche nicht unbedingt eingehalten werden muss. Variablennamen werden jeweils ein Kürzel des Datentyps vorangestellt. Konstanten werden komplett gross geschrieben (ausser das Kürzel).

  #highlight[Beispiel]: `bTrigger` für eine `BOOL`-Variable
]

=== #octicon("code") IF-ELSE

```c
IF <condition1> THEN
  // Stuff 1
ELSE IF <condition2> THEN
  // Stuff 2
ELSE
  // Other stuff
END_IF
```

=== #octicon("code") FOR

```c
FOR nCounter := 1 TO 5 BY 1 DO
    nVar1 := nVar1*2;
END_FOR;
nErg := nVar1;
```


=== #octicon("code") CASE


```c
CASE nVar OF
1,5 :
  bVar1 := TRUE;
  bVar3 := FALSE;
2 :
  bVar2 := FALSE;
  bVar3 := TRUE;
10..20 :
  bVar1 := TRUE;
  bVar3 := TRUE;
ELSE
  bVar1 := NOT bVar1;
  bVar2 := bVar1 OR bVar2;
END_CASE;
```

Switch-Case kann auch für Enums verwendet werden:

```c
CASE eSystemMode OF
	ENUM_SystemModus.System_Init:
    bVar1 := TRUE;
    bVar2 := FALSE;
  ENUM_SystemModus.System_Init:
    bVar1 := FALSE;
    bVar2 := TRUE;
  ELSE // for unused enums
    bVar1 := FALSE;
    bVar2 := FALSE;
```

=== #octicon("code") WHILE

```c
WHILE nCounter <> 0 DO
  nVar1 := nVar1*2
  nCounter := nCounter-1;
END_WHILE;
```

=== #octicon("code") REPEAT

```c
REPEAT
  nVar1 := nVar1*2;
  nCounter := nCounter-1;
UNTIL
  nCounter = 0
END_REPEAT;
```

=== #octicon("code") RETURN

```c
IF bVar1 = TRUE THEN
    RETURN;
END_IF;
nVar2 := nVar2 + 1;
```

=== #octicon("code") JMP

Kannste den gleichen Fehler wie in C machen (`goto`)

```c
nVar1 := 0;
_label1 : nVar1 := nVar1+1;
(*instructions*)
IF (nVar1 < 10) THEN
    JMP _label1;
END_IF;
```

=== #octicon("code") EXIT

Mit `EXIT` können _FOR_, _REPEAT_ und _WHILE_-Loops ausgebrochen werden (wie `break` in C).

=== #octicon("code") CONTINUE

Ähnlich wie `continue` in C.

```c
FOR nCounter :=1 TO 5 BY 1 DO
    nInt1:=nInt1/2;
    IF nInt1=0 THEN
        CONTINUE; (* to avoid a division by zero *)
    END_IF
    nVar1:=nVar1/nInt1; (* executed, if nInt1 is not 0 *)
END_FOR;
nRes:=nVar1;
```

=== #octicon("code") Bitshifting SHR/SHL

#todo[schreiben!]

=== #octicon("package") Array

#todo[schreiben!]

=== #octicon("package") Struct/Enum

#todo[schreiben!]

=== #octicon("package") Global Variable List (GVL)

```c
{attribute 'qualified_only'}
VAR_GLOBAL
	uGlobalEncoderCount AT %I* : UINT;
	bGlobalEncoderOverflow AT %I* : BOOL;
	bGlobalEncoderUnderflow AT %I* : BOOL;
	bGlobalMotorEnable AT %Q* : BOOL;
	iGlobalMotorVelocity AT %Q* : INT;
END_VAR
```


=== Hardware Verknüpfen / AT-Deklaration

Da die SPS ein Gerät ist, welches mit anderer Hardware interagiert, können deren Pins mit Variablen verknüpft werden. Dies wird mit dem `AT` Keyword gemacht:

```c
<identifier> AT <address> : <data type>;
// ┌────────────────┘
   %<memory area prefix> ( <size prefix> )? <memory position>
```


```c
<memory area prefix> : I | Q | M
<size prefix>        : X | B | W | D
<memory position>    : * | <number> ( .<number> )*
```

- *I*: Input (_sensors_); *Q*: Output (_actuator_) ; *M*: Memory/Speicher
- *X*: Single Bit ; *B*: Byte (8 bits) ; *W*: Word (16 bits) ; *D*: Double Word (32 bits)

#highlight[Beispiele]:

```c
IbSensor1 AT %I*    : BOOL;
IbSensor2 AT %IX7.5 : BOOL;
```


=== Casting `_TO_`

TwinCat ST meckert, wenn man teils-ungültige Datentypen kombiniert (z.B. Zuweisung von Typ INT nach Typ DINT). Um dies zu lösen, können Casting-Funktionen verwendet werden:

```c
dstValue := <src-type>_TO_<dst-type>(srcValue)

iEncCntDifference := UINT_TO_DINT(uEncNewCnt) - UINT_TO_DINT(uEncOldCnt);
iMotorSpeed  := REAL_TO_INT(32767.0 * rU/24.0);
```

=== Programm
- Können als Funktion gestartet werden: z.B. `P_Programm();`
- Können keinen Rückgabewert haben

```c
PROGRAM Spaghetti_Sauce
VAR
  // declare Stuff here
	bTrig  : BOOL := FALSE;
  rValue : REAL := 0.0;
END_VAR
```

```c
// do stuff in the main program
IF (bTrig = FALSE) AND (rValue >= -1.0) THEN // also just `NOT bTrig` works
  rValue := 2.0;
END_IF


P_Prog2(); // call other programs
```

=== Funktion
- Kann ohne Instanzierung verwendet
- Keine statische Werte / Merkt sich Werte nicht!
- Return-Wert wird durch zuweisen eines Wertes auf den Funktionsnamen gemacht


```c
FUNCTION F_CalculateVelocity : REAL
VAR_INPUT
	uEncoderNewCount : UINT;
	uEncoderOldCount : UINT;
	rT : real;
END_VAR
VAR
	iEncoderCountDifference : DINT;
END_VAR
```

```c
iEncoderCountDifference := UINT_TO_DINT(uEncoderNewCount)
                         - UINT_TO_DINT(uEncoderOldCount);
IF (iEncoderCountDifference < 0) AND (GVL_Hardware.bGlobalEncoderOverflow) THEN
	// (new + max) - old
	iEncoderCountDifference := DINT_TO_INT(
                                (UINT_TO_DINT(uEncoderNewCount) + 65535)
                              - UINT_TO_DINT(uEncoderOldCount));
END_IF
// calculate rotation speed: 1/rT * 60 converts task cycle to rpm
F_CalculateVelocity := DINT_TO_REAL(iEncoderCountDifference)/ 2048.0 * (1/rT * 60);
```

=== Funktionsblock
- Muss im Deklarationsbereich zuerst instanziert werden: `fbCounter : FB_Counter;`
- `FB_Counter();` geht nicht
- Interne Variablen werden zwischengespeichert.


Funktionsblöcke können wie gefolgt aufgerufen werden:

```c
fbTMR : TON;
fbTMR (IN := %OX5, PT := T#300ms);
bVarA := fbTMR.Q;
```

oder

```c
fbTMR : TON;
fbTMR (IN := %OX5, PT := T#300ms, fbTMR.Q => bVarA);
```

/ `:=`: eine Funktions-Variable von `VAR_INPUT` wird ein Wert zugewiesen
/ `=>`: der Wert nach Funktionsaufruf wird einer Variable zugewiesen


== TwinCat - Funktionsblöcke

=== #octicon("tools") Timer Off-Delay (TOF)

#grid(columns: (1fr, 0.8fr))[


  #image("twincat_tof.png")

  #small[
    / `IN`: Eingangssignal ($1->0$ startet Timer)

    / `PT`: Verzögerungszeit
    / `Q`: Ausgang des Timers (`1` gehalten bis `PT` erreicht)
    / `ET`: abgelaufene Zeit
  ]
][
  #image("twincat_tof_graph.png")
]

```C
VAR
  fbTOF : TOF;
END_VAR
```

```C
fbTOF(IN := bInput, PT := T#500MS);
bLamp := fbTOF.Q;
```

=== #octicon("tools") Timer On-delay (TON)

#grid(columns: (1fr, 0.8fr))[

  #image("twincat_ton.png")

  #small[
    / `IN`: Eingangssignal ($0->1$ startet Timer)

    / `PT`: Verzögerungszeit
    / `Q`: Ausgang des Timers (`1` gesetzt, nachdem `PT` erreicht)
    / `ET`: abgelaufene Zeit
  ]

][
  #image("twincat_ton_graph.png")
]

```C
VAR
  fbTON : TON;
END_VAR
```

```C
fbTON(IN := bInput, PT := T#500MS);
bLamp := fbTON.Q;
```

=== #octicon("tools") Timer Pulse Generator (TP)

#grid(columns: (1fr, 0.8fr))[

  #image("twincat_tp.png")

  #small[
    / `IN`: Eingangssignal ($0->1$ startet Timer)

    / `PT`: Pulselänge
    / `Q`: Ausgang des Timers (`1` $ "wenn" t < "PT"$)
    / `ET`: abgelaufene Zeit
  ]

][
  #image("twincat_tp_graph.png")
]

```C
VAR
  fbTP : TP;
END_VAR
```

```C
fbTP(IN := bInput, PT := T#500MS);
bLamp := fbTP.Q;
```

== AMS Net ID

Die _AMS Net ID_ ist die Adresse des lokalen Rechners im TwinCAT-Netzwerk.


#pagebreak()
= Beispiel Code

== #octicon("code") Edge Detector

```c
FUNCTION_BLOCK  FB_EdgeDetector
VAR_INPUT
	bInputValue : BOOL;
END_VAR

VAR_OUTPUT
	bRisingEdge : BOOL;
	bFallingEdge : BOOL;
	bDoubleTap : BOOL;
END_VAR
VAR
	bOldValue : BOOL := FALSE;
	fbTimerDoubleTap : TON;
	bTimerDoubleTapFlag : BOOL := FALSE;
	tTimerDuration : TIME := T#2000MS;
END_VAR
```

```C
IF bInputValue > bOldValue THEN
	bRisingEdge := TRUE;
	bFallingEdge := FALSE;
ELSIF bInputValue < bOldValue THEN
	bRisingEdge := FALSE;
	bFallingEdge := TRUE;
ELSE
	bRisingEdge := FALSE;
	bFallingEdge := FALSE;
END_IF

IF bRisingEdge OR bDoubleTap OR fbTimerDoubleTap.Q THEN
	IF bTimerDoubleTapFlag = FALSE AND bDoubleTap = FALSE THEN // first tap
		bTimerDoubleTapFlag := TRUE; // start the timer
	ELSIF bTimerDoubleTapFlag = TRUE AND fbTimerDoubleTap.Q = FALSE THEN
		bDoubleTap := TRUE;
		bTimerDoubleTapFlag := FALSE;
	ELSE
		bTimerDoubleTapFlag := FALSE;
		bDoubleTap := FALSE;
	END_IF
END_IF

fbTimerDoubleTap(IN:=bTimerDoubleTapFlag, PT:= tTimerDuration);

bOldValue := bInputValue;
```


== #octicon("code") PWM Signal `F_PWMFunction`

```c
FUNCTION PwmSignal : REAL
VAR_INPUT
	rYMax : REAL := 1;
	rYMin : REAL := 0;
	rDutyCycle : REAL := 0.5;
	rYOffset : REAL := 0;
	rAngularFrequency : REAL;
	rTime : REAL;
END_VAR
VAR
	rPeriod : REAL;
	rModuleTime : REAL;
	rModulo : INT;
	rThreshold : REAL;
END_VAR
```

```c
rPeriod := 2.0 * PI / rAngularFrequency;

rModulo := (TRUNC_INT(rTime/rPeriod));
rModuleTime := rTime - rModulo * rPeriod;
rThreshold := (rPeriod * rDutyCycle);
IF rModuleTime >= rThreshold THEN
	PwmSignal := rYMin + rYOffset;
ELSE
	PwmSignal := rYMax + rYOffset;
END_IF
```

== #octicon("code") Sinus Signal `F_SinusFunction`

```c
FUNCTION SinusFunction : REAL
VAR_INPUT
	rAmplitude : REAL := 1;
	rYOffset : REAL := 0;
	rAngularFrequency : REAL;
	rTime : REAL;
END_VAR
```

```c
SinusFunction := SIN(rAngularFrequency * rTime) * rAmplitude + rYOffset;
```

== #octicon("code") PWM Signal  `F_SquareFunction`

```c
FUNCTION SquareSignal : REAL
VAR_INPUT
	rYMax : REAL := 1;
	rYMin : REAL := 0;
	rYOffset : REAL := 0;
	rAngularFrequency : REAL;
	rTime : REAL;
END_VAR
VAR
	rPeriod : REAL;
	rModuleTime : REAL;
	rModulo : INT;
END_VAR
```

```c
rPeriod := 2.0 * PI / rAngularFrequency;

rModulo := (TRUNC_INT(rTime/rPeriod));
rModuleTime := rTime - rModulo * rPeriod;

IF rModuleTime >= (rPeriod * 0.5) THEN
	SquareSignal := rYMin + rYOffset;
ELSE
	SquareSignal := rYMax + rYOffset;
END_IF
```

== #octicon("code") PT1 Prozess 

```c
FUNCTION_BLOCK FB_LowpassFilter
VAR_INPUT
	rInputValue : REAL; // x[n]
	rDeltaTimeSec : REAL;
	rTau : REAL;
END_VAR
VAR_OUTPUT
	rOutputValue : REAL;
END_VAR
VAR
	rLastOutputValue : REAL := 0; // x[n-1]
END_VAR
```

```c
rOutputValue := (rDeltaTimeSec * rInputValue + rTau * rLastOutputValue)/(rDeltaTimeSec + rTau);
rLastOutputValue := rOutputValue;
```

== #octicon("code") PT2 Prozess 

```c
FUNCTION_BLOCK FB_SecondOrderLag
VAR_INPUT
	rInputValue : REAL; // x[n]
	rDeltaTimeSec : REAL;
	rRotFreq : REAL;
	rDamping : REAL;
END_VAR
VAR_OUTPUT
	rOutputValue : REAL;
END_VAR
VAR
	rLastOutputValues : ARRAY[0..1] OF REAL := [0,0]; // x[n-1], x[n-2]
END_VAR
```

```c
rOutputValue := (rInputValue * EXPT(rDeltaTimeSec,2) * EXPT(rRotFreq,2)
			   		+ rLastOutputValues[0] * (2 + 2 * rDamping * rRotFreq * rDeltaTimeSec)
			   		- rLastOutputValues[1])
				/ (1 + 2 * rDamping * rRotFreq * rDeltaTimeSec + EXPT(rDeltaTimeSec,2) * EXPT(rRotFreq,2));

// Shift InputValue into the lastValues array
rLastOutputValues[1] := rLastOutputValues[0];
rLastOutputValues[0] := rOutputValue;
```