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

// create a ballot
Ballot.new().then((bal) => b = bal);

//build ballot
b.addDecision('What is your favorite color?');
b.addOption(0, 'red');
b.addOption(0, 'blue');
b.addOption(0, 'green');

b.addDecision('What is the speed of a swallow?')
b.addOption(1, '50mph');
b.addOption(1, '60mph');
b.addOption(1, 'African or European?');

//add voters (use b.owner() to use creator of ballot's address)
b.owner().then((o)=> b.addVoter(o))

//start voting mode
b.activate();

//get questions and convert to ascii
b.getDecisions().then((dl)=>dl.map(d => web3.toAscii(d)))

//get options for each decision Index (right-padded)
b.getOptions(0).then((ol)=>ol.map(o => web3.toAscii(o)))
b.getOptions(1).then((ol)=>ol.map(o => web3.toAscii(o)))

// open the polls
b.activate();

// bug in truffle made me use this constructor
var votes = web3.eth.accounts.constructor(0);
votes.push(0); // red
votes.push(2); // African or European?

// cast votes defined above (index = decision, value = option index)
b.castVote(votes);

//end voting
b.close();

// decision 1 results
b.getOptionResults(0,0).then((bn)=> bn.toNumber())
b.getOptionResults(0,1).then((bn)=> bn.toNumber())
b.getOptionResults(0,2).then((bn)=> bn.toNumber())

// decision 2 results
b.getOptionResults(1,0).then((bn)=> bn.toNumber())
b.getOptionResults(1,1).then((bn)=> bn.toNumber())
b.getOptionResults(1,2).then((bn)=> bn.toNumber())
```
