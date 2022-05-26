// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Auction.sol";

contract DutchAuction is Auction {

    uint public initialPrice;
    uint public biddingPeriod;
    uint public priceDecrement;

    uint internal auctionEnd;
    uint internal auctionStart;

    /// Creates the DutchAuction contract.
    ///
    /// @param _sellerAddress Address of the seller.
    /// @param _judgeAddress Address of the judge.
    /// @param _timer Timer reference
    /// @param _initialPrice Start price of dutch auction.
    /// @param _biddingPeriod Number of time units this auction lasts.
    /// @param _priceDecrement Rate at which price is lowered for each time unit
    ///                        following linear decay rule.
    constructor(
        address _sellerAddress,
        address _judgeAddress,
        Timer _timer,
        uint _initialPrice,
        uint _biddingPeriod,
        uint _priceDecrement
    )  Auction(_sellerAddress, _judgeAddress, _timer) {
        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        priceDecrement = _priceDecrement;
        auctionStart = time();
        // Here we take light assumption that time is monotone
        auctionEnd = auctionStart + _biddingPeriod;
    }

    /// In Dutch auction, winner is the first pearson who bids with
    /// bid that is higher than the current prices.
    /// This method should be only called while the auction is active.
    function bid() public payable {
        require(time() >= auctionStart, "Auction has not yet begun.");
        require(time() <= auctionEnd, "Auction is over.");
        require(outcome == Outcome.NOT_FINISHED, "Auction finished.");

        uint256 offer = msg.value;
        uint256 currentTime = time() - auctionStart;
        uint256 currentPrice = initialPrice - currentTime * priceDecrement;

        require(offer >= currentPrice, "Bid too low.");

        finishAuction(Outcome.SUCCESSFUL, msg.sender);

        if(offer > currentPrice){
            uint256 priceDelta = offer - currentPrice;
            payable(msg.sender).transfer(priceDelta);
        }


    }
}