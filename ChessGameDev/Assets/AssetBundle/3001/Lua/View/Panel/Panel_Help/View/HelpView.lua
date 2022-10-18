HelpView=Class()

function HelpView:ctor(gameObj)
	self:Init(gameObj)
	
end

function HelpView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function HelpView:InitData()
	self.Button=GameManager.GetInstance().Button
end



function HelpView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function HelpView:FindView(tf)
	self.QuitBtn=tf:Find("Panel"):GetComponent(typeof(self.Button))
end



function HelpView:InitViewData()
	
end


function HelpView:AddEventListenner()
	self.QuitBtn.onClick:AddListener(function () self:OnclickCloseHelp() end)
	
end


function HelpView:OnclickCloseHelp()
	AudioManager.GetInstance():PlayNormalAudio(16)
	HelpManager.GetInstance():IsShowHelpPanel(false)
end




