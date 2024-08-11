// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
   

   function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);

    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(),5e18);
    }
    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

   
    function testPriceFeedVersionIsAccurate() public{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

     function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }
    
    function testUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(address(USER));
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToList() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawalWithASingleFunder() public funded {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 fundMeStartingBalance = address(fundMe).balance;

        //Act
        
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance =  address(fundMe).balance;
        assertEq(fundMeStartingBalance + startingOwnerBalance, endingOwnerBalance);
        assertEq(endingFundMeBalance, 0);
    }

    function testWithdrawalWithMultipleFunders() public funded {

        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFundersIndex = 1;
        for(uint160 i = startingFundersIndex; i < numberOfFunders; i++){
            hoax(address(i),STARTING_BALANCE);
            fundMe.fund{value:SEND_VALUE}();
        }
        
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 fundMeStartingBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance =  address(fundMe).balance;
        assertEq(fundMeStartingBalance + startingOwnerBalance, endingOwnerBalance);
        assertEq(endingFundMeBalance, 0);



    }

     function testWithdrawalWithMultipleFundersCheaper() public funded {

        //Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFundersIndex = 1;
        for(uint160 i = startingFundersIndex; i < numberOfFunders; i++){
            hoax(address(i),STARTING_BALANCE);
            fundMe.fund{value:SEND_VALUE}();
        }
        
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 fundMeStartingBalance = address(fundMe).balance;

        //Act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance =  address(fundMe).balance;
        assertEq(fundMeStartingBalance + startingOwnerBalance, endingOwnerBalance);
        assertEq(endingFundMeBalance, 0);



    }

}