pragma solidity ^0.4.4;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Ballot is Ownable {

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
    uint256 s = 0;
    for (uint d = 0; d < decisions.length; d++) {
      decisions[d].tally[selections[s]]++;
      s++;
    }
    voted[msg.sender] = true;
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

  function addCoin(){

  }

  function removeCoin(){

  }

  function activate() building onlyOwner {
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
