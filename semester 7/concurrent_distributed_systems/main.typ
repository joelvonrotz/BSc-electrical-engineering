#import "../summary_template.typ": conf
#import "../commands.typ": *

#import "@preview/octique:0.1.0": *
#import "@preview/cetz:0.3.1" as cetz
#import "@preview/fletcher:0.5.2" as fletcher: node, edge, shapes


#let accent = "425eaf"
#let color_alert = rgb("#cb4154")
#let color_caution = rgb("#e79925")

#set enum(numbering: (it => strong[#it.]))

#set text(lang: "de", font: "Ubuntu Sans", 10pt)
#show raw: set text(ligatures: true, font: "Cascadia Code", size: 1.1em)

#show: conf.with(
  title: [Concurrent Distributed Systems],
  subtitle: [Zusammenfassung],
  subject: [CDS],
  author: [Joel von Rotz],
  accent_color: "425eaf",
  fontsize: 9pt,
  show-outline: true,
  place: [HSLU T&A],
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207",
)

#colbreak(weak: true)
#colbreak()


/* -------------------------------------------------------------------------- */
/*                             Struktur Übersicht                             */
/* -------------------------------------------------------------------------- */
= C\#/.NET

#callout(
  title: "Garbage Collector",
)[C\# verfügt über einen Garbage Collector, welcher nicht verwendete (& referenzlose) Objekte automatisch löscht und somit Speicher freigibt.]


// Fancy Block for displaying a right aligned object
#grid(
  columns: (auto, auto),
  align: center + horizon,
  heading(level: 2)[Threads], small[`System.Threading`],
)

#image("threads.png")

- Erhält eigenen Stack für lokale Variablen
- Mehrere Threads können auf gemeinsame Variablen zugreifen
  - #b(color: red)[Deadlock] und #b(color: red)[Race Condition] beachten!

=== Erstellen

Erstellen mit #raw("new Thread(...)", lang: "cs") auf zwei Varianten: #raw("ThreadStart", lang: "cs") & #raw("ParameterizedThreadStart", lang: "cs")

```cs
Thread t  = new Thread(new ThreadStart(f1));
Thread t2 = new Thread(new ParameterizedThreadStart(f2));

static void f1(void) {/*...*/};
static void f2(object value){/*...*/};
```

=== Starten

Starten mit #raw(".start(param)", lang: "cs"):

```cs
t.start();
t2.start(true);
```

=== Priorität konfigurieren

Priorität setzen mit #raw(".Priority", lang: "cs")

```cs
t.Priority = ThreadPriority.Lowest;
```

#par()[
  #small[`Highest` (4),`AboveNormal` (3),`Normal` (2),`BelowNormal` (1),`Lowest` (0)]
]

=== Beenden

1. Methode ohne Felder beendet
2. Auftreten einer Exception

```cs
static void Main() {
  try {
    new Thread(Go).Start();
  } catch(Exception ex) {
    Console.Writeline("Exception!");
  }
}
static void Go() {
  throw null; // exception will NOT be caught
  Console.Writeline("uups");
}
```

#callout(
  title: "Thread sind (fast) isoliert",
  icon: "alert",
  color: color_caution,
)[
  #u[Beispiel oben] `try/catch` ist nur im Bezug zur Erstellung des Threads brauchbar, denn es wird die Exception *NICHT* abfangen, da diese *IM* Thread ausgelöst wurde.
]

Die Funktion #raw(".Abort()", lang: "cs") "killed" den Thread à la:

#small[
  #rect(width: 100%, radius: 4pt, stroke: (paint: gray, cap: "round", dash: "dashed"))[
    / Scenario: You want to turn off your computer
    / Solution: You strap dynamite to your computer, light it, and run.
  ]
]


=== Lebenszyklen

#image("thread_lifecycle_waited.png")

#b[Legende]
/ `new`: Thread-Objekt erstellt, #u[aber noch nicht gestartet]

/ `ready`: gestartet, lokaler Speicher (Stack) zugeteilt, wartet auf Zuweisung des Prozessors

/ `running`: Thread läuft

/ `blocked`: Thread wartet bis eine Bedingung erfüllt wird #b[/] Aufruf einer Betriebssystemroutine, z.B. File-Operationen

/ `stopped`: Thread existiert nicht mehr, Objekt schon.

/ `Object lock-pool`: Bei der Verwendung vom _lock_-Konstrukt, erhält der Threads Lebenszyklus diesen zusätzlichen Zustand. Jedes Object hat genau einen lock-pool.

/ `Object wait-pool`: Menge von Threads, die vom Scheduler unterbrochen wurden und auf ein Ereignis warten, um fortgesetzt wreden zu können.

#callout(title: [Wichtig], icon: "alert", color: color_alert)[
  Der Objects lock-pool und der Objects wait-pool müssen zum gleichen Objekt gehören.

  ```cs
  object synch = new object();

  lock (synch) {
    Monitor.Wait(synch);
  }
  ```

  Bei nicht Einhaltung wird die Exception ausgelöst:

  `System.Threading.SynchronizationLockException`

]

