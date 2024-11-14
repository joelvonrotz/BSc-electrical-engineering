#import "../summary_template.typ": conf
#import "../commands.typ": *

#set math.cases(gap: 0.4em)

#set text(lang: "de")
#set par(leading: 1em, spacing: 0.9em, justify: true)

#show: conf.with(
  title: [Industrial Automation],
  subtitle: [Zusammenfassung],
  subject: [IAUT],
  author: [Joel von Rotz],
  accent_color: "425eaf",
  place: [HSLU T&A],
  fontsize: 10pt,
  font-heading: "Alegreya Sans",
  font-paragraph: "Ubuntu Sans",
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207"
)


= Automatisierung

== Test

= Digitale Regelung

#callout()[Hello]

Digitales Integrieren

_Mittelpunkt_ Riemann-Summe

$
  integral_0^t e(t) dot d t approx sum cases(
    e[k]dot Delta T,
    e[k-1]dot Delta T,
    (e[k]+e[k-1])\/2 dot Delta T
  )
$

$
  
$