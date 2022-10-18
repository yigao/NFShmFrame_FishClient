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
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
end

function HelpView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function HelpView:FindView(tf)
	self:FindHelpBaseView(tf)
end

function HelpView:FindHelpBaseView(tf)
	self.CloseBtn = tf:Find("bg"):GetComponent(typeof(self.Button))
end

function HelpView:InitViewData()

end

function HelpView:AddEventListenner()
	self.CloseBtn.onClick:AddListener(function () self:OnclickClose() end)
end

function HelpView:OnclickClose()
	HelpManager.GetInstance():IsShowHelpPanel(false)
end
