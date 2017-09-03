pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/elections/Election.sol";

contract TestElection {
    function testInitialization() {
        Election b = new Election();

        uint256 expected = 0;
        Assert.equal(b.getDecisionCount(), expected, "Creation should initialize to 0");
    }

    function testAddDecision() {
        Election b = new Election();

        b.addDecision("President 2020");

        uint256 expected = 1;
        Assert.equal(b.getDecisionCount(), expected, "Creation should add 1 to count");
    }

    function testCastVote(){

        //create ballot with 2 decisions
        Election b = new Election();
        b.addDecision("President 2020");
        b.addOption(0, "trump");
        b.addOption(0, "perot");

        //allow ballot to transact votecoin for voter
        Votecoin v = new Votecoin();
        b.setVotecoin(v);
        v.mint(b.owner(), 100); //enough for a vote
        v.approve(address(b), 100);

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

    function testCastVoteChangePrice(){

        //create ballot with 2 decisions
        Election b = new Election();
        b.addDecision("President 2020");
        b.addOption(0, "trump");
        b.addOption(0, "perot");

        //allow ballot to transact votecoin for voter
        Votecoin v = new Votecoin();
        b.setVotecoin(v);
        v.mint(b.owner(), 200); //enough for a vote
        v.approve(address(b), 200);
        v.setVoteRate(200);

        Assert.equal(v.allowance(b.owner(), address(b)), 200, "Allowance should be 200");

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

    function testCastMultiDecisionVote(){
        //create ballot with 2 decisions
        Election b = new Election();
        b.addDecision("President 2020");
        b.addOption(0, "trump");
        b.addOption(0, "perot");

        b.addDecision("Governor 2020");
        b.addOption(1, "Glavine");
        b.addOption(1, "Smoltz");

        //allow ballot to transact votecoin for voter
        Votecoin v = new Votecoin();
        b.setVotecoin(v);
        v.mint(b.owner(), 100); //enough for a vote
        v.approve(address(b), 100);

        Assert.equal(v.allowance(b.owner(), address(b)), 100, "Allowance should be 100");

        //activate election
        b.activate();

        // vote for perot & glavine (index = 1)
        var votes = new uint[](2);
        votes[0] = uint(1);
        votes[1] = uint(0);
        b.castVote(votes);

        Assert.equal(b.getOptionResults(0, 0), 0, "Trump should be 0");
        Assert.equal(b.getOptionResults(0, 1), 1, "Perot should be 1");
        Assert.equal(b.getOptionResults(1, 0), 1, "Glavine should be 1");
        Assert.equal(b.getOptionResults(1, 1), 0, "Smoltz should be 0");

        b.close();
    }

}