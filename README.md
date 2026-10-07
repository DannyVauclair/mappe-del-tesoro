# Wildlands — Mappe del Tesoro

Mappa interattiva per RedM / Wildlands con route condivise, sessioni di gruppo e gestione globale dei marker.

## Funzioni

- Route **Blu**, **Gialla** e **Rossa**
- marker numerati nell'ordine da seguire
- mappa **multirisoluzione a tasselli**:
  - zoom 0: 2048 × 1590
  - zoom 1: 4096 × 3180
  - zoom 2: 8192 × 6360
  - zoom 3: 16384 × 12720
- zoom e trascinamento fluidi
- filtro per singola route o tutte insieme
- pulsante **Prossimo da controllare**
- tre stati per ogni punto:
  - **Da controllare**
  - **Nessun tesoro** (×)
  - **Tesoro spawnato** (★)
- filtro per nascondere i punti vuoti
- conteggi per route: da controllare / vuoti / spawnati
- layout responsive desktop/mobile

## Sessione personale e gruppo

In modalità **Personale** gli stati sono salvati nel browser.

In modalità **Gruppo** tutti quelli che usano lo stesso codice condividono:
- × nessun tesoro
- ★ tesoro spawnato
- autore e orario dell'ultimo aggiornamento
- reset del giro

Gli aggiornamenti vengono propagati live e riallineati periodicamente con Supabase.

## Marker globali

Titolo, descrizione, immagine, coordinate e nuovi marker sono **globali** e visibili a tutti.

La modalità **Admin** permette di:
- modificare un marker esistente;
- aggiungere un marker cliccando direttamente sulla mappa;
- cambiare titolo e descrizione;
- caricare un'immagine di riferimento;
- cambiare la posizione;
- eliminare un marker;
- ripristinare un marker originale.

Le immagini vengono compresse nel browser e caricate nel bucket pubblico Supabase `treasure-images`.
La chiave Admin non è salvata nel repository e resta solo nella sessione del browser.

## Backend

Supabase gestisce:
- stato condiviso dei gruppi;
- override globali dei marker;
- Storage delle immagini;
- Edge Function `treasure-image-upload`.

File principali:
- `supabase/schema.sql`
- `supabase/global-markers.sql`
- `supabase/functions/treasure-image-upload/index.ts`
- `sync-config.js`

## Mappa base

La sorgente cartografica è 21617 × 16785 px. Durante il deploy GitHub Pages viene trasformata in una piramide di **4264 tile WebP**, circa 14 MB complessivi, così il browser carica solo i tasselli necessari al livello di zoom corrente.

## Route iniziali

- **Blu:** 33 punti visibili nella reference (manca il n. 27)
- **Gialla:** 27 punti
- **Rossa:** 24 punti visibili nella reference (manca il n. 5)

Le posizioni mancanti non sono state inventate.

## Pubblicazione

Il workflow in `.github/workflows/pages.yml` pubblica automaticamente il sito su GitHub Pages a ogni push su `main`.
