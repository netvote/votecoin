pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/ownership/Claimable.sol';
import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract Votecoin is MintableToken, Claimable {
    string public name = "Votecoin";
    string public symbol = "VOTE";
    uint public decimals = 18;

    uint256 pendingVotesPerVotecoin = 1000;
    uint public priceChangeNotice;
    uint public priceChangeDeadline = 0;

    //number of votes per votecoin
    uint256 public votesPerVotecoin = 1000;

    // 18 zeros
    uint256 public votebase = 1000000000000000000;

    // amount subtracted from ballot per vote (calculated on update)
    uint256 public votecoinPerVote = 1000000000000000;

    function Votecoin(uint priceNotice){
        priceChangeNotice = priceNotice;
    }

    modifier priceChangeNoticePassed() {
        require(priceChangeDeadline <= now);
        _;
    }

    function setPendingVotesPerVotecoin(uint256 vtsPerVotecoin) onlyOwner {
        pendingVotesPerVotecoin = vtsPerVotecoin;
        priceChangeDeadline = now + priceChangeNotice;
    }

    function updateVotesPerVotecoin() onlyOwner priceChangeNoticePassed {
        votesPerVotecoin = pendingVotesPerVotecoin;
        votecoinPerVote = votebase / votesPerVotecoin;
    }
}