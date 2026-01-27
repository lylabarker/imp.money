# Cara ROI Berfungsi

IMP Money menjana hasil melalui penyediaan kecairan automatik. Berikut penjelasan teknikalnya.

## Sumber Hasil

Pulangan anda datang daripada **yuran dagangan PancakeSwap V3**, bukan daripada deposit baru.

```
Volume Dagangan → Yuran LP → IMP Vault → ROI Harian Anda
```

### PancakeSwap V3 CLMM

IMP menggunakan **Concentrated Liquidity Market Making (CLMM)**:

- Modal digunakan dalam pasangan USDT/USDC
- Julat harga sempit (stablecoin berdagang hampir 1:1)
- Kecekapan modal lebih tinggi daripada AMM tradisional
- Yuran dagangan dari setiap swap dalam julat

## Mengapa 0.7% Harian?

### Matematik

- Pool USDT/USDC menjana ~50-100% APY yuran
- Posisi tertumpu boleh mencapai 100-500% APY
- 0.7% harian = 255% APY (kompaun)
- Selepas yuran protokol, 0.7% mampan

### Buffer Konservatif

Protokol mengekalkan rizab untuk memastikan pengeluaran semasa tempoh volume rendah. 0.7% anda direka untuk konsisten tanpa mengira keadaan pasaran.

## Pengiraan ROI

Pendapatan anda dikira mudah:

```
Pendapatan Harian = Jumlah Deposit × 0.7%
```

### Contoh

| Deposit | Harian | Mingguan | Bulanan |
|---------|--------|----------|---------|
| $100 | $0.70 | $4.90 | $21.00 |
| $1,000 | $7.00 | $49.00 | $210.00 |
| $10,000 | $70.00 | $490.00 | $2,100.00 |

## Bila ROI Bermula?

Pendapatan anda bermula serta-merta selepas transaksi deposit disahkan:

- Blok N: Anda deposit $1,000
- Blok N+1: Mula menjana
- Selepas 24 jam: ~$7.00 boleh dituntut

## Kesan Kompaun

Jika anda laburkan semula pendapatan setiap kitaran 21 hari:

| Mula | Selepas 6 Bulan | Selepas 1 Tahun |
|------|-----------------|-----------------|
| $1,000 | $2,653 | $9,450 |
| $5,000 | $13,265 | $47,250 |
| $10,000 | $26,530 | $94,500 |

*Andaikan pelaburan semula penuh tanpa pengeluaran*

---

Ketahui lebih lanjut: [PancakeSwap V3 CLMM](pancakeswap-clmm.md)
