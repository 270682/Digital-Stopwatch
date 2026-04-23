# Digital-Stopwatch

Cílem tohoto projektu je vytvořit návrh stopek s možností ukládání jednotlivých kol v jazyku VHDL a následně ho implementovat na vývojovou desku Nexys A7-50T.

<img width="1816" height="871" alt="obrazek" src="https://github.com/user-attachments/assets/671a6f38-2cea-49fb-a71d-96446c89e216" />

## Výstup
K zobrazení aktuálně měřeného času slouží 8 sedmisegmentových displejů. Čas je zobrazen ve formátu `MM:SS:hh` (minuty:sekundy:setiny). Systém využívá dva režimy zobrazení:

* **Režim aktuálního času** – Displej zobrazuje běžící čas.
* **Režim historie** – Aktivuje se stiskem tlačítka `Mode`. Stopky na pozadí stále běží, ale displej zobrazuje uložený čas z paměti.

## Vstupy
Pro ovládání jsou použita tlačítka:

* **Start/Stop** – Spuštění nebo zastavení stopek.
* **Reset** – Nastavení stopek do výchozího stavu. Paměti a čítače jsou vynulovány.
* **Lap_save** – Uložení aktuálního času do vnitřní paměti.
* **Lap_scroll** – Cyklické listování uloženými časy.
* **Mode** – Přepínaní mezi zobrazením aktuálního měřeného času a uloženými časy.

## Vnitřní moduly
### [start_stop](https://github.com/270682/Digital-Stopwatch/tree/main/Komponenty/start_stop)
Tento modul slouží jako řídicí hradlo s funkcí přepínače. Spravuje průchod signálu Clock Enable na na vstup čítače na základě interakce uživatele pomocí tlačítka. 
Po zapnutí nebo aktivaci resetu je modul ve výchozím stavu stop, kdy je výstup blokován. Každý impulz z tlačítka přepne vnitřní stav mezi režimy aktivním a neaktivním režimem. V aktivním stavu výstup en kopíruje vstup ce. V neaktivním stavu je výstup en vynucen na logickou 0.

<img width="1359" height="315" alt="obrazek" src="https://github.com/user-attachments/assets/514f5596-4925-4032-8b75-552bb7e3415c" />

### [time_decoder](https://github.com/270682/Digital-Stopwatch/tree/main/Komponenty/time_decoder)

Tento modul slouží jako převodník binární hodnoty času (v setinách) na zobrazitelný formát pro `display_driver`. Přijímá celkový čas v setinách sekundy a rozkládá ho na jednotlivé číslice v kódu BCD (6 číslic => 24 bitů).

<img width="1500" height="204" alt="obrazek" src="https://github.com/user-attachments/assets/6a332282-73ce-488a-b542-8035ddb3cb98" />

### [lap_memory](https://github.com/270682/Digital-Stopwatch/tree/main/Komponenty/lap_memory)

Modul slouží jako úložiště, které umožňuje uživateli zachytit a uchovat aktuální časy (kola) bez přerušení běhu hlavního čítače. Tato paměť disponuje osmi sloty o šířce 19 bitů. Vstupní impulz lap_save ukládá aktuální čas ze vstupu na pozici určenou vnitřním zapisovacím ukazatelem. Impulz lap_scroll umožňuje uživateli cyklicky listovat uloženými daty (používá se vnitřní ukazetel čtení). Při resetu dojde k úplnému vymazání paměťového pole i k vynulování obou ukazatelů.

<img width="1795" height="458" alt="obrazek" src="https://github.com/user-attachments/assets/3eef0236-a818-489b-bded-424167dfb48e" />

### [view_mode](https://github.com/270682/Digital-Stopwatch/tree/main/Komponenty/view_mode)

Tento modul funguje jako přepínač (multiplexer), který určuje zdroj dat pro zobrazení na displeji. Umožňuje uživateli volit mezi sledováním aktuálně běžícího času a prohlížením uložených časů. Ovladán je stiskem tlačítka. Při zaznamenání impulzu přepne mezi jedním nebo druhým zdrojem dat na vstupu, který zrcadlí na výstup.

<img width="1502" height="386" alt="obrazek" src="https://github.com/user-attachments/assets/8d8c0d5b-eeec-40cb-ac6a-d87efe1c42c1" />

### [display_driver](https://github.com/270682/Digital-Stopwatch/tree/main/Komponenty/display_driver)

Tento modul zajišťuje obsluhu šesti sedmisegmentových displejů. Protože jsou displeje na vývojové desce zapojeny sdíleně, tento blok se stará o rychlé přepínání jednotlivých cifer tak, aby díky setrvačnosti lidského oka působily jako svítící současně (multiplexování). Také se v něm nachází převodník, který převede kód BCD na signál zobrazitelný sedmisegmentovým displejem. Ze vstupního 24 bitového signálu jsou postupně vybírány jednotlivé 4 bitové číslice.

<img width="1779" height="329" alt="obrazek" src="https://github.com/user-attachments/assets/0ff21f1d-08c3-4232-85af-ce8d9465d21e" />

