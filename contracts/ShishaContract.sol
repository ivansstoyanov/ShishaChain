pragma solidity ^0.4.25;

import "node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";
import "node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol";

contract ShishaContract {

    event FreshLime(string name);

    struct Lime {
        string name;
        uint8 carbohydrates;
        uint8 fat;
        uint8 protein;
    }

    Lime[] public limes;

    function createLime(string _name, uint8 _carbohydrates, uint8 _fat, uint8 _protein) internal {
        limes.push(Lime(_name, _carbohydrates, _fat, _protein));
        emit FreshLime(_name);
    }
}