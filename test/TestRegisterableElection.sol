pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/RegisterableElection.sol";
import "./BaseElectionTest.sol";

contract TestRegisterableElection is BaseElectionTest {

    function testRegisterElection(){
        RegisterableElection e = new RegisterableElection();
        addDecisions(e);
        addCoin(e, 100);
        setVoteRate(e, 100);

        var hsh = sha256("fakepin");
        e.addPin(hsh);
        e.register("fakepin");

        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

}
