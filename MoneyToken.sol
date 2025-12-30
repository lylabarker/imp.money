// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MoneyToken ($MONEY)
 * @notice Fair launch reward token - no presale, no team allocation, no governance
 * @dev 100% distributed through liquidity provision only.
 *      Single authorized minter set at deployment - cannot be changed.
 */
contract MoneyToken is ERC20 {
    
    // The one and only minter (the vault) - set at deployment, never changes
    address public immutable minter;
    
    // Supply cap - once set, cannot be changed
    uint256 public immutable maxSupply;
    
    // Statistics
    uint256 public totalMinted;
    uint256 public totalBurned;

    // Events
    event Minted(address indexed to, uint256 amount);
    event Burned(address indexed from, uint256 amount);

    // Errors
    error NotMinter();
    error SupplyCapExceeded();
    error ZeroAddress();
    error ZeroAmount();

    /**
     * @notice Deploy $MONEY with fixed minter and optional supply cap
     * @param _minter The vault contract that can mint (IMMUTABLE)
     * @param _maxSupply Maximum total supply (0 = uncapped, IMMUTABLE)
     */
    constructor(address _minter, uint256 _maxSupply) ERC20("Imp Money", "MONEY") {
        if (_minter == address(0)) revert ZeroAddress();
        minter = _minter;
        maxSupply = _maxSupply;
    }

    /**
     * @notice Mint rewards to liquidity providers
     * @dev Only callable by the vault contract
     */
    function mint(address to, uint256 amount) external {
        if (msg.sender != minter) revert NotMinter();
        if (to == address(0)) revert ZeroAddress();
        if (amount == 0) revert ZeroAmount();
        
        if (maxSupply > 0 && totalSupply() + amount > maxSupply) {
            revert SupplyCapExceeded();
        }
        
        _mint(to, amount);
        totalMinted += amount;
        emit Minted(to, amount);
    }

    /**
     * @notice Burn your own tokens
     * @dev Permissionless - anyone can burn their own tokens
     */
    function burn(uint256 amount) external {
        if (amount == 0) revert ZeroAmount();
        _burn(msg.sender, amount);
        totalBurned += amount;
        emit Burned(msg.sender, amount);
    }

    /**
     * @notice Burn tokens with approval
     * @dev Caller must have sufficient allowance
     */
    function burnFrom(address account, uint256 amount) external {
        if (amount == 0) revert ZeroAmount();
        _spendAllowance(account, msg.sender, amount);
        _burn(account, amount);
        totalBurned += amount;
        emit Burned(account, amount);
    }

    // ═══════════════════════════════════════════════════════════════════════════
    //                            VIEW FUNCTIONS
    // ═══════════════════════════════════════════════════════════════════════════

    function circulatingSupply() external view returns (uint256) {
        return totalMinted - totalBurned;
    }

    function remainingMintable() external view returns (uint256) {
        if (maxSupply == 0) return type(uint256).max;
        return maxSupply > totalSupply() ? maxSupply - totalSupply() : 0;
    }
}
