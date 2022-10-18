ElectricSkillManager=Class()

local Instance=nil
function ElectricSkillManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function ElectricSkillManager.GetInstance()
	return Instance
end

function ElectricSkillManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end

function ElectricSkillManager:InitData()
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

function ElectricSkillManager:AddScripts()
	self.ScriptsPathList={
		"/View/Skill/ElectricSkill/Skill/ElectricSkillItem",
	}
end


function ElectricSkillManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end

function ElectricSkillManager:InitView(gameObj)
	
end

function ElectricSkillManager:InitInstance()
	self.ElectricSkillItem=ElectricSkillItem
end

function ElectricSkillManager:InitViewData()	
	
end

function ElectricSkillManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONAIM_RSP"),self.ResponesDianCiCannonAimMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONSHOOT_RSP"),self.ResponesDianCiCannonShootMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONDESTORY_RSP"),self.ResponesDianCiCannonDestroyMsg,self)
end

function ElectricSkillManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONAIM_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONSHOOT_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONDESTORY_RSP"))
end

function ElectricSkillManager:RequestDianCiCannonAimMsg(chairID,electriclAngle,electricUID)
	local sendAimEletric={}
	sendAimEletric.usChairId=chairID
	sendAimEletric.usDianCiCannonId=electricUID
	sendAimEletric.usAngle = electriclAngle
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.DianCiCannonAimReq", sendAimEletric)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONAIM_REQ"),bytes)
end


function ElectricSkillManager:ResponesDianCiCannonAimMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.DianCiCannonAimRsp",msg)
	local electricSkillItem = self.CurrentUseSkillInsList[data.usDianCiCannonId]
	if electricSkillItem then
		electricSkillItem:ChangeElectricSkillAim(data.usChairId,data.usAngle)
	end
end

function ElectricSkillManager:RequestDianCiCannonShootMsg(chairID, electriclAngle,electricUID)
	local sendShootEletric={}
	sendShootEletric.usChairId=chairID
	sendShootEletric.usDianCiCannonId=electricUID
	sendShootEletric.usAngle = electriclAngle
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.DianCiCannonShootReq", sendShootEletric)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONSHOOT_REQ"),bytes)
end

function ElectricSkillManager:ResponesDianCiCannonShootMsg(msg)
	
	local data=LuaProtoBufManager.Decode("Fish_Msg.DianCiCannonShootRsp",msg)
	local electricSkillItem = self.CurrentUseSkillInsList[data.usDianCiCannonId]
	if electricSkillItem then
		GameUIManager.GetInstance():IsGamePress(false)
		electricSkillItem.SkillVo.usProcUserChairId = data.usProcUserChairId
		electricSkillItem:ShootGunElectric(data.usChairId,data.usAngle,0)
	end
end


function ElectricSkillManager:RequestDianCiCannonHitFishMsg(chairID,UID,hitFishTable,robotChairId)
	local eletricHitFishs={}
	eletricHitFishs.usChairId=chairID
	eletricHitFishs.usDianCiCannonId=UID
	eletricHitFishs.SubFishes = hitFishTable
	eletricHitFishs.usRobotChairId = robotChairId
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.DianCiCannonHitFishReq", eletricHitFishs)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_DIANCICANNONHITFISH_REQ"),bytes)
end


function ElectricSkillManager:ResponesDianCiCannonDestroyMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.DianCiCannonDestroyRsp",msg)
	local electricSkillItem = self.CurrentUseSkillInsList[data.usDianCiCannonId]

	local specialDeclareUID = self.SpecialDeclareList[data.usDianCiCannonId]
	if specialDeclareUID then
		self:ShowSpecialDeclareScore(specialDeclareUID,data.usTotalScore,data.usTotalMul)
		self.SpecialDeclareList[data.usDianCiCannonId] = nil
	end
end

function ElectricSkillManager:ElectricAimOnClick(isPress)
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v:ElectricAimOnClick()
		end
	end
end

function ElectricSkillManager:EnterEletricSkillMode(data)
	local fishIns = FishManager.GetInstance():GetUsingFishByFishUID(data.usKilledFishId)
	local playerIns = PlayerManager.GetInstance():GetPlayerInsByChairdId(data.usChairId)
	local UID = data.usDianCiCannonId
	local electricSkillStatus =data.usDianCiCannonStatus
	local electricSkillTime = data.usDianCiCannonStatusTime
	local fishId = data.usKilledFishKind
	local beginPos = CSScript.Vector3.zero
	if fishIns then
		beginPos = fishIns.gameObject.transform.position
	end

	if self.CurrentUseSkillInsList[data.usDianCiCannonId] == nil then
	 	self:CreateEletricSkill(UID,beginPos,playerIns,electricSkillStatus,electricSkillTime)
	else
		self.CurrentUseSkillInsList[data.usDianCiCannonId].isCanDestory = true
		self:UpdateRemoveElectricSkill()
		self:CreateEletricSkill(UID,beginPos,playerIns,electricSkillStatus,electricSkillTime)
	end

	if playerIns:GetOnlineState() == true then
		self:ShowSpecialDeclareEffect(UID,fishId,playerIns)
	end
