pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/elections/Election.sol";
import "./BaseElectionTest.sol";

contract TestElection is BaseElectionTest {
    function testInitialization() {
        var dec = new uint[](0);
        Election b = new Election("",dec, 1000);
    }

    function testCastVote(){
        var dec = new uint[](0);
        Election e = new Election("",dec, 1000);
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testCastVoteChangePrice(){
        var dec = new uint[](0);
        Election e = new Election("",dec, 1000);
        addDecisions(e);
        setExpensive(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testLowerPriceDuringElection(){
        var dec = new uint[](0);
        Election e = new Election("",dec, 1000);
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