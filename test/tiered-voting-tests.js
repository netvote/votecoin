let LocalElection = artifacts.require("./public-elections/LocalElection.sol");
let ParentElection = artifacts.require("./public-elections/ParentElection.sol");


contract('Base Election', (accounts)=> {
    let federal;
    let state;
    let district;
    let localElection;
    let admin = accounts[1];
    let voter = accounts[2];
    let vote = "encrypted-vote-contents";
    let encryptSeed = "seed";
    let ref = "ipfs";
    let gasAmt = 12345;


    // create elections
    beforeEach(() => {
        return ParentElection.new(ref, {from: admin}).then((e) => {
            federal = e;
            return ParentElection.new(ref, {from: admin})
        }).then((e) => {
            state = e;
            return ParentElection.new(ref, {from: admin})
        }).then((e) => {
            district = e;
            return LocalElection.new([district.address, state.address, federal.address], gasAmt, {from: admin});
        }).then ((e) => {
            localElection = e;
            return federal.addSender(localElection.address, {from: admin}).then(()=>{
                return state.addSender(localElection.address, {from: admin})
            }).then(()=>{
                return district.addSender(localElection.address, {from: admin})
            });
        }).then (() => {
            return federal.activate({from: admin})
        }).then(() => {
            return state.activate({from: admin})
        }).then(() => {
            return district.activate({from: admin})
        })
    });

    it("Cast Hierarchical Vote", ()=>{
       return localElection.castVotes(vote, encryptSeed, {from: voter}).then(() => {
           return federal.groupResult(district.address, 0, {from: admin})
       }).then((res) => {
           assert.equal(res, vote, "expected district vote to exist");
           return federal.groupResult(state.address, 0, {from: admin})
       }).then((res) => {
           assert.equal(res, vote, "expected state vote to exist");
           return federal.groupResult(federal.address, 0, {from: admin})
       }).then((res) => {
           assert.equal(res, vote, "expected federal vote to exist");
       })
    });


});