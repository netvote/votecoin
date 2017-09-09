pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/WeightedRegisterableElection.sol";
import "./BaseElectionTest.sol";

contract TestWeightedRegisterableElection is BaseElectionTest {

    function testCastVoteDefault(){
        WeightedRegisterableElection e = new WeightedRegisterableElection();
        addDecisions(e);
        setCheap(e);

        var hsh = sha256("fakepin");
        e.addPin(hsh);
        e.register("fakepin");

        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testCastVoteMultiple(){
        WeightedRegisterableElection e = new WeightedRegisterableElection();
        addDecisions(e);
        setCheap(e);

        var hsh = sha256("fakepin");
        e.addPin(hsh);
        e.register("fakepin");

        e.setWeight(e.owner(), 2);


        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 2);
    }

}