== Thread Synchronisation

=== Race Conditions

...ist eine Konstellation, in denen das Ergebnis einer Operation vom zeitlichen Verhalten bestimmter Einzeloperationen abhängt.

#align(center)[#image("race_conditions.png")]

Gute Lösung dazu muss vier Bedingungen erfüllen:

#small[
  1. Nur ein Thread in kritischen Abschnitten
  + Keine Annahmen zur zugrundeliegenden Hardware treffen.
  + Ein Thread darf andere Threads nicht blockieren, #u[ausser] in kritischen Bereichen
  + Thread sollte nicht unendlich lange warten, bis dieser in den kritischen Bereich eintreten kann.]

=== Deadlocks

Entsteht, wenn Threads auf Resourcen warten, welche sie gegenseitig sperren und somit kein Thread sich befreien kann.

#align(center)[#image("deadlock.png", width: 7cm)]

=== Join-Funktion

Mit #raw(".Join()", lang: "cs") können Threads auf den Abschluss eines anderen Threads warten (z.B. Öffnung einer Datei bevor Schreibung). Beim Aufruf wird der aktuelle Thread blockiert, bis die Join-Kondition erreicht wurde.

```cs
// in Thread t
t2.Join(); // wait for Thread t2's completion
```

=== `lock` Konstrukt

Mit Locks können Threads Code Bereiche reservieren. Dies wird mit#sym.dots.h

```cs
lock(<object>) {
  /* do stuff with <object> or use it as a flag*/
}
```

#sym.dots.h gemacht. Als `<object>` kann eine Flag (z.B. ein `object` Objekt) oder eine Ressource (z.B. File Objekt) verwendet werden.

`lock` ist die Kurzform für#sym.dots.h

```cs
Monitor.Enter(<object>);
try{
  /* critical section */
}
finally { Monitor.Exit(<object>) }
```

=== EventWaitHandle

Threads warten an einem inaktiven Event-Objekt, bis dieses aktiv (frei) geschaltet wird. Es gibt zwei Arten:

/ `AutoResetEvent`: Threadaktivierung durch das Event setzt das Eventsignal automatisch zurück zu _inaktiv_ (nur `.Set()`)

/ `ManualResetEvent`: Eventsignal muss manuel zurückgesetzt werden (`.Set()` $arrow$ dann `.Reset()`)

```cs
private static
  EventWaitHandle wh = new AutoResetEvent(false);

static void Main() {
  new Thread(Waiter).Start();
  Thread.Sleep(1000);
  wh.Set();
}

static void Waiter() {
  Console.Writeline("Waiting...");
  wh.WaitOne();
}
```

=== Pulse/Wait

Wenn der Zugang zu einem kritischen Abschnitt nur von bestimmten Bedingungen oder Zuständen abhängt, so reicht das Konzept der einfachen Synchronisation mit _lock_ nicht aus

```cs
/* Monitor.<func> */
bool Wait(object obj);
bool Wait(object obj, int timeout_ms);
bool Wait(object obj, TimeSpan timeout);

void Pulse(object obj);
void PulseAll(object obj);
```

Es führen zwei Wege aus dem Warte-Zustand:

1. Anderer Thread signalisiert Zustandswechsel
2. Angegebene Zeit ist abgelaufen (dabei wird der aktuelle Lock wieder genommen und `Wait` gibt `false` zurück)

#callout(title: [Nur in kritischen Bereichen], icon: "alert", color: color_caution)[
  `Wait`, `Pulse` und `PulseAll` dürfen nur innerhalb eines kritischen Bereichs ausgeführt werden!

  Ruft ein Thread `Wait` auf, wird der Lock für diesen Abschnitt freigeben! Nach Erhalt eines Pulses wartet der Thread auf den Lock seines Abschnittest.
]

```cs
private static object synch = new object();

static void Main() {
  new Thread(Waiter).Start();
  Thread.Sleep(1000);
  lock (synch) {
    Monitor.Pulse(synch);
  }
}

static void Waiter() {
  lock (synch) {
    Console.WriteLine("Waiting...");
    if (Monitor.Wait(synch, 1000))
      Console.WriteLine("Notified");
    else
      Console.WriteLine("Timeout");
  }
}
```

=== Semaphore
#small[(Signalmasten, Leuchttürme)]

#image("semaphore.png")

Mit Semaphoren können an vorbestimmte Anzahl _Teilnehmer_ erlaubt werden, bevor der Ressourcen-Zugang gesperrt wird.

/ `.WaitOne()` ($"sema"."P"()$): Eintritt (Passieren) in einen synchronisierten Bereich, wobei mitgezählt wird, der wievielte Bereich es ist.

/ `.Release()` ($"sema"."V"()$): Verlassen (Freigeben) eines synchronisierten Bereichs, wobei mitgezählt wird, wie oft der Bereich verlassen wird.

