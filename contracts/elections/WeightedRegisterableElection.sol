pragma solidity ^0.4.11;

import './WeightedElection.sol';
import './RegisterableElection.sol';

contract WeightedRegisterableElection is WeightedElection, RegisterableElection {}