var Election = artifacts.require("./Election.sol");
var VotecoinCappedCrowdsale = artifacts.require("./VotecoinCappedCrowdsale.sol");

module.exports = function(deployer) {
  deployer.deploy(Election);

  const startBlock = web3.eth.blockNumber + 2;
  const endBlock = startBlock + 300;
  const rate = 40;
  const wallet = web3.eth.accounts[0];

  const totalSupply = 20000000;
  const weiCap = web3.toWei(0.025, "ether") * totalSupply;

  deployer.deploy(VotecoinCappedCrowdsale, startBlock, endBlock, rate, wallet, weiCap);
};

/*

Example console commands:
truffle migrate
account1 = web3.eth.accounts[1]
VotecoinCappedCrowdsale.deployed().then(inst => { crowdsale = inst })
crowdsale.token().then(addr => { tokenAddress = addr } )
voteCoinInstance = Votecoin.at(tokenAddress)
voteCoinInstance.balanceOf(account1).then(balance => balance.toString(10))
crowdsale.sendTransaction({ from: account1, value: web3.toWei(0.025, "ether")})
voteCoinInstance.balanceOf(account1).then(balance => balance.toString(10))


 */