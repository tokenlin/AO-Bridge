
local bint = require('./process/bint')(256*3+32)

local discreteEllipticCurve = require('./DiscreteEllipticCurve')

local keccak256 = require('./keccak256')


local curve = discreteEllipticCurve.DiscreteEllipticCurve(discreteEllipticCurve.secp256k1_curve())

local private = bint("0x7f034b6bb7e8275135aec1e661ca342471e5c0d10f6ecdc37a09c3c8c45bedc8")
local PP = curve.scalarMul(private)

-- print(PP[1])
-- print(PP[2])
-- print(bint.tobase(PP[1], 16, 1) .. bint.tobase(PP[2], 16, 1))

local hash = keccak256.fromHex(bint.tobase(PP[1], 16, 1) .. bint.tobase(PP[2], 16, 1))
local address = "0x" .. string.sub(hash, #hash-39, #hash)

-- print(hash)
print(address)
