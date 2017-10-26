let VotecoinCrowdsale = artifacts.require("./VotecoinCrowdsale.sol");

module.exports = function(deployer, network) {
  console.log("network = "+network);
  const startTime = 1509033903132;
  const endTime = 1540579715718;
  const rate = 10;
  const totalSupply = 10000000;
  const weiCap = web3.toWei(0.1, "ether") * totalSupply;

  if (network === "ropsten") {
      console.log("deploying crowdsale to ropsten");

      // web3.eth.getBlock("latest", function(err,result){
      //     let limit = result.gasLimit;
      //     // this is steven
      //     const wallet = "0x74ecf4529b8d0fb84dbcf512b6f4cbc0ffadd690";
      //     console.log("starting deploy");
      //     deployer.deploy(VotecoinCrowdsale, rate, wallet, weiCap, {gas: (limit-1) });
      // });

  } else {
      const wallet = web3.eth.accounts[0];
      const weiCap = web3.toWei(0.1, "ether") * totalSupply;
      deployer.deploy(VotecoinCrowdsale, startTime, endTime, rate, wallet, weiCap);
  }
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