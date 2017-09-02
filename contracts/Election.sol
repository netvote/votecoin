pragma solidity ^0.4.11;

import './Votecoin.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Election is Ownable {

  enum Stages {
    Building,
    Voting,
    Closed
  }

  // This is the current stage.
  Stages public stage = Stages.Building;
  Decision[] decisions;
  bytes32[] decisionNames;
  bool public open = false;

  //TODO: hardcode deployed votecoin
  Votecoin votecoin;

  mapping (address => bool) public voted;
  mapping (address => bool) public voters;

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

  modifier building() {
    require(stage == Stages.Building);
    _;
  }

  modifier voting() {
    require(stage == Stages.Voting);
    _;
  }

  modifier canVote() {
    require((open || voters[msg.sender]) && !voted[msg.sender]);
    _;
  }

  function castVote(uint[] selections) voting canVote {
    require(selections.length == decisions.length);
    purchaseVote();
    for (uint d = 0; d < decisions.length; d++) {
      decisions[d].tally[selections[d]]++;
    }
    voted[msg.sender] = true;
  }

  //TODO: implement this
  function getRate() internal constant returns (uint256) {
    return 100;
  }

  function purchaseVote() internal {
    uint256 r = getRate();
    require(votecoin.allowance(owner, this) >= r);
    votecoin.transferFrom(owner, votecoin.owner(), r);
  }

  function addVoter(address voter) building onlyOwner {
    voters[voter] = true;
  }

  function removeVoter(address voter) building onlyOwner {
    voters[voter] = false;
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

  function setOpen(bool o) building onlyOwner {
    open = o;
  }

  function reset() building onlyOwner {
    delete decisions;
    delete decisionNames;
  }

  function activate() building onlyOwner votecoinAddressSet {
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
