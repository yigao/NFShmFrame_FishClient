PlayerInfo=Class()

function PlayerInfo:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function PlayerInfo:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	self:AddBtnEventListenner()
	CommonHelper.AddUpdate(self)
end


function PlayerInfo:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.LockTragetFish=nil		--锁定的鱼
	self.IsLockFish=false		--是否锁定鱼
	self.IsAutoShootFish=false	--是否自动
	self.IsContinuePress=false	--是否持续点击
	self.PressTimes=0.5			--按下不放时间
	self.ShootBulletRate={0.4,0.3,0.2}		--射击间隔
	self.CurrentShootBulletRateIndex=1
	self.CurrentShootBulletTime=0
	self.CacheBulletList={}			--服务端下发的子弹集
	self.CurrentShootBulletIntervalTime=0
	self.ChairdID=0					--座位id
	self.UserId=154183				--玩家ID
	self.PrecisionValue=10000				--精度值
	self.BulletUID=1
	self.BulletUIDMax=1
	self.BulletIntervalDistance=50			--子弹间隔距离
	self.ShowLockFishList={}				--展示用的鱼列表
	self.CurrentGunLevel=1				--当前炮等级
	self.currentNetAnimName="Net_01_net01"			--当前使用Net等级动画
	self.currentBulletAnimName="Bullet_01"			--当前子弹等级动画
	self.currentUseRealGunLevel=1						--当前客户端真实使用的炮台资源等级
	self.IsDoubleScoreStatus = false --是否进入攻击双倍得分状态
	self.isOnLine=false
	self.LimitBulletCount=30
	self.currentPlayMoney=0
end


function PlayerInfo:InitPlayerData(tempId)
	self:InitBulletUID(tempId)
end

function PlayerInfo:InitBulletUID(ChairdID)
	self.BulletUID=PlayerManager.GetInstance():GetPlayerBulletUID(ChairdID)
	self.BulletUIDMax=2*self.BulletUID
end

function PlayerInfo:InitView(gameObj)
	self.Panel=PlayerManager.GetInstance().PlayerPanel.New(gameObj)
	
end


function PlayerInfo:InitViewData()
	self:IsShowPlayerPanel(false)
	
	self.GunTeamObj=self.Panel.GunTeamObj
	self.BulletPos=self.Panel.BulletPos
	self.GunLockPointTrans=self.Panel.GunLockPoint.transform
	self.LockPointList=self.Panel.LockPointList
	self.LockTips=self.Panel.LockTips
	self.ChangeLockFishBtn=self.Panel.ChangeLockFishBtn
	self.AddBetBtn=self.Panel.AddBetBtn
	self.ReduceBetBtn=self.Panel.ReduceBetBtn
	self.BetScoreLabel=self.Panel.BetScoreLabel
	self.PlayerMoneyLabel=self.Panel.PlayerMoneyLabel
    self.PlayerNameLabel=self.Panel.PlayerNameLabel
	self.FlyCoinPos=self.Panel.FlyCoinPos
	self.FlyScorePos=self.Panel.FlyScorePos
	self.BigAwardPosList = self.Panel.BigAwardPosList
end 


function PlayerInfo:SetPlayerChairID(chairId)
	self.ChairdID=chairId
end


function PlayerInfo:GetPlayerChairID()
	return self.ChairdID
end




function PlayerInfo:SetUserID(userId)
	self.UserId=userId
end

function PlayerInfo:GetUserID()
	return self.UserId
end


function PlayerInfo:SetOnlineState(onLine)
	self.isOnLine=onLine
end

function PlayerInfo:GetOnlineState()
	return self.isOnLine
end


function PlayerInfo:ClearBulletCache()
	self.CacheBulletList={}
end


function PlayerInfo:SetPlayerMoney(money)
	self.currentPlayMoney=money
end


function PlayerInfo:GetPlayerMoney()
	return self.currentPlayMoney
end


function PlayerInfo:GetCurrentBetValue()
	return self.gameData.GunLevelConfig[self.CurrentGunLevel].cannon_value
end


function PlayerInfo:ResetBulletRate()
	self.CurrentShootBulletRateIndex=1
end


function PlayerInfo:IsShowPlayerPanel(isDsisplay)
	CommonHelper.SetActive(self.gameObject,isDsisplay)
end


