pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

//import "../node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
//import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./ShishaToken.sol";

contract ShishaVotes {//} is ShishaToken {
    
    uint256 public defaultVotePrice = 5;
    mapping(uint256 => mapping(address => bool)) _shishaVotes;
    mapping(uint256 => uint256) _shishaVotesCount;

    event LogNewShishaVote(address buyer, uint256 shishaId);

    constructor() public { }

    function voteShisha(uint256 _shishaId) public {
        require(_shishaVotes[_shishaId][msg.sender] == false, "Already voted");
        //TODO why transferFrom is not working?
        //require(ERC20(shishaCoinAddress).transferFrom(address(this), msg.sender, defaultVotePrice), "Not enough promotion tokens");

        _shishaVotes[_shishaId][msg.sender] == true;
        //_shishaVotesCount[_shishaId] = _shishaVotesCount[_shishaId].add(1);

        emit LogNewShishaVote(msg.sender, _shishaId);
    }

    function getShishaVotes(uint256 _shishaId) public returns (uint256) {
        return _shishaVotesCount[_shishaId];
    }
}