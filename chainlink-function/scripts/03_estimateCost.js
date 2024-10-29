// const { ethers } = require("hardhat");
const ethers = require("ethers");
const {provider, signer } = require("../connection.js");


const abi= [
  "function estimateCost(uint64 subscriptionId, bytes memory data, uint32 callbackGasLimit, uint256 gasPriceWei) external view returns (uint96)"
];

// sepolia testnet
// billedCost Cost in Juels (1e18) of LINK
// only estimate, this will be blocked inadvance.
const consumerAddress = "0x1d4ad17b358120619796Da07264539b621511c34";  // sepolia, Chainlink functionsBilling
const subscriptionId = "1759";

const readResponse = async() => {
  
  const functionsConsumer =  new ethers.Contract(consumerAddress, abi, signer); 

  
  const gasPriceWei = (await provider.getFeeData()).gasPrice;
  console.log("gasPriceWei: ", gasPriceWei);  

  const estimateCostJuels = await functionsConsumer.estimateCost(
    subscriptionId,
    "0x",
    300000n,
    gasPriceWei
  );

  console.log("estimateCostJuels: ", estimateCostJuels);

  console.log("");
  
};

readResponse().catch(err => {
  console.log("Error reading response: ", err);
});
