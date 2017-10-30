pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/RepeatableElection.sol";
import "./BaseElectionTest.sol";

contract TestRepeatableElection is BaseElectionTest {

    function testSingleRepeatableVote(){
        var dec = new uint[](0);
        RepeatableElection e = new RepeatableElection("",dec,1, 1000);
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }


    function testMultipleRepeatableVote(){
        var dec = new uint[](0);
        RepeatableElection e = new RepeatableElection("",dec,0, 1000);
        addDecisions(e);
        addCoin(e, 1000000000000000000);
        setVotesPerVotecoin(e, 2);
        e.activate();
        castVote(e);
        castVote(e);
        e.close();
        verifyResults(e, 2);
    }


}
