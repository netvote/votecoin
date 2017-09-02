pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "../contracts/elections/WeightedTokenHolderElection.sol";

contract TestWeightedTokenHolderElection {

    function testCastVote(){

        Votecoin token = new Votecoin();

        //create ballot with 2 decisions
        WeightedTokenHolderElection b = new WeightedTokenHolderElection(token);
        b.addDecision("President 2020");
        b.addOption(0, "trump");
        b.addOption(0, "perot");

        //allow ballot to transact votecoin for voter
        Votecoin v = new Votecoin();
        b.setVotecoin(v);
        v.mint(b.owner(), 100); //enough for a vote
        v.approve(address(b), 100);

        token.mint(b.owner(), 1);

        Assert.equal(v.allowance(b.owner(), address(b)), 100, "Allowance should be 100");

        //activate election
        b.activate();

        // vote for perot (index = 1)
        var votes = new uint[](1);
        votes[0] = uint(1);
        b.castVote(votes);

        Assert.equal(v.allowance(b.owner(), address(b)), 0, "Allowance should be 0");

        uint256 notVotedOptionCount = 0;
        Assert.equal(b.getOptionResults(0, 0), notVotedOptionCount, "Results should be 0");

        uint256 votedOptionCount = 1;
        Assert.equal(b.getOptionResults(0, 1), votedOptionCount, "Results should be 1");

        b.close();
    }

    function testCastVoteWeighted(){

        Votecoin token = new Votecoin();

        //create ballot with 2 decisions
        WeightedTokenHolderElection b = new WeightedTokenHolderElection(token);
        b.addDecision("President 2020");
        b.addOption(0, "trump");
        b.addOption(0, "perot");

        //allow ballot to transact votecoin for voter
        Votecoin v = new Votecoin();
        b.setVotecoin(v);
        v.mint(b.owner(), 100); //enough for a vote
        v.approve(address(b), 100);

        token.mint(b.owner(), 1);

        b.setWeight(b.owner(), 2);

        Assert.equal(v.allowance(b.owner(), address(b)), 100, "Allowance should be 100");

        //activate election
        b.activate();

        // vote for perot (index = 1)
        var votes = new uint[](1);
        votes[0] = uint(1);
        b.castVote(votes);

        Assert.equal(v.allowance(b.owner(), address(b)), 0, "Allowance should be 0");

        uint256 notVotedOptionCount = 0;
        Assert.equal(b.getOptionResults(0, 0), notVotedOptionCount, "Results should be 0");

        uint256 votedOptionCount = 2;
        Assert.equal(b.getOptionResults(0, 1), votedOptionCount, "Results should be 1");

        b.close();
    }


}