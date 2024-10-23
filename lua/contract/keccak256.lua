local sha3 = require('./process/crypto/digest/sha3')

local keccak256 = {}
function keccak256.fromStr(data)
	assert(type(data) == 'string', 'string is required!')
	return "0x" .. sha3.keccak256(data).asHex()
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
	return "0x" .. sha3.keccak256(_data).asHex()
end

return keccak256
