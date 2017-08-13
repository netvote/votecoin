pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/token/MintableToken.sol';

contract Votecoin is MintableToken {
    string public name = "Votecoin";
    string public symbol = "VOTE";
    uint public decimals = 18;
}