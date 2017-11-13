let LocalElection = artifacts.require("./public-elections/LocalElection.sol");
let ParentElection = artifacts.require("./public-elections/ParentElection.sol");


contract('Base Election', (accounts)=> {
    let federal;
    let state;
    let district1;
    let district2;
    let localElection1;
    let localElection2;
    let admin = accounts[1];
    let voter1 = accounts[2];
    let voter2 = accounts[3];
    let vote1 = "encrypted-vote-contents1";
    let vote2 = "encrypted-vote-contents2";
    let encryptSeed = "seed";
    let ref = "ipfs";
    let gasAmt = 12345;
    let pin = "password";

    // create elections
    beforeEach(() => {
        return ParentElection.new(ref, {from: admin}).then((e) => {
            federal = e;
            return ParentElection.new(ref, {from: admin})
        }).then((e) => {
            state = e;
            return ParentElection.new(ref, {from: admin})
        }).then((e) => {
            district1 = e;
            return ParentElection.new(ref, {from: admin})
        }).then((e) => {
            district2 = e;
            return LocalElection.new([district1.address, state.address, federal.address], gasAmt, [web3.sha3(pin)], {from: admin});
        }).then((e) => {
            localElection1 = e;
            return LocalElection.new([district2.address, state.address, federal.address], gasAmt, [web3.sha3(pin)], {from: admin});
        }).then ((e) => {
            localElection2 = e;
            return federal.addSender(localElection1.address, {from: admin}).then(()=>{
                return state.addSender(localElection1.address, {from: admin})
            }).then(()=>{
                return district1.addSender(localElection1.address, {from: admin})
            });
        }).then (() => {
            return federal.addSender(localElection2.address, {from: admin}).then(()=>{
                return state.addSender(localElection2.address, {from: admin})
            }).then(()=>{
                return district2.addSender(localElection2.address, {from: admin})
            });
        }).then (() => {
            return localElection1.registerSelf(pin, {from: voter1});
        }).then (() => {
            return localElection2.registerSelf(pin, {from: voter2});
        }).then (() => {
            return federal.activate({from: admin})
        }).then(() => {
            return state.activate({from: admin})
        }).then(() => {
            return district1.activate({from: admin})
        }).then(() => {
            return district2.activate({from: admin})
        }).then(() => {
            return localElection1.castVotes(vote1, encryptSeed, {from: voter1})
        }).then(() => {
            return localElection2.castVotes(vote2, encryptSeed, {from: voter2})
        })
    });

    it("Federal Results", ()=>{
       return federal.groupResult(district1.address, 0, {from: admin}).then((res) => {
           assert.equal(res, vote1, "expected district 1 vote to exist");
           return federal.groupResult(district2.address, 0, {from: admin})
       }).then((res) => {
           assert.equal(res, vote2, "expected district 2 vote to exist");
           return federal.groupResult(state.address, 0, {from: admin})
       }).then((res) => {
           assert.equal(res, vote1, "expected state vote to exist");
           return federal.groupResult(federal.address, 0, {from: admin})
       }).then((res) => {
           assert.equal(res, vote1, "expected federal vote to exist");
       })
    });

    it("State Results", ()=>{
        return state.groupResult(district1.address, 0, {from: admin}).then((res) => {
            assert.equal(res, vote1, "expected district 1 vote to exist");
            return state.groupResult(district2.address, 0, {from: admin})
        }).then((res) => {
            assert.equal(res, vote2, "expected district 2 vote to exist");
            return state.groupResult(state.address, 0, {from: admin})
        }).then((res) => {
            assert.equal(res, vote1, "expected state vote to exist");
        })
    });

    it("District 1 Results", ()=>{
        return district1.groupResult(district1.address, 0, {from: admin}).then((res) => {
            assert.equal(res, vote1, "expected district 1 vote to exist");
        })
    });

    it("District 2 Results", ()=>{
        return district2.groupResult(district2.address, 0, {from: admin}).then((res) => {
            assert.equal(res, vote2, "expected district 2 vote to exist");
        })
    });


});