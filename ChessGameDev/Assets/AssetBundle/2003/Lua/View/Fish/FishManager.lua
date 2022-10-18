FishManager=Class()

local Instance=nil
function FishManager:ctor(obj)
	Instance=self
	self.gameObject=obj
	self:Init(obj)
	CommonHelper.AddUpdate(self)
end


function FishManager:Init (obj)
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView(obj)
	self:InitInstance()
	self:InitViewData()
	self:AddEventListenner()
end



function FishManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.FishPrefixName="Fish_"
end

function FishManager:AddScripts()
	self.ScriptsPathList={
		"/View/Fish/FishVo/FishBase",
		"/View/Fish/FishVo/Fish",
		"/View/Fish/FishVo/ComboFish",
		"/View/Fish/FishVo/SpineFish",
		"/View/Fish/FishVo/TipsFish",
		}
end


function FishManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function FishManager:InitView(gameObj)
	
end


function FishManager:InitInstance()
	self.Fish=Fish
	self.ComboFish=ComboFish
	self.SpineFish=SpineFish
	self.TipsFish=TipsFish
end


function FishManager:InitViewData()	
	self.AllUsedFishInsList={}	
	self.CurrentUseFishList={}
	self.FishSortingOrderList={}
end


function FishManager:CreateChildFishVo(fishID)
	local localConfig=self.gameData.gameConfigList.FishConfigList[fishID]
	local vo={}
	vo.FishId=fishID
	vo.FishConfig=localConfig
	return vo
end


function FishManager:GetChildFish(fishID)
	local vo=self:CreateChildFishVo(fishID)
	local tempFish=self:GetFish(vo,false)
	if tempFish then
		self:SetRedFishState(tempFish)
	end
	return tempFish
end

--移除组合鱼中的子鱼实列并添加到当前未使用的列表中
function FishManager:AddChildFishToAllUsedFishList(fish)
	if not self.AllUsedFishInsList[fish.FishVo.FishId] then
		self.AllUsedFishInsList[fish.FishVo.FishId]={}
	end
	table.insert(self.AllUsedFishInsList[fish.FishVo.FishId],fish)
end


function FishManager:GetFish(vo,isAddCurrentUseFishList)
	if self.AllUsedFishInsList and self.AllUsedFishInsList[vo.FishId] and next(self.AllUsedFishInsList[vo.FishId]) then
		local fish=table.remove(self.AllUsedFishInsList[vo.FishId],1)
		if fish then
			if isAddCurrentUseFishList then
				if self.CurrentUseFishList[vo.UID] then
					Debug.LogError("FishUID存在相同==>>"..vo.UID)
					--GameManager.GetInstance():ShowUITips("FishUID存在相同==>>"..vo.UID,2)
					table.insert(self.AllUsedFishInsList[vo.FishId],fish)
					return nil
				end
				self.CurrentUseFishList[vo.UID]=fish
			end
			fish:ResetFishState(vo)
			return fish
		else
			Debug.LogError("获取存在中的fish为nil==>"..vo.FishId)
			return nil
		end
	else
		local fishName=""
		if vo.FishId<10 then
			fishName=self.FishPrefixName.."0"..vo.FishId
		else
			fishName=self.FishPrefixName..vo.FishId
		end
		local FishItem=GameObjectPoolManager.GetInstance():GetGameObject(fishName,GameObjectPoolManager.PoolType.FishPool)
		local fish=nil
		if FishItem then
			-- 根据鱼的类型配置决定使用哪种Fish实例
			local rawFishType=vo.FishConfig.clientBuildFishType
			if rawFishType==nil then  Debug.LogError("rawFishType类型不存在==>"..vo.FishId)  return nil end
			
			if rawFishType==self.gameData.GameConfig.FishType.Normal then
				fish=self.Fish.New()  
			elseif rawFishType==self.gameData.GameConfig.FishType.Combo then
				fish=self.ComboFish.New()
			elseif rawFishType==self.gameData.GameConfig.FishType.Spine then
				fish=self.SpineFish.New()
			elseif rawFishType==self.gameData.GameConfig.FishType.Tips then
				fish=self.TipsFish.New()
			else
				Debug.LogError("不存在的rawFishTypeID==>"..rawFishType)
			end
			if fish then
				if isAddCurrentUseFishList then
					if self.CurrentUseFishList[vo.UID] then
						Debug.LogError("FishUID存在相同==>>"..vo.UID)
						--GameManager.GetInstance():ShowUITips("NewFishUID存在相同==>>"..vo.UID,2)
						GameObjectPoolManager.GetInstance():ReCycleToGameObject(FishItem,GameObjectPoolManager.PoolType.FishPool)
						return nil
					end
					self.CurrentUseFishList[vo.UID]=fish		
				end
				fish:BuildFish(vo,FishItem)
			else
				GameObjectPoolManager.GetInstance():ReCycleToGameObject(FishItem,GameObjectPoolManager.PoolType.FishPool)
				Debug.LogError("Fish生成失败==>"..vo.FishId)
				return nil
			end
			
		else
			Debug.LogError("当前FishPool中不存在==>"..fishName)
			return nil
		end
		
		return fish
	end
