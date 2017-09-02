pragma solidity ^0.4.11;

import './Election.sol';
import 'zeppelin-solidity/contracts/token/ERC20.sol';


contract WeightedElection is Election {

    mapping (address => uint256) voteWeight;

    function setWeight(address vtr, uint weight) building onlyOwner {
        require(weight > 0);
        voteWeight[vtr] = weight;
    }

    function getVoteIncrement() constant returns (uint res){
        if (voteWeight[msg.sender] == 0) {
            return 1;
        }
        return voteWeight[msg.sender];
    }
}