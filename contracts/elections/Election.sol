pragma solidity ^0.4.11;

import '../Votecoin.sol';
import '../GasPayer.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Election is Ownable, GasPayer {

  enum Stages {
    Building,
    Voting,
    Closed
  }

  string ipfsReference;

  // This is the current stage.
  Stages public stage = Stages.Building;
  Decision[] decisions;

  //TODO: hardcode deployed votecoin
  Votecoin public votecoin;
  uint256 votecoinPerVote;

  mapping (address => bool) public voted;

  struct Decision {
    uint[] tally;
  }

  struct Option {
    bytes32 name;
  }

  //TODO: will not be needed eventually
  modifier votecoinAddressSet() {
    require(address(0) != address(votecoin));
    _;
  }

  //TODO: just for testing
  //TODO: DANGER DANGER - DO NOT GO LIVE WITH THIS IMPLEMENTED, VC ADDRESS MUST BE HARDCODED
  //TODO: If this is implemented, any ballot owner can just print their own votecoin and use it
  //TODO: did I mention DANGER?
  function setVotecoin(address v) building onlyOwner {
    votecoin = Votecoin(v);
  }

  function getOptionResults(uint256 d, uint256 o) constant returns (uint res){
    res = decisions[d].tally[o];
  }

  // how many votes to increment when this voter votes?
  function getVoteIncrement() constant returns (uint res){
    res = 1;
  }

  modifier building() {
    require(stage == Stages.Building);
    _;
  }

  modifier voting() {
    require(stage == Stages.Voting);
    _;
  }

  modifier notVoted() {
    require(!voted[msg.sender]);
    _;
  }

  function currentPrice() internal returns (uint) {
    var latestVotecoinPerVote = votecoin.votecoinPerVote();
    if (latestVotecoinPerVote < votecoinPerVote) {
      return latestVotecoinPerVote;
    } else {
      return votecoinPerVote;
    }
  }

  function purchaseVote() internal {
    var price = currentPrice();
    require(votecoin.balanceOf(this) >= price);
    votecoin.transfer(votecoin.owner(), price);
  }

  // ADMIN ACTIONS
  function activate() building onlyOwner votecoinAddressSet {
    votecoinPerVote = votecoin.votecoinPerVote();
    stage = Stages.Voting;
  }

  // permanently end election
  function close() onlyOwner {
    stage = Stages.Closed;
  }

  function setDecisions(string ipfsJsonReference, uint[] optionCounts) building onlyOwner {
    ipfsReference = ipfsJsonReference;
    delete decisions;
    for (uint256 i = 0; i < optionCounts.length; i++) {
      decisions.push(Decision({
        tally: new uint[](optionCounts[i])
      }));
    }
  }

  // VOTER ACTIONS

  function getIPFSReference() constant returns (string ipRef) {
    return ipfsReference;
  }

  function castVote(uint[] selections) voting notVoted {
    require(selections.length == decisions.length);
    purchaseVote();
    for (uint d = 0; d < decisions.length; d++) {
      decisions[d].tally[selections[d]] += getVoteIncrement();
    }
    voted[msg.sender] = true;
  }

}
