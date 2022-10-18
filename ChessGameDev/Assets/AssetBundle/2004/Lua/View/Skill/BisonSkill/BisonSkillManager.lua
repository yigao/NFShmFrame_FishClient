BisonSkillManager=Class()

local Instance=nil
function BisonSkillManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function BisonSkillManager.GetInstance()
	return Instance
end


function BisonSkillManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end

function BisonSkillManager:InitData()
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

function BisonSkillManager:AddScripts()
	self.ScriptsPathList={
		"/View/Skill/BisonSkill/Skill/BisonSkillItem",
	}
end


function BisonSkillManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function BisonSkillManager:InitView(gameObj)
	
end


function BisonSkillManager:InitInstance()
	self.BisonSkillItem=BisonSkillItem
end


function BisonSkillManager:InitViewData()	
	
end


function BisonSkillManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DESTORYMADCOW_RSP"),self.ResponesBisonDestroyMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_MADCOWSTATUS_RSP"),self.ResponesBisonShootMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_MADCOWSCORE_RSP"),self.ResponesBisonScoreMsg,self)
end

function BisonSkillManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DESTORYMADCOW_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_MADCOWSTATUS_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_MADCOWSCORE_RSP"))
end


function BisonSkillManager:ResponesBisonShootMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.MadCowStatusRsp",msg)
	local bisonSkillItem = self.CurrentUseSkillInsList[data.usMadCowIdId]
	if bisonSkillItem  and data.usStatus == 2 then
		bisonSkillItem:BeginBisonShoot(0)
	end
end

function BisonSkillManager:ResponesBisonScoreMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.MadCowScoreRsp",msg)
	local bisonSkillItem = self.CurrentUseSkillInsList[data.usMadCowIdId]
	if bisonSkillItem then
		bisonSkillItem:RefreshBisonInfo(data.usTotalScore,data.usTotalMul)
	end
end


function BisonSkillManager:ResponesBisonDestroyMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.DestoryMadCowRsp",msg)
	local bisonSkillItem = self.CurrentUseSkillInsList[data.usMadCowId]
	if bisonSkillItem then
		bisonSkillItem:EndBisonSkill(data.usTotalScore,data.usTotalMul)
	end
end


function BisonSkillManager:EnterBisonSkillMode(data)
	local fishIns = FishManager.GetInstance():GetUsingFishByFishUID(data.usKilledFishId)
	local playerIns = PlayerManager.GetInstance():GetPlayerInsByChairdId(data.usChairId)
	local UID = data.usMadCowId
	local skillStatus =data.usStatus
	local skillTime = data.usStatusTime
	local skillScore = data.usTotalScore
	local skillMul = data.usTotalMul
	local direction = data.usRunDirection

	if self.CurrentUseSkillInsList[data.usMadCowId] == nil then
		 self:CreateBisonSkill(UID,playerIns,skillStatus,skillTime,skillScore,skillMul,direction)
	else
		Debug.LogError("牛正处在撞击状态")
	end
end

function BisonSkillManager:CreateBisonSkill(UID,playerIns,skillStatus,skillTime,skillScore,skillMul,direction)
	local bisonSkillVo=self:GetBisonSkillVo(UID,playerIns,direction)
	local tempBisonSkillIns=self:GetBisonSkill(bisonSkillVo)
	if tempBisonSkillIns then
		tempBisonSkillIns:ResetSkillState(skillStatus,skillTime,skillScore,skillMul)
	else
		Debug.LogError("获取BisonSkill失败==>")
	end
end

function BisonSkillManager:GetBisonSkillVo(UID,playerIns,direction)
	local vo={}
	vo.UID= UID
	vo.PlayerIns = playerIns
	vo.Direction = direction
	vo.ChairdID = playerIns.ChairdID
	vo.IsMe = (playerIns.ChairdID == self.gameData.PlayerChairId)
	return vo
end

function BisonSkillManager:GetBisonSkill(bisonSkillVo)
	if self.AllUseSkillInsList and #self.AllUseSkillInsList>0 then
		local tempBisonSkillIns= table.remove(self.AllUseSkillInsList,1)
		if tempBisonSkillIns then
			tempBisonSkillIns:ResetSkillVo(bisonSkillVo)
			self.CurrentUseSkillInsList[bisonSkillVo.UID]= tempBisonSkillIns
			return tempBisonSkillIns
		end
	else
		local tempBisonSkillIns= self.BisonSkillItem.New()
		if tempBisonSkillIns then
			tempBisonSkillIns:ResetSkillVo(bisonSkillVo)
			self.CurrentUseSkillInsList[bisonSkillVo.UID]= tempBisonSkillIns
			return tempBisonSkillIns
		end
	end
	return nil
end

function BisonSkillManager:ClearAllBisonSkill()
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveBisonSkill()
	end
	self.CurrentUseSkillInsList ={}
end


function BisonSkillManager:ClearOtherPlayerBisonSkill(charidID)
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.SkillVo.ChairdID == charidID then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveBisonSkill()
	end
end



function BisonSkillManager:RecycleBisonSkill(bisonSkillVo)
	local tempBisonSkillIns =self.CurrentUseSkillInsList[bisonSkillVo.UID]
	if tempBisonSkillIns then
		table.insert(self.AllUseSkillInsList,tempBisonSkillIns)
		self.CurrentUseSkillInsList[bisonSkillVo.UID]=nil
	else
		Debug.LogError("回收BisonSkillItem失败==>"..bisonSkillVo.UID)
	end	
end

function BisonSkillManager:UpdateRemoveBisonSkill()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleBisonSkill(v.SkillVo)
			end
		end
	end
end

function BisonSkillManager:OnUpdate()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if not v.isCanDestory then
				v:Update()
			end
		end
	end
end

function BisonSkillManager:Update()
	self:OnUpdate()
	self:UpdateRemoveBisonSkill()
end

function BisonSkillManager:__delete()
	self:RemoveEventListenner()
	self.AllUseSkillInsList= nil
	self.CurrentUseSkillInsList= nil
	self.Animator= nil
	self.Text=nil
	self.Button = nil
	self.Tween = nil
	self.Sequence = nil
	self.Ease = nil
	self.DOTween = nil
	self.TweenExtensions = nil
end
