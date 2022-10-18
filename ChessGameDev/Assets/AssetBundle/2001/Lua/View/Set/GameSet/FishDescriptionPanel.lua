FishDescriptionPanel=Class()

function FishDescriptionPanel:ctor(gameobj)
	self.gameObject=gameobj
	self:Init()
end


function FishDescriptionPanel:Init()
	self:InitData()
	self:FindView()
	self:AddBtnEventListenner()
	self:InitViewData()
end


function FishDescriptionPanel:InitData()
	self.ContentList={}
	self.ToggleIndex=1
	self.ContentTotalCount=3
end


function FishDescriptionPanel:FindView()
	local tf=self.gameObject.transform
	local Toggle=CS.UnityEngine.UI.Toggle
	local Button=CS.UnityEngine.UI.Button
	
	self.FishRulePanel=tf:Find("RulePanel/FishRulePanel").gameObject
	self.CloseFishRulePanelBtn=tf:Find("RulePanel/FishRulePanel/SetFishPanel/CloseBtn"):GetComponent(typeof(Button))
	self.NormalToggle=tf:Find("RulePanel/FishRulePanel/SetFishPanel/KindBtn/NormalBtn"):GetComponent(typeof(Toggle))
	self.BossToggle=tf:Find("RulePanel/FishRulePanel/SetFishPanel/KindBtn/BossBtn"):GetComponent(typeof(Toggle))
	self.SpecialToggle=tf:Find("RulePanel/FishRulePanel/SetFishPanel/KindBtn/SpecialBtn"):GetComponent(typeof(Toggle))
	
	self:FindFishDescriptionContent(tf)
	
end

function FishDescriptionPanel:FindFishDescriptionContent(tf)
	for i=1,self.ContentTotalCount do
		local ct=tf:Find("RulePanel/FishRulePanel/SetFishPanel/Content/C"..i).gameObject
		table.insert(self.ContentList,ct)
	end
end


function FishDescriptionPanel:InitViewData()
	self:IsShowFishDescriptionPanel(false)
end


function FishDescriptionPanel:AddBtnEventListenner()
	self.CloseFishRulePanelBtn.onClick:AddListener(function () self:OnclickCloseFishRulePanelBtn() end)
	self.NormalToggle.onValueChanged:AddListener(function (isOn) self:OnclickNormalToggle(isOn) end)
	self.BossToggle.onValueChanged:AddListener(function (isOn) self:OnclickBossToggle(isOn) end)
	self.SpecialToggle.onValueChanged:AddListener(function (isOn) self:OnclickSpecialToggle(isOn) end)
	
end


function FishDescriptionPanel:OnclickCloseFishRulePanelBtn()
	AudioManager.GetInstance():PlayNormalAudio(41)
	self:IsShowFishDescriptionPanel(false)
end


function FishDescriptionPanel:OnclickNormalToggle(isOn)
	if isOn then
		AudioManager.GetInstance():PlayNormalAudio(41)
		self:IsShowContentPanel(1,true)
	end
end


function FishDescriptionPanel:OnclickBossToggle(isOn)
	if isOn then
		AudioManager.GetInstance():PlayNormalAudio(41)
		self:IsShowContentPanel(2,true)
	end
end


function FishDescriptionPanel:OnclickSpecialToggle(isOn)
	if isOn then
		AudioManager.GetInstance():PlayNormalAudio(41)
		self:IsShowContentPanel(3,true)
	end
end


function FishDescriptionPanel:IsShowFishDescriptionPanel(isdisplay)
	CommonHelper.SetActive(self.FishRulePanel,isdisplay)
end


function FishDescriptionPanel:IsShowContentPanel(index,isdisplay)
	CommonHelper.IsShowPanel(index,self.ContentList,isdisplay,true,false)
end