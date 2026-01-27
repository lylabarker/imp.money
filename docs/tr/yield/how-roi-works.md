# ROI Nasıl Çalışır

IMP Money, otomatik likidite sağlama yoluyla getiri üretir. İşte teknik açıklama.

## Getiri Kaynağı

Kazançlarınız yeni yatırmalardan değil, **PancakeSwap V3 işlem ücretlerinden** gelir.

```
İşlem Hacmi → LP Ücretleri → IMP Vault → Günlük ROI'niz
```

### PancakeSwap V3 CLMM

IMP **Yoğunlaştırılmış Likidite Piyasa Yapıcılığı (CLMM)** kullanır:

- Sermaye USDT/USDC çiftlerinde kullanılır
- Dar fiyat aralığı (stablecoin'ler 1:1'e yakın işlem görür)
- Geleneksel AMM'lerden çok daha yüksek sermaye verimliliği
- Aralıktaki her swap'tan işlem ücretleri

## Neden Günlük %0,7?

### Matematik

- USDT/USDC havuzu ~%50-100 APY ücret üretir
- Yoğunlaştırılmış pozisyonlar %100-500 APY'ye ulaşabilir
- Günlük %0,7 = %255 APY (bileşik)
- Protokol ücretlerinden sonra %0,7 sürdürülebilir

### Muhafazakâr Tampon

Protokol, düşük hacim dönemlerinde çekimleri sağlamak için rezerv tutar. %0,7'niz piyasa koşullarından bağımsız olarak tutarlı olacak şekilde tasarlanmıştır.

## ROI Hesaplaması

Kazançlarınız basitçe hesaplanır:

```
Günlük Kazanç = Yatırılan Tutar × %0,7
```

### Örnekler

| Yatırma | Günlük | Haftalık | Aylık |
|---------|--------|----------|-------|
| $100 | $0,70 | $4,90 | $21,00 |
| $1.000 | $7,00 | $49,00 | $210,00 |
| $10.000 | $70,00 | $490,00 | $2.100,00 |

## ROI Ne Zaman Başlar?

Yatırma işleminiz onaylandıktan hemen sonra kazançlarınız başlar:

- Blok N: $1.000 yatırırsınız
- Blok N+1: Kazanmaya başlar
- 24 saat sonra: ~$7,00 talep edilebilir

## Bileşik Etkisi

Her 21 günlük döngüde kazançlarınızı yeniden yatırırsanız:

| Başlangıç | 6 Ay Sonra | 1 Yıl Sonra |
|-----------|------------|-------------|
| $1.000 | $2.653 | $9.450 |
| $5.000 | $13.265 | $47.250 |
| $10.000 | $26.530 | $94.500 |

*Çekim yapmadan tam yeniden yatırım varsayılır*

---

Daha fazla bilgi: [PancakeSwap V3 CLMM](pancakeswap-clmm.md)
