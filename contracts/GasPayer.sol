pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract GasPayer is Ownable {

    mapping (address => bool) public paid;
    mapping (address => bool) public withdrawn;

    //TODO: this is Netvote payer account
    address payer = 0x8b2927a8c6c2b67e6bd29fc869eb03a5ac99f14d;
    uint public gasAmount;

    function GasPayer(uint gasAmt) Ownable() payable {
        gasAmount = gasAmt;
    }

    modifier onlyPayer() {
        require(msg.sender == payer || msg.sender == owner);
        _;
    }

    modifier onlyPayee() {
        require(paid[msg.sender] && !withdrawn[msg.sender]);
        _;
    }

    function loadGas() payable {

    }

    function setGasAmount(uint gasA) onlyOwner {
        gasAmount = gasA;
    }

    function payGas(address voter) onlyPayer {
        require(!paid[voter]);
        paid[voter] = true;
        voter.transfer(gasAmount);
    }

}