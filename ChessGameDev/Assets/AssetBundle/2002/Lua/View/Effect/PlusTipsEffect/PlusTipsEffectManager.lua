PlusTipsEffectManager=Class()

local Instance=nil
function PlusTipsEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function PlusTipsEffectManager.GetInstance()
	return Instance
end


function PlusTipsEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	
end



function PlusTipsEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllUseEffectInsList={}
	self.CurrentUseEffectInsList={}
	self.UID=1

	self.Animator=CS.UnityEngine.Animator
	self.Text=CS.UnityEngine.UI.Text
	
end

function PlusTipsEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/PlusTipsEffect/Effect/PlusTipsEffecItem",
	}
end


function PlusTipsEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function PlusTipsEffectManager:InitView(gameObj)
	
end


function PlusTipsEffectManager:InitInstance()
	self.PlusTipsEffecItem=PlusTipsEffecItem
end


function PlusTipsEffectManager:InitViewData()	
	
end


function PlusTipsEffectManager:GetPlusTipsEffectUID()
	self.UID=self.UID+1
	return self.UID
end



function PlusTipsEffectManager:GetPlusTipsEffectConfig(plusTipsEffectID)
	local tempConfig=self.gameData.gameConfigList.PlusTipsEffectConfigList[plusTipsEffectID]
	if tempConfig then
		return tempConfig
	else
		Debug.LogError("获取加分配置失败==>"..plusTipsEffectID)
	end
end


function PlusTipsEffectManager:GetPlusTipsEffectVo(plusTipsEffectConfig,chairID)
	local vo={}
	vo.PlusTipsEffectConfig=plusTipsEffectConfig
	vo.UID=self:GetPlusTipsEffectUID()
	return vo
end



function PlusTipsEffectManager:SetPlusTipsEffectShowMode(chairID,flyObj,showScore,plusTipsEffectConfig)
	if chairID ~= self.gameData.PlayerChairId then
		return
	end

	local plusTipsEffectVo=self:GetPlusTipsEffectVo(plusTipsEffectConfig,chairID)
	local tempPlusTipsEffectIns=self:GetPlusTipsEffect(plusTipsEffectVo)
	local startPos = flyObj.position
	if tempPlusTipsEffectIns then
		tempPlusTipsEffectIns:SetShowScoreText(showScore)
		tempPlusTipsEffectIns:ResetState(startPos,plusTipsEffectConfig.plusTipsDelayTime,plusTipsEffectConfig.plusTipsShowTime)
	end
end




function PlusTipsEffectManager:GetPlusTipsEffect(plusTipsEffectVo)
	if self.AllUseEffectInsList[plusTipsEffectVo.PlusTipsEffectConfig.id] and #(self.AllUseEffectInsList[plusTipsEffectVo.PlusTipsEffectConfig.id])>0 then
		local tempEffectIns=table.remove(self.AllUseEffectInsList[plusTipsEffectVo.PlusTipsEffectConfig.id],1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(plusTipsEffectVo)
			self.CurrentUseEffectInsList[plusTipsEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建PlusTipsEffect失败==>"..plusTipsEffectVo.PlusTipsEffectConfig.id)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(plusTipsEffectVo.PlusTipsEffectConfig.plusTipsResource,GameObjectPoolManager.PoolType.PlusTips)
		
		local tempEffectIns=self.PlusTipsEffecItem.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(plusTipsEffectVo)
			self.CurrentUseEffectInsList[plusTipsEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.PlusTips)
			Debug.LogError("创建PlusTipsEffect失败==>"..plusTipsEffectVo.PlusTipsEffectConfig.id)
		end
			
	end
	
	return nil
end



function PlusTipsEffectManager:RecyclePlusTipsEffect(plusTipsEffectIns)
	--Debug.LogError("移除UID==>"..scoreEffectIns.EffectVo.UID)
	local tempEffectIns=self.CurrentUseEffectInsList[plusTipsEffectIns.EffectVo.UID]
	if tempEffectIns then
		if self.AllUseEffectInsList[plusTipsEffectIns.EffectVo.PlusTipsEffectConfig.id]==nil then
			self.AllUseEffectInsList[plusTipsEffectIns.EffectVo.PlusTipsEffectConfig.id]={}
		end
		table.insert(self.AllUseEffectInsList[plusTipsEffectIns.EffectVo.PlusTipsEffectConfig.id],plusTipsEffectIns)
		self.CurrentUseEffectInsList[plusTipsEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("移除的goldEffectIns为nil==>UID"..plusTipsEffectIns.EffectVo.UID)
	end
end


function PlusTipsEffectManager:ClearAllPlusTipsEffect()
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemovePlusTipsEffect()
	end
end



function PlusTipsEffectManager:UpdateRemovePlusTipsEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecyclePlusTipsEffect(v)
			end
		end
	end
end


function PlusTipsEffectManager:Update()
	self:UpdateRemovePlusTipsEffect()
end



