Bullet=Class(BulletBase)

function Bullet:ctor(gameobj)
	self.gameObject=gameobj
	self:Init()
	CommonHelper.AddUpdate(self)
end


function Bullet:Init()
	self:InitData()
	self:AddEnventLisenner()
end


function Bullet:InitData()
	self.FishTag="Fish"
	self.Left_Leg_Tag = "Left_Leg"
	self.Right_Leg_Tag = "Right_Leg"
end


function Bullet:AddEnventLisenner()
	self.LuaBehaviour.onTriggerCallBack=function(other) self:OnTriggerEnter(other) end
end


function Bullet:RemoveEventLisenner()
	self.LuaBehaviour.onTriggerCallBack=nil
end


function Bullet:DestoryBullet()
	self:IsEnabledCollider(false)
	self.isCanDestroy=true
	self.LuaBehaviour.curFishStatus= CS.FishLuaBehaviour.FishStatus.Stop
end


function Bullet:SendPlayerHitFishMsg(FishUID,isSendRobotChairId)
	local sendMsg={}
	sendMsg.fishId=FishUID
	sendMsg.bulletid=self.BulletVo.BulletUID
	if isSendRobotChairId then
		sendMsg.usRobotChairId=self.BulletVo.ChairId
	else
		sendMsg.usRobotChairId=-1
	end
	FishManager.GetInstance():RequestPlayerHitFishMsg(sendMsg)
end

function Bullet:SendPlayerHitFishProcess(FishUID)
	--判断子弹是否是玩家自己的
	local tempPlayerID=self:GetBulletBelongPlayerID()
	if tempPlayerID then
		-- 是否对机器人进行上传数据
		if self.BulletVo.usProcUserChairId~=-1 and  self.BulletVo.usProcUserChairId==BulletManager.GetInstance().gameData.PlayerChairId then
			self:SendPlayerHitFishMsg(FishUID,true)
		else
			if tempPlayerID~=BulletManager.GetInstance().gameData.PlayerChairId then
				return
			end
			self:SendPlayerHitFishMsg(FishUID,false)
		end
	end
end

function Bullet:CreateNet(targetNetPos)
	self:GetBulletTargerPlayer():CreateNet(targetNetPos)
end

function Bullet:OnTriggerEnter(other)
	if other.gameObject:CompareTag(self.FishTag) then
		local HitFish=other.transform.parent.parent:GetComponent(typeof(CS.FishLuaBehaviour)).m_luaTable
		if HitFish then
			if HitFish:GetIsDie() then
				return
			end
			
			if self.targetFish and HitFish~=self.targetFish then
				return		
			end

			--判断瞄准部位鱼的时候，只攻击瞄准的部位
			if self.targetFish and HitFish.FishVo.FishConfig.clientBuildFishType == BulletManager.GetInstance().gameData.GameConfig.FishType.Part then 
				if other.gameObject:CompareTag(HitFish:GetColliderObj().gameObject.tag) == false then
					return
				end
			end

			HitFish:SetHitFlyDirection(self.LuaBehaviour.m_direction)
			HitFish:SetBeHitColor()
			self:DestoryBullet()
			self:SendPlayerHitFishProcess(HitFish.FishVo.UID)
			self:CreateNet(self.gameObject.transform.localPosition)
			if self.gameData.PlayerChairId==self:GetBulletTargerPlayer().ChairdID then
				HitFish:SetTipsContentInfo()
			end
		end
	elseif other.gameObject:CompareTag(self.Left_Leg_Tag) or other.gameObject:CompareTag(self.Right_Leg_Tag) then
		local HitFish=other.transform.parent.parent:GetComponent(typeof(CS.FishLuaBehaviour)).m_luaTable
		if HitFish then
			if HitFish:GetIsDie() then
				return
			end
			
			if self.targetFish and HitFish~=self.targetFish then
				return		
			end

			--判断瞄准部位鱼的时候，只攻击瞄准的部位
			if self.targetFish and  HitFish.FishVo.FishConfig.clientBuildFishType == BulletManager.GetInstance().gameData.GameConfig.FishType.Part then 
				if other.gameObject:CompareTag(HitFish:GetColliderObj().gameObject.tag) == false then
					return
				end
			end

			HitFish:SetHitFlyDirection(self.LuaBehaviour.m_direction)
			HitFish:SetBeHitColor()
			self:DestoryBullet()
			local partID = 1
			if other.gameObject:CompareTag(self.Left_Leg_Tag) then
				partID = 1
			elseif  other.gameObject:CompareTag(self.Right_Leg_Tag) then
				partID = 2
			end
			self:SendPlayerHitFishPart(HitFish.FishVo.UID,partID)
			self:CreateNet(self.gameObject.transform.localPosition)
		end
	end
end


function Bullet:SendPlayerHitFishPart(FishUID,partID)
	local tempPlayerID=self:GetBulletBelongPlayerID()
	if tempPlayerID then
		if tempPlayerID~=BulletManager.GetInstance().gameData.PlayerChairId then
			return
		end
	end
	
	local sendMsg={}
	sendMsg.usBulletId=self.BulletVo.BulletUID
	sendMsg.usHaiWangCrabId=FishUID
	sendMsg.usPartId = partID
	FishManager.GetInstance():RequestPlayerHitFishPartMsg(sendMsg)
end

function Bullet:Update()
	if self.targetFish then 
		if self.targetFish.FishVo.FishConfig.clientBuildFishType == BulletManager.GetInstance().gameData.GameConfig.FishType.Part then
			if self.targetFish:GetIsDie() or self.targetFish:GetIsDestoty() or not self.targetFish:CheckBoundValid() then
				self:SetBulletLockTargetFish(nil)
			elseif self.LuaBehaviour.m_targetTrans then
				if self.targetFish:RemoveLockPart(self.LuaBehaviour.m_targetTrans) == true then
					self:SetTargetFishTransform(nil)
					self:SetTargetFish(nil)
				end
			end
		else
			if self.targetFish:GetIsDie() or self.targetFish:GetIsDestoty() or not self.targetFish:CheckBoundValid() then
				self:SetBulletLockTargetFish(nil)
			end
		end
	end
end


function Bullet:__delete()
	self.LuaBehaviour.curFishStatus= CS.FishLuaBehaviour.FishStatus.Stop
end