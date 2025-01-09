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

#set columns(gutter: 4mm)
#set page(columns: 3)
#set highlight(top-edge: "baseline", fill: rgb("#9ed0ff"))
#set enum(numbering: (it => strong[#it.]))
#set text(lang: "de", font: "Ubuntu Sans", 10pt)
#set par(justify: true)

#show image: set align(center) // default image alignments
#show link: set text(fill: color_links)
#show raw: set text(ligatures: false, font: "Cascadia Code", size: 1.1em)

#show raw.where(block: true): set text(size: 0.8em)

#show: conf.with(
  title: [Concurrent Distributed Systems],
  subtitle: [Zusammenfassung],
  subject: [CDS],
  author: [Joel von Rotz],
  accent_color: "425eaf",
  fontsize: 9pt,
  show-outline: true,
  compact_spacing: false,
  flipped: true,
  place: [HSLU T&A],
  source: "https://github.com/joelvonrotz/BSc-electrical-engineering/tree/main/semester%207",
)

#image("meme.jpg")
#image("meme.jpeg")

#set page(columns: 3)

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

#image("race_conditions.png")

Gute Lösung dazu muss vier Bedingungen erfüllen:

#small[
  1. Nur ein Thread in kritischen Abschnitten
  + Keine Annahmen zur zugrundeliegenden Hardware treffen.
  + Ein Thread darf andere Threads nicht blockieren, #u[ausser] in kritischen Bereichen
  + Thread sollte nicht unendlich lange warten, bis dieser in den kritischen Bereich eintreten kann.]

=== Deadlocks

Entsteht, wenn Threads auf Ressourcen warten, welche sie gegenseitig sperren und somit kein Thread sich befreien kann.

#image("deadlock.png", width: 7cm)

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

/ Lesen: Aus dem Datenstrom muss gelesen werden, ansonsten könnte man die Daten nicht weiterverarbeiten.

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

#colbreak()

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

#image("endtoend.png", width: 90%)

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

#image("udp_datagram.png", width: 90%)

#image("udp_header.png", width: 90%)

UDP Header besteht aus 8 Byte. Die _Länge_ entspricht Header Bytes + Daten Bytes. Die Prüfsumme wird über das gesamte Frame berechnet (IP Paket).

#image("udp_ports.png", width: 90%)

Der Ziel-Port bestimmt, für welche Anwendung ein Datenpaket bestimmt ist.

=== UDP: Client

```cs
string host = "eee-00123.simple.eee.intern";
int port = 1234;
string msg = "Nachricht...";
```

```cs
UdpClient udpClient = new UdpClient(host, port);
byte[] data = Encoding.ASCII.GetBytes(msg);
udpClient.Send(data, data.Length);
```

```cs
IPEndPoint remote = new IPEndPoint(IPAddress.Any, 0);
byte[] dataReceived = udpClient.Receive(ref remote);
string rec = Encoding.ASCII.GetString(dataReceived);
Console.WriteLine("Received: " + rec + " from " + remote);
```

=== UDP: Server

```cs
int port = 1234;
IPEndPoint iPEndPoint = new IPEndPoint(IPAddress.Any, port);
UdpClient udpServer = new UdpClient(iPEndPoint);
IPEndPoint sender = new IPEndPoint(IPAddress.Any, 0);
```

```cs
Console.WriteLine($"Waiting for UDP-Packets from {iPEndPoint}");
while (true) {
  byte[] data = udpServer.Receive(ref sender);
  string s = Encoding.ASCII.GetString(data);
  Console.WriteLine("Server received: " + s);
  Thread.Sleep(1000);
  udpServer.Send(data, data.Length, sender);
}
```

=== TCP Protokoll
#v(-2em)
#h(1fr)#small[Transmission Control Protocol]
#v(0.1em)

Datagram ist ähnlich wie bei UDP.

*IP* sorgt dafür, dass die Pakete von Knoten zu Knoten gelangen; *TCP* behandelt den Inhalt der Pakete und korrigiert dies (durch erneutes Senden)

TCP kann als End-to-End Verbindung in Vollduplex betrachtet werden $arrow$ Möglich mit separierten Sende- & Empfangs-Counter.

#image("tcp_header.png", width: 90%)

Wichtige Merkmale:

