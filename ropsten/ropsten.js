let RegisterableElection = artifacts.require("./elections/RegisterableElection.sol");
let Votecoin = artifacts.require("./Votecoin.sol");

module.exports = function(callback) {
    let election, votecoin;

    RegisterableElection.new("test",[2,2], [web3.sha3("password")], 1000).then((re) => {
        console.log("created election: "+re.address);
        election = re;
        return re.votecoin();
    }).then((vc) => {
        votecoin = Votecoin.at(vc);
        return votecoin.transfer(election.address, web3.toWei(1, "ether"))
    }).then((res)=>{
        console.log("transferred 1 vote");
        return election.votesLeft()
    }).then((left)=>{
        console.log("votes left in contract: "+left);
    })
};