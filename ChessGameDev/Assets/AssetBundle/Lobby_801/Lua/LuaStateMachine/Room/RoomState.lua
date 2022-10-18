RoomState = Class(LuaBaseState)

function RoomState:ctor(stateType)
	
end

function RoomState:OnStateEnter(...)
	LuaBaseState.OnStateEnter(self,...)
	self:SwitchToRoom()
end

function RoomState:SwitchToRoom()
	if LuaStateControl.GetInstance():GetLastStateType() == LuaStateControl.StateType.Lobby then
		LobbyRoomSystem.GetInstance():LobbySwitchToRoom()
	elseif LuaStateControl.GetInstance():GetLastStateType() == LuaStateControl.StateType.Game then
		LobbyRoomSystem.GetInstance():GameSwitchToRoom()
	end	
end

function RoomState:OnStateLeave()

end

function RoomState:OnStateReset(...)
	LuaBaseState.OnStateEnter(self,...)
end