BeBankerView=Class()

function BeBankerView:ctor(gameObj)
	self:Init(gameObj)
	
end

function BeBankerView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function BeBankerView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.Text=GameManager.GetInstance().Text
	self.Slider = GameManager.GetInstance().Slider
	self.UIFormScript = GameManager.GetInstance().UIFormScript
	self.UIListScript = GameManager.GetInstance().UIListScript
	self.prepareBankerMoney = 0
	self.beBankItemList = {}
end

function BeBankerView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BeBankerView:FindView(tf)
	self.uiFormScript = tf:GetComponent(typeof(self.UIFormScript))

	self.uiListScript = tf:Find("LeftLayout/BankerItemList"):GetComponent(typeof(self.UIListScript))
	self.uiListScript.InstantiateElementCallback = function (go) self:CreateBeBankItem(go) end

	self.CloseBtn = tf:Find("CloseBtn"):GetComponent(typeof(self.Button))
	self.ApplyBankerBtn = tf:Find("RightLayout/applyBanker_Btn"):GetComponent(typeof(self.Button))
	self.ReduceBtn = tf:Find("RightLayout/reduce_Btn"):GetComponent(typeof(self.Button))
	self.AddBtn = tf:Find("RightLayout/add_Btn"):GetComponent(typeof(self.Button))

	self.bebanker_describe_text = tf:Find("RightLayout/bebanker_describe"):GetComponent(typeof(self.Text))
	self.min_bebanker_money_text = tf:Find("RightLayout/min_bebanker_money"):GetComponent(typeof(self.Text))

	self.Slider = tf:Find("RightLayout/Slider"):GetComponent(typeof(self.Slider))
end


function BeBankerView:InitViewData()
	self.uiListScript:Initialize(self.uiFormScript)
end

function BeBankerView:AddEventListenner()
	self.CloseBtn.onClick:AddListener(function () self:OnClickClose() end)
	self.ApplyBankerBtn.onClick:AddListener(function () self:OnClickApplyBanker() end)
	self.ReduceBtn.onClick:AddListener(function () self:OnClickReduce() end)
	self.AddBtn.onClick:AddListener(function () self:OnClickAdd() end)
	self.Slider.onValueChanged:AddListener(function(value) self:OnSliderValueChange(value) end)
end

function BeBankerView:OpenBeBankerPanel()
	self.prepareBankerMoney = self.gameData.BeBankMinMoney
	self:SetBeBankInfoValue()
	self:ShowBeBankItemView()
	self:IsDisableApplyBtn()
end

function BeBankerView:UpdateBeBankerPanel()
	self:ShowBeBankItemView()
	self:IsDisableApplyBtn()
end

function BeBankerView:ShowBeBankItemView()
	if self.uiListScript ~= nil then
		self.uiListScript:ResetContentPosition()
	end
	if self.gameData.WaitBankerVoList and #self.gameData.WaitBankerVoList > 0 then
		self.uiListScript:SetElementAmount(#self.gameData.WaitBankerVoList)
	end
end

function BeBankerView:SetBeBankInfoValue()
	local value =CommonHelper.FormatBaseProportionalScore(tonumber(self.gameData.BeBankMinMoney))
	self.bebanker_describe_text.text = string.format("上庄金额小于%d自动下庄",value) 
	self:SetBeBankerMoneyValue()
end

function BeBankerView:SetBeBankerMoneyValue()
	self.min_bebanker_money_text.text = CommonHelper.FormatBaseProportionalScore(tonumber(self.prepareBankerMoney))
end

function BeBankerView:CreateBeBankItem(go)
	local beBankItem = BeBankerManager.GetInstance().BeBankerItem.New(go)
    table.insert(self.beBankItemList,beBankItem)
end

function BeBankerView:OnClickClose()
	AudioManager.GetInstance():PlayNormalAudio(27)
	BeBankerManager.GetInstance():IsShowBeBankerPanel(false)
end

function BeBankerView:OnClickApplyBanker()
	GameUIManager.GetInstance():RequestApplyUserBeBank(tonumber(self.prepareBankerMoney))
end

function BeBankerView:IsDisableApplyBtn()
	if self.gameData.CurBankerVo.usNtChairId == self.gameData.PlayerChairId or BeBankerManager.GetInstance():IsMySelfWaitBankerList() then
		self.ApplyBankerBtn.interactable = false
	else
		self.ApplyBankerBtn.interactable = true
	end
end

function BeBankerView:OnClickReduce()
	if self.prepareBankerMoney > self.gameData.BeBankMinMoney then
		self.prepareBankerMoney = self.prepareBankerMoney - 10
	end

	if self.prepareBankerMoney< self.gameData.BeBankMinMoney then
		self.prepareBankerMoney = self.gameData.BeBankMinMoney
	end
	self:SetBeBankerMoneyValue()
end

function BeBankerView:OnClickAdd()
	local mySelfVo =  PlayerManager.GetInstance():GetPlayerVoByChairdId(self.gameData.PlayerChairId)
	if self.prepareBankerMoney <mySelfVo.user_money then
		self.prepareBankerMoney = self.prepareBankerMoney + 10
	end

	if self.prepareBankerMoney > mySelfVo.user_money then
		self.prepareBankerMoney = mySelfVo.user_money
	end
	self:SetBeBankerMoneyValue()
end

function BeBankerView:OnSliderValueChange(value)
	local mySelfVo =  PlayerManager.GetInstance():GetPlayerVoByChairdId(self.gameData.PlayerChairId)
	if self.prepareBankerMoney <= mySelfVo.user_money then
		self.prepareBankerMoney =self.gameData.BeBankMinMoney + math.floor(value * (mySelfVo.user_money - self.gameData.BeBankMinMoney))
		self:SetBeBankerMoneyValue()
	else
		self.Slider.value = 0
	end
end

function BeBankerView:__delete()
	
end