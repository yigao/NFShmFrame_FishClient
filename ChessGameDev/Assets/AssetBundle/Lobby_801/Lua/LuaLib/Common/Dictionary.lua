Dictionary = {}

function Dictionary:New(tk, tv)
    local o = {keyType = tk, valueType = tv}
    setmetatable(o, self)
    self.__index = self
    o.keyList = {}
    return o
end

function Dictionary:Add(key, value)
    if self[key] == nil then
        self[key] = value
        table.insert(self.keyList, key)
    else
        self[key] = value
    end
end

function Dictionary:Clear()
    local count = self:Count()
    for i=count,1,-1 do
        self[self.keyList[i]] = nil
        table.remove(self.keyList)
    end
end

function Dictionary:ContainsKey(key)
    local count = self:Count()
    for i=1,count do
        if self.keyList[i] == key then
            return true
        end
    end
    return false
end

function Dictionary:ContainsValue(value)
    local count = self:Count()
    for i=1,count do
        if self[self.keyList[i]] == value then
            return true
        end
    end
    return false
end

function Dictionary:Count()
    return #(self.keyList)
end

function Dictionary:Iter(action)
    if (action == nil or type(action) ~= 'function') then
        print('action is invalid!')
        return
    end
    local count = self:Count()
    for i=1, count do
        local key = self.keyList[i];
        local value = self[key]
        action(key, value)
    end
end

function Dictionary:Remove(key)
    if self:ContainsKey(key) then
        local count = self:Count()
        for i=1,count do
            if self.keyList[i] == key then
                table.remove(self.keyList, i)
                break
            end
        end
        self[key] = nil
    end
end

function Dictionary:KeyType()
    return self.keyType
end

function Dictionary:ValueType()
    return self.valueType
end

--[[--如何使用
local dic = Dictionary:New('string', 'string')
dic:Add('BeiJing', '010')
dic:Add('ShangHai', '021')
 
while true do
    local it = dic:Iter()
    if it ~= nil then
        local key = it()
        local value = dic[key]
        print('key: ' .. tostring(key) .. ' value: ' .. tostring(value))
    else
        break
    end
end
]]--