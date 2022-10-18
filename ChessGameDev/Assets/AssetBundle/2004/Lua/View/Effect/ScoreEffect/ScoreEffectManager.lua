ScoreEffectManager=Class()

local Instance=nil
function ScoreEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function ScoreEffectManager.GetInstance()
	return Instance
end


function ScoreEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
end

function ScoreEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllUseEffectInsList={}
	self.CurrentUseEffectInsList={}
	self.UID=1

	self.Animator=CS.UnityEngine.Animator
	self.Text=CS.UnityEngine.UI.Text
	
	self.ScoreType={
		AllShow=1,
		OnlyShow=2,
	}
end

function ScoreEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/ScoreEffect/Effect/ScoreEffecItem",	
	}
end


function ScoreEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end

function ScoreEffectManager:InitView(gameObj)
	
end

function ScoreEffectManager:InitInstance()
	self.ScoreEffecItem=ScoreEffecItem
end


function ScoreEffectManager:InitViewData()	
	
end


function ScoreEffectManager:GetGoldEffectUID()
	self.UID=self.UID+1
	return self.UID
end



function ScoreEffectManager:GetScoreEffectConfig(scoreEffectID)
	local tempConfig=self.gameData.gameConfigList.ScoreEffectConfigList[scoreEffectID]
	if tempConfig then
		return tempConfig
	else
		Debug.LogError("获取得分效果配置失败==>"..scoreEffectID)
	end
end

function ScoreEffectManager:GetScoreEffectVo(scoreEffectConfig,score,chairID,behaviourType)
	local vo={}
	vo.ScoreEffectConfig=scoreEffectConfig
	vo.Score = score
	vo.behaviourType = behaviourType
	vo.ChairID = chairID
	vo.UID=self:GetGoldEffectUID()
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	return vo
end


function ScoreEffectManager:SetScoreEffectShowMode(startPos,chairID,showScore,scoreEffectID,behaviourType)
	local scoreEffectConfig = self:GetScoreEffectConfig(scoreEffectID)
	if scoreEffectConfig then
		local scoreEffectVo=self:GetScoreEffectVo(scoreEffectConfig,showScore,chairID,behaviourType)
		local tempScoreEffectIns=self:GetScoreEffect(scoreEffectVo)
		if tempScoreEffectIns then
			tempScoreEffectIns:ResetState(startPos,scoreEffectConfig.scoreDelayTime,scoreEffectConfig.scoreShowTime)
		end
	end
end


function ScoreEffectManager:GetScoreEffect(scoreEffectVo)
	if self.AllUseEffectInsList[scoreEffectVo.ScoreEffectConfig.id] and #(self.AllUseEffectInsList[scoreEffectVo.ScoreEffectConfig.id])>0 then
		local tempEffectIns=table.remove(self.AllUseEffectInsList[scoreEffectVo.ScoreEffectConfig.id],1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(scoreEffectVo)
			self.CurrentUseEffectInsList[scoreEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建ScoreEffect失败==>"..scoreEffectVo.ScoreEffectConfig.scoreResource)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(scoreEffectVo.ScoreEffectConfig.scoreResource,GameObjectPoolManager.PoolType.ScorePool)
		
		local tempEffectIns=self.ScoreEffecItem.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(scoreEffectVo)
			self.CurrentUseEffectInsList[scoreEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.ScorePool)
			Debug.LogError("EffectIns生成失败==>"..scoreEffectVo.ScoreEffectConfig.scoreResource)
		end
			
	end
	return nil
end

function ScoreEffectManager:RecycleScoreEffect(scoreEffectIns)
	--Debug.LogError("移除UID==>"..scoreEffectIns.EffectVo.UID)
	local tempEffectIns=self.CurrentUseEffectInsList[scoreEffectIns.EffectVo.UID]
	if tempEffectIns then
		if self.AllUseEffectInsList[scoreEffectIns.EffectVo.ScoreEffectConfig.id]==nil then
			self.AllUseEffectInsList[scoreEffectIns.EffectVo.ScoreEffectConfig.id]={}
		end
		table.insert(self.AllUseEffectInsList[scoreEffectIns.EffectVo.ScoreEffectConfig.id],scoreEffectIns)
		self.CurrentUseEffectInsList[scoreEffectIns.EffectVo.UID]=nil
	else
		Debug.LogError("移除的goldEffectIns为nil==>UID"..scoreEffectIns.EffectVo.UID)
	end
end


function ScoreEffectManager:ClearAllScoreEffect()
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveScoreEffect()
	end
	self.CurrentUseEffectInsList= {}
end

function ScoreEffectManager:ClearOtherPlayerScoreEffect(chairID)
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if (v.EffectVo.ChairID == chairID) and (v.EffectVo.behaviourType == 3) then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveScoreEffect()
	end
end


function ScoreEffectManager:UpdateRemoveScoreEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleScoreEffect(v)
			end
		end
	end
end


function ScoreEffectManager:Update()
	self:UpdateRemoveScoreEffect()
end

function ScoreEffectManager:__delete()
	self.AllUseEffectInsList= nil
	self.CurrentUseEffectInsList= nil
	self.Animator= nil
	self.Text=nil
end




