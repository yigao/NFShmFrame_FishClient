LoginState = Class(LuaBaseState)

function LoginState:ctor(stateType)
	
end

function LoginState : OnStateEnter(...)
	LuaBaseState.OnStateEnter(self,...)
	LobbyLoginSystem.GetInstance():Open()
end

function LoginState : OnStateLeave()

end

function LoginState : OnStateReset(...)
	LuaBaseState.OnStateReset(self,...)
end