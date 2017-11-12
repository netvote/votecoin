pragma solidity ^0.4.11;

import '../GasPayer.sol';
import './ParentElection.sol';


//TODO: add registration of voter
contract LocalElection is GasPayer {

    address[] ballotAddresses;

    function LocalElection(address[] ballots, uint gasAmt) GasPayer(gasAmt) payable {
        ballotAddresses = ballots;
    }

    function castVotes(string vote, string encryptionSeed){
        for(uint256 i = 0; i<ballotAddresses.length; i++) {
            ParentElection(ballotAddresses[i]).castVote(i, ballotAddresses, vote, encryptionSeed);
        }
    }
}