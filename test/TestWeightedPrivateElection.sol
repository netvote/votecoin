pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/WeightedPrivateElection.sol";
import "./BaseElectionTest.sol";

contract TestWeightedPrivateElection is BaseElectionTest {

    function testCastVoteDefault(){
        WeightedPrivateElection e = new WeightedPrivateElection();
        e.addVoter(e.owner());
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testCastVoteWeighted(){
        WeightedPrivateElection e = new WeightedPrivateElection();
        e.addVoter(e.owner());
        e.setWeight(e.owner(), 2);
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 2);
    }

}