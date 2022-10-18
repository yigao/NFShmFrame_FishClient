LobbyState = Class(LuaBaseState)

function LobbyState:ctor(stateType)
	
end

function LobbyState:OnStateEnter(...)
	LuaBaseState.OnStateEnter(self,...)
	self:SwitchToLobby()
end

function LobbyState : SwitchToLobby()
	if LuaStateControl.GetInstance():GetLastStateType() == LuaStateControl.StateType.Login then
		LobbyHallCoreSystem.GetInstance():LoginSwitchToLobby(self.args)
	elseif LuaStateControl.GetInstance():GetLastStateType() == LuaStateControl.StateType.Room then
		LobbyHallCoreSystem.GetInstance():RoomSwitchToLobby()
	end	
end

function LobbyState : OnStateLeave()

end

function LobbyState : OnStateReset(...)
	LuaBaseState.OnStateReset(self,...)
end