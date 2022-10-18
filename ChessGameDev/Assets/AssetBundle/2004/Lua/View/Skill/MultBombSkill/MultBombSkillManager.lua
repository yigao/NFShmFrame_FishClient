MultBombSkillManager=Class()

local Instance=nil
function MultBombSkillManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function MultBombSkillManager.GetInstance()
	return Instance
end

function MultBombSkillManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end

function MultBombSkillManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData

	self.AllUseSkillInsList={}
	self.CurrentUseSkillInsList={}
	self.SpecialDeclareList = {}
	self.UID=1

	self.Animator=CS.UnityEngine.Animator
	self.Text=CS.UnityEngine.UI.Text
	self.Button = CS.UnityEngine.UI.Button
	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.DOTween = CS.DG.Tweening.DOTween
	self.TweenExtensions = CS.DG.Tweening.TweenExtensions
end

function MultBombSkillManager:AddScripts()
	self.ScriptsPathList={
		"/View/Skill/MultBombSkill/Skill/MultBombSkillItem",
	}
end


function MultBombSkillManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end

function MultBombSkillManager:InitView(gameObj)
	
end

function MultBombSkillManager:InitInstance()
	self.MultBombSkillItem=MultBombSkillItem
end

function MultBombSkillManager:InitViewData()	
	
end

function MultBombSkillManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_SERIALBOMBCRAB_BOMB_RSP"),self.ResponesMultBombCrabBombMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DESTORYSERIALBOMBCRAB_RSP"),self.ResponesMultBombCrabDestroyMsg,self)
end

function MultBombSkillManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_SERIALBOMBCRAB_BOMB_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DESTORYSERIALBOMBCRAB_RSP"))
end

function MultBombSkillManager:ResponesMultBombCrabBombMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.SerialBombCrabBombRsp",msg)
	local multBombSkillItem = self.CurrentUseSkillInsList[data.usSerialBombCrabId]
	if multBombSkillItem then
		multBombSkillItem.SkillVo.BombCount  = data.usBombCount
		if data.usNextBombPosX == 0 and data.usNextBombPosy==0 then
			multBombSkillItem.SkillVo.NextPos = nil
		else
			multBombSkillItem.SkillVo.NextPos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform:TransformPoint(CS.FishManager.ScreenPointToRealPoint(data.usNextBombPosX, data.usNextBombPosy))
		end
		multBombSkillItem:MultBombExplose()
	end
end



function MultBombSkillManager:ResponesMultBombCrabDestroyMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.SerialBombCrabBombRsp",msg)
	local multBombSkillItem = self.CurrentUseSkillInsList[data.usSerialBombCrabId]
	if multBombSkillItem then
		multBombSkillItem:DelayMultBombDestroy(data.usTotalScore,data.usTotalMul)
	end
end


function MultBombSkillManager:EnterMultBombSkillMode(data)
	local fishIns = FishManager.GetInstance():GetUsingFishByFishUID(data.usKilledFishId)
	local playerIns = PlayerManager.GetInstance():GetPlayerInsByChairdId(data.usChairId)
	local UID = data.usSerialBombCrabId
	local skillStatus =data.usStatus
	local skillTime = data.usStatusTime
	local bombCount = data.usBombCount
	local bombFishId = data.bombFishId


	if self.CurrentUseSkillInsList[data.usDelayBombId] == nil then
		if data.usNextBombPosX == 0 and data.usNextBombPosy ==0 then
			return
		else
			local beginPos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform:TransformPoint(CS.FishManager.ScreenPointToRealPoint(data.usBombPosX,data.usBombPosY))
			local nextPos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform:TransformPoint(CS.FishManager.ScreenPointToRealPoint(data.usNextBombPosX,data.usNextBombPosy))
			self:CreateMultBombSkill(UID,beginPos,nextPos,bombCount,playerIns,skillStatus,skillTime)
		end
	else
		Debug.LogError("连环炸弹炸弹正在正处在爆炸状态")
	end

	if playerIns:GetOnlineState() == true then
		self:ShowSpecialDeclareEffect(UID,bombFishId,playerIns)
	end
end



function MultBombSkillManager:CreateMultBombSkill(UID,beginPos,nextPos,bombCount,playerIns,skillStatus,skillTime)
	local multBombSkillVo=self:GetMultBombSkillVo(UID,nextPos,bombCount,playerIns)
	local tempMultBombSkillIns=self:GetMultBomSkill(multBombSkillVo)
	if tempMultBombSkillIns then
		tempMultBombSkillIns:ResetSkillState(beginPos,skillStatus,skillTime)
	else
		Debug.LogError("获取MultBombSkill失败==>")
	end
