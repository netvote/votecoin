pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "../contracts/elections/WeightedTokenHolderElection.sol";
import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import "./BaseElectionTest.sol";

contract TestWeightedTokenHolderElection is BaseElectionTest {

    function testDefaultCastTokenHolderVote(){
        MintableToken token = new MintableToken();
        WeightedTokenHolderElection e = new WeightedTokenHolderElection(token);
        token.mint(e.owner(), 1);
        addDecisions(e);
        addCoin(e, 100);
        setVoteRate(e, 100);
        e.activate();
        castVote(e);
        e.close();
        verifyResults(e, 1);
    }

    function testWeightedCastTokenHolderVote(){
        MintableToken token = new MintableToken();
        WeightedTokenHolderElection e = new WeightedTokenHolderElection(token);
        token.mint(e.owner(), 1);
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