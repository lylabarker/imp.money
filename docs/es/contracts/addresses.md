# Direcciones de Contratos

Todos los contratos de IMP Money están desplegados en BNB Smart Chain (BSC) y son completamente verificados en BSCScan.

## Contratos Principales

### IMP Vault
La bóveda principal que gestiona depósitos y retiros.

| Atributo | Valor |
|----------|-------|
| Dirección | `0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C` |
| Red | BNB Smart Chain |
| Verificado | ✅ Sí |
| Auditoría | CertiK |

[Ver en BSCScan →](https://bscscan.com/address/0x3439aF4B86a419ad938CAbA8D0767a2a0eD4cE7C)

### IMP Treasury
El contrato de tesorería que gestiona las referencias y los rangos.

| Atributo | Valor |
|----------|-------|
| Dirección | `0x69077f02A721d2EC2548DAeA35d96B5481165Dd0` |
| Red | BNB Smart Chain |
| Verificado | ✅ Sí |
| Propietario | 🔒 Renunciado (0x0) |

[Ver en BSCScan →](https://bscscan.com/address/0x69077f02A721d2EC2548DAeA35d96B5481165Dd0)

### MONEY Token
Token ERC-20 para representar participaciones.

| Atributo | Valor |
|----------|-------|
| Dirección | `0x32c1E28e402caC53a2A7D5aCCa2132BE62DB2d7c` |
| Símbolo | MONEY |
| Decimales | 18 |

[Ver en BSCScan →](https://bscscan.com/address/0x32c1E28e402caC53a2A7D5aCCa2132BE62DB2d7c)

## Contratos Externos

### USDT (BEP-20)
El token de depósito utilizado por IMP Money.

| Atributo | Valor |
|----------|-------|
| Dirección | `0x55d398326f99059fF775485246999027B3197955` |
| Símbolo | USDT |
| Decimales | 18 |

### PancakeSwap V3 Pool
El pool de liquidez donde se despliegan los fondos.

| Atributo | Valor |
|----------|-------|
| Par | USDT/USDC |
| Fee Tier | 0.01% |
| Protocolo | PancakeSwap V3 |

## Cómo Verificar

### 1. Verificar Código del Contrato
1. Ve a BSCScan
2. Busca la dirección del contrato
3. Haz clic en "Contract" → "Read Contract"
4. El código debe coincidir con nuestro GitHub

### 2. Verificar Auditoría
1. Visita [skynet.certik.com/projects/imp-money](https://skynet.certik.com/projects/imp-money)
2. Revisa el reporte de auditoría
3. Confirma las direcciones auditadas

### 3. Verificar TVL
1. Revisar el saldo del contrato Vault en BSCScan
2. Comparar con el dashboard de imp.money

## Interactuar con Contratos

### Vía BSCScan

Puedes leer y escribir directamente a los contratos:

1. **Leer**:
   - Ver tu saldo
   - Ver ganancias pendientes
   - Verificar fecha de desbloqueo

2. **Escribir** (requiere billetera):
   - Reclamar ganancias
   - Retirar fondos
   - Depositar (avanzado)

### Funciones Principales del Vault

```solidity
// Depositar USDT
function deposit(uint256 amount, address referrer)

// Reclamar ganancias
function claimROI()

// Retirar principal
function withdraw()

// Ver ganancias pendientes
function pendingROI(address user) returns (uint256)
```

## Nota de Seguridad

⚠️ **Siempre verifica las direcciones antes de interactuar**

- Copia direcciones solo de fuentes oficiales
- No interactúes con contratos no verificados
- En caso de duda, usa la interfaz de imp.money

---

→ [Arquitectura de Contratos](architecture.md)
→ [Seguridad y Auditorías](security.md)
