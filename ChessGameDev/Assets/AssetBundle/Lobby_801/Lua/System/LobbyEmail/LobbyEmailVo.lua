LobbyEmailVo = Class()

function LobbyEmailVo:ctor(emailData)
	if emailData ~= nil then
		self.id = emailData.id
		self.sendName = emailData.send_name
		self.title = emailData.title
		self.content = emailData.content
		self.sendTime = os.date("%Y-%m-%d %H:%M:%S",emailData.send_time) --CS.System.DateTime(1970,1,1):AddSeconds(emailData.send_time):ToString()
		self.emailStatus = emailData.status
		self.usAreaId = emailData.usAreaId
	end
	self.isGouXuan=false
end

function LobbyEmailVo:UpdateEmailStatus(status)
	self.emailStatus = status	
end

function LobbyEmailVo:UpdateEmailGouXuan(isGouXuan)
	if self.emailStatus == 0 then return end
	self.isGouXuan = isGouXuan	
end

function LobbyEmailVo:__delete( )
   
end