end


function FishManager:RemoveFish(fish)
	--print("移除鱼==>"..fish.FishVo.UID)
	local tempFish=self.CurrentUseFishList[fish.FishVo.UID]
	if tempFish then
		if not self.AllUsedFishInsList[fish.FishVo.FishId] then
			self.AllUsedFishInsList[fish.FishVo.FishId]={}
		end
		table.insert(self.AllUsedFishInsList[fish.FishVo.FishId],tempFish)
		self.CurrentUseFishList[fish.FishVo.UID]=nil
	else
		Debug.LogError("移除的FishUID为nil==>"..fish.FishVo.UID)
	end
end



function FishManager:ClearAllUsingFish()
	if self.CurrentUseFishList  then
		for k,v in pairs(self.CurrentUseFishList) do
			 v:Destroy()
			 self:RemoveFish(v)	
		end
	end
	self.gameData.fishRawDataList={}
end

function FishManager:FishQuickOutScene(speed)
	speed=speed or 10
	if self.CurrentUseFishList  then
		for k,v in pairs(self.CurrentUseFishList) do
			 v.LuaBehaviour:FishQuickOutScene(speed)
		end
	end	
end


function FishManager:GetUsingFishByID(fishID)
	for k,tempFish in pairs(self.CurrentUseFishList) do
		if tempFish.FishVo.FishId==fishID then
			if tempFish then
				if not tempFish:GetIsDie() and not tempFish:GetIsDestoty() and tempFish:CheckBoundValid() then
					return tempFish
				end
			end
		end
	end
	return nil
end


function FishManager:GetUsingFishByFishUID(FishUID)
	local tempFish=self.CurrentUseFishList[FishUID]
	if tempFish and tempFish:GetIsDie()==false then
		return tempFish
	else
		Debug.LogError("获取的本地鱼为nil==>"..FishUID)
	end
	return nil
end

function FishManager:ParseFishConfig(msg)
	local localConfig=self.gameData.gameConfigList.FishConfigList[msg.usFishKind]
	local localDieEffectConfig = self.gameData.gameConfigList.DieEffectConfigList[localConfig.dieEffectId]
	local vo={}
	vo.FishId=msg.usFishKind
	vo.UID=msg.usFishID
	vo.FishConfig=localConfig
	vo.DieEffectConfig = localDieEffectConfig
	vo.FishKindGroup=msg.subFishKinds
	vo.TraceId = msg.usTraceId
	vo.StartPointIndex = msg.usStartIndex
	vo.OffsetIndex = msg.usOffsetIndex
	vo.OffsetPosX=msg.usOffsetPosX
	vo.OffsetPoxY=msg.usOffsetPoxY
	vo.DelayBornTime = msg.usBirthDelay
	vo.IsRedFish=msg.usIsRedFish

	vo.usGroupId=msg.usGroupId or -1
	
	if vo.FishConfig.clientBuildFishType==self.gameData.GameConfig.FishType.Combo and vo.FishKindGroup==nil then
		Debug.LogError("组合鱼异常==>"..vo.FishId)
		return nil
	end
	return vo
