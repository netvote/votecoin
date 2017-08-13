# votecoin

This repo contains solidity contracts supporting the netvote platform

## setup
```
npm install -g ethereumjs-testrpc
npm install -g truffle
cd votecoin
npm install zeppelin-solidity
```

## truffle console walkthrough:
```
// deploy the latest ballot 
truffle migrate

// three addresses, just to see coin move around
netvote = web3.eth.accounts[0];
ballotowner = web3.eth.accounts[1];
voter = web3.eth.accounts[2];

// create a ballot
Ballot.new({from: ballotowner}).then((bal) => b = bal);

// initialie votecoin, give self 100, and point ballot to votecoin location (won't normally have to do)
Votecoin.new({from: netvote}).then((vc) => v = vc);
b.setVotecoin(v.address, {from: ballotowner});
v.mint(ballotowner, 100);

// confirm balance
v.balanceOf(ballotowner);

//build ballot
b.addDecision('What is your favorite color?', {from: ballotowner});
b.addOption(0, 'red', {from: ballotowner});
b.addOption(0, 'blue', {from: ballotowner});
b.addOption(0, 'green', {from: ballotowner});

b.addDecision('What is the speed of a swallow?', {from: ballotowner});
b.addOption(1, '50mph', {from: ballotowner});
b.addOption(1, '60mph', {from: ballotowner});
b.addOption(1, 'African or European?', {from: ballotowner});

//add voters (use b.owner() to use creator of ballot's address)
b.addVoter(voter, {from: ballotowner})
//OR make this a public ballot
b.setOpen(true, {from: ballotowner})

//approve the ballot to transact 100 coin on your behalf
v.approve(b.address, 100, {from:ballotowner});

//start voting mode
b.activate({from: ballotowner});

//get questions and convert to ascii
b.getDecisions().then((dl)=>dl.map(d => web3.toAscii(d)))

//get options for each decision Index (right-padded)
b.getOptions(0).then((ol)=>ol.map(o => web3.toAscii(o)))
b.getOptions(1).then((ol)=>ol.map(o => web3.toAscii(o)))

// bug in truffle made me use this constructor
var votes = web3.eth.accounts.constructor(0);
votes.push(0); // red
votes.push(2); // African or European?

// confirm balances
v.balanceOf(ballotowner);  //should be 100
v.balanceOf(netvote); // should be 0

// cast votes defined above (index = decision, value = option index)
b.castVote(votes, {from: voter});

//end voting
b.close({from: ballotowner});

// decision 1 results
b.getOptionResults(0,0).then((bn)=> bn.toNumber())
b.getOptionResults(0,1).then((bn)=> bn.toNumber())
b.getOptionResults(0,2).then((bn)=> bn.toNumber())

// decision 2 results
b.getOptionResults(1,0).then((bn)=> bn.toNumber())
b.getOptionResults(1,1).then((bn)=> bn.toNumber())
b.getOptionResults(1,2).then((bn)=> bn.toNumber())
```
