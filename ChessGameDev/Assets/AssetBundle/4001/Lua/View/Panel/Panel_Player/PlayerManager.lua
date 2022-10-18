PlayerManager=Class()

local Instance=nil
function PlayerManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function PlayerManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Player
		local BuildPlayerPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				PlayerManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildPlayerPanelCallBack)
		
	else
		return Instance
	end
end


function PlayerManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function PlayerManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function PlayerManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitPlayerIns()
	self:AddEventListenner()
end

function PlayerManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserBetChipRsp"),self.ReponseMyUserBetChipMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_OtherUserBetChipRsp"),self.ReponseOtherUserBetChipMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserEnterDeskRsp"),self.ReponseOtherPlayerEnterRoomMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserLeaveDeskRsp"),self.ReponseOtherPlayerLeaveRoomMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserRepeatBetRsp"),self.ReponseMyUserRepeatBetRsp,self)
end

function PlayerManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserBetChipRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_OtherUserBetChipRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserEnterDeskRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserLeaveDeskRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_SC_MSG_UserRepeatBetRsp"))
end


function PlayerManager:InitData()
	self.gameData=GameUIManager.GetInstance().gameData
	self.playerVoList = {}
	self.PlayerInsList={}
end

function PlayerManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Player/View/PlayerView",
		"View/Panel/Panel_Player/Player/Player",
		"View/Panel/Panel_Player/Player/PlayerInfoView",
	}
end

function PlayerManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function PlayerManager:InitInstance()
	self.PlayerView=PlayerView.New(self.gameObject)
	self.Player=Player
	self.PlayerInfoView=PlayerInfoView
end


function PlayerManager:InitView()
	self.playerObjList=self.PlayerView.playerObjList
end


function PlayerManager:InitPlayerIns()
	for i=1,#self.playerObjList do
		local tempPlayerIns=self.Player.New(self.playerObjList[i],i)
		table.insert(self.PlayerInsList,tempPlayerIns)
	end
end

function PlayerManager:InitPlayerListData(playerDataList)
	self.playerVoList = playerDataList
	self:SetPlayerListSeat()
end


function PlayerManager:UpdatePlayerListVo(playerDataList)
	self.playerVoList = playerDataList
end


function PlayerManager:EnterGameStart()
	for i = 1,#self.PlayerInsList do 
		self.PlayerInsList[i]:InitAllPanel()
	end
	self:SetPlayerListSeat()
end

function PlayerManager:EnterBetChip()
	
end

function PlayerManager:EnterOpenPrize(aryPlayerList)
	self:UpdatePlayerListVo(aryPlayerList)
end


