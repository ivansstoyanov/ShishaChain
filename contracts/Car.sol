pragma solidity ^0.4.25;

import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Car is Ownable {

    address public contractOwner;

    uint256 public price = 1 ether;
    //address[] public historyOwners;
    //string public slogan;

    mapping(bytes => address) carOwnedBy;
    mapping(bytes => uint256) carPrice;
    mapping(address => bytes[]) ownerCars;
    //mapping(address => uint) carOwnersCount;

    //event LogBillboardBought(string _slogan, address buyer);

    constructor(address _contractOwner) public {
        contractOwner = _contractOwner;
    }

    modifier onlyPositiv(uint256 _newPrice) {
        require(_newPrice > 0, "Price should be greater than zero");
        _;
    }

    function setNewPrice(uint256 _newPrice) public onlyPositiv(_newPrice) onlyOwner() {
        price = _newPrice;
    }

    event LogWithdraw(uint256 _withdrawAmount);

    

    function buy(string _brand, string _model) public payable {
        require(msg.value >= price, "error value too low");
        
        bytes memory carAddress = _generateCarId(_brand, _model);

        //when availiable
        carOwnedBy[carAddress] = msg.sender;
        //todo when car is already taken
        

        carPrice[carAddress] = msg.value;
        //todo double car price
        //todo extract 150%money, keep 50% for the contract


        //add to owner
        ownerCars[msg.sender].push(carAddress);
        //todo remove from old owner
        


        //moneySpent[msg.sender] += msg.value;
        //emit LogBillboardBought(_slogan, msg.sender);
    }

    function _generateCarId(string _brand, string _model) public pure returns (bytes)  {
        //bytes32 carAddress = keccak256(abi.encode(_toLower(_brand), _toLower(_model)));
        return abi.encode(keccak256(_toLower(_brand)), keccak256(_toLower(_model)));
	}

    function _toLower(string str) public pure returns (string)  {
		bytes memory bStr = bytes(str);
		bytes memory bLower = new bytes(bStr.length);
		for (uint i = 0; i < bStr.length; i++) {
			// Uppercase character...
			if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
				// So we add 32 to make it lowercase
				bLower[i] = bytes1(int(bStr[i]) + 32);
			} else {
				bLower[i] = bStr[i];
			}
		}
		return string(bLower);
	}

    function withdrawFunds() public onlyOwner() returns(bool) {
        contractOwner.transfer(address(this).balance);
    
        emit LogWithdraw(address(this).balance);
    }
}