/ Verbindungsorientiert: Vor Datenübertragung, wird eine Verbindung aufgebaut (Threeway Handshake)

/ Zuverlässige Datenübertragung: Sicherstellung, dass alle gesendeten Daten korrekt beim Empfänger ankommen (Sequenz-Counter, ACK, Fehlerkorrektur [z.B. Prüfsummen])

/ Segmentierung und Reassemblierung: Grosse Datenmengen werden in kleinere Segmente (65535 bytes [64KB]) aufgeteilt und entsprechend beim Empfänger wieder zusammengesetzt.

/ Flow Control: damit Sender den Empfänger nicht mit mehr Daten überfordert.

/ Congestion Control: Dynamische Datenübertragungsrate anhand Netzwerkauslastung

#image("tcp_ports.png", width: 90%)

Verbindungsaufbau wird via _Three-Way_ Handshake gemacht (folgendes Bild rechts). Der Abbau mit einem _Four-Way_ Handshake (folgendes Bild links).

#image("tcp_connection.png")

=== TCP: Client

```cs
TcpClient tcpClient2 = new TcpClient();
tcpClient2.Connect("hostname", 1234);
```

```cs
// Get the underlying socket:
Socket socket = tcpClient.Client;
```

```cs
// Returns the bidirectional communication stream:
NetworkStream networkstream = tcpClient.GetStream();
StreamReader sr = new StreamReader(networkstream);
StreamWriter sw = new StreamWriter(networkstream);
string s = sr.ReadLine();
```

```cs
tcpClient.Close();
```


=== TCP: Server

```cs
TcpListener listen = new TcpListener(5555);
listen.Start();
while (true) {
  Console.WriteLine("Warte auf Verbindung auf Port " +
                    listen.LocalEndpoint + "...");
  TcpClient client = listen.AcceptTcpClient();
  Console.WriteLine("Verbindung zu " +
                    client.Client.RemoteEndPoint);
  StreamWriter sw = new StreamWriter(client.GetStream());
  sw.Write(DateTime.Now.ToString());
  sw.Flush();
  client.Close();
}
```



== Interfaces

```cs
interface ISampleInterface {
    void SampleMethod();
}
```

```cs
class ImplementationClass : ISampleInterface {
  // Explicit interface member implementation:
  void ISampleInterface.SampleMethod() {
    // Method implementation.
  }
  static void Main() {
    // Declare an interface instance.
    ISampleInterface obj = new ImplementationClass();
    // Call the member.
    obj.SampleMethod();
  }
}
```

== Andere Sachen

=== Labels im Takt ändern (z.B. Datum + Zeit Anzeige)

```cs
timer = new DispatcherTimer();
timer.Interval = TimeSpan.FromMilliseconds(250);
timer.Tick += Timer_Tick;
timer.Start();
```

```cs
private void Timer_Tick(object sender, EventArgs e) {
    Time = DateTime.Now.ToString("HH:mm:ss");
}
```

=== MVVM Binding Data

Im Main-View wird das ViewModel als _DataContext_ mit dem View verknüpft

```xml
<View:MoveUserControl DataContext="{Binding MovementViewModel}" ... />
```

#small(callout(title: "Benamslig vom ViewModel-Objekt")[
  Im Main-View gibt man an, welches Model genommen wird. Es können z.B. verschiedene Views das gleiche ViewModel verwende.n
])
\

Im _View_ wird eine Eigenschaft mit einem _Property_ verbunden:

```xml
<Line Visibility="{Binding ArrowVisibility}" ...>
```

Im _ViewModel_ werden die Properties des entsprechenden Typs definiert: 

```cs
public Visibility ArrowVisibility {
    get { return arrowVisibility; }
    set { SetField(ref arrowVisibility, value); }
}
```

Es können auch _Commands_ (Interaktion im View, z.B. Button-Klicks) abgefangen und verarbeitet werden. Im ViewModel mit einem Button:

```cs
<Button Content="Beep" Command="{Binding Beep}" .../> 
```

Im ViewModel wird eine Command Properties

```cs
// somewhere inside class
public Command Beep { get; }
```

```cs
// in constructor
Beep = new Command(execute => DoBeep(), // or 'execute => { ... }'
  param => frequencyHz > 0 && timeMs > 0);
```

