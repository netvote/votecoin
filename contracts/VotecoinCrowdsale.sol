pragma solidity ^0.4.11;

import './Votecoin.sol';
import 'zeppelin-solidity/contracts/crowdsale/CappedCrowdsale.sol';

contract VotecoinCrowdsale is CappedCrowdsale {

    //TODO: decide actual duration of crowdsale
    function VotecoinCrowdsale(uint256 _rate, address _wallet, uint256 _cap) CappedCrowdsale (_cap) Crowdsale (now, (now + 1 years), _rate, _wallet) {
        token.transferOwnership(msg.sender);
    }

    function createTokenContract() internal returns (MintableToken) {
        return new Votecoin(30 days);
    }
}