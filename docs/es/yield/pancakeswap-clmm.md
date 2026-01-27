# PancakeSwap V3 CLMM

IMP Money utiliza Concentrated Liquidity Market Making (CLMM) de PancakeSwap V3 para generar rendimiento sostenible.

## ¿Qué es CLMM?

**Concentrated Liquidity Market Making** es la última evolución en tecnología AMM (Automated Market Maker).

### AMM Tradicional vs CLMM

| Aspecto | AMM V2 | CLMM V3 |
|---------|--------|---------|
| Distribución de Liquidez | Uniforme (0 a ∞) | Concentrada en rangos |
| Eficiencia de Capital | ~10-20% | ~100%+ |
| Tarifas Generadas | Menores | Significativamente mayores |
| Complejidad | Simple | Avanzada |

### Ventaja de Liquidez Concentrada

En lugar de distribuir liquidez en todo el rango de precios, CLMM la concentra donde ocurre el trading:

```
Precio USDT/USDC: 0.999 - 1.001

AMM V2: Liquidez distribuida de $0.01 a $100
CLMM:   Liquidez concentrada de $0.998 a $1.002
```

Resultado: **4-5x más tarifas** con el mismo capital.

## Por qué USDT/USDC

IMP eligió el par USDT/USDC por varias razones:

### 1. Riesgo de Precio Mínimo
- Ambos son stablecoins anclados a $1
- Fluctuación típica: 0.1-0.5%
- Pérdida impermanente casi inexistente

### 2. Alto Volumen
- Par de stablecoins más operado
- Millones en volumen diario
- Constante generación de tarifas

### 3. Demanda Constante
- Usuarios intercambian entre stables frecuentemente
- Arbitrajeurs mantienen precios alineados
- Actividad 24/7

## Cómo IMP Usa CLMM

### Despliegue de Fondos

1. Tus USDT se depositan en el smart contract
2. El protocolo crea posiciones de liquidez concentrada
3. Rangos de precio optimizados automáticamente
4. Tarifas recolectadas de cada swap

### Gestión Automática

IMP maneja:
- ✅ Creación de posiciones
- ✅ Rebalanceo de rangos
- ✅ Recolección de tarifas
- ✅ Distribución de rendimiento

## Rendimientos Reales

### Historial de PancakeSwap V3

Pool USDT/USDC típicamente genera:
- **50-100% APY** en posiciones pasivas
- **200-500% APY** en posiciones concentradas optimizadas
- Varía según volumen de mercado

### Modelo de IMP

| Componente | Valor |
|------------|-------|
| APY Objetivo del Pool | ~300% |
| Tu ROI | 0.7% diario (255% APY) |
| Reserva/Operación | ~45% |

## Seguridad

### PancakeSwap
- DEX más grande de BSC
- Millones en TVL
- Historial probado de años

### Contratos IMP
- Auditados por CertiK
- Lógica verificable on-chain
- Sin acceso a claves privadas

## Transparencia

Puedes verificar:
- Posiciones en PancakeSwap via BSCScan
- TVL del protocolo
- Historial de transacciones

---

→ [Ciclos de 21 Días](cycles.md)
→ [Calculadora de Rendimiento](calculator.md)
