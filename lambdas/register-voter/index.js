'use strict';

console.log('Loading function');

const Web3 = require('web3');
const ELECTION_ABI = require('./RegisterableElection.json');

/**
 * Demonstrates a simple HTTP endpoint using API Gateway. You have full
 * access to the request and response payload, including headers and
 * status code.
 *
 * To scan a DynamoDB table, make a GET request with the TableName as a
 * query string parameter. To put, update, or delete an item, make a POST,
 * PUT, or DELETE request respectively, passing in the payload to the
 * DynamoDB API as a JSON body.
 */
exports.handler = (event, context, callback) => {
    console.log('Received event:', JSON.stringify(event, null, 2));
    console.log('Received context:', JSON.stringify(context, null, 2));

    let infuraUrl = process.env.INFURA_URL;
    let infuraToken = process.env.INFURA_TOKEN;

    const done = (err, res) => callback(null, {
        statusCode: err ? '400' : '200',
        body: err ? err.message : JSON.stringify(res),
        headers: {
            'Content-Type': 'application/json',
        },
    });


    let electionId = event.pathParameters.electionId;
    let netvoteKey = event.headers["x-netvote-key"];
    const web3 = new Web3(new Web3.providers.HttpProvider(infuraUrl+infuraToken));

    new web3.eth.Contract(ELECTION_ABI);

    let elections = new web3.eth.Contract(ELECTION_ABI);
    let election = elections.at(electionId);

    console.log("IPFS:",election.methods.getIPFSReference());

    /*
        connect to contract
        register with netvoteKey
        submit payment
     */

    //async
    done(undefined, "success");
};
