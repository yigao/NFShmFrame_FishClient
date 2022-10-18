LightningEffectManager=Class()

local Instance=nil
function LightningEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function LightningEffectManager.GetInstance()
	return Instance
end


function LightningEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
end

function LightningEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllUseSkillInsList = {}
	self.CurrentUseEffectInsList={}
	self.UID=1
	self.RectTransform = CS.UnityEngine.RectTransform
	self.Quaternion = CS.UnityEngine.Quaternion
	self.Animator=CS.UnityEngine.Animator
	self.Image = CS.UnityEngine.UI.Image
	self.Vector2 = CS.UnityEngine.Vector2
end

function LightningEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/LightningEffect/Effect/LightningEffectItem",
	}	
end


function LightningEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function LightningEffectManager:InitView(gameObj)
	
end


function LightningEffectManager:InitInstance()
	self.LightningEffectItem=LightningEffectItem
end


function LightningEffectManager:InitViewData()	
	
end


function LightningEffectManager:GetLightningEffectUID()
	self.UID=self.UID+1
	return self.UID
end


function LightningEffectManager:GetFishEffectConfig(fishEffectID)
	return self.gameData.gameConfigList.DieEffectConfigList[fishEffectID]
end

function LightningEffectManager:SetLightningEffectShowMode(tempFishTF,subFishTF,chairID,fishUID,dieEffectConfig,callBack)
	local lineNameRes = dieEffectConfig.childFishLineRes
	
	if lineNameRes ~= "nil" then
		local lineDelyTime = dieEffectConfig.childFishLineDelyTime
		local lineLifeTime = dieEffectConfig.childFishLineLifeTime
		local beginPos = tempFishTF.position
		local targetPos = subFishTF.position
		local distance = CSScript.Vector3.Distance(tempFishTF.localPosition,subFishTF.localPosition)
		self:ShowLightningEffect(chairID,fishUID,beginPos,targetPos,distance,lineNameRes,lineDelyTime,lineLifeTime,callBack)
	end
end

function LightningEffectManager:ShowLightningEffect(chairID,fishUID,beginPos,targetPos,distance,lineRes,delayTime,lifeTime,callBack)
	local vo=self:GetLightningEffectVo(fishUID,chairID,lineRes,delayTime,lifeTime)
	local tempEffectIns=self:GetLightningEffect(vo)
	if tempEffectIns then
		tempEffectIns:ResetState(beginPos,targetPos,distance,callBack)
	else
		Debug.LogError("获取effectName失败==>"..effectName)
	end
end


function LightningEffectManager:GetLightningEffectVo(fishUID,chairID,lineRes,delayTime,lifeTime)
	local vo={}
	vo.UID=self:GetLightningEffectUID()
	vo.fishUID = fishUID
	vo.ChairID = chairID
	vo.EffectName = lineRes
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	vo.EffectDelayTime = delayTime
	vo.EffectLifeTime = lifeTime
	return vo
end


function LightningEffectManager:GetLightningEffect(lightningffectVo)
	if self.AllUseEffectInsList and #self.AllUseEffectInsList>0 then
		local tempEffectIns=table.remove(self.AllUseEffectInsList,1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(lightningffectVo)
			self.CurrentUseEffectInsList[lightningffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建闪电失败==>"..lightningffectVo.EffectName)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(lightningffectVo.EffectName,GameObjectPoolManager.PoolType.LightningPool)
		local tempEffectIns= self.LightningEffectItem.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(lightningffectVo)
			self.CurrentUseEffectInsList[lightningffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.LightningPool)
			Debug.LogError("创建闪电失败==>"..lightningffectVo.EffectName)
		end
	end
	return nil	
end


function LightningEffectManager:RecycleLightningEffect(lightningEffectInfo)


	local tempLightningEffect=self.CurrentUseEffectInsList[lightningEffectInfo.UID]
	if tempLightningEffect then
		if self.AllUseEffectInsList==nil then
			self.AllUseEffectInsList={}
		end
		table.insert(self.AllUseEffectInsList,tempLightningEffect)
		self.CurrentUseEffectInsList[lightningEffectInfo.UID]=nil
	else
		Debug.LogError("移除的闪电为nil==>UID"..lightningEffectInfo.UID)
	end
end



function LightningEffectManager:ClearAllLightningEffect()

	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveLightningEffect()
	end
	self.CurrentUseEffectInsList = {}
end

function LightningEffectManager:UpdateRemoveLightningEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleLightningEffect(v.LightningVo)
			end
		end
	end
end


function LightningEffectManager:Update()
	self:UpdateRemoveLightningEffect()
end

function LightningEffectManager:__delete()
	self.AllUseSkillInsList = nil
	self.CurrentUseEffectInsList = nil
	self.RectTransform = nil
	self.Quaternion = nil
	self.Animator = nil
	self.Image = nil
	self.Vector2 = nil
end