function PlayerInfo:RotationPaoTao()
	self.gameObject.transform.localEulerAngles=CSScript.Vector3(0,0,180)
end



function PlayerInfo:AddBtnEventListenner()
	self.ChangeLockFishBtn.onClick:AddListener(function () self:OnclickChangeLockFish() end)
	self.AddBetBtn.onClick:AddListener(function () self:OnclickAddBet() end)
	self.ReduceBetBtn.onClick:AddListener(function () self:OnclickReduceBet() end)
end



function PlayerInfo:PlayerEnterState(palyerInfo)
	self:SetPlayerChairID(palyerInfo.chair_id)
	self:SetPlayerName(palyerInfo.user_name)
	self:SetPlayerMoneyScore(palyerInfo.user_money)
	--炮台等级
	self:SetGunLevelValue(palyerInfo.cannon_id)
	self:IsShowBetPanel()
	self:IsShowPlayerPanel(true)
	self:IsShowImHere()
	self:ClearBulletCache()
	self:SetOnlineState(true)
end


function PlayerInfo:PlayerLeaveState()
	self:SetPlayerChairID(0)
	self:ResetBulletRate()
	self:SetAutoSendShootBullet(false)
	self:SetAutoLockFish(false)
	self.LockTragetFish=nil
	self:IsShowPlayerPanel(false)
	self.Panel:SetShowPanel(false)
	self:ClearBulletCache()
	self:SetOnlineState(false)
	
end



function PlayerInfo:EnterDoubleScoreState( )
	self.IsDoubleScoreStatus = true
	self.Panel:IsShowBetPanel(false)
	self:SetGunParticleEffect()
	self:SetDoubleStatsGunLevelValue(self.CurrentGunLevel)
end

function PlayerInfo:LeaveDoubleScoreState( )
	self.IsDoubleScoreStatus = false
	self.Panel:IsShowBetPanel(true)
	self:SetGunParticleEffect()
	self:SetGunLevelValue(self.CurrentGunLevel)
end

function PlayerInfo:DoubleGunOnOffState(state)
	if state == 1 then
		self:EnterDoubleScoreState()
	else
		self:LeaveDoubleScoreState()
	end
end

--------------------------------------------------------------PlayerSet----------------------------------------------------------

function PlayerInfo:OnclickAddBet()
	AudioManager.GetInstance():PlayNormalAudio(48)
	--AudioManager.GetInstance():PlayNormalAudio(self.gameData.gameConfigList.GunConfigList[self.gameData.GunLevelConfig[self.CurrentGunLevel].cannon_value_gun_id].makeUpAudio)
	local tempGunLevel=self.CurrentGunLevel+1
	if tempGunLevel>#self.gameData.GunLevelConfig then
		tempGunLevel=1
	end
	PlayerManager.GetInstance():SendChangeGunMsg(tempGunLevel)
end


function PlayerInfo:OnclickReduceBet()
	AudioManager.GetInstance():PlayNormalAudio(48)
	--AudioManager.GetInstance():PlayNormalAudio(self.gameData.gameConfigList.GunConfigList[self.gameData.GunLevelConfig[self.CurrentGunLevel].cannon_value_gun_id].makeUpAudio)
	local tempGunLevel=self.CurrentGunLevel-1
	if tempGunLevel<=0 then
		tempGunLevel=#self.gameData.GunLevelConfig
	end
	PlayerManager.GetInstance():SendChangeGunMsg(tempGunLevel)
end

function PlayerInfo:SetDoubleStatsGunLevelValue(level)
	self.CurrentGunLevel=level
	--下注值
	self:SetBetScore(self.gameData.GunLevelConfig[level].cannon_value)
	--设置显示炮等级
	self:SetShowGun(self.gameData.gameConfigList.GunConfigList[self.gameData.GunLevelConfig[level].cannon_value_gun_id].doubleGunRes)
	--网等级
	self:SetNetAnimName(self.gameData.gameConfigList.GunConfigList[level].doubleNetRes)
	--子弹等级
	self:SetBulletAnimName(self.gameData.gameConfigList.GunConfigList[level].doubleBulletRes)
end

