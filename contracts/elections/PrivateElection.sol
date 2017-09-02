pragma solidity ^0.4.11;

import './Election.sol';

contract PrivateElection is Election {

    mapping (address => bool) public voters;

    modifier inVoterList() {
        require(voters[msg.sender]);
        _;
    }

    function addVoter(address voter) building onlyOwner {
        voters[voter] = true;
    }

    function removeVoter(address voter) building onlyOwner {
        voters[voter] = false;
    }

    function castVote(uint[] selections) inVoterList {
        super.castVote(selections);
    }

}