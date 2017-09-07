pragma solidity ^0.4.11;

import './PrivateElection.sol';

contract RegisterableElection is PrivateElection {

    mapping (bytes32 => bool) public pinHashes;

    function register(string pin) {
        var hsh = sha256(pin);
        require(pinHashes[hsh]);
        pinHashes[hsh] = false;
        voters[msg.sender] = true;
    }

    function addPin(bytes32 pinHash) {
        pinHashes[pinHash] = true;
    }

    function removePin(bytes32 pinHash){
        pinHashes[pinHash] = false;
    }
}