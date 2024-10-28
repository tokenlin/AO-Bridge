
local bint = require('./process/bint')(256*3+32)

local proofVerify = require("./proofVerify")

-- local discreteEllipticCurve = require('./DiscreteEllipticCurve')

-- local keccak256 = require('./keccak256')


-- local curve = discreteEllipticCurve.DiscreteEllipticCurve(discreteEllipticCurve.secp256k1_curve())

-- local private = bint("0x7f034b6bb7e8275135aec1e661ca342471e5c0d10f6ecdc37a09c3c8c45bedc8")
-- local PP = curve.scalarMul(private)

-- -- print(PP[1])
-- -- print(PP[2])
-- -- print(bint.tobase(PP[1], 16, 1) .. bint.tobase(PP[2], 16, 1))

-- local hash = keccak256.fromHex(bint.tobase(PP[1], 16, 1) .. bint.tobase(PP[2], 16, 1))
-- local address = "0x" .. string.sub(hash, #hash-39, #hash)

-- -- print(hash)
-- print(address)

local proof = "0x3e0a1130170986a28844d9d70c73fcceef2f6feecee41f5296dcce38daaf4a6579be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8d26326f1c17b5a07a1dcb3f417201003d4643bb436f9cefe8c5d813fdf8b56596d11b37ef4fc909ae1ec6c63584f99843f04ea9466730f8e58950c8c7262e6933ca3dd37304995604f567517e8c6e6074de37eab843f91475f713bd062067e61"
print(proofVerify.proofVerify(proof))
