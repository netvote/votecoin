pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/TokenHolderElection.sol";
import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import "./BaseElectionTest.sol";

contract TestTokenHolderElection is BaseElectionTest {

    function testCastTokenHolderVote(){
        // test token
        MintableToken token = new MintableToken();
        TokenHolderElection e = new TokenHolderElection(token);

        // grant token to owner so he is now token-owner
        token.mint(e.owner(), 1);

        addDecisions(e);
        addCoin(e, 100);
        setVoteRate(e, 100);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

}