```cs
// somewhere inside class
public void DoBeep() {
    BuzzerModel.Beep(FrequencyHz, TimeMs);
}
```

#colbreak()

= MVVM

#align(center)[
  #fletcher.diagram(
    spacing: (10mm, 7mm),
    node-corner-radius: 3pt,
    node-outset: 2mm,
    label-size: 8pt,

    node(
      (0, 0),
      [View(s)],
      fill: green.lighten(80%),
      stroke: green.mix((black, 30%)),
      height: 4em,
      width: 4em,
      inset: 0pt,
    ),
    node(
      (2, 0),
      [View\ Model],
      fill: red.lighten(80%),
      stroke: red.mix((black, 30%)),
      height: 4em,
      width: 4em,
      inset: 0pt,
    ),
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
#v(-0.8em)
#h(1fr)#small[_What to display, Flow of interaction_]

Ist das User Interface des Programmes und ist via `Binding` und `Command` and das ViewModel gebunden.

== View Model
#v(-0.8em)
#h(1fr)#small[_Business Logic, Data Objects_]

Bildet den Zustand der View(s) ab. Es können verschieden Views mit dem selben ViewModel verbunden werden.

== Model
#v(-0.8em)
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


#image("esp32_blockdiagramm.png", height: 74%)

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

#image("esp32_startup.png", width: 80%)

=== ESP app_main()

- `app_main()` wird von einem Task gerufen $arrow$ Task hat tiefste Priorität `0` (`tskIDLE_PRIORITY`)
- *FreeRTOS*: Preemptive, Highest Priority Task läuft
- `printf` wird auf Konsole (UART) umgeleitet

== OpenOCD
#v(-1.1em)
#h(1fr)#small[Open On-Chip Debugging]
#v(-0.3em)

Ein *GDB-Server* für Debugging, In-System Programming und _boundry-scan_ testing für Mikrocontroller-Systeme. Was eigentlich zwischen GBD und Mikrocontroller eingesetzt wird.

(ESP-IDF hat eine eigene modifizierte Version)

=== GBD Client-Server Architektur
#v(-2em)
#h(1fr)#small[GNU Debugger]
#v(0.1em)


#image("gbd_architecture.png")

- IDE $<=>$ GDB MI Protokoll $<=>$ GDB
- IDE verbindet sich via GDB-Client zum GDB-Server (z.B. OpenOCD, Jlink GDB Server)
- Server übersetzt Befehle in *Debug* Signale (JTAG, SWD)

=== JTAG
#v(-2em)
#h(1fr)#small[Joint Test Action Group]
#v(0.1em)

- Shift Register Protokoll, für Design-Verifikation und Testen von Halbleitern.
- Daisy-Chain möglich!

#image("jtag_pins.png")

$=>$ *cJTAG* Variante mit weniger Pins: _TMS_ $->$ _TMSC_, #strike[TDI]

\

== CMake

Löst das Problem der Abhängigkeit von Host & Toolchain von `make` $->$ `cmake` ist ein *Generator*, welches dann mit `make` oder `ninja` weiterverarbeitet wird.

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

