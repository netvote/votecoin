pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Ballot.sol";

contract TestBallot {

    function testInitialization() {
        Ballot b = Ballot(DeployedAddresses.Ballot());

        uint256 expected = 0;
        Assert.equal(b.getDecisionCount(), expected, "Creation should initialize to 0");
    }

    function testAddDecision() {
        Ballot b = new Ballot();

        b.addDecision("President 2020");

        uint256 expected = 1;
        Assert.equal(b.getDecisionCount(), expected, "Creation should add 1 to count");
    }

    function testCastVote(){
        Ballot b = new Ballot();
        b.addDecision("President 2020");
        b.addOption(0, "trump");
        b.addOption(0, "perot");
        b.addVoter(b.getOwner());

        var votes = new uint[](1);

        votes[0] = uint(1);

        b.activate();

        b.castVote(votes);

        uint256 notVotedOptionCount = 0;
        Assert.equal(b.getOptionResults(0, 0), notVotedOptionCount, "Results should be 0");

        uint256 votedOptionCount = 1;
        Assert.equal(b.getOptionResults(0, 1), votedOptionCount, "Results should be 1");

        b.close();
    }

}
