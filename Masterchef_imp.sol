// SPDX-License-Identifier: MIT

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/utils/EnumerableSet.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./SushiToken.sol";

interface IMigratorChef {
    function migrate(IERC20) external returns(IERC20);
}

contract MasterChaf is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct UserInfo {
        uint amount; // How many LP provided by user
        uint rewardDebt;
    }
    struct PoolInfo {
        IERC20 lpToken;
        uint allocPoint;
        uint lastRewardBlock;
        uint accSushiPerShare;
    }
    SushiToken public sushi;
    address public devaddr;
    uint public bonusEndBlock;
    uint public sushiPerBlock;
    uint publlic constant BONUS_MULTIPLIER = 10;
    IMigratorChef public migrator;
    PoolInfo[] poolInfo;
    mapping(uint =>mapping(address => UserInfo))public userInfo;
    uint totalAllocPoint = 0;
    uint public startBlock;

    event Deposit(address indexed user,uint indexed pid, uint amount);
    event Withdraw(address indexed user,uint indexed pid, uint amount);
    event Emergency(address indexed user,uint indexed pid, uint amount);

    constructor(
        SushiToken _sushi,
        address _devaddr,
        uint _sushiPerBlock,
        uint _startBlock,
        uint _bonusEndBlock
    ) public {
        sushi = _sushi;
        devaddr = _devaddr;
        sushiPerBlock = _sushiPerBlock;
        bonusEndBlock = _bonusEndBlock;
        startBlock = _startBlock;
    }
    function poolLength() external view returns(uint) {
        return poolInfo.length;
    }

    //Adding new LP to pool. OnlyOwner.
    // Dont add same LP > Once. initiates a bug in rewards

    function add(
        uint _allocPoint,
        IERC20 _lpToken,
        bool _withUpdate
    ) public OnlyOwner {
        if (_withUpdate) {massUpdatePools();}
        uint lastRewardBlock = block.number > startBlock ? block.number : startBlock;
        totalAllocPoint = totalAllocPoint.add(_allocPoint);
        poolInfo.push(
            PoolInfo({
                lpToken: _lpToken,
                allocPoint: _allocPoint,
                lastRewardBlock: lastRewardBlock,
                accSushiPerShare: 0
            })
        );
    }
    










    
}