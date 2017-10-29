pragma solidity ^0.4.11;

import './Election.sol';

contract PrivateElection is Election {

    mapping (address => bool) public voters;

    function PrivateElection(string ref, uint[] optionCounts, uint gasAmt) Election(ref, optionCounts, gasAmt) payable {}

    modifier inVoterList() {
        require(voters[msg.sender]);
        _;
    }

    function isVoter() constant returns (bool) {
        return voters[msg.sender];
    }

    function addVoter(address voter) onlyOwner {
        voters[voter] = true;
    }

    function removeVoter(address voter) onlyOwner {
        voters[voter] = false;
    }

    function updateVoterAddress(address from, address to) onlyOwner {
        voters[to] = voters[from];
        voters[from] = false;
    }

    function castVote(uint[] selections) inVoterList {
        super.castVote(selections);
    }

}