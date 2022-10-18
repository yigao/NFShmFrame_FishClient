BetChipBtnView=Class()

function BetChipBtnView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
end

function BetChipBtnView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function BetChipBtnView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.BetChipTextList={}			--筹码表
	self.BetChipTransList = {}
	self.BetChipBeginPosList = {}
end



function BetChipBtnView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BetChipBtnView:FindView(tf)
	self.OneChipBtn = tf:Find("BetChipBtnPanel/Panel/Chip1_Btn"):GetComponent(typeof(self.Button))
	local chip1_text = tf:Find("BetChipBtnPanel/Panel/Chip1_Btn/Number"):GetComponent(typeof(self.Text))
	table.insert(self.BetChipTextList,chip1_text)
	table.insert(self.BetChipTransList,self.OneChipBtn.transform)
	table.insert(self.BetChipBeginPosList,self.OneChipBtn.transform.localPosition)
	
	self.TwoChipBtn = tf:Find("BetChipBtnPanel/Panel/Chip2_Btn"):GetComponent(typeof(self.Button))
	local chip2_text = tf:Find("BetChipBtnPanel/Panel/Chip2_Btn/Number"):GetComponent(typeof(self.Text))
	table.insert(self.BetChipTextList,chip2_text)
	table.insert(self.BetChipTransList,self.TwoChipBtn.transform)
	table.insert(self.BetChipBeginPosList,self.TwoChipBtn.transform.localPosition)

	self.ThreeChipBtn = tf:Find("BetChipBtnPanel/Panel/Chip3_Btn"):GetComponent(typeof(self.Button))
	local chip3_text = tf:Find("BetChipBtnPanel/Panel/Chip3_Btn/Number"):GetComponent(typeof(self.Text))
	table.insert(self.BetChipTextList,chip3_text)
	table.insert(self.BetChipTransList,self.ThreeChipBtn.transform)
	table.insert(self.BetChipBeginPosList,self.ThreeChipBtn.transform.localPosition)

	self.FourChipBtn = tf:Find("BetChipBtnPanel/Panel/Chip4_Btn"):GetComponent(typeof(self.Button))
	local chip4_text = tf:Find("BetChipBtnPanel/Panel/Chip4_Btn/Number"):GetComponent(typeof(self.Text))
	table.insert(self.BetChipTextList,chip4_text)
	table.insert(self.BetChipTransList,self.FourChipBtn.transform)
	table.insert(self.BetChipBeginPosList,self.FourChipBtn.transform.localPosition)
	
	self.FiveChipBtn = tf:Find("BetChipBtnPanel/Panel/Chip5_Btn"):GetComponent(typeof(self.Button))
	local chip5_text = tf:Find("BetChipBtnPanel/Panel/Chip5_Btn/Number"):GetComponent(typeof(self.Text))
	table.insert(self.BetChipTextList,chip5_text)
	table.insert(self.BetChipTransList,self.FiveChipBtn.transform)
	table.insert(self.BetChipBeginPosList,self.FiveChipBtn.transform.localPosition)
end


function BetChipBtnView:InitViewData()
	self:ResetChipBtnPosition()
end

function BetChipBtnView:ResetChipBtnPosition()
	for i = 1,#self.BetChipTransList do 
		self.BetChipTransList[i].localPosition = self.BetChipBeginPosList[i]
	end
end

function BetChipBtnView:AddEventListenner()
	self.OneChipBtn.onClick:AddListener(function () self:OnClickOneChip() end)
	self.TwoChipBtn.onClick:AddListener(function () self:OnClickTwoChip() end)
	self.ThreeChipBtn.onClick:AddListener(function () self:OnClickThreeChip() end)
	self.FourChipBtn.onClick:AddListener(function () self:OnClickFourChip() end)
	self.FiveChipBtn.onClick:AddListener(function () self:OnClickFiveChip() end)
end


function BetChipBtnView:InitBetChipValue()
	self:ResetChipBtnPosition()
	for i = 1,#self.gameData.GameChipMoneyList do
		self.BetChipTextList[i].text = self.gameData.GameChipMoneyList[i]
	end
end

