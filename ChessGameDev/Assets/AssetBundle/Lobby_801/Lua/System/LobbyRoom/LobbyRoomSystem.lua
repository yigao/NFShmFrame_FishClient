LobbyRoomSystem=Class()

LobbyRoomSystem.StepStateType ={
	None = 1,
	Room = 2,
	Desk = 3,
}

local Instance=nil
function LobbyRoomSystem:ctor()
	Instance=self
	self:GetLuaScripts()
	self:RequireLuaScripts()
	self:Init()
	self:AddEventListenner()
end

function LobbyRoomSystem.GetInstance()
	if Instance==nil then
		Instance=LobbyRoomSystem.New()
	end
	return Instance
end

function LobbyRoomSystem:LoadPB(  )
	LuaProtoBufManager.LoadProtocFiles("H/Lua/System/LobbyRoom/Proto/proto_room")
end

function LobbyRoomSystem:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/System/LobbyRoom/LobbyFishRoomView",
		"H/Lua/System/LobbyRoom/LobbyArcadeRoomView",
		"H/Lua/System/LobbyRoom/LobbyChessRoomView",
		"H/Lua/System/LobbyRoom/LobbyDeskView",
		"H/Lua/System/LobbyRoom/LobbyRoomVo/LobbyDeskVo",
		"H/Lua/System/LobbyRoom/LobbyRoomVo/LobbyChairVo",
		"H/Lua/System/LobbyRoom/LobbyRoomItem/LobbyRoomItem",
		"H/Lua/System/LobbyRoom/LobbyRoomItem/LobbyDeskItem",
		"H/Lua/System/LobbyRoom/LobbyRoomItem/LobbyChairItem",
	}
end


function LobbyRoomSystem:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end

function LobbyRoomSystem:Init()
	self:LoadPB()
	self.gameItemVo = nil
	self.roomVoList = {}
	self.deskVoList = {}
	self.roomId = nil
	self.deskId = nil
	self.chairId = nil
	self.roomInfoCallBack = nil
	self.stepType = LobbyRoomSystem.StepStateType.None
	self.fishRoomView=LobbyFishRoomView.New()
	self.arcadeRoomView = LobbyArcadeRoomView.New()
	self.chessRoomView = LobbyChessRoomView.New()
	self.deskView=LobbyDeskView.New() 
end


function LobbyRoomSystem:LobbySwitchToRoom()
	if self:IsAutoAllotRoom() == true then --当房间列表为1个时，默认自动选择房间列表，不需要打开房间列表窗口
		self:SendDeskListReq(self.roomVoList[1].room_id)
		return 
	end
	self:OpenForm()
end

function LobbyRoomSystem:GameSwitchToRoom()
	LobbyPaoMaDengSystem.GetInstance():Open()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.PaoMaDengChangePosition_EventName,false,1)
	if self:IsAutoAllotRoom() == true then --当房间列表为1个时，退出游戏，立马回到大厅
		self:RoomSwitchToLobby()
		return
	end
	self.deskVoList = {}
	self.chairId = nil
	self.deskId = nil
	if self.stepType ==  LobbyRoomSystem.StepStateType.Desk then
		self:SendDeskListReq(self.roomId)
	else
		self:OpenRoomForm()
	end
end

function LobbyRoomSystem:OpenForm()
	if self.stepType == LobbyRoomSystem.StepStateType.None or self.stepType == LobbyRoomSystem.StepStateType.Room then
		self:OpenRoomForm()		
	elseif self.stepType == LobbyRoomSystem.StepStateType.Desk then
		self:OpenDeskForm()
	end
end

function LobbyRoomSystem:CloseForm()
	if self.fishRoomView ~= nil then
		self.fishRoomView:CloseForm()
	end

	if self.arcadeRoomView ~= nil then
		self.arcadeRoomView:CloseForm()
	end

	if self.chessRoomView ~= nil then
		self.chessRoomView:CloseForm()
	end

	if self.deskView ~= nil then
		self.deskView:CloseForm()
	end
end


function LobbyRoomSystem:OpenRoomForm()
	if self.gameItemVo.gameType == 1 then
		self.arcadeRoomView:OpenForm()
	elseif self.gameItemVo.gameType == 2 then
		self.fishRoomView:OpenForm()
	elseif self.gameItemVo.gameType == 3 or self.gameItemVo.gameType == 4 then
		self.chessRoomView:OpenForm()
	end
	self.stepType = LobbyRoomSystem.StepStateType.Room
end

function LobbyRoomSystem:OpenDeskForm()
	-- self.roomView:CloseForm()
	if self.gameItemVo.gameType == 1 then
		self.arcadeRoomView:OpenForm()
	elseif self.gameItemVo.gameType == 2 then
		self.fishRoomView:OpenForm()
	elseif self.gameItemVo.gameType == 3 or self.gameItemVo.gameType == 4 then
		self.chessRoomView:OpenForm()
	end
	self.deskView:OpenForm()
	self.stepType = LobbyRoomSystem.StepStateType.Desk
end

function LobbyRoomSystem:Close()
	self.gameItemVo = nil
	self.roomVoList = {}
	self.deskVoList = {}
	self.roomId = nil
	self.deskId = nil
	self.chairId = nil
	self.stepType = LobbyRoomSystem.StepStateType.None

	self:CloseForm()
end

function LobbyRoomSystem:IsAutoAllotRoom()
	if self.roomVoList ~= nil and #self.roomVoList == 1 then
		return true
	end
	return false
end


