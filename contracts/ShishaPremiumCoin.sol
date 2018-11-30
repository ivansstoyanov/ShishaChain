pragma solidity ^0.4.25;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";

contract ShishaPremiumCoin is ERC20Mintable, ERC20Detailed {

    constructor() ERC20Detailed("Shisha Premium Coin", "SHISHA PREMIUM", 17) public {
        
    }
}