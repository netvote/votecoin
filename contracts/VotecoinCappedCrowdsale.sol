pragma solidity ^0.4.11;

import './Votecoin.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';

contract VotecoinCappedCrowdsale is CappedCrowdsale {

    function VotecoinCappedCrowdsale(uint256 _startBlock, uint256 _endBlock, uint256 _rate, address _wallet, uint256 _cap) CappedCrowdsale (_cap) Crowdsale (_startBlock, _endBlock, _rate, _wallet) {
        token.transferOwnership(msg.sender);
    }

    function createTokenContract() internal returns (MintableToken) {
        return new Votecoin(0 seconds);
    }
}