#v(2mm)
#align(center)[#box(
    stroke: (dash: (5pt, 3pt), paint: color_caution),
    fill: color.lighten(color_caution, 80%),
    inset: 5pt,
    radius: 5pt,
  )[#text(1.2em)[#quote[_Commit Early, commit often_]]]]
#v(3mm)

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

= ESP32

== WiFi
#v(-0.8em)
#h(1fr)#small[Erich Styper Implementation]

[`initialise_wifi`]:
- FreeRTOS Event Group erstellt für Connections/Disconnections/etc. verwendet
  ```c
  s_wifi_event_group = xEventGroupCreate();
  esp_netif_init();
  esp_event_loop_create_default();
  APP_WiFi_NetIf = esp_netif_create_default_wifi_sta();
  ```
- WiFi Konfiguration basierend auf MAC holen
  ```c
  config = ESP32_GetDeviceConfig();
  esp_netif_set_hostname(APP_WiFi_NetIf, config->hostName);
  ```
- Standard WiFi Konfiguration initialisieren
  ```c
  config = ESP32_GetDeviceConfig();
  esp_netif_set_hostname(APP_WiFi_NetIf, config->hostName);
  ```
- Event Handler registrieren
  - Callback, wo Event Group bits gesetzt werden
  ```c
  esp_event_handler_register(WIFI_EVENT,
      ESP_EVENT_ANY_ID, &event_handler, NULL);
  esp_event_handler_register(IP_EVENT,
      IP_EVENT_STA_GOT_IP, &event_handler, NULL);
  ```

$=>$ Falls eine Verbindung nicht geht, wird die alternative Verbindung (z.B. Home-WiFi) genommen.

== UDP
#v(-0.8em)
#h(1fr)#small[User Data Protocol]

- UDP-Datagramm:\ #box(stroke: gray, radius: 5pt, inset: 5pt)[#text(font: "Roboto Mono")[SrcPort#sub[16b] + DstPort#sub[16b] + Length#sub[16b] + CRC#sub[16b] + Data]]
- IP-Datagramm:\ #box(stroke: gray, radius: 5pt, inset: 5pt)[#text(font: "Roboto Mono")[IP-Header#sub[96b (IPv4)] + UDP-Datagramm]]
- IPv4 Header:\ #box(stroke: gray, radius: 5pt, inset: 5pt)[#text(font: "Roboto Mono")[SrcIP#sub[32b] + DstIP#sub[32b] + 0#sub[8b] + P-ID#sub[8b] + Length#sub[16b]]]

#align(center)[#box(
    stroke: color_caution,
    radius: 5pt,
    inset: 5pt,
  )[UDP hat einen kleineren Header als TCP (8-Byte vs 20 Byte)!]]

#image("udp_server_startup.png", width: 70%)

== (Espressif) FreeRTOS SMP
#v(-0.8em)
#h(1fr)#small[Symmetric Multiprocessing]

- *RTOS*: Skalierbarkeit, Erweiterbarkeit, #highlight[Synchronisation]

- SMP wurde von Espressif entwickelt (gleiche MIT Lizenz)
  - Dual-Core Tensilica, gemeinsamer Speicher
  - `CPU0` $arrow$ `PRO_CPU` Protocol
  - `CPU1` $arrow$ `APP_CPU` Application (`app_main()`)
- Tasks können an spezifischen Task gepinnt werden

=== Prioritäten

#image("freertos_priorities.png")

- 0 (`tskIDLE_PRIORITY`) ist tiefste Dringlichkeit (FreeRTOS: Val$arrow.t$Prio$arrow.t$, ARM: V$arrow.t$P$arrow.b$)
- Es läuft "ready" Task mit höchster Prio
- preemptive: Scheduler unterbricht Tasks

=== SMP Round Robin (RR) Scheduling

- Standard FreeRTOS: _RR_ für Tasks gleicher Prio

#image("freertos_roundrobin_scheduling.png")

- #highlight[FreeRTOS SMP: _Best-Effort RR_]
  - Scheduler auf *jedem* Core! $->$ behandelt nur eigene Tasks, tick interrupt *NICHT* synchronisiert
  - *Gemeinsame* Task Liste

#image("freertos_smp_roundrobin_scheduling_p1.png")

- #highlight[Core-Scheduler überspringt Tasks gleicher Prioritäten des anderen Cores!]

#image("freertos_smp_roundrobin_scheduling_p2.png")

=== Tasks

Erstellen eines Tasks ist ähnlich wie beim Standard-FreeRTOS, ausser die Zuweisung auf einen Core (wird mit wrapper umgangen!)

```c
// Standard & Wrapper
BaseType_t xTaskCreate(
  TaskFunction_t pvTaskCode, const char *const pcName,
  const uint32_t usStackSize, void *const pvParam,
  UBaseType_t uxPrio, TaskHandle_t *const pvTaskHndl);
// SMP
xTaskCreatePinnedToCore(
  ...,
  tskNO_AFFINITY)
```

`0`: auf `PRO_CPU` ; `1`: auf `APP_CPU` ; `tskNO_AFFINITY`: auf beiden

= RNet

#grid(columns: (0.8fr, 1fr), column-gutter: 2mm)[
  #image("rnet_layers.png")

][
  #small[

    #v(3mm)*APP*: SendMessage(0x12,"hello")
    #v(5pt)*NWK*: resend(msg), route(msg,dst), connect(addr, port), etc.
    #v(3pt)*MAC*: SelectChannel(6), ScanChannels(all)
    #v(3pt)*PYH*: GetLQI(), SetRxMode(), SetTxMode(), SPITransmit(buf)
  ]
]

