CSEventManager=CSEventManager or Class()

local Instance=nil
function CSEventManager:ctor()
	Instance=self
	self:Init()
end

function CSEventManager:Init()
	self.CSEventMap={}
end

function CSEventManager:AddEvent(eventName,eventFunc,eventObj)
	local tempEvent=self.CSEventMap[eventName]
	if tempEvent==nil then
		self.CSEventMap[eventName]={}
	end
	if self.CSEventMap[eventName][eventFunc]==nil  then
		self.CSEventMap[eventName][eventFunc]={}
	end
	
	self.CSEventMap[eventName][eventFunc].CallBackFunc=function (...)
		local eventPrams={...}
		eventFunc(eventObj,table.unpack(eventPrams))
	end
	CS.EventManager.instance:AddEvent(eventName,self.CSEventMap[eventName][eventFunc].CallBackFunc)
end

function CSEventManager:RemoveSingleEvent(eventName,eventFunc)
	if self.CSEventMap[eventName] then
		if self.CSEventMap[eventName][eventFunc] then
			CS.EventManager.instance:RemoveSingleEvent(eventName,self.CSEventMap[eventName][eventFunc].CallBackFunc)
			self.CSEventMap[eventName][eventFunc].CallBackFunc=nil
			self.CSEventMap[eventName][eventFunc]=nil
		end 
	else
		--Debug.LogError("移除未通过lua注册的cs事件,eventFunc为CS的delegate")
		CS.EventManager.instance:RemoveSingleEvent(eventName,eventFunc)
	end
	
end


function CSEventManager:RemoveAllEvent(eventName)
	self.CSEventMap[eventName]=nil
	CS.EventManager.instance:RemoveEvent(eventName)
end



function CSEventManager:DispatchEvent(eventName,...)
	local eventPrams={...}
	CS.EventManager.instance:DispatchEvent(eventName,table.unpack(eventPrams))
end

function CSEventManager:ContainsKey(key)
	return CS.EventManager.instance:IsContainsKey(key)
end

function CSEventManager.GetInstance()
	if Instance==nil then
		Instance=CSEventManager.New()
	end
	return Instance
end