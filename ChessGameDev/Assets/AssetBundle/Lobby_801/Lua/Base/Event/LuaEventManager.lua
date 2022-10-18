LuaEventManager=LuaEventManager or Class()


local Instance=nil
function LuaEventManager:ctor()
	Instance=self
	self.AllEventList={}
end


function LuaEventManager:AddEventListenner(keyName,callBackFunc,obj)
	if keyName==nil or callBackFunc==nil  or obj==nil then
		Debug.LogError("AddEventListenner参数为nil==>")
		return nil
	end
	local tempEvent=self.AllEventList[keyName]
	if tempEvent==nil then
		self.AllEventList[keyName]=PrototypeEvent.New()
	else
		Debug.LogError("绑定多个事件Add==>"..keyName)
	end
	self.AllEventList[keyName]:AddEvent(keyName,obj,callBackFunc)
end


function LuaEventManager:RemoveEventListenner(keyName,obj)
	if keyName==nil or obj==nil then
		Debug.LogError("RemoveEventListenner参数为nil==>")
		return nil
	end
	local tempEvent=self.AllEventList[keyName]
	if tempEvent==nil then
		Debug.LogError("移除事件不存在==>"..keyName)
		return
	end
	self.AllEventList[keyName]:RemoveEvent(keyName,obj)
	self.AllEventList[keyName]=nil
end


function LuaEventManager:RemoveAllEventListenner(keyName)
	local tempEvent=self.AllEventList[keyName]
	if tempEvent==nil then
		Debug.LogError("移除事件不存在==>"..keyName)
		return
	end
	self.AllEventList[keyName]:RemoveAllEvent()
	self.AllEventList[keyName]=nil
end


function LuaEventManager:DispatchEvent(keyName,...)
	local tempEvent=self.AllEventList[keyName]
	if tempEvent==nil then
		Debug.LogError("分发事件不存在==>"..keyName)
		return
	end
	local tempParams={...}
	self.AllEventList[keyName]:DispatchEvent(keyName,tempParams)
end


function LuaEventManager:ContainsKey(key)
	local tempEvent=self.AllEventList[key]
	if tempEvent==nil then
		return false
	else
		return true
	end
end


function LuaEventManager.GetInstance()
	if Instance==nil then
		Instance=LuaEventManager.New()
	end
	return Instance
end