function PlayerInfo:SetGunLevelValue(level)
	self.CurrentGunLevel=level
	--Debug.LogError(level)
	--pt(self.gameData.GunLevelConfig)
	--下注值
	self:SetBetScore(self.gameData.GunLevelConfig[level].cannon_value)
	--设置显示炮等级
	self:SetShowGun(self.gameData.gameConfigList.GunConfigList[self.gameData.GunLevelConfig[level].cannon_value_gun_id].normalGunRes)
	--网等级
	self:SetNetAnimName(self.gameData.gameConfigList.GunConfigList[level].normalNetRes)
	--子弹等级
	self:SetBulletAnimName(self.gameData.gameConfigList.GunConfigList[level].normalBulletRes)
end

function PlayerInfo:SetGunParticleEffect(  )
	self.Panel:IsShowGunParticleEffect()	
end

function PlayerInfo:SetShowGun(index)
	self.currentUseRealGunLevel=tonumber(index)
	self.Panel:SetShowGunPanel(self.currentUseRealGunLevel,true)
end


function PlayerInfo:GetGunLevel()
	return self.CurrentGunLevel
end


function PlayerInfo:SetNetAnimName(netName)
	self.currentNetAnimName=netName
end

function PlayerInfo:SetBulletAnimName(bulletName)
	self.currentBulletAnimName=bulletName
end


function PlayerInfo:SetBetScore(score)
	self.BetScoreLabel.text=CommonHelper.FormatBaseProportionalScore(score)
end

function PlayerInfo:SetPlayerMoneyScore(score)
	self.PlayerMoneyLabel.text=CommonHelper.FormatBaseProportionalScore(score)
	self:SetPlayerMoney(score)
end

function PlayerInfo:SetPlayerName(name)
	self.PlayerNameLabel.text=name
end


function PlayerInfo:GetFlyCoinPos()
	return self.FlyCoinPos.position
end


function PlayerInfo:IsShowBetPanel()
	local isDsisplay=false
	if self.ChairdID==self.gameData.PlayerChairId then
		isDsisplay=true
	end
	self.Panel:IsShowBetPanel(isDsisplay)
end

function PlayerInfo:IsShowImHere( )
	local isDsisplay=false
	if self.ChairdID==self.gameData.PlayerChairId then
		isDsisplay=true
	end
	self.Panel:IsShowImHere(isDsisplay)
end

function PlayerInfo:IsShowAwardTipsPanel(score)
	local isMe = self.ChairdID==self.gameData.PlayerChairId
	self.Panel:IsShowAwardTipsPanel(isMe,score,true)
end

--------------------------------------------------------------CreateNet-------------------------------------------------------

function PlayerInfo:CreateNet(netLevel,targetNetPos)
	local netIns=NetManager.GetInstance():GetNet(netLevel,targetNetPos)
	netIns:SetPlayAnimSatate(true)
	netIns:PlayNetAnimator()
end


--------------------------------------------------------------LockFish----------------------------------------------------------

function PlayerInfo:SetLockFish(fish)
	self:LockFishProcess(fish)
	self.LockTragetFish=fish
end

function PlayerInfo:LockFishProcess(fish)
	if fish and self.IsLockFish  then
		local tempUID=0
		if self.LockTragetFish then
			tempUID=self.LockTragetFish.FishVo.UID
		end
		if tempUID~=fish.FishVo.UID  then
			self:UpLoadLockFish(fish)
			self:DeleteCopyFish()
			if self.ChairdID==self.gameData.PlayerChairId then
				self.Panel:PlayLockTipsAnim()
				--[[local fishVo=CommonHelper.DeepCopyTable(fish.FishVo)
				PlayerManager.GetInstance().ShowFishUIDMark=PlayerManager.GetInstance().ShowFishUIDMark+1
				fishVo.UID=PlayerManager.GetInstance().ShowFishUIDMark
				local currentShowLockFish=FishManager.GetInstance():GetFish(fishVo,true)
				if currentShowLockFish then
					currentShowLockFish:IsEnableBoxcollider(false)
					currentShowLockFish:SetFishParent(self.Panel.LockFishPos.transform)
					currentShowLockFish:SetMainFishOrder(0)
					table.insert(self.ShowLockFishList,currentShowLockFish)
				end--]]
			
			end

		end
	end
end


function PlayerInfo:GetLockFish()
	return self.LockTragetFish
end



