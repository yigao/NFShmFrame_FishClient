BombSkillManager=Class()

local Instance=nil
function BombSkillManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function BombSkillManager.GetInstance()
	return Instance
end


function BombSkillManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
 	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end

function BombSkillManager:InitData()
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

function BombSkillManager:AddScripts()
	self.ScriptsPathList={
		"/View/Skill/BombSkill/Skill/BombSkillItem",
	}
end


function BombSkillManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function BombSkillManager:InitView(gameObj)
	
end


function BombSkillManager:InitInstance()
	self.BombSkillItem=BombSkillItem
end


function BombSkillManager:InitViewData()	
	
end


function BombSkillManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DELAYBOMB_BOMB_RSP"),self.ResponesBombCrabBombMsg,self)
end

function BombSkillManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DELAYBOMB_BOMB_RSP"))
end

function BombSkillManager:ResponesBombCrabBombMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.DelayBomb_Bomb_Rsp",msg)
	local bombSkillItem = self.CurrentUseSkillInsList[data.usDelayBombId]
	if bombSkillItem then
		bombSkillItem:BombCrabExplosion(data.usTotalScore,data.usTotalMul)
	end
end


function BombSkillManager:EnterBombSkillMode(data)
	local fishIns = FishManager.GetInstance():GetUsingFishByFishUID(data.usKilledFishId)
	local playerIns = PlayerManager.GetInstance():GetPlayerInsByChairdId(data.usChairId)
	local UID = data.usDelayBombId
	local skillStatus =data.usStatus
	local skillTime = data.usStatusTime
	local bombFishId = data.bombFishId
	local beginPos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform:TransformPoint(CS.FishManager.ScreenPointToRealPoint(data.usPosX, data.usPoxY))

	if self.CurrentUseSkillInsList[data.usDelayBombId] == nil then
		self:CreateBombSkill(UID,beginPos,playerIns,skillStatus,skillTime)
	else
		Debug.LogError("炸弹正在正处在爆炸状态")
	end

	if playerIns:GetOnlineState() == true then
		self:ShowSpecialDeclareEffect(UID,bombFishId,playerIns)
	end
end

function BombSkillManager:CreateBombSkill(UID,beginPos,playerIns,skillStatus,skillTime)
	local bombSkillVo=self:GetBombSkillVo(UID,playerIns)
	local tempBombSkillIns=self:GetBombSkill(bombSkillVo)
	if tempBombSkillIns then
		tempBombSkillIns:ResetSkillState(beginPos,skillStatus,skillTime)
	else
		Debug.LogError("获取BombSkill失败==>")
	end
end

function BombSkillManager:GetBombSkillVo(UID,playerIns)
	local vo={}
	vo.UID= UID
	vo.PlayerIns = playerIns
	vo.ChairdID = playerIns.ChairdID
	vo.IsMe = (playerIns.ChairdID == self.gameData.PlayerChairId)
	return vo
end

function BombSkillManager:GetBombSkill(bombSkillVo)
	if self.AllUseSkillInsList and #self.AllUseSkillInsList>0 then
		local tempBombSkillIns= table.remove(self.AllUseSkillInsList,1)
		if tempBombSkillIns then
			tempBombSkillIns:ResetSkillVo(bombSkillVo)
			self.CurrentUseSkillInsList[bombSkillVo.UID]= tempBombSkillIns
			return tempBombSkillIns
		end
	else
		local tempBombSkillIns= self.BombSkillItem.New()
		if tempBombSkillIns then
			tempBombSkillIns:ResetSkillVo(bombSkillVo)
			self.CurrentUseSkillInsList[bombSkillVo.UID]= tempBombSkillIns
			return tempBombSkillIns
		end
	end
	return nil
end


function BombSkillManager:ShowSpecialDeclareEffect(UID,fishId,playerIns)
	local fishConfig = self.gameData.gameConfigList.FishConfigList[fishId]
	local damageDieConfig = self.gameData.gameConfigList.DieEffectConfigList[fishConfig.dieEffectId]
	local specialDeclareConfig = SpecialDeclareEffectManager.GetInstance():GetSpecialDeclareEffectConfig(damageDieConfig.specialDeclareID)
	local specialDeclareUID = SpecialDeclareEffectManager.GetInstance():SetSpecialDeclareEffectShowMode(playerIns.ChairdID,playerIns.SpecialDeclarePanel.position,specialDeclareConfig)
	self.SpecialDeclareList[UID] = specialDeclareUID
end

function BombSkillManager:ShowSpecialDeclareScore(bombUID,score,multiple)
	local specialDeclareUID = self.SpecialDeclareList[bombUID]
	if specialDeclareUID then
		self.SpecialDeclareList[bombUID] = nil
		SpecialDeclareEffectManager.GetInstance():BeginSpecialDeclareEffectChangeScore(specialDeclareUID,score,multiple)
	end
end


function BombSkillManager:ClearAllBombSkill()
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveBombSkill()
	end
	self.CurrentUseSkillInsList ={}
end

function BombSkillManager:ClearOtherPlayerBombSkill(charidID)
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.SkillVo.ChairdID == charidID then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveBombSkill()
	end
end


function BombSkillManager:RecycleBombSkill(bombSkillVo)
	local tempBombSkillIns =self.CurrentUseSkillInsList[bombSkillVo.UID]
	if tempBombSkillIns then
		table.insert(self.AllUseSkillInsList,tempBombSkillIns)
		self.CurrentUseSkillInsList[bombSkillVo.UID]=nil
	else
		Debug.LogError("回收BombSkillItem失败==>"..bombSkillVo.UID)
	end	
end

function BombSkillManager:UpdateRemoveBombSkill()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleBombSkill(v.SkillVo)
			end
		end
	end
end

function BombSkillManager:OnUpdate()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if not v.isCanDestory then
				v:Update()
			end
		end
	end
end

function BombSkillManager:Update()
	self:OnUpdate()
	self:UpdateRemoveBombSkill()
end

function BombSkillManager:__delete()
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
