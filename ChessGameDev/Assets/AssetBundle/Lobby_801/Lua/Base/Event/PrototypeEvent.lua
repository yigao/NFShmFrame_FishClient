PrototypeEvent=PrototypeEvent or Class()

function PrototypeEvent:ctor()
	self._EventList={}
	self.KeyName=nil
end


function PrototypeEvent:AddEvent(keyName,obj,callBackFunc)
	local tempEvent=self._EventList[keyName]
	if tempEvent==nil then
		self.KeyName=keyName
		--Debug.LogError("添加事件==>"..keyName)
		self._EventList[keyName]={}	
	end
	tempEvent=self._EventList[keyName][obj]
	if tempEvent==nil then
		self._EventList[keyName][obj]={}
	else
		Debug.LogError("再次添加事件==>"..keyName)
	end
	self._EventList[keyName][obj].Self=obj
	self._EventList[keyName][obj].CallBackFunc=callBackFunc
end


function PrototypeEvent:RemoveEvent(keyName,obj)
	if self._EventList and self._EventList[keyName] then
		self._EventList[KeyName][obj]=nil
	else
		Debug.LogError("事件移除失败，不存在Key==>"..keyName)
	end
end


function PrototypeEvent:RemoveAllEvent()
	self._EventList={}
end


function PrototypeEvent:DispatchEvent(keyName,params)
	if self.KeyName and self.KeyName==keyName and self._EventList and self._EventList[self.KeyName] then
		for _,v in pairs(self._EventList[self.KeyName]) do
			if v.CallBackFunc then
				v.CallBackFunc(v.Self,table.unpack(params))
			end
		end
	else
		Debug.LogError("分发事件不存在==>"..keyName)
	end
end



function PrototypeEvent:__delete()
	self._EventList=nil
	self.KeyName=nil
	self=nil
end