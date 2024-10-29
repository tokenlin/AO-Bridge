
const url = 'https://cu.ao-testnet.xyz/dry-run?process-id=OKo3TSifCu4Q_4_fUo7XrAQq9_WaDuYzKaxoEFY4VBw';


const proof = "0x3e0a1130170986a28844d9d70c73fcceef2f6feecee41f5296dcce38daaf4a6579be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8d26326f1c17b5a07a1dcb3f417201003d4643bb436f9cefe8c5d813fdf8b56596d11b37ef4fc909ae1ec6c63584f99843f04ea9466730f8e58950c8c7262e6933ca3dd37304995604f567517e8c6e6074de37eab843f91475f713bd062067e61"


const data = {"Id":"1234","Target":"OKo3TSifCu4Q_4_fUo7XrAQq9_WaDuYzKaxoEFY4VBw","Owner":"1234","Anchor":"0","Data": proof,"Tags":[{"name":"Action","value":"Verify"},{"name":"Data-Protocol","value":"ao"},{"name":"Type","value":"Message"},{"name":"Variant","value":"ao.TN.1"}]}


const apiResponseTrans = await Functions.makeHttpRequest({
url: url,
method: 'POST',
headers: {
  'Content-Type': 'application/json'
},
data: data
});

if (apiResponseTrans.error) {
  throw Error(`Get text failed`);
  }

const result = apiResponseTrans.data.Messages[0].Data;

return Functions.encodeString(result);