function PlayerManager:SetPlayerListSeat()
	self:ChangePlayerOrder()
	local count=#self.playerVoList
	if count>0 then
		local mySelfPlayerVo = self:GetPlayerVoByChairdId(self.gameData.PlayerChairId)
		self.PlayerInsList[1]:PlayerEnterSeat(mySelfPlayerVo)
		self.PlayerInsList[2]:PlayerEnterSeat(self.playerVoList[1])
		for i = 1,count do
			if (i<=#self.PlayerInsList-2) then
				self.PlayerInsList[i+2]:PlayerEnterSeat(self.playerVoList[i])
			end
		end
	end
end

function PlayerManager:SetResultScoreValue()
	for i = 1,#self.PlayerInsList do
		for j = 1,#self.playerVoList do
			if self.PlayerInsList[i]:GetPlayerChairID() == self.playerVoList[j].chair_id then
				self.PlayerInsList[i]:UpdatePlayerValue(self.playerVoList[j])
				self.PlayerInsList[i]:SetResultScoreValue(self.playerVoList[j].user_curWinMoney)
			end
		end
	end
end

function PlayerManager:ChangePlayerMoneyValue(aryPlayerInfo)
	for i = 1,#self.playerVoList do 
		for j = 1,#aryPlayerInfo do
			if self.playerVoList[i].chair_id == aryPlayerInfo[j].chair_id then
				self.playerVoList[i] = aryPlayerInfo[j]
				break
			end
		end
	end

	for i = 1,#self.PlayerInsList do
		for j = 1,#self.playerVoList do
			if self.PlayerInsList[i]:GetPlayerChairID() == self.playerVoList[j].chair_id then
				self.PlayerInsList[i]:SetPlayerMoney(self.playerVoList[j].user_money)
				break
			end
		end
	end
end

function PlayerManager:ChangePlayerOrder()
	table.sort(self.playerVoList,function(a,b) return a.user_money>b.user_money end)
	local index = self:GetPlayerByShenSuanZiIndex()
	local shenSuanZi = self.playerVoList[index]
	table.remove(self.playerVoList,index)
	table.insert(self.playerVoList,1,shenSuanZi)
end

function PlayerManager:GetWinPlayerVoListCount()
	local count = 0
	for i = 1,#self.playerVoList do
		if self.playerVoList[i].user_curWinMoney > 0 then
			count = count + 1
		end	
	end
	return count
end

function PlayerManager:GetWinPlayerInsList()
	local winPlayerInsList = {}
	for i = 1,#self.PlayerInsList do
		for j = 1,#self.playerVoList do
			if self.PlayerInsList[i]:GetPlayerChairID() == self.playerVoList[j].chair_id and self.playerVoList[j].user_curWinMoney > 0 then
				-- local flag = false
				-- for k=1,#winPlayerInsList do
				-- 	if self.PlayerInsList[i]:GetPlayerChairID() == winPlayerInsList[k]:GetPlayerChairID() then
				-- 		flag = true
				-- 		break
				-- 	end
				-- end
				-- if flag == false then
				table.insert(winPlayerInsList,self.PlayerInsList[i])
				--end
				break
			end
		end
	end
	return winPlayerInsList
end

function PlayerManager:GetPlayerVoByChairdId(chairId)
	for i = 1,#self.playerVoList do 
		if self.playerVoList[i].chair_id == chairId then
			return self.playerVoList[i]
		end
	end
end

function PlayerManager:GetPlayerBySeatId(chairId)
	for i = 1,#self.PlayerInsList do 
		if self.PlayerInsList[i]:GetPlayerChairID() == chairId then
			return self.PlayerInsList[i]
		end
	end
	return nil
end

function PlayerManager:IsShenSuanZiPlayer(chairId)
	if self.PlayerInsList[2]:GetPlayerChairID() == chairId then
		return  self.PlayerInsList[2]
	end
	return nil
end

function PlayerManager:GetMySelfPlayer()
	return self.PlayerInsList[1]
end

function PlayerManager:GetPlayerByShenSuanZi()
	local index = 1
	local min = self.playerVoList[index].user_curWinMoney
	for i = 1,#self.playerVoList do 
		if self.playerVoList[i].user_curWinMoney >= min then
			min = self.playerVoList[i].user_curWinMoney
			index = i
		end
	end
	return self.playerVoList[index]
end

function PlayerManager:GetPlayerByShenSuanZiIndex()
	local index = 1
	local min = self.playerVoList[index].user_curWinMoney
	for i = 1,#self.playerVoList do 
		if self.playerVoList[i].user_curWinMoney >= min then
			min = self.playerVoList[i].user_curWinMoney
			index = i
		end
	end
	return index
end

function PlayerManager:AddOtherPlayer(playerVo)
	local tmpPlayerVo=self:GetPlayerVoByChairdId(playerVo.chair_id)
	if tmpPlayerVo == nil then
		table.insert(self.playerVoList,playerVo)
		self:SetPlayerListSeat()
	else
		Debug.LogError("当前位置玩家进入异常==>"..playerVo.chair_id)
	end
end

function PlayerManager:LeaveOtherPlayer(chairID)
	local index = 0
	for i = 1,#self.playerVoList do 
		if self.playerVoList[i].chair_id == chairID then
			index = i
		end
	end
	table.remove(self.playerVoList,index)
	self:SetPlayerListSeat()
end

function PlayerManager:RequestUserBetChipMsg(areaIndex,chipIndex)
	local sendMsg={}
	sendMsg.areaIndex= areaIndex
	sendMsg.chipIndex = chipIndex
	local bytes = LuaProtoBufManager.Encode("Lhd_Msg.UserBetChipReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_CS_MSG_UserBetChipReq"),bytes)
end