== nRF24L01+

#columns(2)[

  - Nordic nRF24L01+
  - Pins: SPI, CE, CSN, IRQ
  - 2.4 GHz ISM
  - 250 kbps, 1 Mbps, 2 Mbps
  - Enhanced ShockBurst: auto ACK & retry
  - Payload: max 32 Bytes
  - 6 data pipe MulitCeiver

  Receive Data Pipes: Empfangs-"Kanäle" $==>$
  #colbreak()

  #image("nrf_datapipes.png")
]

== Übliche WSN Anwendung und Stack

#image("nrf_typical_app.png", width: 95%)

== RNet Stack Anwendung

#image("rnet_stack_app.png", width: 95%)

== Payload Packaging

#image("nrf_payload_packaging.png", width: 95%)

== Radio States & Processing

#image("radio_states.png")


#image("radio_processing.png", width: 80%)

Der Radio-Stack behandlet die Payloads via Queues (mit einem Task)! Senden wird direkt in die Queue geschrieben via Wrapper Funktion. Lesen wird über ein `OnPackt`-Event ausgelöst.

#callout(title: "Copy-Less Stack Operation")[
  Pakete werden durch den Stack gereicht, damit nicht alles kopiert werden muss! Am Schluss werden Dateien hinzugefügt.

  #small[#highlight[Beispiel]: *MAC* & *PHY* sind inhaltlich gleich, nur die Betrachtung anders]
  #v(-7pt)
  #image("radio_copyless_framing.png")
]


= Verteile Architekturen

== Art der Verbindung

/ Tightly Couples: (PC, ESP, Roboter)
- Hoch integriert, eng verbunden
- Erscheint 'aus einem Guss'
- 'Share everything'
- Ressourcen-basiert, Distributed Shared Memory (DSM)

/ Loosely Coupled: Verbindung zwischen PC, ESP, Roboter
- Client-Server, Master-Slave
- Peer-to-Peer
- 'Share nothing', meldungsbasiert
- Programmier-Schnittstellen
  - Verteilte Objekte
  - Web Services

=== Tightly Coupled: Distributed Shared Memory

- Verteilter Speicher, virtuell als Ganzes gesehen
- Kein Versenden von Meldungen, Teile durch Netzwerk/Bus verbunden
- Anwendung: _Multicore_
- Kritisch: Bandwidth, Latency, Delays, Concurrency, Coherency

#image("distributed_shared_memory.png")

== Loose Coupled: Stilarten

- Schichtenmodell
- Dienst-Schichten
- Objektorientiert
- Event-basiert
- Daten-zentriert
- Client-Server

#columns(2, gutter: 3mm)[
  === Schichtenmodell
  #v(-1.9em)
  #h(1fr)#small[asynchron]
  #v(0.1em)

  #image("modell_layers.png")

  Anfragen gehen \'#imageIcon("arrow-narrow-down.svg")\' \
  Antworten nach \'#imageIcon("arrow-narrow-up.svg")\'

  === Dienst-Schichten
  #v(-1.9em)
  #h(1fr)#small[synchron]
  #v(0.1em)

  #image("modell_application_layer.png", width: 50%)

  Schichtung der Hardware und Software.

  === Objektorientiert

  #image("modell_objectoriented.png")

  Objekte (Knoten) als Info-Quellen und -Senken.

  === Events

  #image("modell_events.png", width: 80%)

  Gemeinsamer Bus. Publish-Subscribe Modell. Oft mit objektorientiertem Ansatz kombiniert

  === Shared Data Space
  #small[z.B. Dropbox, VCS]

  #image("modell_shareddataspace.png", width: 80%)

  Variante eines Event-Systems $->$ typisch Subscriber-Publisher!

  Daten persistent gespeichert.

  === Client-Server

  #image("modell_clientserver.png", width: 80%)

  #small[

    - *Server*: passiv \
      - *Stateless*: behält keine Infos
      - *Stateful*: merkt sich Infos (zwischen Anfragen)
    - *Client*: aktiv, Leader

    #octicon("x-circle", color: color_redish): nicht gut skalierbar, _single point of failure_
  ]

  === Mehrfach-Server

  #image("modell_multipleservers.png")

  #small[
    - Mehrere Server (virtuell 1 Service)
    - Server untereinander verbunden
    #octicon("check-circle", color: color_green) redundanz, skalierbar\
    #octicon("alert", color: color_caution) Server Synchronisation
  ]

  === Proxy

  #image("modell_proxy.png")

  #small[
    - Zugriffskontroller
    - Caching
  ]

  === Mobiler Client

  #image("modell_mobileclient.png")

  #small[
    - Mobiler Code/Applet
    - Übertragung/Transfer Applet
    - Verteilung von Server Code und/oder Daten
    - Reduktion Netzbelastung
  ]

  === Thin Client

  #image("modell_thinclient.png")

  #small[
    - Verlagerung rechenintensiver Arbeit auf den Server
    - Verwendung schwache Clients
    - Balance Rechenleistung vs. übertragender Datenmenge
  ]

  === Peer-to-Peer

  #image("modell_p2p.png")

  #small[
    - 'Shareable Objects'
    - Symmetrisch, allehaben die gleichen Rechte, echt verteilt
    - Braucht Daten/Discovery-Management
    - Ausfallsicherheit durch Redundanz
  ]

  === Environment

  #image("modell_environment.png", width: 60%)

  #small[
    - Design Beeinflusst durch Umgebung
    - Hierarchien
    - Kommunikationswege
    - Latenzen

    Beispiel für _country_-server: Games Multiplayer Server
  ]
]

