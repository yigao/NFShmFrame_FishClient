BigAwardTipsEffectManager=Class()

local Instance=nil
function BigAwardTipsEffectManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function BigAwardTipsEffectManager.GetInstance()
	return Instance
end


function BigAwardTipsEffectManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	
end



function BigAwardTipsEffectManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AllUseEffectInsList={}
	self.CurrentUseEffectInsList={}
	self.UID=1
	self.bigAwardPosIndex = 1
	self.Animator=CS.UnityEngine.Animator
	self.Text=CS.UnityEngine.UI.Text
	
end

function BigAwardTipsEffectManager:AddScripts()
	self.ScriptsPathList={
		"/View/Effect/BigAwardTipsEffect/Effect/BigAwardTipsEffectItem",
	}
end


function BigAwardTipsEffectManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function BigAwardTipsEffectManager:InitView(gameObj)
	
end


function BigAwardTipsEffectManager:InitInstance()
	self.BigAwardTipsEffectItem=BigAwardTipsEffectItem
end


function BigAwardTipsEffectManager:InitViewData()	
	
end


function BigAwardTipsEffectManager:GetBigAwardTipsEffectUID()
	self.UID=self.UID+1
	return self.UID
end



function BigAwardTipsEffectManager:GetBigAwardTipsEffectConfig(bigAwardTipsEffectID)
	local tempConfig=self.gameData.gameConfigList.BigAwardTipsEffectConfigList[bigAwardTipsEffectID]
	if tempConfig then
		return tempConfig
	else
		Debug.LogError("获取加分配置失败==>"..bigAwardTipsEffectID)
	end
end


function BigAwardTipsEffectManager:GetBigAwardTipsEffectVo(bigAwardTipsEffectConfig,chairID)
	local vo={}
	vo.BigAwardTipsEffectConfig=bigAwardTipsEffectConfig
	vo.UID=self:GetBigAwardTipsEffectUID()
	vo.ChairID = chairID
	vo.IsMe = (chairID == self.gameData.PlayerChairId)
	return vo
end



function BigAwardTipsEffectManager:SetBigAwardTipsEffectShowMode(chairID,bigAwardPosList,showScore,bigAwardTipsEffectConfig)
	local bigAwardTipsEffectVo=self:GetBigAwardTipsEffectVo(bigAwardTipsEffectConfig,chairID)
	local tempBigAwardTipsEffectIns=self:GetBigAwardTipsEffect(bigAwardTipsEffectVo)
	local startPos =bigAwardPosList[self.bigAwardPosIndex].position
	
	self:AddBigAwardTipdePosIndex()
	if tempBigAwardTipsEffectIns then
		tempBigAwardTipsEffectIns:SetShowScoreText(showScore)
		tempBigAwardTipsEffectIns:ResetState(startPos,bigAwardTipsEffectConfig.bigAwardTipsDelayTime,bigAwardTipsEffectConfig.bigAwardTipsShowTime)
	end
end




function BigAwardTipsEffectManager:GetBigAwardTipsEffect(bigAwardTipsEffectVo)
	if self.AllUseEffectInsList[bigAwardTipsEffectVo.BigAwardTipsEffectConfig.id] and #(self.AllUseEffectInsList[bigAwardTipsEffectVo.BigAwardTipsEffectConfig.id])>0 then
		local tempEffectIns=table.remove(self.AllUseEffectInsList[bigAwardTipsEffectVo.BigAwardTipsEffectConfig.id],1)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(bigAwardTipsEffectVo)
			self.CurrentUseEffectInsList[bigAwardTipsEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			Debug.LogError("创建PlusTipsEffect失败==>"..bigAwardTipsEffectVo.BigAwardTipsEffectConfig.id)
		end
		
	else
		local effectItem=GameObjectPoolManager.GetInstance():GetGameObject(bigAwardTipsEffectVo.BigAwardTipsEffectConfig.bigAwardTipsResource,GameObjectPoolManager.PoolType.BigAwardTipsPool)
		
		local tempEffectIns=self.BigAwardTipsEffectItem.New(effectItem)
		if tempEffectIns then
			tempEffectIns:ResetEffectVo(bigAwardTipsEffectVo)
			self.CurrentUseEffectInsList[bigAwardTipsEffectVo.UID]=tempEffectIns
			return tempEffectIns
		else
			GameObjectPoolManager.GetInstance():ReCycleToGameObject(effectItem,GameObjectPoolManager.PoolType.BigAwardTipsPool)
			Debug.LogError("创建PlusTipsEffect失败==>"..bigAwardTipsEffectVo.BigAwardTipsEffectConfig.id)
		end
			
	end
	
	return nil
end

function BigAwardTipsEffectManager:AddBigAwardTipdePosIndex(  )
	self.bigAwardPosIndex = self.bigAwardPosIndex + 1
	if self.bigAwardPosIndex > 3 then
		self.bigAwardPosIndex  = 1
	end
end

function BigAwardTipsEffectManager:ReduceBigAwardTipdePosIndex(  )
	self.bigAwardPosIndex = self.bigAwardPosIndex - 1
	if self.bigAwardPosIndex < 1 then
		self.bigAwardPosIndex  = 1
	end	
end

function BigAwardTipsEffectManager:RecycleBigAwardTipsEffect(bigAwardTipsEffectIns)
	--Debug.LogError("移除UID==>"..scoreEffectIns.EffectVo.UID)
	local tempEffectIns=self.CurrentUseEffectInsList[bigAwardTipsEffectIns.EffectVo.UID]
	if tempEffectIns then
		if self.AllUseEffectInsList[bigAwardTipsEffectIns.EffectVo.BigAwardTipsEffectConfig.id]==nil then
			self.AllUseEffectInsList[bigAwardTipsEffectIns.EffectVo.BigAwardTipsEffectConfig.id]={}
		end
		table.insert(self.AllUseEffectInsList[bigAwardTipsEffectIns.EffectVo.BigAwardTipsEffectConfig.id],bigAwardTipsEffectIns)
		self.CurrentUseEffectInsList[bigAwardTipsEffectIns.EffectVo.UID]=nil

		self:ReduceBigAwardTipdePosIndex()
	else
		Debug.LogError("移除的goldEffectIns为nil==>UID"..bigAwardTipsEffectIns.EffectVo.UID)
	end
end


function BigAwardTipsEffectManager:ClearAllBigAwardTipsEffect()
	if self.CurrentUseEffectInsList  then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveBigAwardTipsEffect()
	end
	self.bigAwardPosIndex  = 1
end



function BigAwardTipsEffectManager:UpdateRemoveBigAwardTipsEffect()
	if self.CurrentUseEffectInsList and next(self.CurrentUseEffectInsList) then
		for k,v in pairs(self.CurrentUseEffectInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleBigAwardTipsEffect(v)
			end
		end
	end
end


function BigAwardTipsEffectManager:Update()
	self:UpdateRemoveBigAwardTipsEffect()
end



