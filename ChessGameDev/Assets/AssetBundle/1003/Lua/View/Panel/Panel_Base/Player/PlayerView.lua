PlayerView=Class()

function PlayerView:ctor(gameObj)
	self:Init(gameObj)

end

function PlayerView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function PlayerView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Image=GameManager.GetInstance().Image
end



function PlayerView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function PlayerView:FindView(tf)
	self:FindPlayerView(tf)
end


function PlayerView:FindPlayerView(tf)
	self.playerName=tf:Find("Down/Player/PlayerName/Name"):GetComponent(typeof(self.Text))
	self.playerMoney=tf:Find("Down/Player/PlayerMoney/Money"):GetComponent(typeof(self.Text))
	self.PlayerHeadImage=tf:Find("Down/Player/PlayerBG/ImageTX"):GetComponent(typeof(self.Image))
	self:SetPlayerHead()
end


function PlayerView:SetPlayerName(name)
	self.playerName.text=name
end


function PlayerView:SetPlayerMoney(name)
	self.playerMoney.text=name
end

function PlayerView:SetPlayerHead()
	self.PlayerHeadImage.sprite=LobbyHallCoreSystem.GetInstance():GetCurrentUserHeadImage()
end