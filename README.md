# Digital-Stopwatch

Cílem tohoto projektu je vytvořit návrh stopek s možností ukládání jednotlivých kol v jazyku VHDL a následně ho implementovat na vývojovou desku Nexys A7-50T.

<img width="1816" height="871" alt="obrazek" src="https://github.com/user-attachments/assets/f01cbea6-c8e2-47b7-bd67-a4eec00d938d" />


## Výstup
K zobrazení aktuálně měřeného času slouží 8 sedmisegmentových displejů. Čas je zobrazen ve formátu `MM:SS:hh` (minuty:sekundy:setiny). Systém využívá dva režimy zobrazení:

* **Režim aktuálního času** – Displej zobrazuje běžící čas.
* **Režim historie** – Aktivuje se stiskem tlačítka `Lap_scroll`. Stopky na pozadí stále běží, ale displej zobrazuje uložený čas z paměti.

## Vstupy
Pro ovládání jsou použita tlačítka:

* **Start/Stop** – Spuštění nebo zastavení stopek.
* **Reset** – Nastavení stopek do výchozího stavu. Paměti a čítače jsou vynulovány.
* **Lap_save** – Uložení aktuálního času do vnitřní paměti.
* **Lap_scroll** – Cyklické listování uloženými časy.
* **Mode** – Přepínaní mezi zobrazením aktuálního měřeného času a uloženými časy.
