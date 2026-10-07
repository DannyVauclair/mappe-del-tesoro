# Wildlands — Mappe del Tesoro

Mappa interattiva per RedM / Wildlands costruita sulle tre route fornite.

## Funzioni

- Route **Blu**, **Gialla** e **Rossa**
- **84 marker** numerati nell'ordine da seguire
- zoom e trascinamento della mappa
- filtro per singola route o tutte insieme
- pulsante **Prossimo punto**
- possibilità di segnare un punto come trovato
- **Nascondi i punti trovati**
- avanzamento salvato nel browser tramite `localStorage`
- layout responsive per desktop e mobile

## Mappa base

La base è la versione pulita fornita per il progetto, allineata alle tre reference dei tesori.

Per rendere il caricamento più leggero sul web, la mappa viene servita come WebP ottimizzato e ricostruita nel browser dai file:

`map-data/part-01.js` … `map-data/part-11.js`

Dimensioni cartografiche: **2048 × 1590 px**.

## Route

- **Blu:** 33 punti visibili nella reference (manca il n. 27)
- **Gialla:** 27 punti
- **Rossa:** 24 punti visibili nella reference (manca il n. 5)

Le posizioni mancanti non sono state inventate.

## Pubblicazione

Il workflow in `.github/workflows/pages.yml` pubblica automaticamente il sito su GitHub Pages a ogni push su `main`.
