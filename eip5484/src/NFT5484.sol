// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "./IERC5484.sol";
import "forge-std/console.sol";

contract NFT5484 is ERC721, IERC5484 {
    address public owner;
    mapping(address => bool) public permissionedIssuer;
    mapping(uint256 => string) private _tokenURIs;

    string private _baseURIextended;

    struct tokenData {
        address issuer;
        address issuedTo;
        BurnAuth burnAuth;
        string _tokenURI;
    }
    mapping(uint256 => tokenData) public idToData;

    event initiatedIssue(
        address indexed issuer,
        address indexed issuedTo,
        uint256 indexed tokenId,
        BurnAuth burnAuth
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "onlyOwner");
        _;
    }

    modifier onlyIssuer() {
        require(permissionedIssuer[msg.sender], "not an issuer");
        _;
    }

    modifier alreadySet(uint256 tokenId) {
        require(idToData[tokenId].issuedTo == msg.sender, "can't issue to you");
        _;
    }

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        owner = msg.sender;
        console.log("yes i print");
    }

    function setIssuer(address _x) external onlyOwner {
        permissionedIssuer[_x] = true;
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function setToken(
        uint256 tokenId,
        address receiver,
        BurnAuth _burnAuth
    ) external onlyIssuer {
        idToData[tokenId].issuedTo = receiver;
        idToData[tokenId].burnAuth = _burnAuth;
    }

    function mint(uint256 _tokenId) external alreadySet(_tokenId) {
        require(!_exists(_tokenId), "already exists");
        _mint(msg.sender, _tokenId);
        // _setTokenURI(_tokenId, idToData[_tokenId]._tokenURI);
        _tokenURIs[_tokenId] = idToData[_tokenId]._tokenURI;
    }

    // function tokenURI(uint256 tokenId)
    //     public
    //     view
    //     virtual
    //     override
    //     returns (string memory)
    // {
    //     require(
    //         _exists(tokenId),
    //         "ERC721Metadata: URI query for nonexistent token"
    //     );

    //     string memory _tokenURI = _tokenURIs[tokenId];
    //     string memory base = _baseURI();

    //     // If there is no base URI, return the token URI.
    //     if (bytes(base).length == 0) {
    //         return _tokenURI;
    //     }
    //     // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
    //     if (bytes(_tokenURI).length > 0) {
    //         return string(abi.encodePacked(base, _tokenURI));
    //     }
    //     // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
    //     return string(abi.encodePacked(base, tokenId.toString()));
    // }

    function burnAuth(uint256 tokenId)
        external
        view
        override
        returns (BurnAuth)
    {
        return idToData[tokenId].burnAuth;
    }
}
