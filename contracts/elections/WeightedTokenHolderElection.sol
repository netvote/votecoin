pragma solidity ^0.4.11;

import './WeightedElection.sol';
import './TokenHolderElection.sol';

contract WeightedTokenHolderElection is WeightedElection, TokenHolderElection {

    function WeightedTokenHolderElection(address ta) TokenHolderElection(ta) {}

}