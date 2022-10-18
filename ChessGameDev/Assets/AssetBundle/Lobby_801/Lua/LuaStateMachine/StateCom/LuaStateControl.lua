LuaStateControl = Class()

local Instance=nil
function LuaStateControl:ctor()
	Instance=self
	self:Init()
end

LuaStateControl.StateType = {
	Login = 1,
	Lobby = 2,
	Room  = 3,
	Game  = 4,
}

function LuaStateControl.GetInstance()
	if Instance==nil then
		Instance=LuaStateControl.New()
	end
	return Instance
end

function LuaStateControl:GetLuaScripts()
	self.ScriptsList={
		"H/Lua/LuaStateMachine/StateCom/LuaBaseState",
		"H/Lua/LuaStateMachine/StateCom/LuaStateMachine",
		"H/Lua/LuaStateMachine/Login/LoginState",
		"H/Lua/LuaStateMachine/Lobby/LobbyState",
		"H/Lua/LuaStateMachine/Room/RoomState",
		"H/Lua/LuaStateMachine/Game/GameState",
	}
end


function LuaStateControl:RequireLuaScripts()
	CommonHelper.LoaderLuaScripts(self.ScriptsList)
end


function LuaStateControl:Init()
	self:GetLuaScripts()
	self:RequireLuaScripts()

	self.stateMachine = LuaStateMachine.New()

	self.stateMachine:RegisterState(LuaStateControl.StateType.Login,LoginState.New(LuaStateControl.StateType.Login))
	self.stateMachine:RegisterState(LuaStateControl.StateType.Lobby,LobbyState.New(LuaStateControl.StateType.Lobby))
	self.stateMachine:RegisterState(LuaStateControl.StateType.Room, RoomState.New(LuaStateControl.StateType.Room))
	self.stateMachine:RegisterState(LuaStateControl.StateType.Game, GameState.New(LuaStateControl.StateType.Game))
	
end

function LuaStateControl:GotoState(stateType,...)
	if self.stateMachine ~= nil then
		self.stateMachine:ChangeState(stateType,...)
	end
end

function LuaStateControl:GetCurrentStateType()
	if  self.stateMachine ~= nil then
		return self.stateMachine.curState.stateType
	end
	return nil
end

function LuaStateControl:GetLastStateType()
	if self.stateMachine ~= nil then
		return self.stateMachine.lastState.stateType
	end
	return nil
end