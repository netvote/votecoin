pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract GasPayer is Ownable {
    mapping (address => bool) public paid;

    uint public gasAmount;

    function loadGas() payable {

    }

    function setGasAmount(uint gasA) onlyOwner {
        gasAmount = gasA;
    }

    function payGas(address voter) onlyOwner {
        require(!paid[voter]);
        paid[voter] = true;
        voter.transfer(gasAmount);
    }
}