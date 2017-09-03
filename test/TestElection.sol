pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/elections/Election.sol";
import "./BaseElectionTest.sol";

contract TestElection is BaseElectionTest {
    function testInitialization() {
        Election b = new Election();
        uint256 expected = 0;
        Assert.equal(b.getDecisionCount(), expected, "Creation should initialize to 0");
    }

    function testCastVote(){
        Election e = new Election();
        addDecisions(e);
        addCoin(e, 100);
        setVoteRate(e, 100);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testCastVoteChangePrice(){
        Election e = new Election();
        addDecisions(e);
        addCoin(e, 200);
        setVoteRate(e, 200);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

}