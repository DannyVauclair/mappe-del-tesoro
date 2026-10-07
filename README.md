# Wildlands — Mappe del Tesoro

Mappa interattiva per RedM / Wildlands costruita sulle tre route fornite.

## Funzioni

- Route **Blu**, **Gialla** e **Rossa**
- **84 marker** numerati nell'ordine da seguire
- zoom e trascinamento della mappa
- filtro per singola route o tutte insieme
- pulsante **Prossimo da controllare**
- tre stati per ogni punto:
  - **Da controllare**
  - **Nessun tesoro** (×)
  - **Tesoro spawnato** (★)
- filtro per nascondere i punti già controllati e vuoti
- conteggi per route: da controllare / vuoti / spawnati
- layout responsive per desktop e mobile

## Sessione personale

In modalità **Personale** gli stati sono salvati nel browser tramite `localStorage`.
Non vengono condivisi con altri giocatori.

## Sessione gruppo

La UI per la modalità **Gruppo** è già integrata.

Quando Supabase è configurato:
- tutti i giocatori che inseriscono lo stesso codice gruppo condividono gli stati;
- un aggiornamento viene propagato in tempo quasi reale e viene comunque riallineato automaticamente ogni 3 secondi;
- il popup mostra chi ha aggiornato il punto e l'orario;
- **Inizia un nuovo giro per tutti** resetta la sessione condivisa;
- il codice gruppo viene trasformato in hash nel database e la tabella non è accessibile direttamente dal browser.

File backend:
- `supabase/schema.sql` — tabella e funzioni RPC
- `sync-config.js` — URL Supabase e chiave anon/publishable pubblica del progetto

Non inserire mai una service-role key nel repository.

## Mappa base

La base è la versione pulita fornita per il progetto, allineata alle tre reference dei tesori.

Dimensioni cartografiche: **2048 × 1590 px**.

## Route

- **Blu:** 33 punti visibili nella reference (manca il n. 27)
- **Gialla:** 27 punti
- **Rossa:** 24 punti visibili nella reference (manca il n. 5)

Le posizioni mancanti non sono state inventate.

## Pubblicazione

Il workflow in `.github/workflows/pages.yml` pubblica automaticamente il sito su GitHub Pages a ogni push su `main`.