function PlayerInfo:GetAutoLockFish()
	local targetFish=nil
	local fishCount=#self.gameData.GameConfig.LockFishList
	for i=1,fishCount do
		targetFish=FishManager.GetInstance():GetUsingFishByID(self.gameData.GameConfig.LockFishList[CommonHelper.GetRandomTwo(1,fishCount)])
		if targetFish then
			return targetFish
		end
	end
	return nil
end

function PlayerInfo:UpdateAutoLockFish()
	if self.IsLockFish and self.LockTragetFish==nil and self.ChairdID==self.gameData.PlayerChairId then	--只处理自己
		local LockTragetFish=self:GetAutoLockFish()
		if LockTragetFish then
			self:SetLockFish(LockTragetFish)
		end
	end
end

function PlayerInfo:UpLoadLockFish(lockFish)
	local lockFishUID=lockFish.FishVo.UID
	if lockFishUID then
		self:IsShowLockFishStatePanel(true)
		--TODO 上传锁定鱼
		if self.ChairdID==self.gameData.PlayerChairId then
			local sendMsg={}
			sendMsg.fishId=lockFishUID
			FishManager.GetInstance():RequestLockTargetFishMsg(sendMsg)
		end
		
	end
end

function PlayerInfo:UpdateCheckLockFishState()
	if self.IsLockFish and self.LockTragetFish then
		if self.LockTragetFish:GetIsDie() or self.LockTragetFish:GetIsDestoty() or not self.LockTragetFish:CheckBoundValid() then
			self.LockTragetFish=nil
			self:IsShowLockFishStatePanel(false)
			
		end
	end
end


function PlayerInfo:UpdateLockFish()
	self:UpdateAutoLockFish()
	self:UpdateCheckLockFishState()
	self:UpdateCaculateLockPoint()
end


function PlayerInfo:SetAutoLockFish(isAuto)
	self.IsLockFish=isAuto
end

function PlayerInfo:UploadAutoLockFish(isAuto)
	local sendMsg={}
	sendMsg.onOff=isAuto
	FishManager.GetInstance():RequestLockFishSwitchNetMsg(sendMsg)
end


function PlayerInfo:ResetLockTargetFishState(isAuto)
	if isAuto==false then
		self:SetLockFish(nil)
		self:IsShowLockFishStatePanel(false)
		
	end
end


------------------------------------------------------LockFishTips


function PlayerInfo:UpdateCaculateLockPoint()
	if self.IsLockFish and self.LockTragetFish then
		if not self.LockTragetFish:GetIsDie() and  not self.LockTragetFish:GetIsDestoty() and  self.LockTragetFish:CheckBoundValid() then
			--计算鱼和锁定点的距离
			self:CaculateLockFishDistance(self.LockTragetFish,self.GunLockPointTrans)
			self:SetTargetLockFishTips(self.LockTragetFish.gameObject.transform.position)
		end
	end
end


function PlayerInfo:CaculateLockFishDistance(targetFish,currentTrans)
	local lockFishPos=currentTrans:InverseTransformPoint(targetFish.gameObject.transform.position)
	local bulletPos=currentTrans.localPosition
	local distance=CSScript.Vector3.Distance(lockFishPos,bulletPos)
	local dir=(lockFishPos-bulletPos).normalized
	local pointCount=math.floor(distance/self.BulletIntervalDistance) + 1
	local tempPos=0
	local lockPoint=0
	for i=1,#self.LockPointList do
		lockPoint=self.LockPointList[i]
		if i<=pointCount then
			tempPos = bulletPos+dir*self.BulletIntervalDistance*(i-1)
			CSScript.FishManager.SetLocalPosition(lockPoint,tempPos.x,tempPos.y,tempPos.z)
			CommonHelper.SetActive(lockPoint,true)
		else
			CommonHelper.SetActive(lockPoint,false)
		end
		
	end
end


function PlayerInfo:OnclickChangeLockFish()
	self.LockTragetFish=nil
	
end

function PlayerInfo:IsShowLockFishStatePanel(isDsisplay)
	self.Panel:IsShowLockTipsPanel(isDsisplay)
	self.Panel:IsShowGunLockPoint(isDsisplay)
	if self.ChairdID==self.gameData.PlayerChairId then
		--self.Panel:IsShowLockFishPanel(isDsisplay)
		self.Panel:IsShowChangeFishBtnPanel(isDsisplay)
	end	
end