function PlayerManager:RequestUserRepeatBetMsg()
	local sendMsg={}
	sendMsg.Reserved= 0
	local bytes = LuaProtoBufManager.Encode("Lhd_Msg.UserRepeatBetReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Lhd_Msg.Proto_CS_CMD","NF_CS_MSG_UserRepeatBetReq"),bytes)
end

function PlayerManager:ReponseMyUserBetChipMsg(msg)
	local data=LuaProtoBufManager.Decode("Lhd_Msg.UserBetChipRsp",msg)
	if data.result == 0 then
		local isMe = false
		if data.aryPlayerChipInfo and #data.aryPlayerChipInfo >= 1 then
			local beginPos = BaseFctManager.GetInstance():GetOtherPlayerBetInitPosition()
			for i =1,#data.aryPlayerChipInfo do
				local tempPlayerIns = self:GetPlayerBySeatId(data.aryPlayerChipInfo[i].usChairId)
				local shenSuanZiPlayerIns = self:IsShenSuanZiPlayer(data.aryPlayerChipInfo[i].usChairId)
				if tempPlayerIns then
					if shenSuanZiPlayerIns then
						shenSuanZiPlayerIns:PlayXingxingEffect(data.aryPlayerChipInfo[i].areaIndex)
						if data.aryPlayerChipInfo[i].usChairId == self.gameData.PlayerChairId then
							isMe = true
							beginPos = self:GetMySelfPlayer():GetBetInitPosition()
						else
							isMe = false
							beginPos = shenSuanZiPlayerIns:GetBetInitPosition()
						end
					else
						if data.aryPlayerChipInfo[i].usChairId == self.gameData.PlayerChairId then
							isMe = true
							beginPos = self:GetMySelfPlayer():GetBetInitPosition()
						else
							isMe = false
							beginPos = tempPlayerIns:GetBetInitPosition()
						end
					end
					tempPlayerIns:PlayMoveAnimation()
				end
				BetChipManager.GetInstance():CrateBetChip(isMe,true,beginPos,data.aryPlayerChipInfo[i].areaIndex,data.aryPlayerChipInfo[i].chipIndex,data.aryPlayerChipInfo[i].addBetChipMoney,data.aryPlayerChipInfo[i].ownBetChipMoney,data.allBetChipMoney)
			end
			self:ChangePlayerMoneyValue(data.aryPlayerInfo)
		end
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_WRONG_CHIP") then
		GameManager.GetInstance():ShowUITips("错误的押注筹码！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_OVER_MAX_MONEY") then
		GameManager.GetInstance():ShowUITips("超过区域最大下注额！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_UNKNOWN") then
		GameManager.GetInstance():ShowUITips("未知错误！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_NO_DATA_CLEAR") then
		GameManager.GetInstance():ShowUITips("押注错误区域！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_NT_CANT_BET") then
		GameManager.GetInstance():ShowUITips("庄家不能下注！！！",3)
	end
end

