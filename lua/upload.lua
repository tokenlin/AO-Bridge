
local bint = require('.bint')(256*3+32)
local crypto = require(".crypto");
local sha3_keccak256 = crypto.digest.keccak256
local ao = require('ao')





function secp256k1_curve()
    local a = bint(0)
    local b = bint(7)

    -- // field
    -- // p = 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f
    -- let p = 115792089237316195423570985008687907853269984665640564039457584007908834671663n;
    local p = bint("0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffefffffc2f")

    -- // generator
    -- // G = [0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798, 0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8]
    -- let G = [55066263022277343669578718895168534326250603453777594175500187360389116729240n, 32670510020758816978083085130507043184471273380659243275938904335757337482424n];
    local G = {bint("0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798"), bint("0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8")}

    -- // cyclic groups of prime order
    -- // n = 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141
    -- let n = 115792089237316195423570985008687907852837564279074904382605163141518161494337n;
    local n = bint("0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141")

    -- // n_half = 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0
    -- // n_half = 57896044618658097711785492504343953926418782139537452191302581570759080747168n;  // n / 2
    -- let n_half = n / 2n;
    local n_half =  bint.idivmod(n, 2)

    return a, b, p, G, n, n_half
end


-- // x % p
function bigIntMod(x, p)
  local idiv, imod = bint.idivmod(x, p)
  return imod
end


-- // Calculate(x**y % z) efficiently
function powMod(x,y,z)
  local xy = bint.ipow(x, y)
  return bigIntMod(xy, z)
end


-- // x / p
function bigIntDiv(x, p)
  local idiv, imod = bint.idivmod(x, p)
  return idiv
end


function bigIntToBinaryStr(bigNum)
  local idiv = bigNum
  local imod
  local binaryStr = ""
  while(idiv ~= bint(0))
  do
    idiv, imod = bint.idivmod(idiv, bint(2))
    if imod == bint(0) then
      binaryStr = "0" .. binaryStr
    else
      binaryStr = "1" .. binaryStr
    end
  end
  return binaryStr
end

function extendedEuclideanAlgorithm(a, b)

  local s, old_s = bint(0), bint(1)
  local t, old_t = bint(1), bint(0)
  local r, old_r = b, a

  while(r ~= bint(0))
  do
    local quotient = bigIntDiv(old_r, r)
    old_r, r = r, old_r - quotient * r
    old_s, s = s, old_s - quotient * s
    old_t, t = t, old_t - quotient * t
  end

  return old_r, old_s, old_t
end



function inverseOf(n, p)

  local gcd, x, y = extendedEuclideanAlgorithm(n, p);

  assert(bigIntMod((n * x + p * y), p) == gcd, 'gcd error')

  assert(gcd == bint(1), 'no multiplicative inverse')

  return bigIntMod(x, p)
end


function gcd(a, b)
  if b == bint(0) then
    return a
  else
      return gcd(b, bigIntMod(a, b))
  end
end


