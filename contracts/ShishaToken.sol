pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./ShishaCoin.sol";

contract ShishaToken is ERC721 {
    
    address public shishaCoinAddress;
    uint256 public defaultPrice = 20;
    
    mapping(address => uint256[]) public _ownerTokens;
    mapping(uint256 => uint256) public _ownerTokensIndexes;

    struct TokenOffer {
        address buyer;
        uint256 shishaToken;
        uint256 price;
    }
    mapping(uint256 => TokenOffer[]) public _tokenOffers;

    mapping(address => TokenOffer[]) public _madeOffers;
    mapping(address => TokenOffer[]) public _receivedOffers;

    mapping(uint256 => uint256) private _tokenApprovalPrice;

    event LogNewShisha(address buyer, uint256 shishaId, uint256 price);
    event LogNewShishaPrice(address buyer, uint256 shishaId, uint256 price);
    event LogNewOffer(address buyer, uint256 shishaId, uint256 price);

    constructor(address _shishaCoinAddress) public {
        shishaCoinAddress = _shishaCoinAddress;
    }

    modifier tokenExist(uint256 _shishaId) {
        require(_exists(_shishaId), "Shisha token not exist");
        _;
    }

    function getAllShishaTokens(address _owner) public view returns (uint256[]) {
        return _ownerTokens[_owner];
    }

    function buyShisha(uint _shishaId) public {
        require(_shishaId != 0, "Invalid Shisha token");
        require(!_exists(_shishaId), "Shisha already taken");
        require(ShishaCoin(shishaCoinAddress).transferCoins(msg.sender, shishaCoinAddress, defaultPrice), "Not enough shisha tokens");

        _mint(msg.sender, _shishaId);
        uint256 index = _ownerTokens[msg.sender].push(_shishaId) - 1;
        _ownerTokensIndexes[_shishaId] = index;

        emit LogNewShisha(msg.sender, _shishaId, defaultPrice);
    }

    function setShishaApproval(address _to, uint256 _shishaId, uint256 _price) public tokenExist(_shishaId) {
        require(_price > 0, "Price should be positive");

        approve(_to, _shishaId);
        _tokenApprovalPrice[_shishaId] = _price;

        emit LogNewShishaPrice(msg.sender, _shishaId, _price);
    }

    function getShishaPrice(uint256 _shishaId) public view tokenExist(_shishaId) returns (uint256) {
        return _tokenApprovalPrice[_shishaId];
    }

    function transferShisha(uint256 _shishaId) public tokenExist(_shishaId) {
        require(getApproved(_shishaId) == msg.sender, "Not allowed to buy this token");
        require(ShishaCoin(shishaCoinAddress).transferCoins(msg.sender, ownerOf(_shishaId), _tokenApprovalPrice[_shishaId]), "Not enough shisha tokens");

        uint256 newIndex = _ownerTokens[msg.sender].push(_shishaId) - 1;
        _ownerTokens[ownerOf(_shishaId)][_ownerTokensIndexes[_shishaId]] = 0;
        _ownerTokensIndexes[_shishaId] = newIndex;
        
        transferFrom(ownerOf(_shishaId), msg.sender, _shishaId);

        delete _tokenOffers[_shishaId];

        emit LogNewShisha(msg.sender, _shishaId, _tokenApprovalPrice[_shishaId]);
        _tokenApprovalPrice[_shishaId] = 0;
    }
    

    function makeOffer(uint256 _shishaId, uint _price) public tokenExist(_shishaId) {
        require(ownerOf(_shishaId) != 0, "Shisha not belong to anyone");

        TokenOffer memory newOffer = TokenOffer(msg.sender, _shishaId, _price);
        _tokenOffers[_shishaId].push(newOffer);
        _madeOffers[msg.sender].push(newOffer);
        _receivedOffers[ownerOf(_shishaId)].push(newOffer);

        emit LogNewOffer(msg.sender, _shishaId, _price);
    }

    function getOffers(uint256 _shishaId) public view returns (TokenOffer[]) {
        return _tokenOffers[_shishaId];
    }

    function getMadeOffers(address _owner) public view returns (TokenOffer[]) {
        return _madeOffers[_owner];
    }

    function getReceivedOffers(address _owner) public view returns (TokenOffer[]) {
        return _receivedOffers[_owner];
    }


    /////////////
    /// extrat to other contract. Here for simplicity only
    uint256 public defaultVotePrice = 5;
    mapping(uint256 => mapping(address => bool)) _shishaVotes;
    mapping(uint256 => uint256) _shishaVotesCount;

    event LogNewShishaVote(address buyer, uint256 shishaId);

    function voteShisha(uint256 _shishaId) public {
        require(_shishaVotes[_shishaId][msg.sender] == false, "Already voted");
        require(ShishaCoin(shishaCoinAddress).transferCoins(address(this), msg.sender, defaultVotePrice), "Not enough shisha tokens");

        _shishaVotes[_shishaId][msg.sender] = true;
        _shishaVotesCount[_shishaId] = _shishaVotesCount[_shishaId].add(1);

        emit LogNewShishaVote(msg.sender, _shishaId);
    }

    function getShishaVotes(uint256 _shishaId) public view returns (uint256) {
        return _shishaVotesCount[_shishaId];
    }


    function() public payable { }
}