end

function ElectricSkillManager:CreateEletricSkill(UID,beginPos,playerIns,electricSkillStatus,electricSkillTime)
	local eletricSkillVo=self:GetEletricSkillVo(UID,playerIns)
	local tempElectricSkillIns=self:GetElectricSkill(eletricSkillVo)
	if tempElectricSkillIns then
		tempElectricSkillIns:ResetSkillState(beginPos,electricSkillStatus,electricSkillTime)
	else
		Debug.LogError("获取EletricSkill失败==>")
	end
end

function ElectricSkillManager:GetEletricSkillVo(UID,playerIns)
	local vo={}
	vo.UID= UID
	vo.PlayerIns = playerIns
	vo.ChairdID = playerIns.ChairdID
	vo.IsMe = (playerIns.ChairdID == self.gameData.PlayerChairId)
	return vo
end

function ElectricSkillManager:GetElectricSkill(eletricSkillVo)
	if self.AllUseSkillInsList and #self.AllUseSkillInsList>0 then
		local tempElectricSkillIns= table.remove(self.AllUseSkillInsList,1)
		if tempElectricSkillIns then
			tempElectricSkillIns:ResetSkillVo(eletricSkillVo)
			
			self.CurrentUseSkillInsList[eletricSkillVo.UID]= tempElectricSkillIns
			return tempElectricSkillIns
		end
	else
		local tempElectricSkillIns= self.ElectricSkillItem.New()
		if tempElectricSkillIns then
			tempElectricSkillIns:ResetSkillVo(eletricSkillVo)
		
			self.CurrentUseSkillInsList[eletricSkillVo.UID]= tempElectricSkillIns
			return tempElectricSkillIns
		end
	end
	return nil
end


function ElectricSkillManager:ShowSpecialDeclareEffect(UID,fishId,playerIns)
	local fishConfig = self.gameData.gameConfigList.FishConfigList[fishId]
	local damageDieConfig = self.gameData.gameConfigList.DieEffectConfigList[fishConfig.dieEffectId]
	local specialDeclareConfig = SpecialDeclareEffectManager.GetInstance():GetSpecialDeclareEffectConfig(damageDieConfig.specialDeclareID)
	local specialDeclareUID = SpecialDeclareEffectManager.GetInstance():SetSpecialDeclareEffectShowMode(playerIns.ChairdID,playerIns.SpecialDeclarePanel.position,specialDeclareConfig)
	self.SpecialDeclareList[UID] = specialDeclareUID
end

function ElectricSkillManager:ShowSpecialDeclareScore(specialDeclareUID,score,multiple)
	SpecialDeclareEffectManager.GetInstance():BeginSpecialDeclareEffectChangeScore(specialDeclareUID,score,multiple)
end


function ElectricSkillManager:ClearAllElectricSkill()
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveElectricSkill()
	end
	self.CurrentUseSkillInsList = {}
end

function ElectricSkillManager:ClearOtherPlayerElectricSkill(charidID)
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.SkillVo.ChairdID == charidID then
				v.isCanDestory=true
			end
		end
		self:UpdateRemoveElectricSkill()
	end
end

function ElectricSkillManager:RecycleElectricSkill(electricSkillVo)

	local tempElectricSkillIns =self.CurrentUseSkillInsList[electricSkillVo.UID]
	if tempElectricSkillIns then
		table.insert(self.AllUseSkillInsList,tempElectricSkillIns)
		self.CurrentUseSkillInsList[electricSkillVo.UID]=nil
	else
		Debug.LogError("回收ElectricSkillItem失败==>"..electricSkillVo.UID)
	end	
end

function ElectricSkillManager:UpdateRemoveElectricSkill()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleElectricSkill(v.SkillVo)
			end
		end
	end
end

function ElectricSkillManager:OnUpdate()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if not v.isCanDestory then
				v:Update()
			end
		end
	end
end

function ElectricSkillManager:Update()
	self:OnUpdate()
	self:UpdateRemoveElectricSkill()
end

function ElectricSkillManager:__delete()
	self:RemoveEventListenner()
	self.AllUseSkillInsList= nil
	self.CurrentUseSkillInsList= nil
	self.SpecialDeclareList = nil
	self.Animator = nil
	self.Text = nil
	self.Button = nil
	self.Tween = nil
	self.Sequence = nil
	self.Ease = nil
	self.DOTween = nil
	self.TweenExtensions = nil
end
