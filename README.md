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
### start_stop
<img width="1359" height="315" alt="obrazek" src="https://github.com/user-attachments/assets/514f5596-4925-4032-8b75-552bb7e3415c" />

### time_decoder
<img width="1500" height="204" alt="obrazek" src="https://github.com/user-attachments/assets/6a332282-73ce-488a-b542-8035ddb3cb98" />

### lap_memory
<img width="1795" height="458" alt="obrazek" src="https://github.com/user-attachments/assets/3eef0236-a818-489b-bded-424167dfb48e" />

### view_mode
<img width="1502" height="386" alt="obrazek" src="https://github.com/user-attachments/assets/8d8c0d5b-eeec-40cb-ac6a-d87efe1c42c1" />

### display_driver
<img width="1779" height="329" alt="obrazek" src="https://github.com/user-attachments/assets/0ff21f1d-08c3-4232-85af-ce8d9465d21e" />

