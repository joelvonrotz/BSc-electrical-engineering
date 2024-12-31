#import "../summary_template.typ": conf
#import "../commands.typ": *

#import "@preview/octique:0.1.0": *
#import "@preview/cetz:0.3.1" as cetz
#import "@preview/fletcher:0.5.2" as fletcher: node, edge, shapes


#let accent = "425eaf"
#let color_redish = rgb("#cb4154")
#let color_alert = color_redish
#let color_caution = rgb("#e79925")
#let color_links = rgb("#2549e7")
#let color_green = rgb("#025809")

#set enum(numbering: (it => strong[#it.]))

#set text(lang: "de", font: "Ubuntu Sans", 10pt)
#set par(justify: true)

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

Mit Semaphoren können an vorbestimmte Anzahl _Teilnehmer_ Ressourcen erlaubt werden, bevor der Ressourcen-Zugang gesperrt wird.

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


== Streams

Streams dienen dazu, drei elementare Operationen ausführen zu können:

/ Schreiben: Dateninformationen müssen in einem Stream geschrieben werden. Das Format hängt vom Stream ab.

/ Lesen : Aus dem Datenstrom muss gelesen werden, ansonsten könnte man die Daten nicht weiterverarbeiten.

/ Wahlfreien Zugriff: Nicht immer ist es erforderlich, den Datenstrom vom ersten bis zum letzten Byte auszuwerten. Manchmal reicht es, erst ab einer bestimmten Position zu lesen.

C\# implementiert Stream-Klassen mit sequentielle Ein-/Ausgabe auf verschiedene Datentypen:

/ Zeichenorientiert: (`StreamReader/-Writer`, `StringReader``/-Writer`) mit Wandlung zwischen interner Binärdarstellung und externer Textdarstellung. Grundlage ist die byteorientierte Ein- und Ausgabe mit den Klassen `TextReader` und `TextWriter`

/ Binär: (`BinaryReader/-Writer`, Unterklassen von `Stream`) ohne Wandlung der Binärdarstellung

=== Stream Architektur


.NET-Stream-Architektur konzentriert sich auf drei Konzepte:

