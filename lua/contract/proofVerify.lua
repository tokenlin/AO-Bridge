local bint = require('./process/bint')(256*3+32)

local discreteEllipticCurve = require('./DiscreteEllipticCurve')

local keccak256 = require('./keccak256')


function proofVerify(proof)

    local n = bint("0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141")

    local curve = discreteEllipticCurve.DiscreteEllipticCurve(discreteEllipticCurve.secp256k1_curve())

    proof = string.gsub(proof, "0x", "")

    local s = bint("0x" .. string.sub(proof, 1, 64))
    local B = {bint("0x" .. string.sub(proof, 65, 128)), bint("0x" .. string.sub(proof, 129, 192))}
    local c = bint("0x" .. string.sub(proof, 193, 256))
    c = discreteEllipticCurve.bigIntMod(c, n);

    local publicKey = {bint("0x" .. string.sub(proof, 257, 320)), bint("0x" .. string.sub(proof, 321, 384))}

    local sB = curve.scalarMulWithBasePoint(s, B);

    local cP = curve.scalarMulWithBasePoint(c, publicKey);

    local R = curve.add(sB, cP);

    local strForHash =  bint.tobase(B[1], 16, 1) .. bint.tobase(B[2], 16, 1)
    strForHash = strForHash .. string.sub(proof, 257, 384)
    strForHash = strForHash .. bint.tobase(R[1], 16, 1) .. bint.tobase(R[2], 16, 1)

    local hashByteStr = keccak256.fromHex(strForHash);


    
    local c_proof = discreteEllipticCurve.bigIntMod(bint(hashByteStr), n);

    if c_proof == c then 
        return true
    else
        return false
    end
    -- print(bint.tobase(R[1], 16, 1) .. bint.tobase(R[2], 16, 1))
    -- print(c_proof)
    -- print(c)
    -- print(s)
    -- print(B[1])
    -- print(B[2])
    -- print(c)
end


return {
    proofVerify=proofVerify
}