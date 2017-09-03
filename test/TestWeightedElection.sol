pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/WeightedElection.sol";
import "./BaseElectionTest.sol";

contract TestWeightedElection is BaseElectionTest {

    function testCastVoteDefault(){
        WeightedElection e = new WeightedElection();
        addDecisions(e);
        addCoin(e, 100);
        setVoteRate(e, 100);
        e.activate();
        castVote(e);
        e.close();
    }

    function testCastVoteWeighted(){
        WeightedElection e = new WeightedElection();
        e.setWeight(e.owner(), 2);
        addDecisions(e);
        addCoin(e, 100);
        setVoteRate(e, 100);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 2);
    }

}