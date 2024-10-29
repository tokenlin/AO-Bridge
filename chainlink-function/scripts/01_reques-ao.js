
const { Contract } = require("ethers");
const fs = require("fs");
const path = require("path");
const { signer } = require("../connection.js");
const abi = require("../package/abi/FunctionsConsumer.json");


// sepolia test
const consumerAddress = "0xbc38276Aa222cf14f45449a6A55baeDf164813c7";
const subscriptionId = "1759";


const sendRequest = async () => {
  if (!consumerAddress || !subscriptionId) {
    throw Error("Missing required environment variables.");
  }

  const functionsConsumer = new Contract(consumerAddress, abi, signer);

  const source = fs
    .readFileSync(path.resolve(__dirname, "./source-ao.js"))
    .toString();


  const callbackGasLimit = 300_000;  // 300_000;


  console.log("\n Sending the Request....")
  const requestTx = await functionsConsumer.sendRequest(
    source,
    [],
    [],
    subscriptionId,
    callbackGasLimit
  );

  const txReceipt = await requestTx.wait(1);
 
  console.log(
    `Request made.  TxHash is ${requestTx.hash}`
  );
  
  console.log("");

};

sendRequest().catch(err => {
  console.log("\nError making the Functions Request : ", err);
});

