# Cara Kerja ROI

IMP Money menghasilkan yield melalui penyediaan likuiditas otomatis. Berikut penjelasan teknisnya.

## Sumber Yield

Return Anda berasal dari **fee trading PancakeSwap V3**, bukan dari deposit baru.

```
Volume Trading → Fee LP → IMP Vault → ROI Harian Anda
```

### PancakeSwap V3 CLMM

IMP menggunakan **Concentrated Liquidity Market Making (CLMM)**:

- Modal ditempatkan di pasangan USDT/USDC
- Rentang harga sempit (stablecoin trading dekat 1:1)
- Efisiensi modal jauh lebih tinggi dari AMM tradisional
- Fee trading dari setiap swap dalam rentang

## Mengapa 0,7% Harian?

### Matematikanya

- Pool USDT/USDC menghasilkan ~50-100% APY fee
- Posisi terkonsentrasi bisa mencapai 100-500% APY
- 0,7% harian = 255% APY (compound)
- Setelah fee protokol, 0,7% berkelanjutan

### Buffer Konservatif

Protokol menjaga cadangan untuk memastikan penarikan selama periode volume rendah. 0,7% Anda dirancang konsisten terlepas kondisi pasar.

## Perhitungan ROI

Penghasilan Anda dihitung sederhana:

```
Penghasilan Harian = Jumlah Deposit × 0,7%
```

### Contoh

| Deposit | Harian | Mingguan | Bulanan |
|---------|--------|----------|---------|
| $100 | $0,70 | $4,90 | $21,00 |
| $1.000 | $7,00 | $49,00 | $210,00 |
| $10.000 | $70,00 | $490,00 | $2.100,00 |

## Kapan ROI Dimulai?

Penghasilan Anda dimulai segera setelah transaksi deposit dikonfirmasi:

- Blok N: Anda deposit $1.000
- Blok N+1: Mulai menghasilkan
- Setelah 24 jam: ~$7,00 bisa diklaim

## Efek Compound

Jika Anda reinvestasi penghasilan setiap siklus 21 hari:

| Awal | Setelah 6 Bulan | Setelah 1 Tahun |
|------|-----------------|-----------------|
| $1.000 | $2.653 | $9.450 |
| $5.000 | $13.265 | $47.250 |
| $10.000 | $26.530 | $94.500 |

*Mengasumsikan reinvestasi penuh tanpa penarikan*

---

Pelajari lebih lanjut: [PancakeSwap V3 CLMM](pancakeswap-clmm.md)
