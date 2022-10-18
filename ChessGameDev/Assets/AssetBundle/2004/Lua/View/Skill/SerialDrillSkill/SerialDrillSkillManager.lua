SerialDrillSkillManager=Class()

local Instance=nil
function SerialDrillSkillManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function SerialDrillSkillManager.GetInstance()
	return Instance
end


function SerialDrillSkillManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end

function SerialDrillSkillManager:InitData()
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

function SerialDrillSkillManager:AddScripts()
	self.ScriptsPathList={
		"/View/Skill/SerialDrillSkill/Skill/SerialDrillSkillItem",
		"/View/Skill/SerialDrillSkill/Skill/SerialDrillBullet",
	}
end


function SerialDrillSkillManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function SerialDrillSkillManager:InitView(gameObj)
	
end


function SerialDrillSkillManager:InitInstance()
	self.SerialDrillSkillItem=SerialDrillSkillItem
	self.SerialDrillBullet = SerialDrillBullet
end


function SerialDrillSkillManager:InitViewData()	
	
end


function SerialDrillSkillManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_SOMEZUANTOUSHOOT_RSP"),self.ResponesSerialDrillShootMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_SOMEZUANTOBOMB_RSP"),self.ResponesSerialDrillBombMsg,self)
end

function SerialDrillSkillManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_SOMEZUANTOUSHOOT_RSP"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_SOMEZUANTOBOMB_RSP"))
end

function SerialDrillSkillManager:ResponesSerialDrillShootMsg(msg)
	pt(msg)

	local data=LuaProtoBufManager.Decode("Fish_Msg.SomeZuanTouShootRsp",msg)
	local serialDrillSkillItem = self.CurrentUseSkillInsList[data.usSomeZuanTouId]
	if serialDrillSkillItem then
		local bulletInfo = {}
		bulletInfo.serialDrillBulletID = data.someZuanTou.usZuanTouId
		bulletInfo.shootAngle =  data.someZuanTou.usAngle
		bulletInfo.traceID = data.someZuanTou.usTraceId
		bulletInfo.traceStartPoint =  data.someZuanTou.usTraceStartPt
		serialDrillSkillItem:UpdateSkillVo(bulletInfo.serialDrillBulletID,bulletInfo)
		serialDrillSkillItem:ShootSerialGunDrill(bulletInfo.serialDrillBulletID,bulletInfo.shootAngle )
	end	
end


function SerialDrillSkillManager:RequestSerialDrillHitFishMsg(chairID,serialDrillUID,bulletUID,hitFishTable)
	local drillHitFishs={}
	drillHitFishs.usChairId=chairID
	drillHitFishs.usSomeZuanTouId=serialDrillUID
	drillHitFishs.usZuanTouId=bulletUID
	drillHitFishs.SubFishes = hitFishTable
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.SomeZuanTouHitFishReq", drillHitFishs)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_FISH_CMD_SOMEZUANTOUHITFISH_REQ"),bytes)
end

function SerialDrillSkillManager:ResponesSerialDrillBombMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.SomeZuanTouBombRsp",msg)
	local serialDrillSkillItem = self.CurrentUseSkillInsList[data.usSomeZuanTouId]
	if serialDrillSkillItem then
		serialDrillSkillItem:BombSerialDrillSkill()
	end
end


function SerialDrillSkillManager:EnterSerialDrillSkillMode(data)
	local fishIns = FishManager.GetInstance():GetUsingFishByFishUID(data.usKilledFishId)
	local playerIns = PlayerManager.GetInstance():GetPlayerInsByChairdId(data.usChairId)
	local UID = data.usSomeZuanTouId
	local serialDrillBulletList = {}

	if data.zuanTous and next(data.zuanTous) then
		for i=1,#data.zuanTous do
			local bulletInfo = {}
			bulletInfo.serialDrillBulletID = data.zuanTous[i].usZuanTouId
			bulletInfo.shootAngle =  data.zuanTous[i].usAngle
			bulletInfo.traceID = data.zuanTous[i].usTraceId
			bulletInfo.traceStartPoint = data.zuanTous[i].usTraceStartPt
			serialDrillBulletList[bulletInfo.serialDrillBulletID] = bulletInfo
		end
	end
	local skillStatus =data.usZuanTouStatus
	local skillTime = data.usZuanTouStatusTime
	local beginPos = fishIns.gameObject.transform.parent:InverseTransformPoint(CSScript.Vector3.zero)
	self:CreateSerialDrillSkill(UID,beginPos,playerIns,serialDrillBulletList,skillStatus,skillTime)
