pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import "node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Articles is Ownable {

    struct Article {
        string title;
        string description;
        string picture;
        address owner;
    }

    Article[] public publicArticles;
    mapping(address => Article[]) privateArticles;

    event LogNewArticle(string title, string description, string picture, address owner);

    constructor() public { }

    function addArticle(string _title, string _description, string _picture) public {
        publicArticles.push(Article(_title, _description, _picture, msg.sender));

        emit LogNewArticle(_title, _description, _picture, msg.sender);
    }

    function addPrivateArticle(string _title, string _description, string _picture) public {
        privateArticles[msg.sender].push(Article(_title, _description, _picture, msg.sender));
    }

    function getArticles() public view returns (Article[]) {
        return publicArticles;
    }

    function getPrivateArticles() public view returns (Article[]) {
        return privateArticles[msg.sender];
    }
}