end



function FishManager:UpdateFish()
	if self.gameData.fishRawDataList and next(self.gameData.fishRawDataList) and GameManager.GetInstance().IsFocus then
		for k,v in pairs(self.gameData.fishRawDataList) do
			local vo=self:ParseFishConfig(v)
			if vo then
				local fish=self:GetFish(vo,true)
				if fish then
					self:SetRedFishState(fish)
					self:SetFishSortingOrder(fish)
					fish:BeginMove()
				end
			end
			
		end
		self.gameData.fishRawDataList={}
		
	end
end


function FishManager:UpdateFishAutoDestory()
	if self.CurrentUseFishList and next(self.CurrentUseFishList) then
		for k,v in pairs(self.CurrentUseFishList) do
			if v.isCanDestroy then
				v:Destroy()
				self:RemoveFish(v)	
			end
		end
	end
end



function FishManager:Update()
	--self:UpdateFish()
	self:UpdateFishAutoDestory()
	
end


function FishManager:SetRedFishState(fish)
	if fish.FishVo.IsRedFish==1 then
		if fish.SetRedFishColor then
			fish:SetRedFishColor()
		else
			Debug.LogError("获取红鱼Func异常===>"..fish.FishVo.FishId)
		end
		
	end
end


function FishManager:SetFishSortingOrder(fish)
	local orderIndex=self:GetFishSortingOrderIndex(fish)
	fish:SetMainFishOrder(orderIndex)
end


function FishManager:GetFishSortingOrderIndex(fish)
	if self.FishSortingOrderList[fish.FishVo.FishId]==nil then
		self.FishSortingOrderList[fish.FishVo.FishId]=fish.FishVo.FishConfig.layerMin
		return fish.FishVo.FishConfig.layerMin
	end
	if self.FishSortingOrderList[fish.FishVo.FishId]<fish.FishVo.FishConfig.layerMax then
		self.FishSortingOrderList[fish.FishVo.FishId]=self.FishSortingOrderList[fish.FishVo.FishId]+1
		return self.FishSortingOrderList[fish.FishVo.FishId]
	else
		self.FishSortingOrderList[fish.FishVo.FishId]=fish.FishVo.FishConfig.layerMin
		return fish.FishVo.FishConfig.layerMin
	end
end



function FishManager:PauseAssignationFish(fishList)
	for i=1,#fishList do
		if not fishList[i]:GetIsDestoty() then
			fishList[i]:SetFishMoveStatus(CS.FishLuaBehaviour.FishStatus.Pause)
		end
	end
end

function FishManager:ResumeAssignationFish(fishList)
	for i=1,#fishList do
		if not fishList[i]:GetIsDestoty() and not fishList[i]:GetIsDie() then
			fishList[i]:SetFishMoveStatus(CS.FishLuaBehaviour.FishStatus.Move)
		end
	end
end


function FishManager:GetCheckLockSaveFish(fishMsg)
	if fishMsg.usErrorCode==0 then
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(fishMsg.chairId)
		if playerIns then
			local hitFish=self:GetUsingFishByFishUID(fishMsg.mainFishUID)
			if hitFish then
				return hitFish,playerIns
			else
				Debug.LogError("获取本地KillFish为nil-KillFish的UID==>"..fishMsg.mainFishUID)
				pt(fishMsg)
			end
			
		else
			Debug.LogError("ResponesPlayerHitFishMsg获取玩家为nil")
		end
	else
		Debug.LogError("Server返回的HitFishCodeErrer==>"..fishMsg.usErrorCode)
	end
	return nil
end




function FishManager.GetInstance()
	return Instance
end




--------------------------------------------------------------handle事件回调-----------------------------------------------------

function FishManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_FishListRsp"),self.ReceiveFishTraceInfo,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_KillFishRsp"),self.ResponesHitFishNetMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_FreezeFishesRsp"),self.ResponesFixedScreenBombNetMsg,self)
	
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_LockOnOffRsp"),self.ResponesLockFishSwitchNetMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_LockFishRsp"),self.ResponesLockTargetFishNetMsg,self)
end