function PlayerInfo:SetTargetLockFishTips(targetFishPos)
	self.Panel:SetLockTipsPos(targetFishPos)
end


function PlayerInfo:DeleteCopyFish()
	if self.ShowLockFishList and next(self.ShowLockFishList) then
		for i=1,#self.ShowLockFishList do
			GameObjectPoolManager.GetInstance():SetPoolParent(self.ShowLockFishList[i].gameObject,GameObjectPoolManager.PoolType.FishPool)
			self.ShowLockFishList[i]:SetDestory(true)
		end
		self.ShowLockFishList={}
	end
	
end




---------------------------------------------------------------ShootBullet---------------------------------------------------

function PlayerInfo:SetAutoSendShootBullet(isAuto)
	self.IsAutoShootFish=isAuto
end

function PlayerInfo:UploadAutoShootBullet(isAuto)
	local sendMsg={}
	sendMsg.onOff=isAuto
	BulletManager.GetInstance():RequestAutoShootBulletSwitchMsg(sendMsg)
end



function PlayerInfo:SetShootBulletRateLevel()
	self.CurrentShootBulletRateIndex=self.CurrentShootBulletRateIndex+1
	if self.CurrentShootBulletRateIndex>#self.ShootBulletRate then
		self.CurrentShootBulletRateIndex=1
	end
	return self.CurrentShootBulletRateIndex
end


function PlayerInfo:UploadShootBulletRateLevel(index)
	local sendMsg={}
	sendMsg.usSpeedIndex=100
	sendMsg.usIntervalIndex=index
	BulletManager.GetInstance():RequestBulletSpeedNetMsg(sendMsg)
end



function PlayerInfo:OnClickSetLockFish(isPress,fish)
	if self.IsLockFish and isPress then
		self:SetLockFish(fish)
	end
end


function PlayerInfo:OnClickSendShootBullet(isPress)
	self.IsContinuePress=isPress
	if isPress and self:GetOnlineState() then
		if self.IsAutoShootFish then return end
		self:ResetShootBulletTime()
		self:SendShootBullet()
	end
end


function PlayerInfo:SendShootBullet()
	local sendBulletCount=BulletManager.GetInstance():GetPlayerBulletCount(self.ChairdID)
	if sendBulletCount>self.LimitBulletCount then 
			--Debug.LogError("超过子弹最大上限数量")
			GameManager.GetInstance():ShowUITips("发射的子弹太多了！！！",1)
		return
	end

	if self:GetPlayerMoney()<self:GetCurrentBetValue() then
		Debug.LogError("玩家下注金额不足！！！")
		GameManager.GetInstance():ShowUITips("玩家下注金额不足！！！",3)
		return
	end
	
	self:UpdateMuzzleRotation()	
	local shootAngle=math.floor(self.GunTeamObj.transform.eulerAngles.z*self.PrecisionValue)
	self:CaculateBulletUID()
	BulletManager.GetInstance():RequestSendBulletMsg(shootAngle,self.BulletUID)
	self:LocalCreateBullet()
end


function PlayerInfo:CaculateBulletUID()
	self.BulletUID=self.BulletUID+1
	if self.BulletUID>=self.BulletUIDMax then
		self.BulletUID=math.ceil(self.BulletUIDMax/2)
	end
end

function PlayerInfo:LocalCreateBullet()
	if self.ChairdID==self.gameData.PlayerChairId then
		BulletManager.GetInstance():LocalCreatBullet(self.ChairdID,self.BulletUID,1,1,self.CurrentGunLevel)
		AudioManager.GetInstance():PlayNormalAudio( tonumber(self.gameData.gameConfigList.GunConfigList[self.gameData.GunLevelConfig[self.CurrentGunLevel].cannon_value_gun_id].normalShootAudio))
	end
end


function PlayerInfo:UpdateSendShootBullet()
	if self.IsContinuePress or (self.IsAutoShootFish and self.ChairdID==self.gameData.PlayerChairId) then
		self.CurrentShootBulletTime=self.CurrentShootBulletTime+CSScript.Time.deltaTime 
		if self.CurrentShootBulletTime>=self.ShootBulletRate[self.CurrentShootBulletRateIndex] then
			self:ResetShootBulletTime()
			self:SendShootBullet()
		end
	end
	
end