/ Adapter: formen Daten (Strings, elementare Datentypen, etc.) aus Programmen um. (siehe #link("https://de.wikipedia.org/wiki/Adapter_(Entwurfsmuster)")[#text(fill: color_links)[Adapter Entwurfsmusters]])

/ Dekorator: fügen neue Eigenschaften zu dem Stream hinzu. (siehe #link("https://de.wikipedia.org/wiki/Decorator")[#text(fill: color_links)[Dekorator Entwurfsmusters]])

/ Sicherungsspeicher: ist ein Speichermedium, wie etwa ein Datenträger oder Arbeitsspeicher.

#image("streams.png")

=== Lesen

Lesen aus einem Netzwerk TCP-Socket (`SR` = `StreamReader`)::

#small[```cs
TcpClient client = new TcpClient("192.53.1.103",13);
SR inStream = new SR(client.GetStream());
Console.WriteLine(inStream.ReadLine());
client.Close();
```]

Lesen aus einer Datei (`SR` = `StreamReader`):

#small[```cs
try {
  using (SR sr = new SR("t.txt")) {
  string line;
    while ((line = sr.ReadLine()) != null) {
      Console.WriteLine(line);
    }
  }
} catch (Exception e) {
  Console.WriteLine(e);
}
```]

Lesen aus einer Datei mit einem Pass-Through-Stream:

#small[```cs
Stream stm = new FileStream("Daten.txt",
                    FileMode.Open,
                    FileAccess.Read);
ICryptoTransform ict = new ToBase64Transform();
CryptoStream cs = new CryptoStream(stm,
                        ict,
                        CryptoStreamMode.Read);
TextReader tr = new StreamReader(cs);
string s = tr.ReadToEnd();
Console.WriteLine(s);

```]

=== Schreiben

Lesen von einer Tastatur und Schreiben auf den Bildschirm:

#small[```cs
string line;
Console.Write("Bitte Eingabe: ");
while ((line = Console.ReadLine()) != null) {
  Console.WriteLine("Eingabe war: " + line);
  Console.Write("Bitte Eingabe: ");
}
```]

Schreiben in eine Daten mit implizitem FileStream:

#small[```cs
try {
  using (StreamWriter sw = new StreamWriter("Daten.txt")) {
    string[] text = { "Titel", "Köln", "4711" };
for (int i = 0; i < text.Length; i++)
sw.WriteLine(text[i]);
}
Console.WriteLine("fertig.");
}
catch (Exception e) { Console.WriteLine(e); }
```]

```cs
StreamWriter sw = new StreamWriter("Daten.txt")
// equals to
FileStream fs = new FileStream("Daten.txt",
                      FileMode.Create);
StreamWriter sw = new StreamWriter(fs);
```

#colbreak(weak: true)

/* -------------------------- Socket Kommunikation -------------------------- */

#grid(
  columns: (auto, auto),
  align: center + horizon,
  heading(level: 2)[Socket Kommunikation], small[`System.Net.Sockets.Socket`],
)

#align(center)[#image("endtoend.png", width: 90%)]

Sockets werden für _Interprozesskommunikation_ verwendet, also zwischen zwei oder mehrere Prozesse (z.B. Applikation). Damit zwei Prozesse sich verstehen, müssen beide die #u[selbe Sprache] (Protokoll) sprechen: _TCP/IP_, _UDP_, _Datagram-Sockets_, _Multicast-Sockets_, etc.

Sockets können#sym.dots.h

- #sym.dots.h\Einen Port binden
- #sym.dots.h\An einem Port auf Verbindungsanfragen hören
- #sym.dots.h\Verbindung zu entfernten Prozess aufbauen
- #sym.dots.h\Verbindungsanfragen akzeptieren
- #sym.dots.h\Daten an entfernten Prozess senden

=== UDP Protokoll
#v(-2em)
#h(1fr)#small[User Data Protocol]
#v(0.1em)

Ermöglicht das Senden von gekapselte rohe IP Datagramme zu übertragen, ohne Verbindungsaufbau.

$arrow.double$ _Verbindungslos_ bedeutet keine Garantie, dass das gesendete Paket beim Empfänger ankommen.

#align(center)[#image("udp_datagram.png", width: 90%)]

#align(center)[#image("udp_header.png", width: 90%)]

UDP Header besteht aus 8 Byte. Die _Länge_ entspricht Header Bytes + Daten Bytes. Die Prüfsumme wird über das gesamte Frame berechnet (IP Paket).

#align(center)[#image("udp_ports.png", width: 90%)]

Der Ziel-Port bestimmt, für welche Anwendung ein Datenpaket bestimmt ist.

#todo[Add Code Snippets here?]

=== TCP Protokoll
#v(-2em)
#h(1fr)#small[Transmission Control Protocol]
#v(0.1em)

Datagram ist ähnlich wie bei UDP.

*IP* sorgt dafür, dass die Pakete von Knoten zu Knoten gelangen; *TCP* behandelt den Inhalt der Pakete und korrigiert dies (durch erneutes Senden)

TCP kann als End-to-End Verbindung in Vollduplex betrachtet werden $arrow$ Möglich mit separierten Sende- & Empfangs-Counter.

#align(center)[#image("tcp_header.png", width: 90%)]

Wichtige Merkmale:

/ Verbindungsorientiert: Vor Datenübertragung, wird eine Verbindung aufgebaut (Threeway Handshake)

/ Zuverlässige Datenübertragung: Sicherstellung, dass alle gesendeten Daten korrekt beim Empfänger ankommen (Sequenz-Counter, ACK, Fehlerkorrektur [z.B. Prüfsummen])  

/ Segmentierung und Reassemblierung: Grosse Datenmengen werden in kleinere Segmente (65535 bytes [64KB]) aufgeteilt und entsprechend beim Empfänger wieder zusammengesetzt.

/ Flow Control: damit Sender den Empfänger nicht mit mehr Daten überfordert.

/ Congestion Control: Dynamische Datenübertragungsrate anhand Netzwerkauslastung

#align(center)[#image("tcp_ports.png", width: 90%)]

Verbindungsaufbau wird via _Three-Way_ Handshake gemacht (folgendes Bild rechts). Der Abbau mit einem _Four-Way_ Handshake (folgendes Bild links).

#image("tcp_connection.png")

#todo[Add Code Snippets here?]

== Interfaces

#todo[Hello]

= MVVM

#align(center)[
  #fletcher.diagram(
    spacing: (10mm, 7mm),
    node-corner-radius: 3pt,
    node-outset: 2mm,
    label-size: 8pt,

    node((0, 0), [View(s)], fill: green.lighten(80%), stroke: green.mix((black, 30%)), height: 4em, width: 4em, inset: 0pt),
    node((2, 0), [View\ Model], fill: red.lighten(80%), stroke: red.mix((black, 30%)), height: 4em, width: 4em, inset: 0pt),
    node((4, 0), [Model], fill: blue.lighten(80%), stroke: blue.mix((black, 30%)), height: 4em, width: 4em, inset: 0pt),
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

#small[*Model-View-ViewModel* (MVVM) ist ein Entwurfsmuster und eine Variante des *Model-View-Controller*-Musters (MVC).]

Darstellung und Logik wird getrennt in UI und Backend. 

#columns(2)[
  #text(fill: color_green)[#octicon("check-circle", color: color_green) *Vorteile*]
  #small[
  - ViewModel kann unabhängig von der Darstellung bearbeitet werden
  - Testbarkeit keine UI-Tests nötig
  - Weniger _Glue Code_ zwischen Model & View
  - Views kann separat von Model & ViewModel implementiert werden
  - Verschiedene Views mit dem selben ViewModel.
  ]
  #colbreak()
  #text(fill: color_redish)[#octicon("x-circle", color: color_redish) *Nachteile*]
  #small[
  - Höherer Rechenaufwand wegen bi-direktionalen "Beobachters"
  - Overkill für simple Applikationen
  - Datenbindung kann grosse Speicher einnehmen
  #v(0.94cm)
  #h(1fr)#text(fill: color_links)[#link("https://learn.microsoft.com/en-us/archive/blogs/johngossman/advantages-and-disadvantages-of-m-v-vm")[Link 1]], #text(fill: color_links)[#link("https://de.wikipedia.org/wiki/Model_View_ViewModel")[Link 2]]
]
  ]

== View
#v(-0.9em)
#h(1fr)#small[_What to display, Flow of interaction_]

Ist das User Interface des Programmes und ist via `Binding` und `Command` and das ViewModel gebunden.

== View Model
#v(-0.9em)
#h(1fr)#small[_Business Logic, Data Objects_]

Bildet den Zustand der View(s) ab. Es können verschieden Views mit dem selben ViewModel verbunden werden.

== Model
#v(-0.9em)
#h(1fr)#small[_How to display information_]

Beschreibt den Zustand für das Backend und kommuniziert mit anderen Prozessen (z.B. Betriebssystemroutinen)

= Werkzeuge & Entwicklung

== Espressif

Chinesische Firma in Shanghai (Gründung 2008). Halbleiter-Chips werden bei TSMC hergestellt (_fabless_ Herstellung).

=== Mikrocontroller
#small[
/ ESP8266 (2014): Tensilica Xtensa LX106, 64KB iRAM, 96KB DRAM, WiFi, ext. SPI Flash
/ ESP32 (2016): Wi-Fi + BLE, Single/Dual Core Xtensa LX6 \@240 Mhz
/ ESP32-S2 (2019): Single-Core, Security, WiFi, keine FPU, kein Bluetooth, Xtensa LX7 \@240 MHz
/ ESP32-S3 (2019): (FPU, WiFi+BLE, Dual-Xtensa LX7 \@240 MHz, + RISC-V)
/ ESP32-C3 (2020): (Single-Core RISC-V \@160 MHz, Security, WiFi+BLE)
/ ESP32-C6 (2021): (RISC-V \@160 MHz, RISC-V \@160 MHz + LP RISC-V \@20 MHz, WiFi, Bluetooth/BLE, IEEE 802.15.4)
/ ESP32-H2 (2023): (Single-core RISC-V \@96 MHz, IEEE802.15.4, BLE, no WiFi)
]


#align(center)[#image("esp32_blockdiagramm.png", height: 75%)]

== ESP-IDF

#image("esp32_espidf.png")

=== ESP32 Startup

1. Power-On oder Reset
2. Bootloader
3. EN Low? $arrow$ Neue Anwendung über UART laden
4. Startup IDF (Initialisierung, Memory,#sym.dots.h)
5. Starten FreeRTOS
6. 'main' Task $arrow$ ruft `app_main()` Funktion auf
7. Anwendung läuft in `app_main()`, oder started neue Tasks

#align(center)[#image("esp32_startup.png", width: 80%)]

=== ESP app_main()

- `app_main()` wird von einem Task gerufen $arrow$ Task hat tiefste Priorität `0` (`tskIDLE_PRIORITY`)
- *FreeRTOS*: Preemptive, Highest Priority Task läuft
- `printf` wird auf Konsole (UART) umgeleitet

== OpenOCD
#v(-1.1em)
#h(1fr)#small[Open On-Chip Debugging]
#v(-0.3em)

#todo[]

=== GBD Client-Server Architektur
#v(-2em)
#h(1fr)#small[GNU Debugger]
#v(0.1em)

#todo[]

=== JTAG
#v(-2em)
#h(1fr)#small[Joint Test Action Group]
#v(0.1em)

#todo[]

== CMake

#todo[]

== Verteilte Entwicklung

#todo[]

== #octicon("git-merge") Git

_Git_ ist eine Versionsverwaltungssoftware!

=== Konzepte

#columns(2, gutter: 4mm)[

Following shows the most basic concepts used in version control systems such as Git.
#v(2mm)

#b[Basic Checkins]
#image("git_concept_checkin.png", width: 100%)

#b[Checkout and Edit]
#image("git_concept_checkout_edit.png", width: 100%)

#b[Branching]
#image("git_concept_branching.png", width: 100%)

#colbreak()

#b[Diffs]
#image("git_concept_diffs.png", width: 100%)

#b[Merging]
#image("git_concept_merging.png", width: 100%)

#b[Conflicts]
#image("git_concept_conflicts.png", width: 100%)
]

=== Was gehört in ein VSC

- *Kein* Backup: Source, Derived, Other
- `.gitignore`
- Stufen: Repository, Verzeichnis, rekursiv
- Empfehlungen

=== Modell

#image("git_modell.png")

- *Connector*: git bash, Client
- *Server*: git (local und als Server (z.B. GitHub))
- Server & Repository: local, remote, verteilt
  - Zentralisiert (z.B. SVN) oder verteilt (z.B. git)
- Überlegungen: Platz, Übertragung, Arbeitsfluss

=== Workflow

#image("git_workflow.png")

#align(center)[#quote[_Commit Early, commit often_]]

=== Befehle

#image("Git_operations_curved.svg")

- Optionales *Remote Repository*
- *Local Repository* (clone)
- Lokale Datenbank existiert als *Working Directory* auf Disk
- *Index*: Cache, Stage, Sammlung von Änderungen, welche in die Datenbank überführt (*commit*) werden
- *fetch*, *pull*, *push*
- *checkout*, *add*



=== Setup & Konfiguration

Mit #raw("git init", lang: "bash") wird der aktuelle Arbeitsordner zu einem Git Repo konvertiert (rückgängig durch löschen von `.git` Ordner)

Möchte man ein Remote Repo _herunterladen_ kann dies mit #raw("git clone [url]", lang: "bash") gemacht werden.

Danach muss das Repo konfiguriert werden.\
#small[Services wie GitLab & GitHub nutzen diese Information um die entsprechenden Profile anzugeben.]

```bash
# local
git config user.name "[name]"
git config user.email "[email]"

# global
git config user.name "[name]"
git config user.email "[email]"
```
=== Add & Commit

```bash
# check current state of the repo
git status
# add/stage files based on pattern (or path)
git add [pattern]
# commit staged files with message 
git commit -m "[msg]"
# push changes to the remote repo
git push
# unstage staged files
git reset -- [pattern]
# compare changes of the file
git diff [file]
# compare changes of the staged file
git diff --staged [file]
```

=== Branch & Merge

Branches sind nützlich für separate Entwicklungen von Funktionen, welche nach Testen in den Hauptbranch gemerget werden.

Branches werden erstellt mit folgendem Befehl (+ weitere nützliche Befehle)

```bash
git branch [new_branch] # create
git branch -m [old_branch] [new_branch] # rename
git branch -c [old_branch] [new_branch] # copy
git branch -d [branch] # delete
git switch [branch] # switch to branch
```

Branch Merging verläuft mit dem Prinzip:

#align(center)[
  _Merge commits *FROM* the stated branch_
]

Also muss man sich im Destinations-Branch befinden und von dort aus die Änderungen von Merge-Branch reinmergen!

1. Änderungen im Branch `dummy` *commiten* und *pushen*

2. Branch zu `main` wechseln
   ```bash
   git switch main
   ```

3. Merge Operation ausführen
   ```bash
   git merge [-m "[msg]"] dummy
   # No automatic merge commit (used for inspection)
   git merge --no-commit dummy
   ```

=== Merge-Konflikten

Merge-Konflikte treten in der Regel in den folgenden Szenarien auf:

#text(0.9em)[

/ Simultaneous Edits: Zwei Entwickler ändern dieselbe Codezeile in verschiedenen Branches
/ Conflicting Changes: Eine Datei wird in einem Branch gelöscht und im anderen geändert
/ Complex Merges: Mehrere Branches werden gemerget und es entstehen Änderungen über mehrere Dateien und Zeilen
]

Bei Konflikten, kann das Mergetool verwendet werden

```bash
git mergetool
```

Möchte man den Merge rückgängig machen

```bash
git merge --abort # revert to pre-merge state
```


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

== FreeRTOS SMP
#v(-1.1em)
#h(1fr)#small[#b[S]ymmetric #b[M]ulti#b[P]rocessing]
#v(-0.3em)


`CPU0` $arrow$ `PRO_CPU` Protocol\
`CPU1` $arrow$ `APP_CPU` Application (`app_main()`)


=== Task für separatem Core erstellen

Hello

```c
xTaskCreatePinnedToCore(
  ...,
  tskNO_AFFINITY)
```


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