--TODO统一移除事件处理
function FishManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_FishListRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_KillFishRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_FreezeFishesRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_LockOnOffRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_SC_MSG_LockFishRsp"))
end

---------------------------------------------------鱼轨迹
function FishManager:ReceiveFishTraceInfo(msg)
	if GameManager.GetInstance().IsFocus==false then  self.gameData.fishRawDataList={}  return end
	--Debug.LogError("事件回调==>10004")
	local data=LuaProtoBufManager.Decode("Fish_Msg.FishListRsp",msg)
	--pt(data)
	if data.Fishes then
		self:SetFishTraceCondition(data.Fishes)
	else
		Debug.LogError("10004鱼轨迹异常==>")
	end
	
end

function FishManager:SetFishTraceCondition(fishs)
	local LimitTracePoint=CS.FishManager.LimitTracePoint
	for k,v in pairs(fishs) do
		local curIndex = (v.usStartIndex + v.usOffsetIndex)
        local isLimit = LimitTracePoint(v.usTraceId,curIndex)
		if isLimit then
			table.insert(self.gameData.fishRawDataList,v)
		else
			--Debug.LogError("isLimit==false==>"..v.usTraceId)
		end
	end
	
	self:UpdateFish()
end


----------------------------------------------------HitFish
function FishManager:RequestPlayerHitFishMsg(sendMsg)
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.HitfishReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_HitfishReq"),bytes)
end


function FishManager:ResponesHitFishNetMsg(msg)
	if GameManager.GetInstance().IsFocus==false then return end
	--Debug.LogError("HitFish事件回调==>10008")
	local data=LuaProtoBufManager.Decode("Fish_Msg.KillFishRsp",msg)
	--pt(data)
	self:ResponesPlayerHitFishProcess(data)
end

function FishManager:ResponesPlayerHitFishProcess(hitFishMsg)
	BombManager.GetInstance():CheckFishState(hitFishMsg)
end


function FishManager:ResponesFixedScreenBombNetMsg(msg)
	--Debug.LogError("FixedScreenBomb事件回调==>10026")
	local data=LuaProtoBufManager.Decode("Fish_Msg.FreezeFishesRsp",msg)
	--pt(data)
	BombManager.GetInstance():SetFixedScreenBombProcess(data)
end


-------------------------------------------------------LockFishSwitch
function FishManager:RequestLockFishSwitchNetMsg(sendMsg)
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.LockOnOffReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_LockOnOffReq"),bytes)
end


function FishManager:ResponesLockFishSwitchNetMsg(CBMsg)
	--Debug.LogError("LockFish事件回调==>10012")
	local data=LuaProtoBufManager.Decode("Fish_Msg.LockOnOffRsp",CBMsg)
	--pt(data)
	self:LockFishSwitchProcess(data)
end

function FishManager:LockFishSwitchProcess(data)
	if data.usErrorCode==0 then
		PlayerManager.GetInstance():ServerToClientLockFishSwitchProcess(data)
	end
end

------------------------------------------------------LockTargetFish
function FishManager:RequestLockTargetFishMsg(sendMsg)
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.LockFishReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","NF_CS_MSG_LockFishReq"),bytes)
end


function FishManager:ResponesLockTargetFishNetMsg(msg)
	--Debug.LogError("LockTargetFish事件回调==>10010")
	local data=LuaProtoBufManager.Decode("Fish_Msg.LockFishRsp",msg)
	--pt(data)
	self:LockTargetFishProcess(data)
end


function FishManager:LockTargetFishProcess(data)
	if data.usErrorCode==0  then
		--TODO 屏蔽掉自己
		if data.chairId~=self.gameData.PlayerChairId then
			PlayerManager.GetInstance():ServerToClientLockTragetFishProcess(data)
		end
		
	end
end


function FishManager:__delete()
	self:RemoveEventListenner()
	self.AllUsedFishInsList=nil	
	self.CurrentUseFishList=nil
	self.FishSortingOrderList=nil
	self.Fish=nil
	self.ComboFish=nil
	self.SpineFish=nil
	self.TipsFish=nil
end