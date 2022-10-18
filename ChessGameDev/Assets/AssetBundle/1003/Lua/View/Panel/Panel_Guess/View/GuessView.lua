GuessView=Class()

function GuessView:ctor(gameObj)
	self:Init(gameObj)

end

function GuessView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function GuessView:InitData()
	self.Animation=GameManager.GetInstance().Animation
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.SaiZiList={}
	self.SaiZiPPrefixName="Point_"
	self.SaiZiAtlasName="SHZSpriteAtlas"
	self.BetList={}
end



function GuessView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function GuessView:FindView(tf)
	self:FindBookmakerBetView(tf)
	self:FindSaiZiView(tf)
	self:FindOtherView(tf)
end



function GuessView:InitViewData()
	self:IsShowBetPanel(false)
	self:IsShowSaiZiPanel(false)
	self:IsShowBetGoldTips(false)
	self:IsShowWinScoreTips(false)
end

function GuessView:ResetView()
	self:IsShowSaiZiPanel(false)
	self:IsShowWinScoreTips(false)
	self:IsShowBetGoldTips(false)
end



function GuessView:FindBookmakerBetView(tf)
	self.BetPanel=tf:Find("BetPanel/BtnGroup").gameObject
	self.MaxBet=tf:Find("BetPanel/BtnGroup/Big"):GetComponent(typeof(self.Button))
	table.insert(self.BetList,self.MaxBet)
	self.MidBet=tf:Find("BetPanel/BtnGroup/Mid"):GetComponent(typeof(self.Button))
	table.insert(self.BetList,self.MidBet)
	self.SmallBet=tf:Find("BetPanel/BtnGroup/Small"):GetComponent(typeof(self.Button))
	table.insert(self.BetList,self.SmallBet)
	self.BetGoldTips=tf:Find("BetPanel/BetGold").gameObject
end


function GuessView:FindSaiZiView(tf)
	self.SaiZiPanel=tf:Find("SaiZi").gameObject
	local SaiZi=tf:Find("SaiZi/Wai/Image1"):GetComponent(typeof(self.Image))
	table.insert(self.SaiZiList,SaiZi)
	SaiZi=tf:Find("SaiZi/Wai/Image2"):GetComponent(typeof(self.Image))
	table.insert(self.SaiZiList,SaiZi)
	SaiZi=tf:Find("SaiZi/Nei/Image1"):GetComponent(typeof(self.Image))
	table.insert(self.SaiZiList,SaiZi)
	SaiZi=tf:Find("SaiZi/Nei/Image2"):GetComponent(typeof(self.Image))
	table.insert(self.SaiZiList,SaiZi)
	
end


function GuessView:FindOtherView(tf)
	self.QuitGuessBtn=tf:Find("BetPanel/Quit"):GetComponent(typeof(self.Button))
	self.WinScoreText=tf:Find("BetPanel/WinSocre"):GetComponent(typeof(self.Text))
	self.WinTips=tf:Find("Tips/WinTips").gameObject
	self.WinTipsText=tf:Find("Tips/WinTips/Text"):GetComponent(typeof(self.Text))
	self.LoseTips=tf:Find("Tips/LoseTips").gameObject
	self.LoseTipsText=tf:Find("Tips/LoseTips/Text"):GetComponent(typeof(self.Text))
end




function GuessView:AddEventListenner()
	self.MaxBet.onClick:AddListener(function () self:OnclickMaxBetBtn() end)
	self.MidBet.onClick:AddListener(function () self:OnclickMidBetBtn() end)
	self.SmallBet.onClick:AddListener(function () self:OnclickSmallBetBtn() end)
	self.QuitGuessBtn.onClick:AddListener(function () self:OnclickCollectScoreBtn() end)
end


function GuessView:OnclickMaxBetBtn()
	AudioManager.GetInstance():PlayNormalAudio(16)
	self:SetBetGoldParent(self.MaxBet.gameObject)
	self:IsShowBetGoldTips(true)
	GuessManager.GetInstance():RequestBetGuess(1)
end

function GuessView:OnclickMidBetBtn()
	AudioManager.GetInstance():PlayNormalAudio(16)
	self:SetBetGoldParent(self.MidBet.gameObject)
	self:IsShowBetGoldTips(true)
	GuessManager.GetInstance():RequestBetGuess(2)
	
end

function GuessView:OnclickSmallBetBtn()
	AudioManager.GetInstance():PlayNormalAudio(16)
	self:SetBetGoldParent(self.SmallBet.gameObject)
	self:IsShowBetGoldTips(true)
	GuessManager.GetInstance():RequestBetGuess(3)
end


function GuessView:OnclickCollectScoreBtn()
	AudioManager.GetInstance():PlayNormalAudio(16)
	GuessManager.GetInstance():RequestCollectPoints()
	
end


function GuessView:IsEnableButton(button,isEnable)
	button.interactable=isEnable
end


function GuessView:IsEnableAllBetButton(isEnable)
	for i=1,#self.BetList do
		self:IsEnableButton(self.BetList[i],isEnable)
	end
end



function GuessView:IsShowBetPanel(isShow)
	CommonHelper.SetActive(self.BetPanel,isShow)
end


function GuessView:IsShowBetGoldTips(isShow)
	CommonHelper.SetActive(self.BetGoldTips,isShow)
end


function GuessView:IsShowSaiZiPanel(isShow)
	CommonHelper.SetActive(self.SaiZiPanel,isShow)
end


function GuessView:IsShowWinScoreTips(isShow)
	CommonHelper.SetActive(self.WinTips,isShow)
end

function GuessView:IsShowLoseScoreTips(isShow)
	CommonHelper.SetActive(self.LoseTips,isShow)
end


function GuessView:SetWinScoreTips(socre)
	self.WinTipsText.text="+"..CommonHelper.FormatBaseProportionalScore(socre)
end

function GuessView:SetLoseScoreTips(socre)
	self.LoseTipsText.text="-"..CommonHelper.FormatBaseProportionalScore(socre)
end


function GuessView:SetBetGoldParent(parent)
	self.BetGoldTips.transform.localPosition=parent.transform.localPosition
end


function GuessView:SetSaiZiValue(value1,value2)
	local tempList={value1,value2,value1,value2}
	local imageName=""
	for i=1,#self.SaiZiList do
		if i<3 then
			imageName=self.SaiZiPPrefixName..tempList[i]
		else
			imageName=self.SaiZiPPrefixName..tempList[i].."_1"
		end
		self.SaiZiList[i].sprite=GameManager.GetInstance().gameData.AllAtlasList[self.SaiZiAtlasName]:GetSprite(imageName)
	end
end


function GuessView:SetWinScore(score)
	self.WinScoreText.text=CommonHelper.FormatBaseProportionalScore(score)
end