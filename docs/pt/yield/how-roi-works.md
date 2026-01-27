# Como o ROI Funciona

IMP Money gera rendimento através de provisão de liquidez automatizada. Aqui está a análise técnica.

## A Fonte do Rendimento

Seus retornos vêm de **taxas de trading do PancakeSwap V3**, não de novos depósitos.

```
Volume de Trading → Taxas LP → IMP Vault → Seu ROI Diário
```

### PancakeSwap V3 CLMM

IMP usa **Concentrated Liquidity Market Making (CLMM)**:

- Capital implantado em pares USDT/USDC
- Faixa de preço estreita (stablecoins negociam perto de 1:1)
- Eficiência de capital muito maior que AMMs tradicionais
- Taxas de trading de cada swap na faixa

## Por que 0,7% Diário?

### A Matemática

- Pool USDT/USDC gera ~50-100% APY em taxas
- Posições concentradas podem atingir 100-500% APY
- 0,7% diário = 255% APY (com composto)
- Após taxas do protocolo, 0,7% é sustentável

### Buffer Conservador

O protocolo mantém reservas para garantir saques durante períodos de baixo volume. Seu 0,7% é projetado para ser consistente independente das condições de mercado.

## Cálculo do ROI

Seus ganhos são calculados simplesmente:

```
Ganhos Diários = Valor Depositado × 0,7%
```

### Exemplos

| Depósito | Diário | Semanal | Mensal |
|----------|--------|---------|--------|
| $100 | $0,70 | $4,90 | $21,00 |
| $1.000 | $7,00 | $49,00 | $210,00 |
| $10.000 | $70,00 | $490,00 | $2.100,00 |

## Quando o ROI Começa?

Seus ganhos começam imediatamente após sua transação de depósito ser confirmada:

- Bloco N: Você deposita $1.000
- Bloco N+1: Começa a ganhar
- Após 24 horas: ~$7,00 resgatáveis

## Efeito Composto

Se você reinvestir seus ganhos a cada ciclo de 21 dias:

| Início | Após 6 Meses | Após 1 Ano |
|--------|--------------|------------|
| $1.000 | $2.653 | $9.450 |
| $5.000 | $13.265 | $47.250 |
| $10.000 | $26.530 | $94.500 |

*Assume reinvestimento total sem saques*

---

Saiba mais: [PancakeSwap V3 CLMM](pancakeswap-clmm.md)
