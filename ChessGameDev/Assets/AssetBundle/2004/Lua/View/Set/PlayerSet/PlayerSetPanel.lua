PlayerSetPanel=Class()

function PlayerSetPanel:ctor(gameobj)
	self.gameObject=gameobj
	self:Init()
end


function PlayerSetPanel:Init()
	self:InitData()
	self:FindView()
	self:AddBtnEventListenner()
	self:InitViewData()
end


function PlayerSetPanel:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.IsEnableAutoBtn=false
	self.IsEnableLockFishBtn=false
	self.IsEnableSpeedBtn=false
	self.SetAtlasName="GameSetSpriteAtlas"	--当前面板使用的图集
	self.BulletSpeedNameList={"toll_bt_Speedx2","toll_bt_Speedx4"}
end


function PlayerSetPanel:FindView()
	local tf=self.gameObject.transform
	local Button=CS.UnityEngine.UI.Button
	self.RenderCamera=tf:Find("RightSetPanel"):GetComponent(typeof(GameManager.GetInstance().Canvas))
	self.RenderCamera.worldCamera=GameUIManager.GetInstance().UICamera
	self.AutoBtn=tf:Find("RightSetPanel/AnchorPanel/AutoSet"):GetComponent(typeof(Button))
	self.LockFishBtn=tf:Find("RightSetPanel/AnchorPanel/LockFishSet"):GetComponent(typeof(Button))
	self.SpeedBtn=tf:Find("RightSetPanel/AnchorPanel/SpeedLevelSet"):GetComponent(typeof(Button))
	self.AutoState=self.AutoBtn.transform:Find("OnclickEffect").gameObject
	self.LockFishState=self.LockFishBtn.transform:Find("OnclickEffect").gameObject
	self.SpeedState=self.SpeedBtn.transform:Find("OnclickEffect").gameObject
	self.SpeedStateSprite=self.SpeedState.transform:Find("ContextImage"):GetComponent(typeof(CS.UnityEngine.UI.Image))
	
end

function PlayerSetPanel:InitViewData()
	self:IsShowAutoStatePanel(false)
	self:IsShowLockFishStatePanel(false)
	self:IsShowSpeedStatePanel(false)
	self:InitBtnState()
end


function PlayerSetPanel:InitBtnState()
	self.IsEnableAutoBtn=false
	self.IsEnableLockFishBtn=false
	self.IsEnableSpeedBtn=false
end


function PlayerSetPanel:AddBtnEventListenner()
	self.AutoBtn.onClick:AddListener(function () self:OnclickAutoBtn() end)
	self.LockFishBtn.onClick:AddListener(function () self:OnclickLockFishBtn() end)
	self.SpeedBtn.onClick:AddListener(function () self:OnclickSpeedBtn() end)
end

function PlayerSetPanel:OnclickAutoBtn()
	AudioManager.GetInstance():PlayNormalAudio(25)
	self.IsEnableAutoBtn=not self.IsEnableAutoBtn	--TODO 是否关闭需要等待服务端通知后才能设置按钮状态及玩家的状态
	self:IsShowAutoStatePanel(self.IsEnableAutoBtn)
	local tempPlayerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(self.gameData.PlayerChairId)
	tempPlayerIns:SetAutoSendShootBullet(self.IsEnableAutoBtn)
	tempPlayerIns:UploadAutoShootBullet(self.IsEnableAutoBtn)
end

function PlayerSetPanel:OnclickLockFishBtn()
	AudioManager.GetInstance():PlayNormalAudio(25)
	self.IsEnableLockFishBtn=not self.IsEnableLockFishBtn
	local tempPlayerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(self.gameData.PlayerChairId)
	tempPlayerIns:UploadAutoLockFish(self.IsEnableLockFishBtn)
	
	if self.IsEnableLockFishBtn == true then
		AudioManager.GetInstance():PlayNormalAudio(27)
	end
end

function PlayerSetPanel:SetLockFishBtnDisable(disable)
	self.LockFishBtn.interactable = disable

end


function PlayerSetPanel:OnclickSpeedBtn()
	AudioManager.GetInstance():PlayNormalAudio(25)
	if self.IsEnableSpeedBtn==false then
		self.IsEnableSpeedBtn=true		
	end
	local tempPlayerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(self.gameData.PlayerChairId)
	local level=tempPlayerIns:SetShootBulletRateLevel()
	tempPlayerIns:UploadShootBulletRateLevel(level)
	if level~=1 then
		--设置speed等级显示
		if self.gameData.AllAtlasList[self.SetAtlasName] then
			self.SpeedStateSprite.sprite=self.gameData.AllAtlasList[self.SetAtlasName]:GetSprite(self.BulletSpeedNameList[level-1])
		end
	else
		self.IsEnableSpeedBtn=false
	end
	self:IsShowSpeedStatePanel(self.IsEnableSpeedBtn)
	
end

function PlayerSetPanel:ResetAutoState()
	self.IsEnableAutoBtn=false
	self:IsShowAutoStatePanel(false)
end

function PlayerSetPanel:SetSpeedBtnDisable(disable)
	self.SpeedBtn.interactable = disable
end

function PlayerSetPanel:ResetLockState()
	self.IsEnableLockFishBtn=false
	self:IsShowLockFishStatePanel(false)
end

function PlayerSetPanel:ResetSpeedState()
	self.IsEnableSpeedBtn = false
	self:IsShowSpeedStatePanel(false)
end


function PlayerSetPanel:IsShowAutoStatePanel(isdisplay)
	CommonHelper.SetActive(self.AutoState,isdisplay)
end

function PlayerSetPanel:IsShowLockFishStatePanel(isdisplay)
	CommonHelper.SetActive(self.LockFishState,isdisplay)
end

function PlayerSetPanel:IsShowSpeedStatePanel(isdisplay)
	CommonHelper.SetActive(self.SpeedState,isdisplay)
end
