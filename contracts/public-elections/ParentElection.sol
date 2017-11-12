pragma solidity ^0.4.11;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract ParentElection is Ownable {

    enum Stages {
        Building,
        Voting,
        Closed
    }

    function ParentElection(string ref) {
        ipfsReference = ref;
    }

    Stages public stage = Stages.Building;
    string public ipfsReference;

    struct GroupVotes {
        address[] voterList;
    }

    mapping (address => string) voterVotes;
    mapping (address => bool) voterVoted;
    mapping (address => GroupVotes) groupVotes;
    mapping (address => string) encryptionSeeds;
    mapping (address => bool) allowedSenders;

    // for iteration of votes/groups
    address[] voterList;
    address[] groupList;

    function addSender(address sender) onlyOwner {
        allowedSenders[sender] = true;
    }

    function addSenders(address[] senders) onlyOwner {
        for (uint256 i = 0; i < senders.length; i++) {
            allowedSenders[senders[i]] = true;
        }
    }

    modifier building() {
        require(stage == Stages.Building);
        _;
    }

    modifier voting() {
        require(stage == Stages.Voting);
        _;
    }

    function activate() building {
        stage = Stages.Voting;
    }

    // e.g., get district results for state election
    function groupResult(address group, uint256 index) constant returns (string) {
        return voterVotes[groupVotes[group].voterList[index]];
    }

    function castVote(uint256 index, address[] ballots, string vote, string encryptionSeed) voting {
        require(ballots[index] == address(this));
        require(!voterVoted[tx.origin]);
        require(allowedSenders[msg.sender]);

        voterVoted[tx.origin] = true;
        encryptionSeeds[tx.origin] = encryptionSeed;
        voterList.push(tx.origin);
        voterVotes[tx.origin] = vote;
        for (uint256 i = 0; i <= index; i++) {
            groupVotes[ballots[i]].voterList.push(tx.origin);
        }
    }

}