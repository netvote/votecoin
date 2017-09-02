pragma solidity ^0.4.11;

import './WeightedElection.sol';
import './PrivateElection.sol';

contract WeightedPrivateElection is WeightedElection, PrivateElection {}