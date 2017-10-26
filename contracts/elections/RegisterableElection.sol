pragma solidity ^0.4.11;

import './PrivateElection.sol';

contract RegisterableElection is PrivateElection {

    mapping (bytes32 => bool) public pinHashes;

    function RegisterableElection(string ref, uint[] optionCounts) PrivateElection(ref, optionCounts) {}

    function register(string pin) {
        var hsh = sha3(pin);
        require(pinHashes[hsh]);
        pinHashes[hsh] = false;
        voters[msg.sender] = true;
        super.payGas(msg.sender);
    }

    function addPin(bytes32 pinHash) onlyOwner {
        pinHashes[pinHash] = true;
    }

    function removePin(bytes32 pinHash) onlyOwner {
        pinHashes[pinHash] = false;
    }
}