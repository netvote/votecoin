pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/elections/Election.sol";
import "./BaseElectionTest.sol";

contract TestElection is BaseElectionTest {
    function testInitialization() {
        Election b = new Election();
        bytes32 expected = "";
        Assert.equal(b.getIPFSReference(), expected, "reference should be empty");
    }

    function testCastVote(){
        Election e = new Election();
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testCastVoteChangePrice(){
        Election e = new Election();
        addDecisions(e);
        setExpensive(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testLowerPriceDuringElection(){
        Election e = new Election();
        addDecisions(e);

        // start with expensive
        addCoin(e, 100000000000000000);
        setVotesPerVotecoin(e, 1);

        e.activate();

        // lower price
        setVotesPerVotecoin(e, 10);

        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

}