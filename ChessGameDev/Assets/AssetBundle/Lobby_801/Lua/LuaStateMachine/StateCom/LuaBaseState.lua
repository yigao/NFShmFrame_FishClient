LuaBaseState = Class()

function LuaBaseState:ctor(stateType)
	self.stateType = stateType
	self.args = {}
end

function LuaBaseState : OnStateEnter(...)
	self.args = {...}
end

function LuaBaseState : OnStateLeave()

end

function LuaBaseState : OnStateReset(...)
	self.args = {...}
end