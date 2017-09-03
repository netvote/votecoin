pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/RepeatableElection.sol";
import "./BaseElectionTest.sol";

contract TestRepeatableElection is BaseElectionTest {

    function testSingleRepeatableVote(){
        RepeatableElection e = new RepeatableElection(1);
        addDecisions(e);
        addCoin(e, 100);
        setVoteRate(e, 100);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }


    function testMultipleRepeatableVote(){
        RepeatableElection e = new RepeatableElection(0);
        addDecisions(e);
        addCoin(e, 200);
        setVoteRate(e, 100);
        e.activate();
        castVote(e);
        castVote(e);
        e.close();
        verifyResults(e, 2);
    }


}
