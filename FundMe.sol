// SPDX-License-Identifier: MIT


pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{
    using SafeMathChainlink for uint256;

    

    //uint256 public variable;
    mapping(address => uint256) public addressToFund;

    //defining constructor to define owner of contract immediately to msg.sender once contract is deployed
    constructor 

    function getfund() public payable {
        uint256 minimumUSD = 1 * 10 ** 18;
        require(getConversion(msg.value) >= minimumUSD, "You need to spend more ETH!");
        addressToFund[msg.sender] = msg.value;
    }

    function getVersion() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        return priceFeed.version();

    }

    function getPrice() public view returns(uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
        //2939565171290000000000
    }
    //
    function getConversion(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount)/ 1000000000000000000;
        return ethAmountInUSD;
    }//0.000002946735466460

    //modifier is used to make a requirement check that msg.sender needs to be original owner who deployed contract before being alloweed to withdraw all the money
    modifier onlyOwner {
        require(msg.sender == owner);

        _;
    }

    //this is a withdraw function which withdraws all the funded amount to the contract owners account address which is different from the contract address.  will need to add modifier to ensure that msg.sender needs to be the owner of the contract first before being able to withdraw the amount
    function withdraw() public payable{
        msg.sender.transfer(address(this).balance);
    }
}
