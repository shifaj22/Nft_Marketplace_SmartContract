// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";




contract MyNFT is ERC721, Ownable{

    address _tokenAddress;
     ERC20 public token = ERC20(_tokenAddress);  // The ERC-20 token contract

    struct Listing {
        address seller;
        uint256 amount;
        uint256 price;
    }

    Listing[] public listings;

    constructor()  ERC721("MyNFT", "MFT") {}

    function createListing(uint256 _amount, uint256 _price) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(_price > 0, "Price must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        listings.push(Listing({
            seller: msg.sender,
            amount: _amount,
            price: _price
        }));
    }

    function buyListing(uint256 _listingIndex) external {
        require(_listingIndex < listings.length, "Invalid listing index");
        Listing storage listing = listings[_listingIndex];
        require(listing.amount > 0, "Listing is sold out");
        require(token.transfer(listing.seller, listing.price), "Transfer to seller failed");
        require(token.transfer(msg.sender, listing.amount), "Transfer to buyer failed");

        // Remove the sold listing
        delete listings[_listingIndex];
    }

    function getListingCount() external view returns (uint256) {
        return listings.length;
    }

        uint256  tokenCounter;

    // Mapping from token ID to the token's metadata (IPFS hash).
    mapping(uint256 => string) private _tokenMetadata;

    // Mapping from token ID to the royalty percentage.
    mapping(uint256 => uint256) private _royalties;

   
   

    function setRoyalty(uint256 tokenId, uint256 royalty) external onlyOwner {
        require(_exists(tokenId), "Token does not exist");
        _royalties[tokenId] = royalty;
    }

    

    function getTokenMetadata(uint256 tokenId) external view returns (string memory) {
        return _tokenMetadata[tokenId];
    }

    function getRoyalty(uint256 tokenId) external view returns (uint256) {
        return _royalties[tokenId];
    }
}