function PlayerManager:ReponseMyUserRepeatBetRsp(msg) 
	local data=LuaProtoBufManager.Decode("Lhd_Msg.UserBetChipRsp",msg)
	if data.result == 0 then
		BaseFctManager.GetInstance().FunctionBtnView:DisabledBtnContinuedBet(false)
		GameManager.GetInstance():ShowUITips("续押成功",3)
		local isMe = false
		if data.aryPlayerChipInfo and #data.aryPlayerChipInfo >= 1 then
			local beginPos = BaseFctManager.GetInstance():GetOtherPlayerBetInitPosition()
			for i =1,#data.aryPlayerChipInfo do
				local tempPlayerIns = self:GetPlayerBySeatId(data.aryPlayerChipInfo[i].usChairId)
				local shenSuanZiPlayerIns = self:IsShenSuanZiPlayer(data.aryPlayerChipInfo[i].usChairId)
				if tempPlayerIns then
					if shenSuanZiPlayerIns then
						--shenSuanZiPlayerIns:PlayXingxingEffect(data.aryPlayerChipInfo[i].areaIndex)
						if data.aryPlayerChipInfo[i].usChairId == self.gameData.PlayerChairId then
							isMe = true
							beginPos = self:GetMySelfPlayer():GetBetInitPosition()
						else
							isMe = false
							beginPos = shenSuanZiPlayerIns:GetBetInitPosition()
						end
					else
						if data.aryPlayerChipInfo[i].usChairId == self.gameData.PlayerChairId then
							isMe = true
							beginPos = self:GetMySelfPlayer():GetBetInitPosition()
						else
							isMe = false
							beginPos = tempPlayerIns:GetBetInitPosition()
						end
					end
				end
			
				local tmpAreaIndex = math.random(1,GameData.AreaType.AREA_Tiger)
				local tempChipIndex = math.random(1,#self.gameData.GameChipMoneyList)
				BetChipManager.GetInstance():CrateBetChip(isMe,true,beginPos,tmpAreaIndex,tempChipIndex,data.aryPlayerChipInfo[i].addBetChipMoney,data.aryPlayerChipInfo[i].ownBetChipMoney,data.allBetChipMoney)
			end
			self:ChangePlayerMoneyValue(data.aryPlayerInfo)
		end
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_WRONG_CHIP") then
		GameManager.GetInstance():ShowUITips("错误的押注筹码！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_OVER_MAX_MONEY") then
		GameManager.GetInstance():ShowUITips("超过区域最大下注额！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_UNKNOWN") then
		GameManager.GetInstance():ShowUITips("未知错误！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_NO_DATA_CLEAR") then
		GameManager.GetInstance():ShowUITips("押注错误区域！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_NT_CANT_BET") then
		GameManager.GetInstance():ShowUITips("庄家不能下注！！！",3)
	elseif data.result == LuaProtoBufManager.Enum("Lhd_Msg.E_NoteErrorCode","NOTE_ERROR_REPEAT_BET_FAIL") then
		GameManager.GetInstance():ShowUITips("续压失败！！！",3)
	end
end


function PlayerManager:ReponseOtherUserBetChipMsg(msg)
	local data=LuaProtoBufManager.Decode("Lhd_Msg.UserBetChipRsp",msg)
	if data.result == 0 then
		if data.aryPlayerChipInfo and #data.aryPlayerChipInfo >= 1 then
			local beginPos = BaseFctManager.GetInstance():GetOtherPlayerBetInitPosition()
			for i =1,#data.aryPlayerChipInfo do
				local OneBet = false
				if data.aryPlayerChipInfo[i].usChairId ~= self.gameData.PlayerChairId then
					local tempPlayerIns = self:GetPlayerBySeatId(data.aryPlayerChipInfo[i].usChairId)
					local shenSuanZiPlayerIns = self:IsShenSuanZiPlayer(data.aryPlayerChipInfo[i].usChairId)
					local tmpAreaIndex = math.random(1,GameData.AreaType.AREA_Tiger)
					if tempPlayerIns then
						OneBet = true
						if shenSuanZiPlayerIns then
							shenSuanZiPlayerIns:PlayXingxingEffect(tmpAreaIndex)
							beginPos = shenSuanZiPlayerIns:GetBetInitPosition()
							shenSuanZiPlayerIns:PlayMoveAnimation()
						else
							beginPos = tempPlayerIns:GetBetInitPosition()
							tempPlayerIns:PlayMoveAnimation()
						end
					end
					BetChipManager.GetInstance():CrateBetChip(false,OneBet,beginPos,tmpAreaIndex,data.aryPlayerChipInfo[i].chipIndex,data.aryPlayerChipInfo[i].addBetChipMoney,data.aryPlayerChipInfo[i].ownBetChipMoney,data.allBetChipMoney)
				end
			end
			self:ChangePlayerMoneyValue(data.aryPlayerInfo)
		end
	end
end


function PlayerManager:ReponseOtherPlayerEnterRoomMsg(msg)
	local data=LuaProtoBufManager.Decode("Lhd_Msg.UserEnterDeskRsp",msg)
	if data.playerInfo then
		self:AddOtherPlayer(data.playerInfo)
	else
		Debug.LogError("其它玩家进入失败")
	end
end

function PlayerManager:ReponseOtherPlayerLeaveRoomMsg(msg)
	local data=LuaProtoBufManager.Decode("Lhd_Msg.UserLeaveDeskRsp",msg)
	self:LeaveOtherPlayer(data.chair_id)
end

function PlayerManager:__delete()
	self:RemoveEventListenner()
	self.playerVoList = {}
	self.PlayerInsList= {}
end