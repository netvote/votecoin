pragma solidity ^0.4.11;

import './Election.sol';
import 'zeppelin-solidity/contracts/token/ERC20.sol';


contract TokenHolderElection is Election {

    ERC20 tokenAddress;

    function TokenHolderElection(string ref, uint[] optionCounts, address ta, uint gasAmt) Election(ref, optionCounts, gasAmt) payable {
        tokenAddress = ERC20(ta);
    }

    modifier hasBalance() {
        require(tokenAddress.balanceOf(msg.sender) > 0);
        _;
    }

    function castVote(uint[] selections) hasBalance {
        super.castVote(selections);
    }

}