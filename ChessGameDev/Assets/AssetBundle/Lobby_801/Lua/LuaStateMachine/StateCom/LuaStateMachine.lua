LuaStateMachine = Class()

function LuaStateMachine:ctor()
    self.registerStateMap = {}
    self.curState = nil
    self.lastState = nil
end

function LuaStateMachine : RegisterState(stateType,baseState)
    if baseState == nil then
        return 
    end
    if self.registerStateMap[stateType] == nil then
        self.registerStateMap[stateType] = {}
    end
    self.registerStateMap[stateType] = baseState
end

function LuaStateMachine : UnregisterState(stateType)
    if stateType == nil then
        return false
    end

    if self.registerStateMap[stateType] == nil then
        return  false
    end
    self.registerStateMap[stateType] = nil
    return true
end

function LuaStateMachine : ChangeState(stateType,...)
    self.lastState = self.curState
    if self.curState ~= nil then
        if self.curState.stateType == stateType then
            self.curState:OnStateReset(...)
        else
            self.curState:OnStateLeave()
            self.curState =  self.registerStateMap[stateType]
            self.curState:OnStateEnter(...)
        end
    else
        self.curState = self.registerStateMap[stateType]
        self.curState:OnStateEnter(...)
    end
end

