pragma solidity ^0.4.25;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";

contract ShishaCoin is ERC20Mintable, ERC20Detailed {

    uint256 public defaultBonus = 100;
    uint256 public maxBonusCount = 1000;
    uint256 public bonusesCount = 0;
    mapping (address => bool) private _initialBonus;

    constructor() ERC20Detailed("Shisha Coin", "SHISHA", 4) public {
        
    }

    function claimBonus() public {
        require(bonusesCount < maxBonusCount, "no more bonuses availiable");
        require(_initialBonus[msg.sender] == false, "bonus already received");
        
        _mint(msg.sender, defaultBonus);

        _initialBonus[msg.sender] = true;
        bonusesCount = bonusesCount.add(1);
    }

    function transferCoins(address from, address to, uint256 value) public onlyMinter() returns(bool) {
        //require(address(this).call(bytes4(keccak256("transfer(address, uint256)")), msg.sender, defaultBonus));
        _transfer(from, to, value);
        return true;
    }
}