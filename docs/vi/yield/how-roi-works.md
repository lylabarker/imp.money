# ROI hoạt động như thế nào

IMP Money tạo ra lợi nhuận thông qua cung cấp thanh khoản tự động. Đây là giải thích kỹ thuật.

## Nguồn lợi nhuận

Lợi nhuận của bạn đến từ **phí giao dịch PancakeSwap V3**, không phải từ tiền gửi mới.

```
Khối lượng giao dịch → Phí LP → IMP Vault → ROI hàng ngày của bạn
```

### PancakeSwap V3 CLMM

IMP sử dụng **Concentrated Liquidity Market Making (CLMM)**:

- Vốn được triển khai trong cặp USDT/USDC
- Phạm vi giá hẹp (stablecoin giao dịch gần 1:1)
- Hiệu quả vốn cao hơn nhiều so với AMM truyền thống
- Phí giao dịch từ mỗi swap trong phạm vi

## Tại sao 0,7% hàng ngày?

### Toán học

- Pool USDT/USDC tạo ra ~50-100% APY phí
- Vị thế tập trung có thể đạt 100-500% APY
- 0,7% hàng ngày = 255% APY (lãi kép)
- Sau phí giao thức, 0,7% bền vững

### Bộ đệm bảo thủ

Giao thức duy trì dự trữ để đảm bảo rút tiền trong thời kỳ khối lượng thấp. 0,7% của bạn được thiết kế nhất quán bất kể điều kiện thị trường.

## Tính toán ROI

Thu nhập của bạn được tính đơn giản:

```
Thu nhập hàng ngày = Số tiền gửi × 0,7%
```

### Ví dụ

| Tiền gửi | Hàng ngày | Hàng tuần | Hàng tháng |
|----------|-----------|-----------|------------|
| $100 | $0,70 | $4,90 | $21,00 |
| $1.000 | $7,00 | $49,00 | $210,00 |
| $10.000 | $70,00 | $490,00 | $2.100,00 |

## ROI bắt đầu khi nào?

Thu nhập của bạn bắt đầu ngay sau khi giao dịch gửi tiền được xác nhận:

- Block N: Bạn gửi $1.000
- Block N+1: Bắt đầu kiếm
- Sau 24 giờ: ~$7,00 có thể nhận

## Hiệu ứng lãi kép

Nếu bạn tái đầu tư thu nhập mỗi chu kỳ 21 ngày:

| Bắt đầu | Sau 6 tháng | Sau 1 năm |
|---------|-------------|-----------|
| $1.000 | $2.653 | $9.450 |
| $5.000 | $13.265 | $47.250 |
| $10.000 | $26.530 | $94.500 |

*Giả sử tái đầu tư hoàn toàn không rút*

---

Tìm hiểu thêm: [PancakeSwap V3 CLMM](pancakeswap-clmm.md)
