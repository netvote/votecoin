pragma solidity ^0.4.11;

import './Election.sol';

contract RepeatableElection is Election {

    mapping (address => uint) public lastVote;
    uint public secondsBetweenVote;

    function RepeatableElection(uint secBetweenVote){
        secondsBetweenVote = secBetweenVote;
    }

    modifier enoughTimeElapsed(){
        require(lastVote[msg.sender] == 0 || lastVote[msg.sender] <= (now - secondsBetweenVote));
        _;
    }

    function castVote(uint[] selections) enoughTimeElapsed {
        lastVote[msg.sender] = now;
        super.castVote(selections);
        voted[msg.sender] = false;
    }

}