function DiscreteEllipticCurve(a_in, b_in, p_in, G_in, n_in, n_half_in)
      local self = {}

      local function init()
          assert( 4 * bint.ipow(a_in,3) + 27 * bint.ipow(b_in, 2) ~= bint(0), 'curve contains singularities')
          self.a = a_in
          self.b = b_in
          self.p = p_in
          self.G = G_in
          self.n = n_in
          self.n_half = n_half_in
          self.P = {bint(0), bint(0)}
          self.R = {bint(0), bint(0)}
      end
      init()

      self.check_on_curve = function(point)
          if bigIntMod((bint.ipow(point[1], 3) + self.a * point[1] + self.b - bint.ipow(point[2], 2)), self.p) == bint(0) then
            return true
          else
            return false
          end
      end

      self.scalarMul = function(n)
        return self.scalarMulWithBasePoint(n, self.G)
      end

      self.scalarMulWithBasePoint = function(n, P)

          if P[1] == bint(0) and P[2] == bint(0) then return {bint(0), bint(0)} end  --// for P = [0n, 0n]
          if n == bint(0) then return {bint(0), bint(0)} end

        

          assert(self.check_on_curve(P) == true, 'scalarMul Error')

         

          n = bigIntMod(n, self.n)
          self.R = {bint(0), bint(0)}
          self.P = P;

          local bitString = bigIntToBinaryStr(n)  --// 11010101010...
          for i=1, #bitString do
              local str = string.sub(bitString, #bitString-i+1, #bitString-i+1)
              if str == "1" then self.R = self.add(self.P, self.R) end
              self.P = self.add(self.P, self.P)
          
          end

          return self.R
      end



      self.add = function(P1, P2)
          if P1[1] == bint(0) and P1[2] == bint(0) or P2[1] == bint(0) and P2[2] == bint(0) then
              if P1[1] == bint(0) then
                return P2
              else
                return P1
              end
          end

          local x1 =P1[1]
          local y1 =P1[2]
          local x2 =P2[1]
          local y2 =P2[2]

          local flag = 1

          local member
          local denominator
          local gcd_value

          assert(self.check_on_curve(P1) == true, "P1 is not in curve")
          assert(self.check_on_curve(P2) == true, "P2 is not in curve")

          if P1[1] == P2[1] and P1[2] == P2[2] then
              member = 3 * bint.ipow(x1, 2) + self.a
              denominator = 2 * y1
    
          else
              member = y2 - y1
              denominator = x2 - x1
              if member * denominator < bint(0) then
                  flag = 0
                  --// member = abs(member);
                  --// denominator = abs(denominator);
                  if member < bint(0) then member = -member end
                  if denominator < bint(0) then denominator = -denominator end
              end
          end
          gcd_value = gcd(member, denominator);
          

          member = bigIntDiv(member, gcd_value);
          
          denominator = bigIntDiv(denominator, gcd_value);
          
          local inverse_value = inverseOf(denominator, self.p);

          local k = (member * inverse_value)
          if flag == 0 then k = -k end
      
          k = bigIntMod(k, self.p);
          local x3 = bigIntMod((bint.ipow(k, 2) - x1 - x2), self.p)
          local y3 = bigIntMod((k * (x1 - x3) - y1), self.p)
          return {x3, y3}

      end


     return self
end







local keccak256 = {}
function keccak256.fromStr(data)
	assert(type(data) == 'string', 'string is required!')
	return "0x" .. sha3_keccak256(data).asHex()
end
-- data = "0x616f" or "616f" (string "ao")
function keccak256.fromHex(data)
	assert(type(data) == 'string', 'string is required!')
	assert(#data % 2 == 0, 'even length is required!')
	data = string.gsub(data, "0x", "")
	local _data = ""
	for i=1, #data, 2 do
		local str = string.sub(data, i, i+1)
		local num = tonumber(str, 16)
		_data = _data .. string.char(num)
		-- print(#_data, _data)
	end
	return "0x" .. sha3_keccak256(_data).asHex()
end









function proofVerify(proof)

    local n = bint("0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364141")

    local curve = DiscreteEllipticCurve(secp256k1_curve())

    proof = string.gsub(proof, "0x", "")

    local s = bint("0x" .. string.sub(proof, 1, 64))
    local B = {bint("0x" .. string.sub(proof, 65, 128)), bint("0x" .. string.sub(proof, 129, 192))}
    local c = bint("0x" .. string.sub(proof, 193, 256))
    c = bigIntMod(c, n);

    local publicKey = {bint("0x" .. string.sub(proof, 257, 320)), bint("0x" .. string.sub(proof, 321, 384))}

    local sB = curve.scalarMulWithBasePoint(s, B);

    local cP = curve.scalarMulWithBasePoint(c, publicKey);

    local R = curve.add(sB, cP);

    local strForHash =  bint.tobase(B[1], 16, 1) .. bint.tobase(B[2], 16, 1)
    strForHash = strForHash .. string.sub(proof, 257, 384)
    strForHash = strForHash .. bint.tobase(R[1], 16, 1) .. bint.tobase(R[2], 16, 1)

    local hashByteStr = keccak256.fromHex(strForHash);


    
    local c_proof = bigIntMod(bint(hashByteStr), n);

    if c_proof == c then 
        return "true"
    else
        return "false"
    end
    -- print(bint.tobase(R[1], 16, 1) .. bint.tobase(R[2], 16, 1))
    -- print(c_proof)
    -- print(c)
    -- print(s)
    -- print(B[1])
    -- print(B[2])
    -- print(c)
end




VerifyResult = VerifyResult or {}

Handlers.add('verify', Handlers.utils.hasMatchingTag('Action', 'Verify'), function(msg)
  local _hash = keccak256.fromHex(msg.Data)
  local _result = proofVerify(msg.Data)
  VerifyResult[_hash] = _result
  ao.send({
    Target = msg.From,
    Data=_result
    -- Data = msg.Data .. "--ok"
  })
end)


Handlers.add('getVerifyResult', Handlers.utils.hasMatchingTag('Action', 'GetVerifyResult'), function(msg)
  local _hash = keccak256.fromHex(msg.Data)
  ao.send({
    Target = msg.From,
    Data=VerifyResult[_hash]
    -- Data = msg.Data .. "--ok"
  })
end)



-- local proof = "0x3e0a1130170986a28844d9d70c73fcceef2f6feecee41f5296dcce38daaf4a6579be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8d26326f1c17b5a07a1dcb3f417201003d4643bb436f9cefe8c5d813fdf8b56596d11b37ef4fc909ae1ec6c63584f99843f04ea9466730f8e58950c8c7262e6933ca3dd37304995604f567517e8c6e6074de37eab843f91475f713bd062067e61"
-- print(proofVerify(proof))

