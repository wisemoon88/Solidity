// SPDX-License-Identifier: MIT


pragma solidity ^0.6.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe{
    using SafeMathChainlink for uint256;

    

    //uint256 public variable;
    mapping(address => uint256) public addressToFund;
    address public owner;
    address[] public funders;

    //defining constructor to define owner of contract immediately to msg.sender once contract is deployed
    constructor() public{
        owner = msg.sender;
    }

    function getfund() public payable {
        uint256 minimumUSD = 1 * 10 ** 18;
        require(getConversion(msg.value) >= minimumUSD, "You need to spend more ETH!");
        //this mapping allows for the current sender address to map the amount being sent to their address
        addressToFund[msg.sender] = msg.value;
        //this array will capture the address of the current sender of the fund into an array which will allow for resetting of the funds from the address later on once the withdraw function has been called
        funders.push(msg.sender);
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

    //modifier is used to make a requirement check that msg.sender needs to be original owner who deployed contract before being alloweed to withdraw all the money.  this can be used multiple times whenver it is called in a function.  eg can be used not only on withdraw function
    modifier onlyOwner {
        require(msg.sender == owner);

        _;
    }

    //this is a withdraw function which withdraws all the funded amount to the contract owners account address which is different from the contract address.  will need to add modifier to ensure that msg.sender needs to be the owner of the contract first before being able to withdraw the amount
    function withdraw() public payable onlyOwner{
        msg.sender.transfer(address(this).balance);
        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            //this is capturing the address of the funder from the funders array
            address funder = funders[funderIndex];
            //this is taking the mapping and using the funder address to reset the amount from the funder to zero
            addressToFund[funder] = 0;
        }
        funders = new address[](0);
    }
}