end

function MultBombSkillManager:GetMultBombSkillVo(UID,nextPos,bombCount,playerIns)
	local vo={}
	vo.UID= UID
	vo.NextPos = nextPos
	vo.BombCount = bombCount
	vo.PlayerIns = playerIns
	vo.ChairdID = playerIns.ChairdID
	vo.IsMe = (playerIns.ChairdID == self.gameData.PlayerChairId)
	return vo
end

function MultBombSkillManager:GetMultBomSkill(multBombSkillVo)
	if self.AllUseSkillInsList and #self.AllUseSkillInsList>0 then
		local tempMultBombSkillIns= table.remove(self.AllUseSkillInsList,1)
		if tempMultBombSkillIns then
			tempMultBombSkillIns:ResetSkillVo(multBombSkillVo)
			self.CurrentUseSkillInsList[multBombSkillVo.UID]= tempMultBombSkillIns
			return tempMultBombSkillIns
		end
	else
		local tempMultBombSkillIns= self.MultBombSkillItem.New()
		if tempMultBombSkillIns then
			tempMultBombSkillIns:ResetSkillVo(multBombSkillVo)
			self.CurrentUseSkillInsList[multBombSkillVo.UID]= tempMultBombSkillIns
			return tempMultBombSkillIns
		end
	end
	return nil
end


function MultBombSkillManager:ShowSpecialDeclareEffect(UID,fishId,playerIns)
	local fishConfig = self.gameData.gameConfigList.FishConfigList[fishId]
	local damageDieConfig = self.gameData.gameConfigList.DieEffectConfigList[fishConfig.dieEffectId]
	local specialDeclareConfig = SpecialDeclareEffectManager.GetInstance():GetSpecialDeclareEffectConfig(damageDieConfig.specialDeclareID)
	local specialDeclareUID = SpecialDeclareEffectManager.GetInstance():SetSpecialDeclareEffectShowMode(playerIns.ChairdID,playerIns.SpecialDeclarePanel.position,specialDeclareConfig)
	self.SpecialDeclareList[UID] = specialDeclareUID
end

function MultBombSkillManager:ShowSpecialDeclareScore(bombUID,score,multiple)

	local specialDeclareUID = self.SpecialDeclareList[bombUID]
	if specialDeclareUID then
		self.SpecialDeclareList[bombUID] = nil
		SpecialDeclareEffectManager.GetInstance():BeginSpecialDeclareEffectChangeScore(specialDeclareUID,score,multiple)
	end
end


function MultBombSkillManager:ClearAllMultBombSkill()
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveMultBombSkill()
	end
	self.CurrentUseSkillInsList ={}
end

function MultBombSkillManager:ClearOtherPlayerMultBombSkill(charidID)
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.SkillVo.ChairdID == charidID then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveMultBombSkill()
	end
end


function MultBombSkillManager:RecycleMultBombSkill(multBombSkillVo)

	local tempMultBombSkillIns =self.CurrentUseSkillInsList[multBombSkillVo.UID]
	if tempMultBombSkillIns then
		table.insert(self.AllUseSkillInsList,tempMultBombSkillIns)
		self.CurrentUseSkillInsList[multBombSkillVo.UID]=nil
	else
		Debug.LogError("回收MultBombSkillItem失败==>"..multBombSkillVo.UID)
	end	
end

function MultBombSkillManager:UpdateRemoveMultBombSkill()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleMultBombSkill(v.SkillVo)
			end
		end
	end
end

function MultBombSkillManager:OnUpdate()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if not v.isCanDestory then
				v:Update()
			end
		end
	end
end

function MultBombSkillManager:Update()
	self:OnUpdate()
	self:UpdateRemoveMultBombSkill()
end

function MultBombSkillManager:__delete()
	self:RemoveEventListenner()
	self.AllUseSkillInsList= nil
	self.CurrentUseSkillInsList=nil
	self.SpecialDeclareList = nil
	self.Animator=nil
	self.Text=nil
	self.Button = nil
	self.Tween = nil
	self.Sequence = nil
	self.Ease = nil
	self.DOTween = nil
	self.TweenExtensions = nil
end
