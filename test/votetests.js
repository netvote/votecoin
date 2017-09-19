let Election = artifacts.require("./elections/Election.sol");
let VotecoinCrowdsale = artifacts.require("./VotecoinCrowdsale.sol");
let Votecoin = artifacts.require("./Votecoin.sol");

let balanceToCoin = function(b){
    return web3.fromWei(b.valueOf(), 'ether');
};

let coin = function(coinCount){
    return web3.toWei(1 * coinCount, "ether")
};

let clean = function(txt) {
    return web3.toAscii(txt).replace(/\0/g, "");
};

let addDecisions = function(election, admin) {
  return election.setDecisions("0x123123123123123", [2,2], {from: admin});
};

contract('Election', (accounts)=>{

    let election;
    let voteCoin;
    let admin = accounts[1];
    let voter = accounts[2];

    // setup account 1 with 10 Votecoin
    beforeEach(()=>{
        let voteCrowdsale;
        return VotecoinCrowdsale.deployed().then((crowdsale)=>{
            voteCrowdsale = crowdsale;
            return crowdsale.token()
        }).then((tokenAddr)=>{
            voteCoin = Votecoin.at(tokenAddr);
            return voteCoin.balanceOf(admin);
        }).then((bal)=>{
            assert.equal(bal, 0, "account should start with 0 coin");
            return voteCrowdsale.sendTransaction({ from: admin, value: web3.toWei(1, "ether")});
        }).then( (result)=>{
            return voteCoin.balanceOf(admin)
        }).then((bal)=>{
            let expected = 10;
            assert.equal(balanceToCoin(bal), expected, "account should end with "+expected+" coin")
        }).then(()=>{
            // create and activate election
            return Election.new({from: admin}).then((e)=>{
                election = e;
                //TODO: this is something we just do for testing
                return election.setVotecoin(voteCoin.address, {from: admin})
            }).then(()=>{
                return voteCoin.transfer(election.address, coin(1), {from: admin})
            }).then(()=>{
                return voteCoin.balanceOf(election.address)
            }).then((bal)=>{
                assert.equal(balanceToCoin(bal), 1, "election should have 1 votecoin")
                return addDecisions(election, admin)
            }).then(()=>{
                return election.activate({from: admin});
            }).then(()=>{
                return election.getOptionResults(0,0)
            }).then((res)=>{
                assert.equal(res, 0, "option 0,0 should have 0 votes")
            }).then(()=>{
                return election.getOptionResults(0,1)
            }).then((res)=>{
                assert.equal(res, 0, "option 0,1 should have 0 votes")
            }).then(()=>{
                return election.getOptionResults(1,0)
            }).then((res)=>{
                assert.equal(res, 0, "option 1,0 should have 0 votes")
            }).then(()=>{
                return election.getOptionResults(1,1)
            }).then((res)=>{
                assert.equal(res, 0, "option 1,1 should have 0 votes")
            })
        })
    });

    it("vote for election",  ()=>{
        let votes = web3.eth.accounts.constructor(0);
        votes.push(0); // red
        votes.push(1); // African or European?

        return election.castVote(votes, {from: voter}).then(()=>{
            return election.getOptionResults(0,0)
        }).then((res)=>{
            assert.equal(res, 1, "option 0,0 should have 1 votes")
        }).then(()=>{
            return election.getOptionResults(0,1)
        }).then((res)=>{
            assert.equal(res, 0, "option 0,1 should have 0 votes")
        }).then(()=>{
            return election.getOptionResults(1,0)
        }).then((res)=>{
            assert.equal(res, 0, "option 1,0 should have 0 votes")
        }).then(()=>{
            return election.getOptionResults(1,1)
        }).then((res)=>{
            assert.equal(res, 1, "option 1,1 should have 1 votes")
        }).then(()=>{
            return voteCoin.balanceOf(election.address)
        }).then((bal)=> {
            assert.equal(balanceToCoin(bal), .999, "election should have .9 votecoin")
        });
    });
});

contract('VotecoinCrowdsale', (accounts)=>{
    it("purchase of 1 ETH worth of VOTE yields 10", ()=>{
        let voteCrowdsale;
        let voteCoin;
        let acct = accounts[1];
        return VotecoinCrowdsale.deployed().then((crowdsale)=>{
            voteCrowdsale = crowdsale;
            return crowdsale.token()
        }).then((tokenAddr)=>{
            voteCoin = Votecoin.at(tokenAddr);
            return voteCoin.balanceOf(acct);
        }).then((bal)=>{
            assert.equal(bal, 0, "account should start with 0 coin");
            return voteCrowdsale.sendTransaction({ from: acct, value: web3.toWei(1, "ether")});
        }).then((result)=>{
            return voteCoin.balanceOf(acct)
        }).then((bal)=>{
            let vcBalance = web3.fromWei(bal.valueOf(), 'ether');
            assert.equal(vcBalance, 10, "account should end with 10 coin")
        })
    });

    it("purchase of 1 VOTE for .1 ETH",  ()=>{
        let voteCrowdsale;
        let voteCoin;
        let acct = accounts[2];
        return VotecoinCrowdsale.deployed().then((crowdsale)=>{
            voteCrowdsale = crowdsale;
            return crowdsale.token()
        }).then( (tokenAddr)=>{
            voteCoin = Votecoin.at(tokenAddr);
            return voteCoin.balanceOf(acct)
        }).then( (bal)=>{
            assert.equal(bal, 0, "account 1 should start with 0 coin");
            return voteCrowdsale.sendTransaction({ from: acct, value: web3.toWei(.1, "ether")});
        }).then( (result)=>{
            return voteCoin.balanceOf(acct)
        }).then((bal)=>{
            let vcBalance = web3.fromWei(bal.valueOf(), 'ether');
            let expected = 1;
            assert.equal(vcBalance, expected, "account 1 should end with "+expected+" coin")
        })
    });
});