function PlayerInfo:ResetShootBulletTime()
	self.CurrentShootBulletTime=0
end

function PlayerInfo:SetMuzzleEulerAngles(angle)
	CS.FishManager.SetLocalEulerAngles(self.GunTeamObj,0,0,angle)
end


function PlayerInfo:ServerToShootBullet(bulletIns)
	if bulletIns.BulletVo.ChairId~=self.gameData.PlayerChairId then
		self:AddShootBulletCache(bulletIns)
	end
end

function PlayerInfo:LocalToShootBullet(bulletIns)
	if bulletIns.BulletVo.ChairId==self.gameData.PlayerChairId then
		self:AddShootBulletCache(bulletIns)
	end
end


function PlayerInfo:AddShootBulletCache(bulletIns)
	table.insert(self.CacheBulletList,bulletIns)
end


function PlayerInfo:ShootBullet(bulletIns)
	if (bulletIns.BulletVo.ChairId~=self.gameData.PlayerChairId and self.IsLockFish==false) or (self.IsLockFish and self.LockTragetFish==nil and bulletIns.BulletVo.ChairId~=self.gameData.PlayerChairId) then
		self:SetMuzzleEulerAngles(bulletIns.BulletVo.BulletAngle/self.PrecisionValue)
	end
	
	self.Panel:PlayGunShotAnim(self.currentUseRealGunLevel)	--播放发炮动画
	bulletIns:SetBulletKindAnim(self.currentBulletAnimName)	--设置子弹等级
	bulletIns:SetBulletLockTargetFish(self.LockTragetFish)
	local bulletVecPos = self.BulletPos.position
	bulletIns:SetPosition(bulletVecPos.x,bulletVecPos.y,bulletVecPos.z)
	bulletIns:SetLocalScale(1,1,1)
    bulletIns:SetEulerAngles(self.BulletPos.eulerAngles)
	bulletIns:BulletBeginMove(bulletIns.bulletSpeed)
end

--TODO 炮口转动还可以做性能优化，当前触发方式会执行多帧
function PlayerInfo:NormalRotationGun()
	local upVector = CSScript.Vector3.up
	local UICamera=GameUIManager.GetInstance().UICamera
	local vecMouse=CSScript.Input.mousePosition
	local vecMouseWorld=UICamera:ScreenToWorldPoint(vecMouse)
	if vecMouse.x>=0 and vecMouse.x<=CSScript.Screen.width and vecMouse.y>=0 and vecMouse.y<=CSScript.Screen.height then
		local gunTeamVerctor3Pos = self.GunTeamObj.transform.position
		local v1=CSScript.Vector3.Normalize(vecMouseWorld-gunTeamVerctor3Pos)
		self.GunTeamObj.transform.eulerAngles=CSScript.Vector3(0,0,CSScript.Quaternion.FromToRotation(upVector,v1).eulerAngles.z)
	end
end


function PlayerInfo:LockingRotationGun()
	local upVector = CSScript.Vector3.up
	local gunTeamVerctor3Pos = self.GunTeamObj.transform.position
	local v1=CSScript.Vector3.Normalize(self.LockTragetFish:GetPosition()-gunTeamVerctor3Pos)
	self.GunTeamObj.transform.eulerAngles=CSScript.Vector3(0,0, CSScript.Quaternion.FromToRotation(upVector,v1).eulerAngles.z)
end


function PlayerInfo:UpdateMuzzleRotation()
	if self.IsLockFish and self.LockTragetFish then
		self:LockingRotationGun()
	elseif self.IsContinuePress then
		self:NormalRotationGun()
	end
end


function PlayerInfo:UpdateShootBullet()
	if self.CacheBulletList and next(self.CacheBulletList) then
		self.CurrentShootBulletIntervalTime=self.CurrentShootBulletIntervalTime+CSScript.Time.deltaTime
		if self.CurrentShootBulletIntervalTime>=0.1 then
			self.CurrentShootBulletIntervalTime=0
			local bulletIns=table.remove(self.CacheBulletList,1)
			self:ShootBullet(bulletIns)
		end
		
	end
end


function PlayerInfo:Update()
	self:UpdateMuzzleRotation()
	self:UpdateSendShootBullet()
	self:UpdateShootBullet()
	self:UpdateLockFish()
end


------------------------------------------------------------------------------------------------------------------------------------


