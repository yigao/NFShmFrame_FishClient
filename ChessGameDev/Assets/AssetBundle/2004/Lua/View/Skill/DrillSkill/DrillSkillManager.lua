DrillSkillManager=Class()

local Instance=nil
function DrillSkillManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function DrillSkillManager.GetInstance()
	return Instance
end


function DrillSkillManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end



function DrillSkillManager:InitData()
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

function DrillSkillManager:AddScripts()
	self.ScriptsPathList={
		"/View/Skill/DrillSkill/Skill/DrillSkillItem",
		"/View/Skill/DrillSkill/Skill/DrillBullet",
	}
end


function DrillSkillManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function DrillSkillManager:InitView(gameObj)
	
end


function DrillSkillManager:InitInstance()
	self.DrillSkillItem=DrillSkillItem
	self.DrillBullet = DrillBullet
end


function DrillSkillManager:InitViewData()	
	
end


function DrillSkillManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUAIM_RSP"),self.ResponesDrillAimMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUSHOOT_RSP"),self.ResponesDrillShootMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUBOMB_RSP"),self.ResponesDrillBombMsg,self)
end

function DrillSkillManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUAIM_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUSHOOT_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUBOMB_RSP"))
end


function DrillSkillManager:RequestDrillAimMsg(chairID, drillAngle,drillUID)
	local zuanTouAimDrill={}
	zuanTouAimDrill.usChairId=chairID
	zuanTouAimDrill.usZuanTouId=drillUID
	zuanTouAimDrill.usAngle = drillAngle
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.ZuanTouAimRsp", zuanTouAimDrill)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUAIM_REQ"),bytes)
end


function DrillSkillManager:ResponesDrillAimMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.ZuanTouAimRsp",msg)
	local drillSkillItem = self.CurrentUseSkillInsList[data.usZuanTouId]
	if drillSkillItem then
		drillSkillItem:ChangeDrillSkillAim(data.usChairId,data.usAngle)
	end
end

function DrillSkillManager:RequestDrillShootMsg(chairID, drillAngle,drillUID)
	local zuanTouShoot={}
	zuanTouShoot.usChairId=chairID
	zuanTouShoot.usZuanTouId=drillUID
	zuanTouShoot.usAngle = drillAngle
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.ZuanTouShootReq", zuanTouShoot)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUSHOOT_REQ"),bytes)
end

function DrillSkillManager:ResponesDrillShootMsg(msg)
	pt(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.ZuanTouShootRsp",msg)

	local drillSkillItem = self.CurrentUseSkillInsList[data.usZuanTouId]
	if drillSkillItem then
		GameUIManager.GetInstance():IsGamePress(false)
		drillSkillItem.SkillVo.TraceID = data.usTraceId
		drillSkillItem.SkillVo.TraceStartPoint = data.usTraceStartPt
		drillSkillItem.SkillVo.usProcUserChairId = data.usProcUserChairId
		drillSkillItem:ShootGunDrill(data.usChairId,data.usAngle,0)
	end
end

function DrillSkillManager:RequestDrillHitFishMsg(chairID,UID,hitFishTable,robotChairId)
	local drillHitFishs={}
	drillHitFishs.usChairId=chairID
	drillHitFishs.usZuanTouId=UID
	drillHitFishs.SubFishes = hitFishTable
	drillHitFishs.usRobotChairId = robotChairId
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.ZuanTouHitFishReq", drillHitFishs)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_ZUANTOUHITFISH_REQ"),bytes)
end

function DrillSkillManager:ResponesDrillBombMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.ZuanTouBombRsp",msg)
	local drillSkillItem = self.CurrentUseSkillInsList[data.usZuanTouId]
	if drillSkillItem then
		drillSkillItem:BombDrillSkill(data.usTotalScore,data.usTotalMul)
	end
end

function DrillSkillManager:DrillAimOnClick(isPress)
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v:DrillAimOnClick()
		end
	end
end

function DrillSkillManager:EnterDrillSkillMode(data)
	local fishIns = FishManager.GetInstance():GetUsingFishByFishUID(data.usKilledFishId)
	local playerIns = PlayerManager.GetInstance():GetPlayerInsByChairdId(data.usChairId)
	local UID = data.usZuanTouId
	local traceID = data.usTraceId
	local traceStartPt = data.usTraceStartPt
	local skillStatus =data.usZuanTouStatus
	local skillTime = data.usZuanTouStatusTime
	local bombFishId = data.bombFishId
	local beginPos = CSScript.Vector3.zero
	if fishIns then
		beginPos = fishIns.gameObject.transform.position
	end

	if self.CurrentUseSkillInsList[data.usZuanTouId] == nil then
	 	self:CreateDrillSkill(UID,beginPos,playerIns,traceID,traceStartPt,skillStatus,skillTime)
	else
		if skillStatus == 1  then
			self.CurrentUseSkillInsList[data.usZuanTouId].isCanDestory = true
			self:UpdateRemoveDrillSkill()
	 		self:CreateDrillSkill(UID,beginPos,playerIns,traceID,traceStartPt,skillStatus,skillTime)
		elseif skillStatus == 2 then
			Debug.LogError("钻头螃蟹正处在发射状态")
		end
	end

	if playerIns:GetOnlineState() == true then
		self:ShowSpecialDeclareEffect(UID,bombFishId,playerIns)
	end
