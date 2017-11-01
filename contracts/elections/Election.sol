pragma solidity ^0.4.11;

import '../GasPayer.sol';
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Election is GasPayer {

  enum Stages {
    Building,
    Voting,
    Closed
  }

  string ipfsReference;

  // This is the current stage.
  Stages public stage = Stages.Building;
  Decision[] decisions;

  uint256 public voteCount;

  mapping (address => bool) public voted;

  struct Decision {
    uint[] tally;
  }

  struct Option {
    bytes32 name;
  }

  function Election(string ref, uint[] optionCounts, uint gasAmt) GasPayer(gasAmt) payable {
    ipfsReference = ref;
    for (uint256 i = 0; i < optionCounts.length; i++) {
      decisions.push(Decision({
        tally: new uint[](optionCounts[i])
      }));
    }
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

  function purchaseVote() internal {
    //TODO: decrement from price contract
    voteCount++;
  }

  // ADMIN ACTIONS
  function activate() building onlyOwner {
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
