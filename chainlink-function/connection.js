// require("@chainlink/env-enc").config();  // for .env.enc
require('dotenv').config();  // for .env

// const { providers, Wallet } = require("ethers");
const {ethers} = require("hardhat");



const RPC_URL = process.env.RPC_ENDPOINT;
const PRIVATE_KEY = process.env.USER_PRIVATE_KEY;

// console.log(RPC_URL);
// console.log(PRIVATE_KEY);


if (!RPC_URL) {
  throw new Error("Please set the RPC_URL environment variable");
}


// const provider = new providers.JsonRpcProvider(RPC_URL);
// const wallet = new Wallet(PRIVATE_KEY || "UNSET");
// const signer = wallet.connect(provider);

// new providers.JsonRpcProvider

const provider = new ethers.providers.JsonRpcProvider(RPC_URL);  // for ethers@5.7.2, not empty
const wallet = new ethers.Wallet(PRIVATE_KEY || "UNSET");
const signer = wallet.connect(provider);


// console.log(provider);


module.exports = { provider, wallet, signer };