== SystemView

#image("systemview.png")

Es kann SystemView für ESP32 angewendet werden, einfach nicht realtime. Es wird geloggt via die JTAG Schnittstelle (UART um genau zu sein). Wenn _HW Up Buffer_ voll ist (durch zu langsames transferieren), muss dieser geleert werden $->$ in SystemView gibt es einen auffälligen Unterbruch.

/* -------------------------------------------------------------------------- */
/*                                 Styger Teil                                */
/* -------------------------------------------------------------------------- */

= FreeRTOS Crash Kurs

== Task (Threads)

```c
BaseType_t res;
TaskHandle_t taskHndl;
res = xTaskCreate (BlinkyTask , /* function */
  "Blinky", /* Kernel awareness name */
  500/ sizeof( StackType_t ), /* stack size */
  (void *)NULL , /* task parameter */
  tskIDLE_PRIORITY +1, /* priority */
  &taskHndl /* handle */
);

if (res != pdPASS) {
  /* error handling here */
}
```

```c
static void MyTask(void *params) {
  (void)params; 1
  for (;;) {
    /* do the work here ... */
  } /* for */
  /* never return */
}
```

#[
  #set image(width: 80%)

  == InterProcess Communication (IPC)

  === Critical Sections, Reentrancy

  #image("reentrancy.png")

  === Semaphore/Mutex
  #v(-1.9em)
  #h(1fr)#small[$N$ Producer (#b[T]ask #b[I]nterrupt) $->$ $N$ Consumer (TI)]
  #v(0.1em)

  #image("semaphore_mutex.png")

  ```c
  SemaphoreHandle_t IPC_Semaphore;
  BaseType_t res;
  IPC_Semaphore = xSemaphoreCreateBinary();  // NULL on fail

  res = xSemaphoreGive(IPC_Semaphore);
  if (res!=pdTRUE) {/* failed give */}

  res = xSemaphoreTake(IPC_Semaphore, pdMS_TO_TICKS(50));
  if (res == pdTRUE) {/* received */}
  ```

  === Event Bits
  #v(-1.9em)
  #h(1fr)#small[$N$ Producer (TI) $->$ $N$ Consumer (TI)]
  #v(0.1em)

  #image("eventsbits.png")

  ```c
  EventGroupHandle_t IPC_EventBits;
  IPC_EventBits = xEventGroupCreate(); // NULL on fail

  uxBits = xEventGroupSetBits(IPC_EventBits, value);
  uxBits = xEventGroupWaitBits(
    IPC_EventBits,
    /* the bits within the event group to wait for. */
    0x02 | 0x03,
    pdTRUE, /* both should be cleared before returning. */
    pdFALSE, /* don’t wait for both bits, either bit will do. */
    pdMS_TO_TICKS(100) /* timeout */
  );
  ```
  #colbreak()

  === Message Queues
  #v(-1.9em)
  #h(1fr)#small[$N$ Producer (TI) $->$ $N$ Consumer (TI)]
  #v(0.1em)

  #v(1.3cm)

  ```c
  QueueHandle_t IPC_Queue;
  IPC_Queue = xQueueCreate(<count>, sizeof(<type>)); // NULL on fail
  xQueueSendToBack(IPC_Queue, <obj>, <timeout>); // pdTRUE
  xQueueReceive(IPC_Queue, <*dest>, <timeout>); // pdTRUE on read
  // errQUEUE_EMPTY if empty
  ```



  === Direct Task Notification
  #v(-1.9em)
  #h(1fr)#small[$N$ Producer (TI) $->$ $1$ Consumer (T)]
  #v(0.1em)

  #v(1.3cm)

  ```c
  TaskHandle_t taskHandle;
  xTaskNotify(taskHandle, <value>, <event>);
  // <event>: eNoAction, eSetBits, eIncrement,
  //   eSetValueWithOverwrite, eSetValueWithoutOverwrite
  res = xTaskNotifyWait(<clear-on-entry>, <clear-on-exit>, <*dest>,
    <timeout>);
  ```

  === Stream Buffer
  #v(-1.9em)
  #h(1fr)#small[$1$ Producer (TI) $->$ $1$ Consumer (TI)]
  #v(0.1em)
  #image("stream_buffer.png", width: 100%)

  #small[Bytes werden einfach in einen Art FIFO-Buffer reingelegt. Da es sich um einen Stream handelt, kann z.B. die Länge einer Nachricht und somit die Nachricht selbst nicht identifiziert werden (dafür gibts Message buffers)]

  ```c
  StreamBufferHandle_t stream;
  stream = xStreamBufferCreate(<buffer-size>, <minimum-for-event);
  xStreamBufferSend(stream, <src>, <size-src>, <timeout>);
  uint8_t buf[16];
  size_t size = xStreamBufferReceive(stream, buf, sizeof(buf),
    portMAX_DELAY);
  if (size!=0) {
    ...
  }
  ```

  === Message Buffer
  #v(-1.9em)
  #h(1fr)#small[$1$ Producer (TI) $->$ $1$ Consumer (TI)]
  #v(0.1em)

  #image("message_buffer.png", width: 100%)

  #small[Sind zwar Stream Buffers, aber können diskrete Nachrichten beinhalten, bzw. die Länge der Nachrichten wird gemerkt $->$ Vor Nachricht werden die Anzahl Bytes angegeben. Diese Information wird standardmässig als `size_t` angegeben (ist aber konfigurierbar via #raw(lang: "c", "#define")).]

  ```c
  MessageBufferHandle_t xMessageBuffer;
  xMessageBuffer = xMessageBufferCreate(<bytes>);
  xBytesSent = xMessageBufferSend(xMessageBuffer,
    (void*) src,
    sizeof(src),
    <timeout>);
  if (xBytesSent>0) {...}

  xReceivedBytes = xMessageBufferReceive(xMessageBuffer,
    (void*)dst,
    sizeof(src),
    <timeout>);
  if (xReceivedBytes>0) {...}
  ```

]

