PlayerPanel=Class()

function PlayerPanel:ctor(obj)
	self.gameObject = obj
	self:Init(obj)
	
end


function PlayerPanel:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function PlayerPanel:InitData()
	self.PreCount=30
	self.LockPointList={}
	self.GunLevelCount=3
	self.CatchFishPosIndex = 0
	self.BigAwardPosCount = 3
	self.CatchFishPosCount = 3
	self.CatchFishPosList ={}
	self.SwrilPanel = nil
	self.SpecialDeclarePanel = nil
	self.GunLevelAnimList={}
	self.GunAnimPramsList={"shot01","shot02","shot03","FireStormGun_Shoot"}
	self.ImHereTimer = nil
	self.SkillGun = nil
	self.SKillPanel = nil
end


function PlayerPanel:InitView(gameObj)
	self:FindView(gameObj)
end



function PlayerPanel:FindView(gameObj)
	local tf=gameObj.transform
	self:FindGunView(tf)
	self:FindLockFishView(tf)
	self:FindPlayerInfoView(tf)
	self:AddNodePanel(tf)
end



function PlayerPanel:InitViewData()
	self:InitLockPoint()
	self:SetShowPanel(false)
end

function PlayerPanel:SetShowPanel(isDisplay)
	self:IsShowlockRotation(isDisplay)
	self:IsShowLockPoint(isDisplay)
	self:IsShowLockTips(isDisplay)
	self:IsShowGunLockPoint(isDisplay)
end


local Button=CS.UnityEngine.UI.Button 
local Animation=CS.UnityEngine.Animation
local Animator=CS.UnityEngine.Animator
local Text=CS.UnityEngine.UI.Text 
function PlayerPanel:FindGunView(mTF)
	self.GunTeamObj=mTF:Find("Gun_Team").gameObject
	self.BulletPos=mTF:Find("Gun_Team/BulletPos")
	self.GunLockPoint=mTF:Find("Gun_Team/LockPonitTeam").gameObject
	self.ImHere = mTF:Find("ImHere").gameObject
	self.ImHereAnimator = self.ImHere:GetComponent(typeof(Animator))
	CommonHelper.SetActive(self.ImHere,false)
	self.GunParticleEffect = mTF:Find("Gun_Team/GunParticleEffect").gameObject
	for i=1,self.GunLevelCount do
		local tempGunAnim=mTF:Find("Gun_Team/GunType0"..i):GetComponent(typeof(Animator))
		table.insert(self.GunLevelAnimList,tempGunAnim)
	end
	local gunFireStorm = mTF:Find("Gun_Team/GunFireStorm"):GetComponent(typeof(Animator))
	table.insert(self.GunLevelAnimList,gunFireStorm)
end


function PlayerPanel:FindLockFishView(mTF)
	self.LockFishPanel = mTF:Find("LockFishPanel").gameObject
	self.LockRotation = mTF:Find("LockFishPanel/SkillLockRotation").gameObject
	self.LockRotationAnim = self.LockRotation:GetComponent(typeof(Animator))
	self.LockPoint = mTF:Find("LockFishPanel/LockPoint").gameObject
	self.LockTips = mTF:Find("LockFishPanel/LockTips").gameObject
	self.LockTipsAnim = self.LockTips:GetComponent(typeof(Animator))
end

function PlayerPanel:FindPlayerInfoView(mTF)
	self.BetPanel=mTF:Find("BetPanel").gameObject
	self.AddBetBtn=mTF:Find("BetPanel/Add"):GetComponent(typeof(Button))
	self.ReduceBetBtn=mTF:Find("BetPanel/Reduce"):GetComponent(typeof(Button))
	self.FlyScorePos=mTF:Find("PlayerInfoPanel/ScoreImage/ScorePoint")
	self.FlyCoinPos=mTF:Find("PlayerInfoPanel/ScoreImage/CoinPos")
	self.BetScoreLabel=mTF:Find("PlayerInfoPanel/BetImage/Text"):GetComponent(typeof(Text))
	self.PlayerMoneyLabel=mTF:Find("PlayerInfoPanel/ScoreImage/Text"):GetComponent(typeof(Text))
	self.PlayerNameLabel=mTF:Find("PlayerInfoPanel/Name"):GetComponent(typeof(Text))
