local bytes = {}
local out = assert(io.open("testD.tmx", "w"))
local detailFile = assert(io.open("DetailTiles.bin", "rb"))
local mapFile = assert(io.open("Map.bin", "rb"))

local tileset = ""
local stringCheck = mapFile:read("*all")
print(string.byte(stringCheck, 12))
if (string.byte(stringCheck, 12) == 75) then --K
	tileset = "KingTileset"
elseif (string.byte(stringCheck, 12) == 80) then --P
	tileset = "PirateTileset"
elseif (string.byte(stringCheck, 12) == 77) then --M
	tileset = "MarsTileset"
end

local bytE = detailFile:read("*all")
for i = 1, 10000 do
	if (string.byte(bytE, i) == nil) then
		break
	elseif ((i / 2) ~= math.floor(i / 2)) then
		local num = tonumber(string.byte(bytE, i))
		local hexstr = "0123456789ABCDEF"
		local result = ""
		while num > 0 do
			local n = math.fmod(num, 16)
			result = string.format("%s%s", string.sub(hexstr, n + 1, n + 1), result)
			num = math.floor(num / 16)
		end
		if (string.len(result) == 1) then
			result = string.format("%s%s", "0", result)
		end
		if (string.len(result) == 0) then
			result = "00"
		end
	
		local num2 = tonumber(string.byte(bytE, i + 1))
		local hexstr2 = "0123456789ABCDEF"
		local result2 = ""
		while num2 > 0 do
			local n = math.fmod(num2, 16)
			result2 = string.format("%s%s", string.sub(hexstr2, n + 1, n + 1), result2)
			num2 = math.floor(num2 / 16)
		end
		if (string.len(result2) == 1) then
			result2 = string.format("%s%s", "0", result2)
		end
		if (string.len(result2) == 0) then
			result2 = "00"
		end

		bytes[#bytes + 1] = tonumber(string.format("%s%s", result2, result), 16) + 1
	end
end
detailFile:close()

for i = 1, 10000 do
	if (bytes[i] == nil) then
		bytes[i] = "0"
	end
end

out:write(
	"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n",
	"<map version=\"1.8\" tiledversion=\"1.8.4\" orientation=\"orthogonal\" renderorder=\"right-down\" width=\"40\" height=\"40\" tilewidth=\"8\" tileheight=\"8\" infinite=\"0\" nextlayerid=\"2\" nextobjectid=\"1\">\n",
	string.format(" <tileset firstgid=\"1\" source=\"%s.tsj\"/>\n", tileset),
	" <layer id=\"1\" name=\"Tile Layer 1\" width=\"40\" height=\"40\">\n",
    "  <data encoding=\"csv\">\n")
out:close()

out = assert(io.open("testD.tmx", "a"))	
for i = 1, 40 do
	for j = 1, 40 do
		if ( j ~= 40) then
			out:write(string.format("%s,", bytes[((i - 1) * 40) + j]))
		elseif (j == 40) then
			if (i ~= 40) then
				out:write(string.format("%s,\n", bytes[((i - 1) * 40) + j]))
			elseif (i == 40) then
				out:write(string.format("%s\n", bytes[((i - 1) * 40) + j]))
			end
		end
	end
end

out:write(
    "</data>\n",
    " </layer>\n",
    "</map>\n")