end


function SerialDrillSkillManager:CreateSerialDrillSkill(UID,beginPos,playerIns,serialDrillBulletList,skillStatus,skillTime)
	local serialDrillSkillVo=self:GetSerialDrillSkillVo(UID,serialDrillBulletList,playerIns)
	local tempSerialDrillSkillIns=self:GetSerialDrillSkill(serialDrillSkillVo)
	if tempSerialDrillSkillIns then
		tempSerialDrillSkillIns:ResetSkillState(beginPos,skillStatus,skillTime)
	else
		Debug.LogError("获取SerialDrillSkill失败==>")
	end
end


function SerialDrillSkillManager:GetSerialDrillSkillVo(UID,serialDrillBulletList,playerIns)
	local vo={}
	vo.UID = UID
	vo.SerialDrillBulletList = serialDrillBulletList
	vo.PlayerIns = playerIns
	vo.IsMe = (playerIns.ChairdID == self.gameData.PlayerChairId)
	return vo
end

function SerialDrillSkillManager:GetSerialDrillSkill(serialDrillSkillVo)
	if self.AllUseSkillInsList and #self.AllUseSkillInsList>0 then
		local tempSerialDrillSkillIns= table.remove(self.AllUseSkillInsList,1)
		if tempSerialDrillSkillIns then
			tempSerialDrillSkillIns:ResetSkillVo(serialDrillSkillVo)
			self.CurrentUseSkillInsList[serialDrillSkillVo.UID]= tempSerialDrillSkillIns
			return tempSerialDrillSkillIns
		end
	else
		local tempSerialDrillSkillIns= self.SerialDrillSkillItem.New()
		if tempSerialDrillSkillIns then
			tempSerialDrillSkillIns:ResetSkillVo(serialDrillSkillVo)
			self.CurrentUseSkillInsList[serialDrillSkillVo.UID]= tempSerialDrillSkillIns
			return tempSerialDrillSkillIns
		end
	end
end

function SerialDrillSkillManager:ClearAllSerialDrillSkill()
	if self.CurrentUseSkillInsList then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			v.isCanDestory=true
		end
		self:UpdateRemoveSerialDrillSkill()
	end
end


function SerialDrillSkillManager:RecycleSerialDrillSkill(serialDrillSkillVo)
	local tempSerialDrillSkillIns =self.CurrentUseSkillInsList[serialDrillSkillVo.UID]
	if tempSerialDrillSkillIns then
		table.insert(self.AllUseSkillInsList,tempSerialDrillSkillIns)
		self.CurrentUseSkillInsList[serialDrillSkillVo.UID]=nil
	else
		Debug.LogError("回收SerialDrillSkillItem失败==>"..serialDrillSkillVo.UID)
	end	
end

function SerialDrillSkillManager:UpdateRemoveSerialDrillSkill()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if v.isCanDestory then
				v:Destroy()
				self:RecycleSerialDrillSkill(v)
			end
		end
	end
end

function SerialDrillSkillManager:OnUpdate()
	if self.CurrentUseSkillInsList and next(self.CurrentUseSkillInsList) then
		for k,v in pairs(self.CurrentUseSkillInsList) do
			if not v.isCanDestory then
				v:Update()
			end
		end
	end
end

function SerialDrillSkillManager:Update()
	self:OnUpdate()
	self:UpdateRemoveSerialDrillSkill()
end

function SerialDrillSkillManager:__delete()
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