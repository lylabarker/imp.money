# Cómo Funciona el ROI

IMP Money genera rendimiento a través de provisión de liquidez automatizada. Aquí está el desglose técnico.

## La Fuente del Rendimiento

Tus retornos provienen de **tarifas de trading de PancakeSwap V3**, no de nuevos depósitos.

```
Volumen de Trading → Tarifas LP → IMP Vault → Tu ROI Diario
```

### PancakeSwap V3 CLMM

IMP usa **Concentrated Liquidity Market Making (CLMM)**:

- Capital desplegado en pares USDT/USDC
- Rango de precio estrecho (stablecoins operan cerca de 1:1)
- Eficiencia de capital mucho mayor que AMMs tradicionales
- Tarifas de trading de cada swap en rango

## ¿Por qué 0.7% Diario?

### Las Matemáticas

- Pool USDT/USDC genera ~50-100% APY en tarifas
- Posiciones concentradas pueden alcanzar 100-500% APY
- 0.7% diario = 255% APY (con compuesto)
- Después de tarifas del protocolo, 0.7% es sostenible

### Buffer Conservador

El protocolo mantiene reservas para asegurar retiros durante períodos de bajo volumen. Tu 0.7% está diseñado para ser consistente sin importar las condiciones del mercado.

## Cálculo del ROI

Tus ganancias se calculan simplemente:

```
Ganancias Diarias = Cantidad Depositada × 0.7%
```

### Ejemplos

| Depósito | ROI Diario | ROI Semanal | ROI Mensual |
|----------|------------|-------------|-------------|
| $100 | $0.70 | $4.90 | $21.00 |
| $500 | $3.50 | $24.50 | $105.00 |
| $1,000 | $7.00 | $49.00 | $210.00 |
| $5,000 | $35.00 | $245.00 | $1,050.00 |
| $10,000 | $70.00 | $490.00 | $2,100.00 |

## Cuándo Comienza el ROI

Tus ganancias comienzan inmediatamente después de que tu transacción de depósito se confirma:

- Bloque N: Depositas $1,000
- Bloque N+1: Comienzas a ganar
- Después de 24 horas: ~$7.00 reclamables

## Efecto Compuesto

Si reinviertes tus ganancias cada ciclo de 21 días:

| Inicio | Después de 6 Meses | Después de 1 Año |
|--------|-------------------|------------------|
| $1,000 | $2,653 | $9,450 |
| $5,000 | $13,265 | $47,250 |
| $10,000 | $26,530 | $94,500 |

*Asume reinversión completa sin retiros*

## Qué Afecta el Rendimiento

### Factores Positivos
- ✅ Alto volumen de trading en PancakeSwap
- ✅ Volatilidad de stablecoins (despegs = más tarifas)
- ✅ Más actividad de arbitraje

### Mantenido Sin Importar
- Tasa de rendimiento fija en 0.7% diario
- Protocolo absorbe períodos de tarifas altas/bajas
- Reservas aseguran consistencia

## Seguridad de Tus Fondos

Tu USDT depositado está:

1. **En contratos inteligentes auditados**
2. **Desplegado en PancakeSwap** (DEX blue-chip)
3. **Generando tarifas de trading reales**
4. **Completamente retirable** después de 21 días

---

→ Aprende más: [PancakeSwap V3 CLMM](pancakeswap-clmm.md)
