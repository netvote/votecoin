# Base Election Types

These are implemented as separate contracts as to avoid excess gas cost in evaluating the configuration.  More complex elections will cost more, but the more basic elections will cost less.

## Election

Base class for all other elections.  By default, any valid ETH address can vote once.

## Private Election

Only voters included in the specified list may vote once.  Others may not vote.

## Registerable Election

A PrivateElection that also has a list of one-time-use hashed pins (sha256) can be specified in advance.  Any address can submit a valid pin to register its address for voting.

## Token Holder Election

Only voters can hold a balance > 0 for the specified ERC20 token address may vote.

## Weighted Election

The owner may allocate more vote increments to a voter.  For instance, allocating a 2 will allow a voter to cast two votes when they vote.  Default is 1.

## Repeatable Election

An open election where any voter may vote every specified number of seconds.

## Combinations of Above

- Weighted Private Election
- Weighted Registerable Election
- Weighted Token Holder Election
