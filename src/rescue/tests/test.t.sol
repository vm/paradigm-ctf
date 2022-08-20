// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Setup} from "../Setup.sol";
import {MasterChefHelper} from "../MasterChefHelper.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/console2.sol";

contract ContractTest is Test {
    Setup public s;
    ERC20 uni;

    MasterChefHelper ourHelper;

    function setUp() public {
    }

    function testRescueExploit() public {
      vm.createSelectFork(vm.rpcUrl("paradigm"));

      uni = ERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
      vm.prank(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
      uni.transfer(address(this), 20000);
      s = new Setup{value: 10 ether}();

      uni.approve(s.getAddress(), type(uint256).max);
      // console2.log(uni.balanceOf(address(this)));

      ourHelper = MasterChefHelper(s.getAddress());

      ourHelper.swapTokenForPoolToken(1, address(uni), 2, 1);
    }
}
