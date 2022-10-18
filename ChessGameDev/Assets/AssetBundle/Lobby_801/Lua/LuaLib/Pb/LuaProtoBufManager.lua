LuaProtoBufManager = {}

local pb = require 'pb'
local protoc = require 'H/Lua/LuaLib/Pb/protoc'

function LuaProtoBufManager.LoadProtocFiles(protocFileName)
    local file = CSScript.LuaManager:GetProtoFile(protocFileName)
    -- Debug.LogError("Load ProtocFiles: "..file)
	local data=file
	if CSScript.LuaManager.DeveloperMode==false then
		data=CSScript.XTable(0,nil,nil,file)
	end
	LuaProtoBufManager.CheckLoad(data)
     --assert(protoc:load(file))
end

function LuaProtoBufManager.Encode(mesgName, data)
    local bytes = assert(pb.encode(mesgName, data))
    return bytes
end


function LuaProtoBufManager.Decode(mesgName, bytes)
	local data = assert(pb.decode(mesgName, bytes))
	return data
end

function LuaProtoBufManager.Enum( mesgName,field)
    return pb.enum(mesgName, field)
end


function LuaProtoBufManager.Clear(typeName)
	assert(pb.clear(typeName) )
end

function LuaProtoBufManager.Type(typeName)
	return pb.type(typeName)
end


function LuaProtoBufManager.CheckLoad(chunk, name)
	local pbdata = protoc.new():compile(chunk, name)
	local ret, offset = pb.load(pbdata)
	if not ret then
		error("load error at "..offset..
            "\nproto: "..chunk..
            "\ndata: "..pbdata)
	end
end


      


