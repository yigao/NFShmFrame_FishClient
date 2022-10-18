BulletBase=Class()

function BulletBase:ctor(gameObj)
	self.gameObject=gameObj
	self:BaseInit()
end


function BulletBase:BaseInit()
	self:BaseInitData()
	self:BaseInitBulletVo()
	self:BaseInitView()
	self:AddEnventLisenner()
end


function BulletBase:BaseInitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.bulletSpeed=1000
	self.isCanDestroy=false
    self.targetFish=nil
    self.player=nil
end


function BulletBase:BaseInitBulletVo()
	self.BulletVo={}
	self.BulletVo.ChairId=0
	self.BulletVo.BulletLevel=1
	self.BulletVo.BulletAngle=1
	self.BulletVo.BulletUID=0	
end

function BulletBase:BaseInitView()
	self:BaseFindView()
	self:BaseInitViewData()
end


function BulletBase:BaseFindView()
	local tf=self.gameObject.transform
	self.Animator=self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
	self.LuaBehaviour=self.gameObject:GetComponent(typeof(CS.FishLuaBehaviour))
	if self.LuaBehaviour==nil then
		self.LuaBehaviour=self.gameObject:AddComponent(typeof(CS.FishLuaBehaviour))
	end
	self.colliders = self.gameObject:GetComponent(typeof(CS.UnityEngine.BoxCollider))
end



function BulletBase:BaseInitViewData()
	self:IsEnabledCollider(true)
	self:IsEnabledAnimator(true)
	self:IsEnabledLuaBehaciour(true)
end



function BulletBase:UpdateBulletVo(bulletVo)
	self.BulletVo=bulletVo
end


function BulletBase:SetBulletTargetPlayer(playerIns)
	self.player=playerIns
end

function BulletBase:GetBulletTargerPlayer()
	return self.player
end


function BulletBase:GetBulletBelongPlayerUserID()
	local targetPlayer=self:GetBulletTargerPlayer()
	if targetPlayer then
		return targetPlayer:GetUserID()
	end
end


function BulletBase:GetBulletBelongPlayerID()
	local targetPlayer=self:GetBulletTargerPlayer()
	if targetPlayer then
		return targetPlayer:GetPlayerChairID()
	end
end


function BulletBase:IsEnabledLuaBehaciour(isEnabled)
	if self.LuaBehaviour then
		self:IsEnabled(self.LuaBehaviour,isEnabled)
	end
	
end

function BulletBase:IsEnabledAnimator(isEnabled)
	if self.Animator then
		self:IsEnabled(self.Animator,isEnabled)
	end
end


function BulletBase:IsEnabledCollider(isEnabled)
	if self.collider then
		self:IsEnabled(self.collider,isEnabled)
	end
end


function BulletBase:IsEnabled(beHaviour,isEnabled)
	beHaviour.enabled=isEnabled
end


function BulletBase:SetBulletKindAnim(bulletName)
	self:PlayBulletAnim(bulletName)
end


function BulletBase:PlayBulletAnim(bulletName)
	self.Animator:Play(bulletName)
end


function BulletBase:SetEulerAngles(euler)
	self.LuaBehaviour:SetEulerAngles(euler.x,euler.y,euler.z)
end

function BulletBase:SetPosition(x,y,z)
	self.LuaBehaviour:SetPosition(x,y,z)
end

function BulletBase:SetLocalPosition(x,y,z)
	self.gameObject.transform.localPosition=CSScript.Vector3(x,y,z)
end

function BulletBase:SetLocalScale(x,y,z)
	self.LuaBehaviour:SetLocalScale(x,y,z)
end


function BulletBase:BulletBeginMove(speed)
	self.LuaBehaviour:BulletBeginMove(speed)
end

function BulletBase:IsShowBullet(isdisplay)
	CommonHelper.SetActive(self.gameObject,isdisplay)
end


function BulletBase:SetTargetFish(targetFish)
	self.targetFish=targetFish
end

function BulletBase:SetTargetFishTransform(targetFishTrans)
	self.LuaBehaviour.m_targetTrans=targetFishTrans
end

function BulletBase:SetBulletLockTargetFish(lockFish)
	self:SetTargetFish(lockFish)
	if lockFish then
		if lockFish.FishVo.FishConfig.clientBuildFishType == BulletManager.GetInstance().gameData.GameConfig.FishType.Part then
			local lockFishTrans=lockFish:GetLockPartPoint().transform
			if lockFishTrans then
				self:SetTargetFishTransform(lockFishTrans)
			end
		elseif lockFish.FishVo.FishConfig.clientBuildFishType == BulletManager.GetInstance().gameData.GameConfig.FishType.Dragon then
			local lockFishTrans=lockFish:GetLockPartPoint().transform
			if lockFishTrans then
				self:SetTargetFishTransform(lockFishTrans)
			end
		else
			local lockFishTrans=lockFish.gameObject.transform
			if lockFishTrans then
				self:SetTargetFishTransform(lockFishTrans)
			end
		end
	else
		self:SetTargetFishTransform(nil)
	end
	
end





function BulletBase:__delete()
	self.isCanDestroy=false
	self:IsEnabledLuaBehaciour(false)
	self:IsEnabledAnimator(false)
	self:SetBulletLockTargetFish(nil)
	self.gameObject.transform.localPosition=CSScript.Vector3(math.random(2000,5000),5000,0)
	
end