function BetChipBtnView:EnterGameStart()
	self:ResetChipBtnPosition()
	self.gameData.CurrentBetIndex = 0
end

function BetChipBtnView:EnterBetChip()
	self.gameData.CurrentBetIndex = 0
	self:SetBetChipBtnStatus(false)
end

function BetChipBtnView:EnterOpenPrize()
	self.gameData.CurrentBetIndex = 0
	self:ResetChipBtnPosition()
	self:SetBetChipBtnStatus(false)
end

function BetChipBtnView:SetBetChipBtnStatus(isInteractable)
	local mySelfPlayer = PlayerManager.GetInstance():GetPlayerVoByChairdId(self.gameData.PlayerChairId)
	if isInteractable == false then
		if self.gameData.GameChipMoneyList[1] > mySelfPlayer.user_money then
			self.OneChipBtn.interactable = isInteractable
		else
			self.OneChipBtn.interactable = not isInteractable
		end

		if self.gameData.GameChipMoneyList[2] > mySelfPlayer.user_money then
			self.TwoChipBtn.interactable = isInteractable
		else
			self.TwoChipBtn.interactable = not isInteractable
		end

		if self.gameData.GameChipMoneyList[3] > mySelfPlayer.user_money then
			self.ThreeChipBtn.interactable = isInteractable
		else
			self.ThreeChipBtn.interactable = not isInteractable
		end

		if self.gameData.GameChipMoneyList[4] > mySelfPlayer.user_money then
			self.FourChipBtn.interactable = isInteractable
		else
			self.FourChipBtn.interactable = not isInteractable
		end

		if self.gameData.GameChipMoneyList[5] > mySelfPlayer.user_money then
			self.FiveChipBtn.interactable = isInteractable
		else
			self.FiveChipBtn.interactable = not isInteractable
		end
	else
		self.OneChipBtn.interactable = isInteractable
		self.TwoChipBtn.interactable = isInteractable
		self.ThreeChipBtn.interactable = isInteractable
		self.FourChipBtn.interactable = isInteractable
		self.FiveChipBtn.interactable = isInteractable
	end
end

function BetChipBtnView:OnClickOneChip()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	if self.gameData.CurrentBetIndex == 1 then
		return
	end
	self:CurrentSelectBetChip(1)
	self.gameData.CurrentBetIndex = 1
	AudioManager.GetInstance():PlayNormalAudio(27)
end

function BetChipBtnView:OnClickTwoChip()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	if self.gameData.CurrentBetIndex == 2 then
		return
	end
	self:CurrentSelectBetChip(2)
	self.gameData.CurrentBetIndex = 2
	AudioManager.GetInstance():PlayNormalAudio(27)
end

function BetChipBtnView:OnClickThreeChip()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	if self.gameData.CurrentBetIndex == 3 then
		return
	end
	self:CurrentSelectBetChip(3)
	self.gameData.CurrentBetIndex = 3
	AudioManager.GetInstance():PlayNormalAudio(27)
end

function BetChipBtnView:OnClickFourChip()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	if self.gameData.CurrentBetIndex == 4 then
		return
	end
	self:CurrentSelectBetChip(4)
	self.gameData.CurrentBetIndex = 4
	AudioManager.GetInstance():PlayNormalAudio(27)
end

function BetChipBtnView:OnClickFiveChip()
	if self.gameData.MainStation ~= StateManager.MainState.STATE_BetChip then
		return
	end
	if self.gameData.CurrentBetIndex == 5 then
		return
	end
	self:CurrentSelectBetChip(5)
	self.gameData.CurrentBetIndex = 5
	AudioManager.GetInstance():PlayNormalAudio(27)
end

function BetChipBtnView:CurrentSelectBetChip(index)
	for i = 1,#self.BetChipTransList do 
		self.BetChipTransList[i]:DOKill()
		self.BetChipTransList[i].localPosition = self.BetChipBeginPosList[i]
	end
	self.BetChipTransList[index]:DOLocalMoveY(25,0.15)
	AudioManager.GetInstance():PlayNormalAudio(27)
end

function BetChipBtnView:__delete()

end
