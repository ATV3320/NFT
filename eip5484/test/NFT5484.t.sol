// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NFT5484.sol";

contract NFT5484Test is Test {
    NFT5484 public nft;

    function setUp() public {
        nft = new NFT5484("aryan", "atv");
    }

    function testSetIssuer() public {
        nft.setIssuer(address(0));
        assertEq(nft.permissionedIssuer(address(0)), true);
    }

    // function testSetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }
}
