// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Auction.sol";

contract EnglishAuction is Auction {

    uint internal highestBid;
    uint internal initialPrice;
    uint internal biddingPeriod;
    uint internal lastBidTimestamp;
    uint internal minimumPriceIncrement;

    address internal highestBidder;

    constructor(
        address _sellerAddress,
        address _judgeAddress,
        Timer _timer,
        uint _initialPrice,
        uint _biddingPeriod,
        uint _minimumPriceIncrement
    ) Auction(_sellerAddress, _judgeAddress, _timer) {
        initialPrice = _initialPrice;
        biddingPeriod = _biddingPeriod;
        minimumPriceIncrement = _minimumPriceIncrement;

        // Start the auction at contract creation.
        lastBidTimestamp = time();
    }

    function bid() public payable {
        if(highestBid == 0 && highestBidder == address(0)){
            require(msg.value >= initialPrice, "Bid too low.");
        } else {
            require(msg.value >= highestBid + minimumPriceIncrement, "Bid too low.");
        }

        require(time() - lastBidTimestamp < biddingPeriod, "Bidding is over.");

        if(highestBidder != address(0)){
            uint toReturn = highestBid;
            highestBid = 0;
            payable(highestBidder).transfer(toReturn);
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
        lastBidTimestamp = time();
    }

    function getHighestBidder() public override returns (address){
        if(time() - lastBidTimestamp >= biddingPeriod && outcome == Outcome.NOT_FINISHED){
            if(highestBidder != address(0)){
                finishAuction(Outcome.SUCCESSFUL, highestBidder);
            } else {
                finishAuction(Outcome.NOT_SUCCESSFUL, address(0));
            }
        }
        return highestBidderAddress;
    }

}