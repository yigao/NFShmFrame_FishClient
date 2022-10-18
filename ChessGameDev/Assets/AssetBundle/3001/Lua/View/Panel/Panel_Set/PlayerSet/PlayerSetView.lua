PlayerSetView=Class()


function PlayerSetView:ctor(obj)
	self:Init(obj)

end

function PlayerSetView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function PlayerSetView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Text=GameManager.GetInstance().Text
	
	self.QZValueTextList={}
	self.BetValueTextList={}
	
end



function PlayerSetView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function PlayerSetView:FindView(tf)
	self:FindQZView(tf)
	self:FindBetView(tf)
end


function PlayerSetView:InitViewData()
	self:IsShowQiangZhunagBtnPanel(false)
	self:IsShowTanPaiBtnPanel(false)
	self:IsShowBetBtnPanel(false)
end


function PlayerSetView:FindQZView(tf)
	self.QZPanel=tf:Find("Panel/PlayerPanel/QZPanel").gameObject
	self.NoQZBtn=tf:Find("Panel/PlayerPanel/QZPanel/CanselButton"):GetComponent(typeof(self.Button))
	self.QZBtn1=tf:Find("Panel/PlayerPanel/QZPanel/OButton"):GetComponent(typeof(self.Button))
	local tempQZT=tf:Find("Panel/PlayerPanel/QZPanel/OButton/Text"):GetComponent(typeof(self.Text))
	table.insert(self.QZValueTextList,tempQZT)
	self.QZBtn2=tf:Find("Panel/PlayerPanel/QZPanel/SButton"):GetComponent(typeof(self.Button))
	tempQZT=tf:Find("Panel/PlayerPanel/QZPanel/SButton/Text"):GetComponent(typeof(self.Text))
	table.insert(self.QZValueTextList,tempQZT)
	self.QZBtn3=tf:Find("Panel/PlayerPanel/QZPanel/TButton"):GetComponent(typeof(self.Button))
	tempQZT=tf:Find("Panel/PlayerPanel/QZPanel/TButton/Text"):GetComponent(typeof(self.Text))
	table.insert(self.QZValueTextList,tempQZT)
	self.QZBtn4=tf:Find("Panel/PlayerPanel/QZPanel/FButton"):GetComponent(typeof(self.Button))
	tempQZT=tf:Find("Panel/PlayerPanel/QZPanel/FButton/Text"):GetComponent(typeof(self.Text))
	table.insert(self.QZValueTextList,tempQZT)
end


function PlayerSetView:FindBetView(tf)
	self.BetPanel=tf:Find("Panel/PlayerPanel/BetPanel").gameObject
	
	self.BetBtn1=tf:Find("Panel/PlayerPanel/BetPanel/1Button"):GetComponent(typeof(self.Button))
	local tempQZT=tf:Find("Panel/PlayerPanel/BetPanel/1Button/Text"):GetComponent(typeof(self.Text))
	table.insert(self.BetValueTextList,tempQZT)
	self.BetBtn2=tf:Find("Panel/PlayerPanel/BetPanel/2Button"):GetComponent(typeof(self.Button))
	tempQZT=tf:Find("Panel/PlayerPanel/BetPanel/2Button/Text"):GetComponent(typeof(self.Text))
	table.insert(self.BetValueTextList,tempQZT)
	self.BetBtn3=tf:Find("Panel/PlayerPanel/BetPanel/3Button"):GetComponent(typeof(self.Button))
	tempQZT=tf:Find("Panel/PlayerPanel/BetPanel/3Button/Text"):GetComponent(typeof(self.Text))
	table.insert(self.BetValueTextList,tempQZT)
	self.BetBtn4=tf:Find("Panel/PlayerPanel/BetPanel/4Button"):GetComponent(typeof(self.Button))
	tempQZT=tf:Find("Panel/PlayerPanel/BetPanel/4Button/Text"):GetComponent(typeof(self.Text))
	table.insert(self.BetValueTextList,tempQZT)
	
	self.TanPaiBtn=tf:Find("Panel/PlayerPanel/TPButton"):GetComponent(typeof(self.Button))
end



function PlayerSetView:AddEventListenner()
	self.NoQZBtn.onClick:AddListener(function () self:OnclickNoQZBtn() end)
	self.QZBtn1.onClick:AddListener(function () self:OnclickQZBtn1() end)
	self.QZBtn2.onClick:AddListener(function () self:OnclickQZBtn2() end)
	self.QZBtn3.onClick:AddListener(function () self:OnclickQZBtn3() end)
	self.QZBtn4.onClick:AddListener(function () self:OnclickQZBtn4() end)
	
	self.BetBtn1.onClick:AddListener(function () self:OnclickBetBtn1() end)
	self.BetBtn2.onClick:AddListener(function () self:OnclickBetBtn2() end)
	self.BetBtn3.onClick:AddListener(function () self:OnclickBetBtn3() end)
	self.BetBtn4.onClick:AddListener(function () self:OnclickBetBtn4() end)
	
	self.TanPaiBtn.onClick:AddListener(function () self:OnclickTanPaiBtn() end)
end


function PlayerSetView:OnclickNoQZBtn()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestQiangZhuangMsg(0)
end

function PlayerSetView:OnclickQZBtn1()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestQiangZhuangMsg(1)
end

function PlayerSetView:OnclickQZBtn2()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestQiangZhuangMsg(2)
end

function PlayerSetView:OnclickQZBtn3()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestQiangZhuangMsg(3)
end

function PlayerSetView:OnclickQZBtn4()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestQiangZhuangMsg(4)
end


function PlayerSetView:OnclickBetBtn1()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestPlayerBetMsg(1)
end

function PlayerSetView:OnclickBetBtn2()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestPlayerBetMsg(2)
end

function PlayerSetView:OnclickBetBtn3()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestPlayerBetMsg(3)
end

function PlayerSetView:OnclickBetBtn4()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestPlayerBetMsg(4)
end

function PlayerSetView:OnclickTanPaiBtn()
	AudioManager.GetInstance():PlayNormalAudio(15)
	GameUIManager.GetInstance():RequestOpenCardMsg()
end


function PlayerSetView:IsShowQiangZhunagBtnPanel(isShow)
	CommonHelper.SetActive(self.QZPanel,isShow)
end

function PlayerSetView:IsShowBetBtnPanel(isShow)
	CommonHelper.SetActive(self.BetPanel,isShow)
end

function PlayerSetView:IsShowTanPaiBtnPanel(isShow)
	CommonHelper.SetActive(self.TanPaiBtn.gameObject,isShow)
end


function PlayerSetView:InitQZAndBetValue(qzV,betV)
	self:SetQZVlaue(qzV)
	self:SetBetVlaue(betV)
end


function PlayerSetView:SetQZVlaue(tempValue)
	for i=1,#self.QZValueTextList do
		self.QZValueTextList[i].text=tempValue[i]
	end
end


function PlayerSetView:SetBetVlaue(tempValue)
	for i=1,#self.BetValueTextList do
		self.BetValueTextList[i].text=tempValue[i]
	end
end



