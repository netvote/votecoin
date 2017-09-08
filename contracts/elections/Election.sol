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

  // This is the current stage.
  Stages public stage = Stages.Building;
  Decision[] decisions;
  bytes32[] decisionNames;

  //TODO: hardcode deployed votecoin
  Votecoin public votecoin;
  uint256 votesPerVotecoin;

  mapping (address => bool) public voted;

  struct Decision {
    bytes32 name;
    bytes32[] options;
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

  modifier hasEnoughCoin() {
    require(votecoin.balanceOf(this) >= votesPerVotecoin);
    _;
  }

  function castVote(uint[] selections) voting notVoted {
    require(selections.length == decisions.length);
    purchaseVote();
    for (uint d = 0; d < decisions.length; d++) {
      decisions[d].tally[selections[d]] += getVoteIncrement();
    }
    voted[msg.sender] = true;
  }

  function purchaseVote() internal hasEnoughCoin {
    votecoin.transfer(votecoin.owner(), votesPerVotecoin);
  }

  function getDecisionCount() constant returns (uint256 l) {
    l = decisions.length;
  }

  function getOptionsCount(uint256 decIndex) constant returns (uint256 l){
    l = decisions[decIndex].options.length;
  }

  function getDecisions() constant returns (bytes32[] d){
    d = decisionNames;
  }

  function getOptions(uint256 index) constant returns(bytes32[] o){
    o = decisions[index].options;
  }

  function getDecision(uint256 index) constant returns (bytes32 name){
    name = decisions[index].name;
  }

  function reset() building onlyOwner {
    delete decisions;
    delete decisionNames;
  }

  function activate() building onlyOwner votecoinAddressSet {
    votesPerVotecoin = votecoin.voteRate();
    stage = Stages.Voting;
  }

  function close() onlyOwner {
    stage = Stages.Closed;
  }

  function getOption(uint256 decIndex, uint256 optIndex) constant returns (bytes32 name){
    name = decisions[decIndex].options[optIndex];
  }

  function addDecision(bytes32 name) building onlyOwner {

    decisions.push(Decision({
        name: name,
        options: new bytes32[](0),
        tally: new uint[](0)
    }));

    decisionNames.push(name);
  }

  function addOption(uint256 index, bytes32 option) building onlyOwner {
    decisions[index].options.push(option);
    decisions[index].tally.push(0);
  }

}
