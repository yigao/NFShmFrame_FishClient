GameState = Class(LuaBaseState)

function GameState:ctor(stateType)
	
end

function GameState : OnStateEnter(...)
	LuaBaseState.OnStateEnter(self,...)
end

function GameState : OnStateLeave()

end

function GameState : OnStateReset(...)
	
end