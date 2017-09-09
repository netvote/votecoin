pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/WeightedElection.sol";
import "./BaseElectionTest.sol";

contract TestWeightedElection is BaseElectionTest {

    function testCastVoteDefault(){
        WeightedElection e = new WeightedElection();
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testCastVoteWeighted(){
        WeightedElection e = new WeightedElection();
        e.setWeight(e.owner(), 2);
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 2);
    }

}