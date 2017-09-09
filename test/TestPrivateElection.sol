pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/PrivateElection.sol";
import "./BaseElectionTest.sol";

contract TestPrivateElection is BaseElectionTest {

    function testUpdateAddress(){
        PrivateElection b = new PrivateElection();
        b.addVoter(b.owner());
        Assert.equal(b.voters(b.owner()), true, "Owner should be true");
        Assert.equal(b.voters(address(b)), false, "Address should be false");

        b.updateVoterAddress(b.owner(), address(b));
        Assert.equal(b.voters(b.owner()), false, "Owner should be true");
        Assert.equal(b.voters(address(b)), true, "Address should be false");
    }

    function testCastPrivateVote(){
        //create ballot with 2 decisions
        PrivateElection e = new PrivateElection();
        e.addVoter(e.owner());
        addDecisions(e);
        setCheap(e);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

}
