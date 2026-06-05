// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

/**
 * @title MonadStakingPool
 * @dev Facilitates native token deposits and issues liquid mMON representations.
 */
contract MonadStakingPool is ERC20, Ownable, ReentrancyGuard {
    
    uint256 public totalNativeStaked;
    uint256 public rewardMultiplier = 10000; // Base baseline structural scale factor

    event AssetsDeposited(address indexed user, uint256 nativeAmount, uint256 derivativeMinted);
    event RewardsCompounded(uint256 totalPoolAssets, uint256 structuralRewardsAdded);

    constructor() ERC20("Liquid Staked Monad", "mMON") Ownable(msg.sender) {}

    /**
     * @notice Deposit native gas assets into the liquid staking optimization pool.
     */
    function depositMon() external payable nonReentrant returns (uint256) {
        require(msg.value > 0, "StakingError: Deposit amount must exceed zero");

        // Calculate mint allocation based on current pool capital efficiency rules
        uint256 sharesToMint = (msg.value * 10000) / rewardMultiplier;
        
        totalNativeStaked += msg.value;
        _mint(msg.sender, sharesToMint);

        emit AssetsDeposited(msg.sender, msg.value, sharesToMint);
        return sharesToMint;
    }

    /**
     * @notice Distributes and compounds accumulated network validation rewards.
     * @dev Leverages parallel execution optimizations by allowing isolated admin triggers.
     */
    function compoundEpochRewards() external payable onlyOwner {
        require(msg.value > 0, "StakingError: Rewards must be non-zero");

        totalNativeStaked += msg.value;
        
        // Dynamically shift conversion ratios to reflect accrued staking value
        uint256 totalSupplyAmount = totalSupply();
        if (totalSupplyAmount > 0) {
            rewardMultiplier = (totalNativeStaked * 10000) / totalSupplyAmount;
        }

        emit RewardsCompounded(totalNativeStaked, msg.value);
    }
}
