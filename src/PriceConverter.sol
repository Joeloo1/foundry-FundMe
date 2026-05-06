// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        // ETH/USD price in 8 decimal places
        require(price > 0, "Invalid price");
        // casting to 'uint256' is safe because we check price > 0 above
        // forge-lint: disable-next-line(unsafe-typecast)
        return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        return priceFeed.version();
    }
}
