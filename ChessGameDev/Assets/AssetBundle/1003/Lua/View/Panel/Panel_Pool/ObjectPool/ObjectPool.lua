ObjectPool=Class()


function ObjectPool:ctor()
	self:InitData()

end


function ObjectPool:InitData()
	self.PrototypeObjectList={}	--游戏对象原型列表
	self.ObjectPoolList={}		--游戏对象池列表
	self.InitCount=10
end


function ObjectPool:RegisterPrototype(gameObj,keyName)
	if not self:FindIsHaveKey(keyName,self.PrototypeObjectList) then
		self.PrototypeObjectList[keyName]=gameObj		
	else
		--Debug.Log("已经存在原型对象"..keyName)
	end	
	
end

function ObjectPool:AddObjectPool(gameObj,number,keyName,poolType)
	if keyName==false then
		keyName=gameObj.name
	end
	if not self:FindIsHaveKey(keyName,self.ObjectPoolList) then
		self.ObjectPoolList[keyName]={}		
	end
	
	self:RegisterPrototype(gameObj,keyName)
	
	for i=1,number do
		local tempObj=CommonHelper.Instantiate(gameObj)
		tempObj.name=keyName
		CommonHelper.SetActive(tempObj,false)
		self:SetPoolParent(tempObj,poolType)
		table.insert(self.ObjectPoolList[keyName],tempObj)
	end
	
end


function ObjectPool:SetPoolParent(gameObj,poolType)
	local parentObj=GameObjectPoolManager.GetInstance().PoolList[poolType]
	if parentObj then
		if gameObj.transform.parent then
			if gameObj.transform.parent.name==parentObj.name then
				return
			end
		end
		CommonHelper.AddToParentGameObjectAndSetPS(gameObj,parentObj,CSScript.Vector3(0,5000,0),CSScript.Vector3.one)
	else
		Debug.LogError("创建Pool失败poolType==>"..poolType)
	end
	
end



function ObjectPool:GetGameObject(gameObjName,poolType)
	if self:FindIsHaveKey(gameObjName,self.ObjectPoolList) then
		local tempObj=self:GetActiveGameObject(gameObjName)
		if tempObj~=nil then
			return tempObj
		else
			--Debug.LogError("keyName值不够使用,继续生成==>"..gameObjName)
			local tempPoolObj=self.PrototypeObjectList[gameObjName]
			if tempPoolObj==nil then
				Debug.LogError(gameObjName.."对象池原型列表中并不存在")
				return nil
			else
				self:AddObjectPool(tempPoolObj,self.InitCount,gameObjName,poolType)
				return self:GetActiveGameObject(gameObjName)
			end
			
		end

	end
end


function ObjectPool:FindIsHaveKey(keyName,targatPool)
	return CommonHelper.IsContainKeyForDic(keyName,targatPool)
end



function ObjectPool:ReCycleToGameObject(gameObj,poolType)
	CommonHelper.SetActive(gameObj,false)
	self:SetPoolParent(gameObj,poolType)
	
end


function ObjectPool:GetActiveGameObject(keyName)
	for i=1,#self.ObjectPoolList[keyName] do
		if self.ObjectPoolList[keyName][i].activeSelf==false then
			CommonHelper.SetActive(self.ObjectPoolList[keyName][i],true)
			return self.ObjectPoolList[keyName][i]
		end
	end
	return nil
end


function ObjectPool:__delete()
	self.PrototypeObjectList=nil
	self.ObjectPoolList=nil	
end