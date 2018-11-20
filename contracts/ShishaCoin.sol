pragma solidity ^0.4.25;

import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

//import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";

contract ShishaCoin is ERC20Mintable, ERC20Detailed, Ownable {

    constructor() {
        name = "Shisha Coin";
        symbol = "SHISHA";
        decimals = 5;
        totalSupply = 100000000000;
        
        owner = msg.sender;
        balances[msg.sender] = totalSupply;
        
        emit Transfer(0x0, msg.sender, totalSupply);
    }

}