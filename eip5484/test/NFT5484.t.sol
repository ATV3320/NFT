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

    function testFailSetIssuer() public {
        vm.prank(address(1));
        nft.setIssuer(address(0));
    }

    function testFullLineOnce() public {
        nft.setIssuer(address(0));
        // nft.setIssuer(address(this));
        vm.startPrank(address(0));
        nft.setToken(0, address(2),IERC5484.BurnAuth.OwnerOnly);
        vm.stopPrank();
        vm.startPrank(address(2));
        nft.mint(0);
        vm.stopPrank();
        assertEq(nft.ownerOf(0), address(2));
        nft.burn(0);
    }
}
