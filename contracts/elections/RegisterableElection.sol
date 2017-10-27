pragma solidity ^0.4.11;

import './PrivateElection.sol';

contract RegisterableElection is PrivateElection {

    mapping (bytes32 => bool) public pinHashes;

    //TODO: this is Netvote payer account
    address registrar = 0x8b2927a8c6c2b67e6bd29fc869eb03a5ac99f14d;

    function RegisterableElection(string ref, uint[] optionCounts) PrivateElection(ref, optionCounts) {}

    modifier onlyRegistrar() {
        require(msg.sender == registrar || msg.sender == owner);
        _;
    }

    function registerSelf(string pin) {
        require(!voters[msg.sender]);
        checkPin(pin);
        voters[msg.sender] = true;
    }

    function register(string pin, address addr) onlyRegistrar {
        require(!voters[addr]);
        checkPin(pin);
        voters[addr] = true;
    }

    function registerAndPay(string pin, address addr) onlyRegistrar {
        require(!voters[addr]);
        checkPin(pin);
        voters[addr] = true;
        payGas(addr);
    }

    function addPins(bytes32[] hashedPins) onlyOwner{
        for (uint256 i = 0; i < hashedPins.length; i++) {
            pinHashes[hashedPins[i]] = true;
        }
    }

    function addPin(bytes32 pinHash) onlyOwner {
        pinHashes[pinHash] = true;
    }

    function removePin(bytes32 pinHash) onlyOwner {
        pinHashes[pinHash] = false;
    }

    function checkPin(string pin) {
        var hsh = sha3(pin);
        require(pinHashes[hsh]);
        pinHashes[hsh] = false;
    }
}