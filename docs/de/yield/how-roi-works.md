# Wie ROI funktioniert

IMP Money generiert Rendite durch automatisierte Liquiditätsbereitstellung. Hier ist die technische Aufschlüsselung.

## Die Quelle der Rendite

Ihre Erträge stammen aus **PancakeSwap V3 Handelsgebühren**, nicht aus neuen Einzahlungen.

```
Handelsvolumen → LP-Gebühren → IMP Vault → Ihre tägliche ROI
```

### PancakeSwap V3 CLMM

IMP verwendet **Concentrated Liquidity Market Making (CLMM)**:

- Kapital wird in USDT/USDC-Paaren eingesetzt
- Enger Preisbereich (Stablecoins handeln nahe bei 1:1)
- Viel höhere Kapitaleffizienz als traditionelle AMMs
- Handelsgebühren von jedem Swap im Bereich

## Warum 0,7% täglich?

### Die Mathematik

- USDT/USDC-Pool generiert ~50-100% APY an Gebühren
- Konzentrierte Positionen können 100-500% APY erreichen
- 0,7% täglich = 255% APY (mit Compound)
- Nach Protokollgebühren ist 0,7% nachhaltig

### Konservativer Puffer

Das Protokoll hält Reserven, um Abhebungen in Zeiten geringer Volumina zu gewährleisten. Ihre 0,7% sind so konzipiert, dass sie unabhängig von Marktbedingungen konsistent sind.

## ROI-Berechnung

Ihre Einnahmen werden einfach berechnet:

```
Tägliche Einnahmen = Eingezahlter Betrag × 0,7%
```

### Beispiele

| Einzahlung | Täglich | Wöchentlich | Monatlich |
|------------|---------|-------------|-----------|
| $100 | $0,70 | $4,90 | $21,00 |
| $1.000 | $7,00 | $49,00 | $210,00 |
| $10.000 | $70,00 | $490,00 | $2.100,00 |

## Wann beginnt die ROI?

Ihre Einnahmen beginnen sofort nachdem Ihre Einzahlungstransaktion bestätigt wird:

- Block N: Sie zahlen $1.000 ein
- Block N+1: Verdienen beginnt
- Nach 24 Stunden: ~$7,00 abrufbar

## Compound-Effekt

Wenn Sie Ihre Einnahmen jeden 21-Tage-Zyklus reinvestieren:

| Start | Nach 6 Monaten | Nach 1 Jahr |
|-------|----------------|-------------|
| $1.000 | $2.653 | $9.450 |
| $5.000 | $13.265 | $47.250 |
| $10.000 | $26.530 | $94.500 |

*Setzt vollständige Reinvestition ohne Abhebungen voraus*

---

Mehr erfahren: [PancakeSwap V3 CLMM](pancakeswap-clmm.md)
