migrate --reset


r.loadGas({value: web3.toWei(1, "ether")});
r.setGasAmount(web3.toWei(0.25, "ether"));
r.addPin("firstpin");