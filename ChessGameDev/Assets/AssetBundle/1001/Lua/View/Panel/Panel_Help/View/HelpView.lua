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
	self.ContentList={}
	self.TipsList={}
	self.ContentCount=3
	self.currentContentIndex=1
end



function HelpView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function HelpView:FindView(tf)
	self:FindHelpBaseView(tf)
	self:FindHelpContentView(tf)
	self:FindHelpTipsView(tf)
end

function HelpView:FindHelpBaseView(tf)
	self.LeftBtn=tf:Find("Btn/LeftBtn"):GetComponent(typeof(self.Button))
	self.RightBtn=tf:Find("Btn/RightBtn"):GetComponent(typeof(self.Button))
	self.CloseBtn=tf:Find("Btn/CloseBtn"):GetComponent(typeof(self.Button))
end


function HelpView:FindHelpContentView(tf)
	for i=1,self.ContentCount do
		local content=tf:Find("Content/CT"..i).gameObject
		table.insert(self.ContentList,content)
	end
end

function HelpView:FindHelpTipsView(tf)
	for i=1,self.ContentCount do
		local tips=tf:Find("Tips/Tips"..i.."/SelectImage").gameObject
		table.insert(self.TipsList,tips)
	end
end


function HelpView:InitViewData()
	self:ShowHelpContent(1)
	self:ShowHelpTips(1)
end


function HelpView:AddEventListenner()
	self.LeftBtn.onClick:AddListener(function () self:OnclickLeft() end)
	self.RightBtn.onClick:AddListener(function () self:OnclickRight() end)
	self.CloseBtn.onClick:AddListener(function () self:OnclickClose() end)
end


function HelpView:OnclickLeft()
	AudioManager.GetInstance():PlayNormalAudio(7)
	self:SetIndex(false)
	self:ShowHelpContent(self.currentContentIndex)
	self:ShowHelpTips(self.currentContentIndex)
end


function HelpView:OnclickRight()
	AudioManager.GetInstance():PlayNormalAudio(7)
	self:SetIndex(true)
	self:ShowHelpContent(self.currentContentIndex)
	self:ShowHelpTips(self.currentContentIndex)
end

function HelpView:OnclickClose()
	AudioManager.GetInstance():PlayNormalAudio(7)
	HelpManager.GetInstance():IsShowHelpPanel(false)
end


function HelpView:SetIndex(IsAdd)
	if IsAdd then
		self.currentContentIndex=self.currentContentIndex+1
	else
		self.currentContentIndex=self.currentContentIndex-1
	end

	if self.currentContentIndex>self.ContentCount then
		self.currentContentIndex=1
	elseif self.currentContentIndex<1 then
		self.currentContentIndex=self.ContentCount
	end
end



function HelpView:ShowContent(index,contentList)
	CommonHelper.IsShowPanel(index,contentList,true,true,false)
end


function HelpView:ShowHelpContent(index)
	self:ShowContent(index,self.ContentList)
end

function HelpView:ShowHelpTips(index)
	self:ShowContent(index,self.TipsList)
end


