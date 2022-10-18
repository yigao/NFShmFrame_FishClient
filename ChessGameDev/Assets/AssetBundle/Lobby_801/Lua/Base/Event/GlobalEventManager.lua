--Lua端统一使用此接口
GlobalEventManager=GlobalEventManager or Class()

local Instance=nil
function GlobalEventManager:ctor()
	Instance=self
	self:Init()
end

function GlobalEventManager:Init()
	
end



function GlobalEventManager:AddLuaEvent(eventName,eventFunc,eventObj)
	LuaEventManager.GetInstance():AddEventListenner(eventName,eventFunc,eventObj)
end


function GlobalEventManager:AddCSEvent(eventName,eventFunc,eventObj)
	CSEventManager.GetInstance():AddEvent(eventName,eventFunc,eventObj)
end



function GlobalEventManager:RemoveEvent(eventName,IsCSEvent)
	if IsCSEvent==nil or IsCSEvent==false then
		LuaEventManager.GetInstance():RemoveAllEventListenner(eventName)
	else
		CSEventManager.GetInstance():RemoveAllEvent(eventName)
	end
end


function GlobalEventManager:DispatchEvent(eventName,IsCSEvent,...)
	local tempData={...}
	if IsCSEvent==nil or IsCSEvent==false then
		LuaEventManager.GetInstance():DispatchEvent(eventName,...)
	else
		CSEventManager.GetInstance():DispatchEvent(eventName,...)
	end
end

function GlobalEventManager:ContainsKey(eventName,IsCSEvent)
	if IsCSEvent==nil or IsCSEvent==false then
		return LuaEventManager.GetInstance():ContainsKey(eventName)
	else
		return CSEventManager.GetInstance():ContainsKey(eventName)
	end
end

function GlobalEventManager.GetInstance()
	if Instance==nil then
		Instance=GlobalEventManager.New()
	end
	return Instance
end