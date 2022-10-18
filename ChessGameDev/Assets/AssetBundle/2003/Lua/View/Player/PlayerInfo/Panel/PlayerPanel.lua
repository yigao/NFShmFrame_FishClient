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
	self.GunLevelCount=4
	self.BigAwardPosCount = 3
	self.BigAwardPosList = {}
	self.GunLevelAnimList={}
	self.GunList={}
	self.GunLevelFireEffectList={}
	self.ImHereAnimatonName = "ImHere"
	self.GunAnimPramsList={"Cannon_Unfold","Cannon_Fire","Cannon_Idle"}
end



function PlayerPanel:InitView(gameObj)
	self:FindView(gameObj)
end



function PlayerPanel:FindView(gameObj)
	local tf=gameObj.transform
	self:FindGunView(tf)
	self:FindEffectView(tf)
	self:FindLockFishView(tf)
	self:FindPlayerInfoView(tf)
	self:FindPlayerPlayerAwardTipsView(tf)
	
end



function PlayerPanel:InitViewData()
	self:InitLockPoint()
	self:SetShowPanel(false)
	self:IsShowHeiDongPanel(false)
end

function PlayerPanel:SetShowPanel(isDisplay)
	self:IsShowLockTipsPanel(isDisplay)
	self:IsShowLockPointPanel(isDisplay)
	self:IsShowLockFishPanel(isDisplay)
	self:IsShowChangeFishBtnPanel(isDisplay)
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
	self.CannonTeamObj=mTF:Find("Gun_Team/CannonTeam").gameObject
	for i=1,self.GunLevelCount do
		local tempGunAnim=mTF:Find("Gun_Team/CannonTeam/GunType0"..i.."/Cannon0"..i.."/Rotate_Center/FireAnimRoot"):GetComponent(typeof(Animation))
		table.insert(self.GunLevelAnimList,tempGunAnim)
		tempGun=mTF:Find("Gun_Team/CannonTeam/GunType0"..i).gameObject
		table.insert(self.GunList,tempGun)
	end
end


function PlayerPanel:FindEffectView(mTF)
	self.HeiDongCanonObj=mTF:Find("Gun_Team/GunEffectList/BlackHole_Cannon").gameObject
	
end


function PlayerPanel:FindLockFishView(mTF)
	self.LockTips=mTF:Find("LockFishPanel/LockTips").gameObject
	self.LockTipsAnim=self.LockTips:GetComponent(typeof(Animation))
	self.LockPoint=mTF:Find("LockFishPanel/LockPoint").gameObject
	self.LockFish=mTF:Find("LockFishPanel/LockFish").gameObject
	self.LockFishPos=mTF:Find("LockFishPanel/LockFish/FishPoint").gameObject
	self.ChangeLockFishBtn=mTF:Find("LockFishPanel/LockFish/Button"):GetComponent(typeof(Button))
end


function PlayerPanel:FindPlayerInfoView(mTF)
	self.BetPanel=mTF:Find("BetPanel").gameObject
	self.AddBetBtn=mTF:Find("BetPanel/Add"):GetComponent(typeof(Button))
	self.ReduceBetBtn=mTF:Find("BetPanel/Reduce"):GetComponent(typeof(Button))
	self.EffectFlyCoin = mTF:Find("PlayerInfoPanel/ScoreImage/EffectFlyCoin").gameObject
	self.FlyScorePos=mTF:Find("PlayerInfoPanel/ScoreImage/ScorePoint")
	self.FlyCoinPos=mTF:Find("PlayerInfoPanel/ScoreImage/CoinPos")
	self.BetScoreLabel=mTF:Find("PlayerInfoPanel/BetImage/Text"):GetComponent(typeof(Text))
	self.PlayerMoneyLabel=mTF:Find("PlayerInfoPanel/ScoreImage/Text"):GetComponent(typeof(Text))
	self.PlayerNameLabel=mTF:Find("PlayerInfoPanel/Name"):GetComponent(typeof(Text))
end

function PlayerPanel:FindPlayerPlayerAwardTipsView(mTF)
	self.BigAwardTipsPos=mTF:Find("BigAwardTipsPos")
	for i = 1,self.BigAwardPosCount do
		local  tempBigAwardPos = self.BigAwardTipsPos:Find("Pos"..i)
		table.insert(self.BigAwardPosList,tempBigAwardPos)
	end
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


function PlayerPanel:IsShowBetPanel(isDisplay)
	CommonHelper.SetActive(self.BetPanel,isDisplay)
end


function PlayerPanel:IsShowGunLockPoint(isDisplay)
	CommonHelper.SetActive(self.GunLockPoint,isDisplay)
end


function PlayerPanel:IsShowLockFishPanel(isDisplay)
	CommonHelper.SetActive(self.LockFish,isDisplay)
end


function PlayerPanel:IsShowLockPointPanel(isDisplay)
	CommonHelper.SetActive(self.LockPoint,isDisplay)
end


function PlayerPanel:IsShowChangeFishBtnPanel(isDisplay)
	CommonHelper.SetActive(self.ChangeLockFishBtn.gameObject,isDisplay)
end


function PlayerPanel:IsShowLockTipsPanel(isDisplay)
	CommonHelper.SetActive(self.LockTips,isDisplay)
end

function PlayerPanel:SetLockTipsPos(targetPos)
	self.LockTips.transform.position=targetPos
end

function PlayerPanel:PlayLockTipsAnim()
	self.LockTipsAnim:Play()
end


function PlayerPanel:IsShowGun(index,isDisplay)
	CommonHelper.IsShowPanel(index,self.GunList,isDisplay,true,false)
end



function PlayerPanel:PlayGunShotAnim(index)
	local animName=self.GunAnimPramsList[2]
	if animName then
		local isPlayChangGunAnim=CommonHelper.IsPlayingFromAnimationName(self.GunLevelAnimList[index],self.GunAnimPramsList[1])
		if isPlayChangGunAnim then return end
		self.GunLevelAnimList[index]:Stop()
		self.GunLevelAnimList[index]:Play(animName)
	end
end

function PlayerPanel:SetShowGunPanel(index,isDisplay)
	self:IsShowGun(index,isDisplay)
	CommonHelper.IsShowPanel(index,self.GunLevelAnimList,isDisplay,false,false)
end


function PlayerPanel:IsShowGunParticleEffect(isDisplay)
	CommonHelper.SetActive(self.GunParticleEffect,false)
	CommonHelper.SetActive(self.GunParticleEffect,true)
end

function PlayerPanel:IsShowFlyCoinParticleEffect(isDisplay)
	CommonHelper.SetActive(self.EffectFlyCoin,false)
	CommonHelper.SetActive(self.EffectFlyCoin,true)
end

function PlayerPanel:IsShowImHere(isDisplay)
	CommonHelper.SetActive(self.ImHere,isDisplay)
	self.ImHereAnimator:Play(self.ImHereAnimatonName,0,0)
end



function PlayerPanel:IsShowCannonTeamPanel(isDisplay)
	CommonHelper.SetActive(self.CannonTeamObj,isDisplay)
end


function PlayerPanel:IsShowHeiDongPanel(isDisplay)
	CommonHelper.SetActive(self.HeiDongCanonObj,isDisplay)
end