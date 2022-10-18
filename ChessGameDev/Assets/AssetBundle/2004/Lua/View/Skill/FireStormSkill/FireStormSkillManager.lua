FireStormSkillManager=Class()

local Instance=nil
function FireStormSkillManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function FireStormSkillManager.GetInstance()
	return Instance
end

function FireStormSkillManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end

function FireStormSkillManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData

	self.AllUseSkillInsList={}
	self.CurrentUseSkillInsList={}
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

function FireStormSkillManager:AddScripts()
	self.ScriptsPathList={
		"/View/Skill/FireStormSkill/Skill/FireStormSkillItem",
	}
end


function FireStormSkillManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end

function FireStormSkillManager:InitView(gameObj)
	
end

function FireStormSkillManager:InitInstance()
	self.FireStormSkillItem=FireStormSkillItem
end

function FireStormSkillManager:InitViewData()	
	
end

function FireStormSkillManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DESTORYFIRESTORM_RSP"),self.ResponesFireStormDestroyMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_FIRESTORMSTATUS_RSP"),self.ResponesFireStormShootMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","F_FISH_CMD_FIRESTORMSCORE_RSP"),self.ResponesFireStormScoreMsg,self)
end

function FireStormSkillManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DESTORYFIRESTORM_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_FIRESTORMSTATUS_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","F_FISH_CMD_FIRESTORMSCORE_RSP"))
end

function FireStormSkillManager:ResponesFireStormShootMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.FireStormStatusShootRsp",msg)
	local fireStormSkillItem = self.CurrentUseSkillInsList[data.usFireStormId]
	if fireStormSkillItem  and data.usStatus == 2 then
		fireStormSkillItem:BeginFireStormShoot(0)
	end
end

function FireStormSkillManager:ResponesFireStormScoreMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.FireStormScoreRsp",msg)
	local fireStormSkillItem = self.CurrentUseSkillInsList[data.usFireStormId]
	if fireStormSkillItem then
		fireStormSkillItem:RefreshFireStormInfo(data.usTotalScore,data.usTotalMul)
	end
end

function FireStormSkillManager:ResponesFireStormDestroyMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.DestoryFireStormRsp",msg)
	local fireStormSkillItem = self.CurrentUseSkillInsList[data.usFireStormId]
	if fireStormSkillItem then
		fireStormSkillItem:EndFireStorm(data.usTotalScore)
	end
end

function FireStormSkillManager:EnterFireStormSkillMode(data)
	local fishIns = FishManager.GetInstance():GetUsingFishByFishUID(data.usKilledFishId)
	local playerIns = PlayerManager.GetInstance():GetPlayerInsByChairdId(data.usChairId)
	local UID = data.usFireStormId
	local skillStatus = data.usStatus
	local skillTime = data.usStatusTime
	local skillScore = data.usTotalScore
	local skillMul = data.usTotalMul

	if self.CurrentUseSkillInsList[data.usFireStormId] == nil then
		self:CreateFireStormSkill(UID,playerIns,skillStatus,skillTime,skillScore,skillMul)
	else
		self.CurrentUseSkillInsList[data.usFireStormId].isCanDestory = true
		self:UpdateRemoveFireStormSkill()
		self:CreateFireStormSkill(UID,playerIns,skillStatus,skillTime,skillScore,skillMul)
	end
end


function FireStormSkillManager:CreateFireStormSkill(UID,playerIns,skillStatus,skillTime,skillScore,skillMul)
	local fireStormSkillVo=self:GetFireStormSkillVo(UID,playerIns)
	local tempFireStormSkillVoSkillIns=self:GetFireStormSkill(fireStormSkillVo)
	if tempFireStormSkillVoSkillIns then
		tempFireStormSkillVoSkillIns:ResetSkillState(skillStatus,skillTime,skillScore,skillMul)
	else
		Debug.LogError("获取FireStormSkill失败==>")
	end
end

function FireStormSkillManager:GetFireStormSkillVo(UID,playerIns)
	local vo={}
	vo.UID=UID
	vo.PlayerIns = playerIns
	vo.IsLockFish = playerIns.IsLockFish
	vo.ChairdID =  playerIns.ChairdID
	vo.IsMe = (playerIns.ChairdID == self.gameData.PlayerChairId)
	return vo
end

function FireStormSkillManager:GetFireStormSkill(fireStormSkillVo)
	if self.AllUseSkillInsList and #self.AllUseSkillInsList>0 then
		local tempFireStormSkillIns= table.remove(self.AllUseSkillInsList,1)
		if tempFireStormSkillIns then
			tempFireStormSkillIns:ResetSkillVo(fireStormSkillVo)
			self.CurrentUseSkillInsList[fireStormSkillVo.UID]= tempFireStormSkillIns
			return tempFireStormSkillIns
		end
	else
		local tempFireStormSkillIns= self.FireStormSkillItem.New()
		if tempFireStormSkillIns then
			tempFireStormSkillIns:ResetSkillVo(fireStormSkillVo)
			self.CurrentUseSkillInsList[fireStormSkillVo.UID]= tempFireStormSkillIns
			return tempFireStormSkillIns
		end
	end
	return nil
end

function FireStormSkillManager:ClearAllFireStormSkill()
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveFireStormSkill()
	end
	self.CurrentUseSkillInsList = {}
end

function FireStormSkillManager:ClearOtherFireStormSkill(charidID)
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.SkillVo.ChairdID == charidID then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveFireStormSkill()
	end
end

function FireStormSkillManager:RecycleFireStormSkill(fireStormSkillVo)
	local tempFireStormSkillIns =self.CurrentUseSkillInsList[fireStormSkillVo.UID]
	if tempFireStormSkillIns then
		table.insert(self.AllUseSkillInsList,tempFireStormSkillIns)
		self.CurrentUseSkillInsList[fireStormSkillVo.UID]=nil
	else
		Debug.LogError("回收FireStormSkillItem失败==>"..fireStormSkillVo.UID)
	end	
end

function FireStormSkillManager:UpdateRemoveFireStormSkill()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleFireStormSkill(v.SkillVo)
			end
		end
	end
end

function FireStormSkillManager:OnUpdate()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if not v.isCanDestory then
				v:Update()
			end
		end
	end
end

function FireStormSkillManager:Update()
	self:OnUpdate()
	self:UpdateRemoveFireStormSkill()
end


function FireStormSkillManager:__delete()
	self:RemoveEventListenner()
	self.AllUseSkillInsList= nil
	self.CurrentUseSkillInsList= nil
	self.Animator=nil
	self.Text=nil
	self.Button = nil
	self.Tween = nil
	self.Sequence = nil
	self.Ease = nil
	self.DOTween = nil
	self.TweenExtensions = nil
end

