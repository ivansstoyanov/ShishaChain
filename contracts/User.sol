pragma solidity ^0.4.25;

import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract User is Ownable {

    //address public contractOwner;

    mapping(address => mapping(address => bool)) friendList;
    mapping(address => uint) friendsCount;

    event LogNewFriend(address buyer);

    constructor() public { }

    // constructor(address _contractOwner) public {
    //     contractOwner = _contractOwner;
    // }

    modifier onlyNewFriends(address _friendAddress) {
        require(friendList[msg.sender][_friendAddress] == false, "Already friends");
        _;
    }

    modifier alreadyFriends(address _friendAddress) {
        require(friendList[msg.sender][_friendAddress] == true, "Not friends");
        _;
    }

    function addNewFriend(address _friendAddress) public onlyNewFriends(_friendAddress) {
        friendList[msg.sender][_friendAddress] = true;
        friendsCount[msg.sender]++;

        emit LogNewFriend(_friendAddress);
    }

    function removeFriend(address _friendAddress) public alreadyFriends(_friendAddress) {
        friendList[msg.sender][_friendAddress] = false;
        friendsCount[msg.sender]--;
    }
}