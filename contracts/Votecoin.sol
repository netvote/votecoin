pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/ownership/Claimable.sol';
import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract Votecoin is MintableToken, Claimable {
    string public name = "Votecoin";
    string public symbol = "VOTE";
    uint public decimals = 18;

    uint256 public voteRate = 100;

    function setVoteRate(uint256 vr) onlyOwner {
        voteRate = vr;
    }
}