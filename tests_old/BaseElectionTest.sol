pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/Election.sol";

contract BaseElectionTest {

    function addDecisions(Election e){
        var optionsCounts = new uint[](2);
        optionsCounts[0] = uint(2);
        optionsCounts[1] = uint(2);

        e.setDecisions("0xabc123123123123123123", optionsCounts);
    }

    function setCheap(Election e){
        addCoin(e, 100000000000000000);
        setVotesPerVotecoin(e, 10);
    }

    function setExpensive(Election e){
        addCoin(e, 1000000000000000000);
        setVotesPerVotecoin(e, 1);
    }

    function setVotesPerVotecoin(Election e, uint256 rate){
        Votecoin vc = e.votecoin();
        vc.setPendingVotesPerVotecoin(rate);
        vc.updateVotesPerVotecoin();
    }

    function addCoin(Election e, uint256 cost){
        //allow ballot to transact votecoin for voter
        Votecoin v = new Votecoin(0 seconds);
        e.setVotecoin(v);
        v.mint(e.owner(), cost); //enough for a vote
        v.transfer(address(e), cost);
        Assert.equal(v.balanceOf(e.owner()), 0, "Balance should be 0");
        Assert.equal(v.balanceOf(address(e)), cost, "Balance should be cost");
    }

    function castVote(Election e){
        var votes = new uint[](2);
        votes[0] = uint(1);
        votes[1] = uint(0);
        e.castVote(votes);
    }

    function verifyResults(Election e, uint256 count){
        Assert.equal(e.votecoin().balanceOf(address(e)), 0, "Balance should be 0");
        Assert.equal(e.getOptionResults(0, 0), 0, "Trump should be 0");
        Assert.equal(e.getOptionResults(0, 1), count, "Perot should be 1");
        Assert.equal(e.getOptionResults(1, 0), count, "Glavine should be 1");
        Assert.equal(e.getOptionResults(1, 1), 0, "Smoltz should be 0");
    }

}