= CI/CD
#v(-1.1em)
#h(1fr)#small[*C*\ontinuous *I*\ntegration and *C*\ontinuous *D*\elivery]
#v(-0.3em)

#small[CI/CD wird für die agile Entwicklung verwendet: kurze Iterationen und schnelles Feedback.

  / CI: lokale Entwicklung + Unit-Testing:
    - "unit tests + any tests related to specific component being built in isolation from other components" [#link("https://stackoverflow.com/questions/76818090/testing-in-ci-vs-testing-in-cd",[Stackoverflow])]

  / CD: Automatische Auslieferung zur Produktion(ähnlicher Umgebung)
    - "integration testing, where software stack is deployed to some non-prod environment and being tested there." (automatisch oder manuell) [#link("https://stackoverflow.com/questions/76818090/testing-in-ci-vs-testing-in-cd",[Stackoverflow])]

  #callout(title: "Prediktive vs. Agile Planung", icon: "info")[
    / Prediktiv: Jährliche 'heldenhafte' Anstrengungen für einen grossen und komplexen Release
    / Agil: regelmässiger Abgleich mit Kunden $->$ schneller ans Endziel kommen
  ]
]

#colbreak()

#block(height: 100%)[
  == Generelle Pipeline

  #align(horizon + center)[
    #image("cicd_gitlab.png", height: 90%)
    #box(
      stroke: red + 1.5pt,
      inset: (x: 5pt, y: 6pt),
      radius: 10pt,
      text(1.3em)[*Protect the main branch at all costs!*],
    )
  ]
]


