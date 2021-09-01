pragma solidity 0.6.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DigiHomie is ERC721, Ownable {
    uint256 public MAX_TOKENS = 5000;
    uint256 public tokenCounter;
    string public LOADINGURI =
        "ipfs://Qme9i2UjhqA6evVSWZaCHgSF4AvgQzsb4mVUDwP971ZNfL";
    mapping(uint256 => string) public tokenIdToURI;

    constructor() public ERC721("DigiHomies", "DH") {
        tokenCounter = 0;
    }

    //Creates contract for each homie & sets URI to resolve Homie
    function mintHomie(string memory tokenURI)
        public
        onlyOwner
        returns (bytes32)
    {
        require((tokenCounter < MAX_TOKENS), "Exceeds maximum token supply.");
        //Use newItemId and Counter, prior to tokenId via mint
        uint256 newItemId = tokenCounter;
        address homieOwner = msg.sender;

        //URI stored for user Mint
        tokenIdToURI[newItemId] = tokenURI;
        _safeMint(homieOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);

        tokenCounter = tokenCounter + 1;
    }

    //Creates token
    function mintHomiePending(string memory tokenURI)
        public
        onlyOwner
        returns (bytes32)
    {
        require((tokenCounter < MAX_TOKENS), "Exceeds maximum token supply.");
        //Use newItemId and Counter, prior to tokenId via mint
        uint256 newItemId = tokenCounter;
        address homieOwner = msg.sender;

        //URI stored for user Mint
        tokenIdToURI[newItemId] = tokenURI;
        _safeMint(homieOwner, newItemId);
        _setTokenURI(newItemId, LOADINGURI);
        tokenCounter = tokenCounter + 1;
    }

    //UserMint - allow user to create new (resolve URI)
    function userMintHomies(uint256 numTokens) public {
        require(
            SafeMath.add(tokenCounter, numTokens) < MAX_TOKENS,
            "Exceeds maximum token supply."
        );
        require(
            numTokens > 0 && numTokens <= 10,
            "Minting must be a min of 1 and a max of 10."
        );
        uint256 newItemId = tokenCounter;

        //Iterate numTokens, mint & resolve URI to mapped URI
        for (uint256 i = 0; i < numTokens; i++) {
            uint256 mintIndex = SafeMath.add(i, newItemId);
            _safeMint(msg.sender, mintIndex);
            _setTokenURI(mintIndex, tokenIdToURI[mintIndex]);
            tokenCounter = tokenCounter + 1;
        }
    }

    //Set metadata - Restricted to contract owner
    function setTokenURI(uint256 tokenId, string memory tokenURI)
        public
        onlyOwner
    {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner or approved."
        );
        require(_exists(tokenId), "TokenId does not exist");
        _setTokenURI(tokenId, tokenURI);
    }
}
