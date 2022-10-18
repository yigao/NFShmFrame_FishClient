LobbyChairVo = Class()

function LobbyChairVo:ctor()
    self.chairId = nil
    self.chairStatus = nil
end

function LobbyChairVo:SetChairData(data)
    self.chairId = data.chair_id
    self.chairStatus = data.chair_status
end

function LobbyChairVo:__delete()
	
end
