'use strict';

console.log('Loading function');

const ELECTION_ABI = require('./RegisterableElection.json').abi;
const ethereumRemote = require('ethereumjs-remote');

exports.handler = (event, context, callback) => {
    console.log('Received event:', JSON.stringify(event, null, 2));
    console.log('Received context:', JSON.stringify(context, null, 2));

    let url = process.env.INFURA_URL;
    let token = process.env.INFURA_TOKEN;
    let ethAddress = process.env.ETH_ADDRESS;
    let ethKey = process.env.ETH_KEY;

    const done = (err, res) => callback(null, {
        statusCode: err ? '400' : '200',
        body: err ? err.message : JSON.stringify(res),
        headers: {
            'Content-Type': 'application/json',
        },
    });

    let electionId = event.pathParameters.electionId;
    let netvoteKey = event.headers["x-netvote-key"];
    let netvoteAddress = event.headers["x-netvote-address"];

    ethereumRemote.sendTransaction({
        from: ethAddress,
        privateKey: ethKey,
        contractAddress: electionId,
        abi: ELECTION_ABI,
        functionName: 'registerAndPay',
        functionArguments: [netvoteKey, netvoteAddress],
        provider: url+token,
        gasLimit: 4500036
    })
        .then(txHash => done(undefined, txHash))
        .catch(err => done(err, "error from transaction"));
};

// used for basic connectivity testing
exports.getIPFSReference = (event, context, callback) => {
    console.log('Received event:', JSON.stringify(event, null, 2));
    console.log('Received context:', JSON.stringify(context, null, 2));

    let url = process.env.INFURA_URL;
    let token = process.env.INFURA_TOKEN;

    const done = (err, res) => callback(null, {
        statusCode: err ? '400' : '200',
        body: err ? err.message : JSON.stringify(res),
        headers: {
            'Content-Type': 'application/json',
        },
    });

    let electionId = event.pathParameters.electionId;
    ethereumRemote.call({
        contractAddress: electionId,
        abi: ELECTION_ABI,
        functionName: 'getIPFSReference',
        functionArguments: [],
        provider: url+token
    })
        .then(ref => done(undefined, ref))
        .catch(err => done(err, "error from transaction"));
};