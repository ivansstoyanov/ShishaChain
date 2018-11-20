pragma solidity ^0.4.25;

import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./User.sol";

contract UserShishas is User {

    address public contractOwner;

    mapping(address => mapping(address => bool)) shishaList;
    mapping(address => uint) shishaCount;

    event LogNewShisha(string _slogan, address buyer);

    constructor(address _contractOwner) public {
        contractOwner = _contractOwner;
    }

    // modifier onlyNewFriends(address _friendAddress) {
    //     require(friendList[msg.sender][_friendAddress] == false, "Already friends");
    //     _;
    // }

    // modifier alreadyFriends(address _friendAddress) {
    //     require(friendList[msg.sender][_friendAddress] == true, "Not friends");
    //     _;
    // }

    function getShisha(bytes flavour, uint256 tokens) public {
        require(tokens > price, "The tokens sent was too low");

        billboardOwner = msg.sender;
        historyOfOwners.push(msg.sender);
        moneySpent[msg.sender] += tokens;
        slogan = newSlogan;
        price = tokens;

        require(ERC20(billToken).transferFrom(msg.sender, address(this), tokens));

        emit LogBillboardBought(msg.sender, tokens, newSlogan);
    }

    // function addNewFriend(address _friendAddress) public onlyNewFriends(_friendAddress) {
    //     friendList[msg.sender][_friendAddress] = true;
    //     friendsCount[msg.sender]++;
    // }

    // function removeFriend(address _friendAddress) public alreadyFriends(_friendAddress) {
    //     friendList[msg.sender][_friendAddress] = false;
    //     friendsCount[msg.sender]--;
    // }
}