end



function PlayerPanel:AddNodePanel(mTF)
	local catchFishPanel = mTF:Find("AddNodePanel/CatchFishPanel")
	for i = 1,self.CatchFishPosCount do
		local tempPos = catchFishPanel:Find("Pos"..i)
		table.insert(self.CatchFishPosList,tempPos)
	end

	self.SwrilPanel = mTF:Find("AddNodePanel/SwrilPanel")

	self.SKillPanel =  mTF:Find("AddNodePanel/SKillPanel")

	self.SkillGun = mTF:Find("Gun_Team/Skill_Gun")

	self.SpecialDeclarePanel=mTF:Find("AddNodePanel/SpecialDeclarePanel")
end


function PlayerPanel:InitLockPoint()
	local GameObject=CS.UnityEngine.GameObject
	local tempPoint=nil
	for i=1,self.PreCount do
		tempPoint=GameObject.Instantiate(self.LockPoint)
		CommonHelper.SetActive(tempPoint,false)
		CommonHelper.AddToParentGameObject(tempPoint,self.GunLockPoint)
		table.insert(self.LockPointList,tempPoint)
	end
end


function PlayerPanel:GetPlayerCatchFishPos(  )
	self.CatchFishPosIndex = self.CatchFishPosIndex + 1
	if self.CatchFishPosIndex > 3 then
		self.CatchFishPosIndex  = 1
	end
	return self.CatchFishPosList[self.CatchFishPosIndex].position
end

function PlayerPanel:RemovePlayerCatchFishPos(  )
	self.CatchFishPosIndex = self.CatchFishPosIndex - 1
	if self.CatchFishPosIndex < 0 then
		self.CatchFishPosIndex  = 0
	end	
end


function PlayerPanel:IsShowBetPanel(isDisplay)
	CommonHelper.SetActive(self.BetPanel,isDisplay)
end

function PlayerPanel:IsShowLockFishPanel(isDisplay)
	CommonHelper.SetActive(self.LockFishPanel,isDisplay)
end


function PlayerPanel:IsShowGunLockPoint(isDisplay)
	CommonHelper.SetActive(self.GunLockPoint,isDisplay)
end


function PlayerPanel:IsShowlockRotation(isDisplay)
	CommonHelper.SetActive(self.LockRotation,isDisplay)
end

function PlayerPanel:IsShowLockPoint(isDisplay)
	CommonHelper.SetActive(self.LockPoint,isDisplay)
end

function PlayerPanel:IsShowLockTips(isDisplay)
	CommonHelper.SetActive(self.LockTips,isDisplay)
end

function PlayerPanel:PlayLockTipsAnim()
	self.LockTipsAnim:Play("LockFishTipsAnim",0,0)
end

function PlayerPanel:SetLockTipsPos(targetPos)
	self.LockTips.transform.position=targetPos
end

function PlayerPanel:PlayGunShotAnim(index)
	local animName=self.GunAnimPramsList[index]
	if animName then
		self.GunLevelAnimList[index]:Play(animName,0,0)
	end
end

function PlayerPanel:PlayGunShotAnim01(index,animName)
	if animName then
		self.GunLevelAnimList[index]:Play(animName,0,0)
	end
end

function PlayerPanel:SetShowGunPanel(index,isDisplay)
	CommonHelper.IsShowPanel(index,self.GunLevelAnimList,isDisplay,false,false)
end

function PlayerPanel:IsShowGunParticleEffect(isDisplay)
	CommonHelper.SetActive(self.GunParticleEffect,false)
	CommonHelper.SetActive(self.GunParticleEffect,true)
end


function PlayerPanel:HideGunPanel()
	for i=1,#self.GunLevelAnimList do
	    self.GunLevelAnimList[i].gameObject:SetActive(false)
	end
end

function PlayerPanel:IsShowImHere(isDisplay)
	CommonHelper.SetActive(self.ImHere,isDisplay)
	if self.ImHereTimer == nil then
		self.ImHereTimer = TimerManager.GetInstance():CreateTimerInstance(3,self.HideImHere,self)
	end
end

function PlayerPanel:HideImHere(  )
	if self.ImHereTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.ImHereTimer)
	end
	self.ImHereTimer = nil
	CommonHelper.SetActive(self.ImHere,false)	
end
