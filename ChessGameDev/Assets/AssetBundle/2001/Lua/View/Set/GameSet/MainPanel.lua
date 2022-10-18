MainPanel=Class()

function MainPanel:ctor(gameobj)
	self.gameObject=gameobj
	self:Init()
end


function MainPanel:Init()
	self:InitData()
	self:FindView()
	self:AddBtnEventListenner()
	self:InitViewData()
end


function MainPanel:InitData()
	
end


function MainPanel:FindView()
	local tf=self.gameObject.transform
	local Button=CS.UnityEngine.UI.Button
	
	self.RenderCamera=tf:Find("LeftSetPanel"):GetComponent(typeof(GameManager.GetInstance().Canvas))
	self.RenderCamera.worldCamera=GameUIManager.GetInstance().UICamera
	self.QuitGameBtn=tf:Find("LeftSetPanel/AnchorPanel/SliderMenu/QuitGameBtn"):GetComponent(typeof(Button))
	self.MenuPanel=tf:Find("LeftSetPanel/AnchorPanel/SliderMenu").gameObject
	self.OpenMenuBtn=tf:Find("LeftSetPanel/AnchorPanel/GameSetBtn"):GetComponent(typeof(Button))
	self.CloseMenuBtn=tf:Find("LeftSetPanel/AnchorPanel/SliderMenu/BackSetBtn"):GetComponent(typeof(Button))
	self.FishRuleBtn=tf:Find("LeftSetPanel/AnchorPanel/SliderMenu/FishKindBtn"):GetComponent(typeof(Button))
	self.GameSetBtn=tf:Find("LeftSetPanel/AnchorPanel/SliderMenu/SetBtn"):GetComponent(typeof(Button))
end


function MainPanel:InitViewData()
	self:IsShowMenuPanel(false)
end


function MainPanel:AddBtnEventListenner()
	self.QuitGameBtn.onClick:AddListener(function () self:OnclickQuitGameBtn() end)
	self.OpenMenuBtn.onClick:AddListener(function () self:OnclickOpenMenuBtn() end)
	self.CloseMenuBtn.onClick:AddListener(function () self:OnclickCloseMenuBtn() end)
	self.FishRuleBtn.onClick:AddListener(function () self:OnclickFishRuleBtn() end)
	self.GameSetBtn.onClick:AddListener(function () self:OnclickGameSetBtn() end)
end



function MainPanel:OnclickQuitGameBtn()
	AudioManager.GetInstance():PlayNormalAudio(41)
	GameSetManager.GetInstance():SendQuitGameMsg()
end

function MainPanel:OnclickOpenMenuBtn()
	AudioManager.GetInstance():PlayNormalAudio(41)
	self:IsShowMenuPanel(true)
end

function MainPanel:OnclickCloseMenuBtn()
	AudioManager.GetInstance():PlayNormalAudio(41)
	self:IsShowMenuPanel(false)
end

function MainPanel:OnclickFishRuleBtn()
	AudioManager.GetInstance():PlayNormalAudio(41)
	GameSetManager.GetInstance().FishDescriptionPanel:IsShowFishDescriptionPanel(true)
end

function MainPanel:OnclickGameSetBtn()
	AudioManager.GetInstance():PlayNormalAudio(41)
	GameSetManager.GetInstance().SystemSetPanel:IsShowSystemSetPanel(true)
end


function MainPanel:IsShowMenuPanel(isdisplay)
	CommonHelper.SetActive(self.MenuPanel,isdisplay)
end