function LobbyRoomSystem:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_Msg_Get_Room_Info_Rsp"),self.ReceiveRoomListRsp,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_MSG_DeskListRsp"),self.ReceiveDeskListRsp,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_MSG_ChairCheckRsp"),self.ReceiveChairCheckRsp,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_MSG_ExitRoomRsp"),self.ReceiveExitRoomRsp,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.QuitGame_EventName,self.QuitGame,self)
	GlobalEventManager.GetInstance():AddLuaEvent(LuaEventParams.EnterGameFailure_EventName,self.RoomSwitchToLobby,self)
end


function LobbyRoomSystem:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_Msg_Get_Room_Info_Rsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_MSG_DeskListRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_MSG_ChairCheckRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_SC_MSG_ExitRoomRsp"))
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.QuitGame_EventName)
	GlobalEventManager.GetInstance():RemoveEvent(LuaEventParams.EnterGameFailure_EventName)
end

function LobbyRoomSystem:SendRoomListReq(gameItemVo,roomInfoCallBack)
	local sendMsg={}
	self.roomInfoCallBack = roomInfoCallBack
	self.gameItemVo = gameItemVo
	sendMsg.game_id = gameItemVo.id
	local bytes = LuaProtoBufManager.Encode("proto_room.GetRoomInfoReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_CS_Msg_Get_Room_Info_Req"),bytes)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end

function LobbyRoomSystem:ReceiveRoomListRsp(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	self.roomVoList = nil
	local data= LuaProtoBufManager.Decode("proto_room.GetRoomInfoRsp",msg)
	if data.result == 0 then
		self.roomVoList = data.rooms
		table.sort(self.roomVoList,function(a,b) return a.room_id<b.room_id end)
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
	if self.roomInfoCallBack then
		self.roomInfoCallBack(self.roomVoList)
	end
end


function LobbyRoomSystem:SendDeskListReq(roomId)
	local sendMsg={}
	self.roomId = roomId
	sendMsg.game_id=self.gameItemVo.id 
	sendMsg.room_id = roomId
	local bytes = LuaProtoBufManager.Encode("proto_room.DeskListReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_CS_MSG_DeskListReq"),bytes)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end

function LobbyRoomSystem:ReceiveDeskListRsp(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	self.deskVoList = {}
	local data= LuaProtoBufManager.Decode("proto_room.DeskListRsp",msg)
	if data.result == 0 then
		if data.desks==nil then  Debug.LogError("桌子为nil") return end
		
		if #data.desks >= 1 then
			for i=1,#data.desks do 
				local deskData = LobbyDeskVo.New()
				deskData:SetDeskData(data.desks[i])
				table.insert(self.deskVoList,deskData)
			end
			if #data.desks == 1 then
				self.deskId  = self.deskVoList[1].deskId
				self.chairId = self.deskVoList[1].chairVoList[1].chairId
				Debug.LogError("LuaEventParams.EnterGame_EventName:"..self.deskId.."  "..self.chairId)
				self:RoomSwitchToGame()
			else
				self:OpenDeskForm()
			end
		else

		end
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)
	end
end

function LobbyRoomSystem:SendChairCheckReq(deskId,chairId)
	local sendMsg={}
	self.deskId = deskId
	self.chairId = chairId
	sendMsg.game_id=self.gameItemVo.id
	sendMsg.room_id = self.roomId
	sendMsg.desk_id = deskId
	sendMsg.chairId = chairId
	pt(sendMsg)
	local bytes = LuaProtoBufManager.Encode("proto_room.ChairCheckReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_CS_MSG_ChairCheckReq"),bytes)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end

function LobbyRoomSystem:ReceiveChairCheckRsp(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data= LuaProtoBufManager.Decode("proto_room.ChairCheckRsp",msg)
	pt(data)
	if data.result == 0 then
		self:RoomSwitchToGame()
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)	
	end
end

function LobbyRoomSystem:SendExitRoomReq()
	local sendMsg={}
	sendMsg.roomId = self.roomId
	sendMsg.game_id=self.gameItemVo.id	
	pt(sendMsg)
	local bytes = LuaProtoBufManager.Encode("proto_room.ExitRoomReq", sendMsg)
	LuaNetwork.SendNetworkMsgLua(0,LuaProtoBufManager.Enum("proto_room.Proto_Room_CMD","NF_CS_MSG_ExitRoomReq"),bytes)
	XLuaUIManager.GetInstance():OpenNetWaitForm(3,0.5,nil)
end

function LobbyRoomSystem:ReceiveExitRoomRsp(msg)
	XLuaUIManager.GetInstance():CloseNetWaitForm()
	local data= LuaProtoBufManager.Decode("proto_room.ExitRoomRsp",msg)
	pt(data)
	if data.result == 0 then
		self.deskView:CloseForm()
		self:OpenRoomForm()
	else
		XLuaUIManager.GetInstance():OpenTipsForm(data.result)	
	end
end

function LobbyRoomSystem:QuitGame(  )
	LuaStateControl.GetInstance():GotoState(LuaStateControl.StateType.Room)
end

function LobbyRoomSystem:RoomSwitchToGame()
	local enterGameCallBack = function ()
		LuaStateControl.GetInstance():GotoState(LuaStateControl.StateType.Game)
		self:CloseForm()
	end
	local isAuto = self:IsAutoAllotRoom()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.PaoMaDengChangePosition_EventName,false,3)

	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.EnterGame_EventName,false,self.roomId,self.deskId,self.chairId,isAuto,enterGameCallBack)
end

function LobbyRoomSystem:RoomSwitchToLobby()
	self:Close()
	GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.UnloadGameAssets_EventName)
	LuaStateControl.GetInstance():GotoState(LuaStateControl.StateType.Lobby)
end

function LobbyRoomSystem:__delete()
	self:Close()
	self:RemoveEventListenner()
	self.fishRoomView:Destroy()
	self.arcadeRoomView:Destroy()
	self.chessRoomView:Destroy()
	self.deskView:Destroy() 
end