pragma solidity ^0.4.4;


contract Ballot {

  address public owner;

  Decision[] decisions;
  bytes32[] decisionNames;
  bool activated;

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

  function Ballot(){
    owner = msg.sender;
  }

  function castVote(uint256[] selections){
    require(voters[msg.sender] && !voted[msg.sender] && optionCount == decisions.length);

    s = 0;
    for (uint d = 0; d < decisions.length; d++) {
      decisions[d].tally[s] = selections[s];
    }
  }

  function addVoter(address voter) {
    require(owner == msg.sender);
    voters[voter] = true;
  }

  function removeVoter(address voter) {
    require(owner == msg.sender);
    voters[voter] = false;
  }

  function getOwner() constant returns (address own){
    own = msg.sender;
  }

  function getDecisionCount() constant returns (uint256 l){
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

  function reset(){
    delete decisions;
    delete decisionNames;
  }

  function activate(){
    activated = true;
  }

  function getOption(uint256 decIndex, uint256 optIndex) constant returns (bytes32 name){
    name = decisions[decIndex].options[optIndex];
  }

  function addDecision(bytes32 name) {
    require(owner == msg.sender);

    decisions.push(Decision({
        name: name,
        options: new bytes32[](0),
        tally: new uint[](0)
    }));

    decisionNames.push(name);
  }

  function addOption(uint256 index, bytes32 option){
    require(owner == msg.sender);
    decisions[index].options.push(option);
    decisions[index].tally.push(0);
  }

}