```cs
// (initialCount: 3, maximumCount: 3)
private static Semaphore s = new Semaphore(3, 3);

static void Main() {
  for (int i = 0; i < 10; i++) {
    new Thread(Go).Start(i);
  }
}

static void Go(object number) {
  while (true) {
    s.WaitOne(); // thread X waits
  
    // thread X enters critical section
    Thread.Sleep(1000); // entries limited to 3

    s.Release(); // Thread X leaves
  }
}
```

#colbreak()

=== Mutex

#image("mutex.png")

Nützlich, wenn eine Ressource (z.B. Ethernet-Schnittstelle) von mehreren Threads verwendet werden möchte. 

#callout(title: "Freigabe-Scope")[
  Im Vergleich zu Semaphoren, welches erlaubt von anderen Aktivitätsträgern freizugeben, muss die Mutex vom Mutex-Besitzer freigegeben werden!
]

```cs
private static      //   (initially owned, name)
  Mutex mu = new Mutex(false, "CoolName");

static void Main() {
  if (!mu.WaitOne(TimeSpan.FromSeconds(5),false)) {
    Console.WriteLine("Another app instance exists");
    return;
  } try {
    Console.WriteLine("Running - Enter to exit");
    Console.ReadLine();
  } finally {
    mu.ReleaseMutex();
  }
}
```

== Interfaces

== Socket Kommunikation

== MVVM/MVC

= Werkzeuge

== Espressif ESP-IDF



== Verteilte Entwicklung

= Verteile Architekturen

== Multicore

== Konfiguration

== Feldbus

== Drahtlos

== Remote Access

/* -------------------------------------------------------------------------- */
/*                                 Styger Teil                                */
/* -------------------------------------------------------------------------- */

= FreeRTOS Crash Kurs

== Critical Sections, Reentrancy

=== Semaphore

=== Mutex

== Nachrichten

=== Semaphore

=== Event Flags

=== Queues

=== Direct Task Notification

=== Stream Buffer

=== Message Buffer


= #octique-inline("repo") Git

#image("Git_operations_curved.svg")

#callout(title: "Commit - Pull - Push")[
  Bei Projekten mit mehreren Entwickler, bevor Änderungen gepusht werden
  #set enum(numbering: n => text(weight: "bold")[#n.])
  + *Commit*
  + *Pull*
    - Merge-Konlikte lösen
  + *Push*
]

== Konfiguration

```bash
git config user.name "[name]"
git config user.email "[email]"
git init
git clone [url]
git status
git add [file]
git diff [file]
git diff --staged [file]
```

= CI/CD
#v(-1.1em)
#h(1fr)#small[*C*\ontinuous *I*\ntegration and *C*\ontinuous *D*\elivery]
#v(-0.3em)

== Pipeline

=== Ausführung von Jobs & Stages überspringen

```yml
when: manual        # .gitlab-ci.yml
[ci skip]           # commit message
git push -o ci.skip # command line
```



/* -------------------------------------------------------------------------- */
/*                                  Jost Teil                                 */
/* -------------------------------------------------------------------------- */

= C\# / .NET

```cs
string str = $"Create string with directly concatting {variables} into it!";
```

== Threads

== Streams

= MVVM

#align(center)[
  #fletcher.diagram(
    spacing: (10mm, 7mm),
    node-corner-radius: 3pt,
    node-outset: 2mm,
    label-size: 8pt,

    node((0, 0), [View(s)], fill: green.lighten(80%), stroke: green.mix((black, 30%)), height: 4em, width: 4em),
    node((2, 0), [View Model], fill: red.lighten(80%), stroke: red.mix((black, 30%)), height: 4em, width: 4em),
    node((4, 0), [Model], fill: blue.lighten(80%), stroke: blue.mix((black, 30%)), height: 4em, width: 4em),
    edge((0, 0), (2, 0), "-solid", stroke: 1pt, bend: 20deg)[User Action],
    edge((2, 0), (0, 0), "-solid", stroke: 1pt, bend: 20deg)[`Binding`],
    edge((2, 0), (4, 0), "-solid", stroke: 1pt, bend: 20deg)[Update Model],
    edge((4, 0), (2, 0), "-solid", stroke: 1pt, bend: 20deg)[Model Changed],

    edge(
      (-0.5, 1),
      (2.5, 1),
      "|-|",
      stroke: 1pt,
      label-anchor: "center",
      label-sep: 0pt,
      label-fill: white,
      label-size: 9pt,
    )[*Frontend*],
    edge(
      (3.5, 1),
      (4.5, 1),
      "|-|",
      stroke: 1pt,
      label-anchor: "center",
      label-sep: 0pt,
      label-fill: white,
      label-size: 9pt,
    )[*Backend*],
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



= Espressif ESP32

== FreeRTOS SMP

SMP $arrow.r$ #b[S]ymmetric #b[M]ulti#b[p]rocessing

`CPU0` $arrow$ `PRO_CPU` Protocol

`CPU1` $arrow$ `APP_CPU` Application (`app_main()`)


=== Task für separatem Core erstellen

Hello

```c
xTaskCreatePinnedToCore(
  ...,
  tskNO_AFFINITY)
```