end


function DrillSkillManager:CreateDrillSkill(UID,beginPos,playerIns,traceID,traceStartPt,skillStatus,skillTime)
	local drillSkillVo=self:GetDrillSkillVo(UID,traceID,traceStartPt,playerIns)
	local tempdrillSkillIns=self:GetDrillSkill(drillSkillVo)
	if tempdrillSkillIns then
		tempdrillSkillIns:ResetSkillState(beginPos,skillStatus,skillTime)
	else
		Debug.LogError("获取DrillSkill失败==>")
	end
end

function DrillSkillManager:GetDrillSkillVo(UID,traceID,traceStartPt,playerIns)
	local vo={}
	vo.UID = UID
	vo.TraceID = traceID
	vo.TraceStartPoint = traceStartPt
	vo.PlayerIns = playerIns
	vo.ChairdID = playerIns.ChairdID
	vo.IsMe = (playerIns.ChairdID == self.gameData.PlayerChairId)
	return vo
end

function DrillSkillManager:GetDrillSkill(drillSkillVo)
	if self.AllUseSkillInsList and #self.AllUseSkillInsList>0 then
		local tempDrillSkillIns= table.remove(self.AllUseSkillInsList,1)
		if tempDrillSkillIns then
			tempDrillSkillIns:ResetSkillVo(drillSkillVo)
			self.CurrentUseSkillInsList[drillSkillVo.UID]= tempDrillSkillIns
			return tempDrillSkillIns
		end
	else
		local tempDrillSkillIns= self.DrillSkillItem.New()
		if tempDrillSkillIns then
			tempDrillSkillIns:ResetSkillVo(drillSkillVo)
			self.CurrentUseSkillInsList[drillSkillVo.UID]= tempDrillSkillIns
			return tempDrillSkillIns
		end
	end
	return nil
end

function DrillSkillManager:ShowSpecialDeclareEffect(UID,fishId,playerIns)
	local fishConfig = self.gameData.gameConfigList.FishConfigList[fishId]
	local damageDieConfig = self.gameData.gameConfigList.DieEffectConfigList[fishConfig.dieEffectId]
	local specialDeclareConfig = SpecialDeclareEffectManager.GetInstance():GetSpecialDeclareEffectConfig(damageDieConfig.specialDeclareID)
	local specialDeclareUID = SpecialDeclareEffectManager.GetInstance():SetSpecialDeclareEffectShowMode(playerIns.ChairdID,playerIns.SpecialDeclarePanel.position,specialDeclareConfig)
	self.SpecialDeclareList[UID] = specialDeclareUID
end

function DrillSkillManager:ShowSpecialDeclareScore(drillUID,score,multiple)
	local specialDeclareUID = self.SpecialDeclareList[drillUID]
	if specialDeclareUID then
		self.SpecialDeclareList[drillUID] = nil
		SpecialDeclareEffectManager.GetInstance():BeginSpecialDeclareEffectChangeScore(specialDeclareUID,score,multiple)
	end
end

function DrillSkillManager:ClearAllDrillSkill()
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveDrillSkill()
	end
	self.CurrentUseSkillInsList ={}
end

function DrillSkillManager:ClearOtherDrillSkill(charidID)
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.SkillVo.ChairdID == charidID and  v:IsDrillShoot() == false then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveDrillSkill()
	end
end


function DrillSkillManager:RecycleDrillSkill(drillSkillVo)
	local tempDrillSkillIns =self.CurrentUseSkillInsList[drillSkillVo.UID]
	if tempDrillSkillIns then
		table.insert(self.AllUseSkillInsList,tempDrillSkillIns)
		self.CurrentUseSkillInsList[drillSkillVo.UID]=nil
	else
		Debug.LogError("回收DrillSkillItem失败==>"..drillSkillVo.UID)
	end	
end

function DrillSkillManager:UpdateRemoveDrillSkill()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleDrillSkill(v.SkillVo)
			end
		end
	end
end

function DrillSkillManager:OnUpdate()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if not v.isCanDestory then
				v:Update()
			end
		end
	end
end

function DrillSkillManager:Update()
	self:OnUpdate()
	self:UpdateRemoveDrillSkill()
end

function DrillSkillManager:__delete()
	self:RemoveEventListenner()
	self.AllUseSkillInsList= nil
	self.CurrentUseSkillInsList= nil
	self.SpecialDeclareList = nil

	self.Animator= nil
	self.Text= nil
	self.Button = nil
	self.Tween = nil
	self.Sequence = nil
	self.Ease = nil
	self.DOTween = nil
	self.TweenExtensions = nil
end


