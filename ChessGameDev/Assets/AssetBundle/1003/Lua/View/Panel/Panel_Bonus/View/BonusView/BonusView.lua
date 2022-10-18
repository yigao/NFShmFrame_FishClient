BonusView=Class()

function BonusView:ctor(gameObj)
	self:Init(gameObj)

end

function BonusView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function BonusView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Animation=GameManager.GetInstance().Animation
	self.EnterBonusAnimNameList={"EnterBonus1","EnterBonus2"}
end



function BonusView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BonusView:FindView(tf)
	self:FindBonusPanelView(tf)
	self:FindBonusSetPanelView(tf)
	
end


function BonusView:FindBonusPanelView(tf)
	self.EnterBonusPanel=tf:Find("EnterBonus").gameObject
	self.MainBounsPanel=tf:Find("BasePanel").gameObject
	self.StartBonusPanel=tf:Find("StartBonus").gameObject
	self.EndBonusPanel=tf:Find("EndBonus").gameObject
end


function BonusView:FindBonusSetPanelView(tf)
	--self.EnterBonusAnim=tf:Find("EnterBonus/RawImage"):GetComponent(typeof(self.Animation))
	self.StartBonusBtn=tf:Find("StartBonus/Set/StartButton"):GetComponent(typeof(self.Button))
	--self.GameMainWinScore=tf:Find("EndBonus/Set/Context/Text2"):GetComponent(typeof(self.Text))
	self.BonusTotalWinScore=tf:Find("EndBonus/Set/Context/Text4"):GetComponent(typeof(self.Text))
	self.ColseBonusBtn=tf:Find("EndBonus/Set/CloseButton"):GetComponent(typeof(self.Button))
end


function BonusView:InitViewData()
	self:HideAllBonusPanel()
	self:SetGameMainWinScore(0)
	self:SetBonusTotalWinScore(0)
end



function BonusView:AddEventListenner()
	self.StartBonusBtn.onClick:AddListener(function () self:OnclickStartBonus() end)
	self.ColseBonusBtn.onClick:AddListener(function () self:OnclickCloseBonus() end)
end


function BonusView:OnclickStartBonus()
	AudioManager.GetInstance():PlayNormalAudio(16)
	self:IsShowStartBonusPanel(false)
	GameUIManager.GetInstance():RequesBonusResultMsg(2)
end


function BonusView:OnclickCloseBonus()
	AudioManager.GetInstance():PlayNormalAudio(16)
	self:IsShowEndBonusPanel(false)
	BonusManager.GetInstance():QuitBonus()
end


function BonusView:IsShowEnterBonusPanel(isShow)
	CommonHelper.SetActive(self.EnterBonusPanel,isShow)
end

function BonusView:IsShowStartBonusPanel(isShow)
	CommonHelper.SetActive(self.StartBonusPanel,isShow)
end

function BonusView:IsShowMainBonusPanel(isShow)
	CommonHelper.SetActive(self.MainBounsPanel,isShow)
end

function BonusView:IsShowEndBonusPanel(isShow)
	CommonHelper.SetActive(self.EndBonusPanel,isShow)
end


function BonusView:HideAllBonusPanel()
	self:IsShowEnterBonusPanel(false)
	self:IsShowStartBonusPanel(false)
	self:IsShowMainBonusPanel(false)
	self:IsShowEndBonusPanel(false)
end


function BonusView:PlayEnterBonusAnim(index)
	self.EnterBonusAnim:Play(self.EnterBonusAnimNameList[index])
end


function BonusView:SetGameMainWinScore(score)
	--self.GameMainWinScore.text=score
end


function BonusView:SetBonusTotalWinScore(score)
	self.BonusTotalWinScore.text=score
end





function BonusView:__delete()

end