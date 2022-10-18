LobbyDeskVo = Class()

function LobbyDeskVo:ctor()
    self.deskId = nil
    self.deskName = nil
    self.deskStatus = nil
    self.chairCount = nil
    self.chairVoList = {}
end

function LobbyDeskVo : SetDeskData(data)
    self.deskId = data.desk_id
    self.deskName = data.desk_name
    self.deskStatus = data.desk_status
    self.chairCount = data.chair_count
    for i = 1,#data.chairs do
        local chairVo = LobbyChairVo.New()
        chairVo:SetChairData(data.chairs[i])
        table.insert(self.chairVoList,chairVo)
    end
end


function LobbyDeskVo:__delete()
	
end