=== Wichtig

#[
  #set par(leading: 0.8em)
  - Main Branch Pulls sind sauber
    - solange gute Tests verwendet werden
  - Main Branch bleibt geschützt
    - aus diesem Branch wird die Production-Version deployed
  - Änderungen können schneller integriert werden
  - Commits und Main werden mit Checks regelmässig geprüft
  - Änderungen sollten klein gehalten werden
    - reduziert Risko und Debug-Komplexität
]

=== Continuous Deployment

- *Automatisierung* der Auslieferung zur Produktion oder ähnlichen Umgebungen
- Auslieferung von `main` oder `release` branch
- Nicht jede Änderung wird ausgeliefert, aber könnte $->$ *continuous delivery*
- Für Auslieferung können zusätzliche Tests ausgeführt werden: Automatisierte Acceptance Tests, Load Testing, Compliance Review

== Werkzeuge

#image("ci_cd_flow.png", width: 100%)



#image("cicd_pipeline.png")

== DevOps

#image("Devops-toolchain.svg", width: 80%)

Eine DevOps-Toolchain ist ein Set oder eine Kombination von Tools, die bei der Bereitstellung, Entwicklung und Verwaltung von Softwareanwendungen während des gesamten Lebenszyklus der Systementwicklung helfen, wie sie von einer Organisation koordiniert werden, die DevOps-Praktiken anwendet.

== GitLab CI/CD Pipeline

#image("gitlab_pipeline.png", width: 80%)

1. Aufsetzen der Runner auf dem Host
2. Push löst einen Trigger aus
3. Jobs wird geschedulet
4. Jobs werden auf Runnder verteilt
5. Runner melden Resultate


=== Aufsetzen

Im Root des Repos eine Datei mit Namen `.gitlab-ci.yml` erstellen.

#colbreak()

=== Stages, Variables & Jobs

Die CI/CD-Datei ist in drei Hauptteilen aufgeteilt: Stages, Variablen und Jobs. Folgend ist ein Beispiel für eine solche Datei.

1. Zuerst werden die Stages und (Umgebungs) Variablen definiert. 

```yaml
stages:
  - build
  - test
  - deploy
variables: # global variables (for local, define inside jobs)
  # example: docker image names
  - IMAGE_NAME_NXP: "erichstyger/cicd_nxp-image:latest"
  - IMAGE_NAME_ESP: "espressif/idf:release-v5.3"
```

2. Danach werden Jobs definiert, welche irgendeine Aufgabe machen.

```yaml
build-esp-remote:
  stage: build # job type
  when: manual # needs to be started manually
  image: # which docker image is used
    name: $IMAGE_NAME_ESP
    entrypoint: [""]
  script: # executed when container is ready
    - cd projects/vscode/esp_remote/
    - source /opt/esp/idf/export.sh
    - idf.py build
  artifacts: # which files & folders to keep
    when: always
    paths:
    - projects/esp_remote/build/esp_remote.bin
    - projects/esp_remote/build/esp_remote.elf
build-robot:
  stage: build
  when: on_success # if previous stages succeded
  image: 
    name: $IMAGE_NAME_NXP
    entrypoint: [""]
  script:
    - cd projects/robot/
    - cmake --preset debug
    - cmake --build --preset app-debug
    - cmake --preset release
    - cmake --build --preset app-release
  artifacts:
    when: always
    paths:
    - projects/robot/build/Release/robot.elf
    - projects/robot/build/Release/robot.s19
    - projects/robot/build/Release/robot.hex
```

- Bei mehreren Stages, welche voneinander abhängen, werden die _Job Artifacts_ in den neuen Job kopiert.

=== Ausführung von Jobs & Stages überspringen

```yml
when: manual        # .gitlab-ci.yml
[ci skip]           # commit message
git push -o ci.skip # command line
```

