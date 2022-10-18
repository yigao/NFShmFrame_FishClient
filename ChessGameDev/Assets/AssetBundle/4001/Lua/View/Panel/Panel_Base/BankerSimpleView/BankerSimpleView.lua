BankerSimpleView=Class()

function BankerSimpleView:ctor(gameObj)
	self:Init(gameObj)
end

function BankerSimpleView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function BankerSimpleView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.Text = GameManager.GetInstance().Text
	self.ScoreResultObjList={}
	self.ScoreResultTextList = {}
end


function BankerSimpleView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BankerSimpleView:FindView(tf)
	self.BeBankerBtn_GoObj = tf:Find("Banker/bebanker_Btn").gameObject
	self.BebankerBtn=tf:Find("Banker/bebanker_Btn"):GetComponent(typeof(self.Button))
	self.DropbankerBtn_GoObj = tf:Find("Banker/dropbanker_Btn").gameObject
	self.DropbankerBtn=tf:Find("Banker/dropbanker_Btn"):GetComponent(typeof(self.Button))
	self.head_icon_image = tf:Find("Banker/head/head_Icon"):GetComponent(typeof(self.Image))
	self.banker_name_text = tf:Find("Banker/head/name_text"):GetComponent(typeof(self.Text))
	self.queue_text = tf:Find("Banker/queue_text"):GetComponent(typeof(self.Text))
	self.continuebanker_text = tf:Find("Banker/continuebanker_text"):GetComponent(typeof(self.Text))
	self.banker_money_text = tf:Find("Banker/money_text"):GetComponent(typeof(self.Text))
	
	self.bankerBetTrans = tf:Find("Banker/bankerBetPos")

	local tempObj=tf:Find("Banker/WinTips/Win").gameObject
	table.insert(self.ScoreResultObjList,tempObj)
	tempObj=tf:Find("Banker/WinTips/Win/Text"):GetComponent(typeof(self.Text))
	table.insert(self.ScoreResultTextList,tempObj)
	tempObj=tf:Find("Banker/WinTips/Lose").gameObject
	table.insert(self.ScoreResultObjList,tempObj)
	tempObj=tf:Find("Banker/WinTips/Lose/Text"):GetComponent(typeof(self.Text))
	table.insert(self.ScoreResultTextList,tempObj)
end

function BankerSimpleView:InitViewData()

end

function BankerSimpleView:AddEventListenner()
	self.BebankerBtn.onClick:AddListener(function () self:OnClickBebanker() end)
	self.DropbankerBtn.onClick:AddListener(function () self:OnClicDropbanker() end)
end

function BankerSimpleView:UpdateBankerScoreValue()
	self:SetResultScoreValue(self.gameData.CurBankerVo.user_curWinMoney)
	self:SetCurBankerValue()

end

function BankerSimpleView:SetResultScoreValue(value)
	self:HideAllScoreResultPanel(false)
	local tempV=CommonHelper.FormatBaseProportionalScore(math.abs(value))
	for i=1,#self.ScoreResultTextList do
		if tonumber(value)>0 then 
			value="+"..tempV 
			self.ScoreResultTextList[1].text = value
			self:IsShowScoreResultPanel(1,true)
		elseif tonumber(value)<0 then 
			value="-"..tempV 
			self.ScoreResultTextList[2].text = value
			self:IsShowScoreResultPanel(2,true)
		end
	end
end

function BankerSimpleView:HideAllScoreResultPanel(isDisplay)
	self:IsShowScoreResultPanel(1,isDisplay)
	self:IsShowScoreResultPanel(2,isDisplay)
end

function BankerSimpleView:IsShowScoreResultPanel(index,isShow)
	CommonHelper.SetActive(self.ScoreResultObjList[index],isShow)
end


function BankerSimpleView:SetCurBankerValue()
	if self.gameData.CurBankerVo then
		local playerVo = PlayerManager.GetInstance():GetPlayerVoByChairdId(self.gameData.CurBankerVo.usNtChairId)
		self.banker_name_text.text = playerVo.user_name
		if self.gameData.WaitBankerVoList then
			self.queue_text.text =string.format("%d人在排队",#self.gameData.WaitBankerVoList)
		end  
		self.continuebanker_text.text =string.format("连庄：%d/%d",self.gameData.CurBankerVo.NtPlayingCount,self.gameData.BankMaxNtCount)
		self.banker_money_text.text =  CommonHelper.FormatBaseProportionalScore(self.gameData.CurBankerVo.ntMoney) 
		self.head_icon_image.sprite = LobbyHallCoreSystem.GetInstance():GetAllocateHeadImage(playerVo.usFaceId)
		if self.gameData.CurBankerVo.usNtChairId == self.gameData.PlayerChairId then
			CommonHelper.SetActive(self.BeBankerBtn_GoObj,false)
			CommonHelper.SetActive(self.DropbankerBtn_GoObj,true)
		else
			CommonHelper.SetActive(self.BeBankerBtn_GoObj,true)
			CommonHelper.SetActive(self.DropbankerBtn_GoObj,false)
		end
	end
end

function BankerSimpleView:OnClickBebanker()
	AudioManager.GetInstance():PlayNormalAudio(27)
	BeBankerManager.GetInstance():OpenBeBankerPanel()
end

function BankerSimpleView:OnClicDropbanker()
	AudioManager.GetInstance():PlayNormalAudio(27)
	GameUIManager.GetInstance():RequestDropUserBeBank()
end

function BankerSimpleView:GetBankerBetPos()
	return self.bankerBetTrans.position
end

function BankerSimpleView:__delete()
	Instance=nil
end