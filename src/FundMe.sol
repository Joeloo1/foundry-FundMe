// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    using PriceConverter for AggregatorV3Interface;

    uint256 public constant MINIMUM_USD = 5 * 1e18;

    address[] private s_funders;
    mapping(address funder => uint256 amountFunded) private s_addressToAmountFunded;

    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function _checkOwner() internal view {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "don't send enough ETH");
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.getVersion();
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    /**
     * Getter Functions
     */

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function getPriceFeed() external view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }
}
