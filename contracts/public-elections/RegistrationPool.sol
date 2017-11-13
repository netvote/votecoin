pragma solidity ^0.4.11;

import '../GasPayer.sol';
import './Election.sol';


contract RegistrationPool is GasPayer {
    mapping (address => bool) public voters;
    mapping (bytes32 => bool) public registrationPins;
    address[] ballotAddresses;

    modifier onlyVoter() {
        require(voters[msg.sender]);
        _;
    }

    function RegistrationPool(address[] ballots, uint gasAmt, bytes32[] hashedPins) GasPayer(gasAmt) payable {
        ballotAddresses = ballots;
        for (uint256 i = 0; i < hashedPins.length; i++) {
            registrationPins[hashedPins[i]] = true;
        }
    }

    function castVotes(string vote) onlyVoter {
        for(uint256 i = 0; i<ballotAddresses.length; i++) {
            Election(ballotAddresses[i]).castVote(i, ballotAddresses, msg.sender, vote);
        }
    }

    function register(string pin, address addr) internal {
        require(!voters[addr]);
        checkPin(pin);
        voters[addr] = true;
    }

    function registerSelf(string pin) {
        register(pin, msg.sender);
    }

    function registerAndPaySelf(string pin) {
        registerSelf(pin);
        payGas(msg.sender);
    }

    function addPins(bytes32[] hashedPins) onlyOwner {
        for (uint256 i = 0; i < hashedPins.length; i++) {
            registrationPins[hashedPins[i]] = true;
        }
    }

    function addPin(bytes32 pinHash) onlyOwner {
        registrationPins[pinHash] = true;
    }

    function removePin(bytes32 pinHash) onlyOwner {
        registrationPins[pinHash] = false;
    }

    function checkPin(string pin) internal {
        var hsh = sha3(pin);
        require(registrationPins[hsh]);
        registrationPins[hsh] = false;
    }

}