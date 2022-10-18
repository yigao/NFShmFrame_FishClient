FishBase=Class()

function FishBase:ctor()
	
	self:BaseInit()

end

function FishBase:BaseInit ()
	self:BaseInitData()
end

function FishBase:BaseInitData()
	self:InitBaseData()
	self:InitFishVo()
end


function FishBase:InitBaseData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self._tag="Fish"
	self.LuaBehaviour=nil		
	self.transform=nil
	self.gameObject=nil
	self.animator = nil
	self.endPos=CSScript.Vector3.zero
	self.beginPos=CSScript.Vector3.zero
	self.isCanSeen=false
    self.fishMoveStatus=CS.FishLuaBehaviour.Born
	self.isCanDestroy=false
	self.isDie=false
	self.beHitTimer = nil
	self.playerIns = nil
	self.chairdID = nil
	self.dieMoveToTargetPos = nil
	self.hitFishMsg = nil
	self.hitFlyDirection = CSScript.Vector3.zero	
	self.beHitColor = CS.UnityEngine.Color(0.76,0.28,0.28,1)
	self.NormalColor = CS.UnityEngine.Color(1,1,1,1)

	self.Tween = CS.DG.Tweening.Tween
	self.Sequence = CS.DG.Tweening.Sequence
	self.Ease = CS.DG.Tweening.Ease
	self.RotateMode = CS.DG.Tweening.RotateMode
	self.DOTween = CS.DG.Tweening.DOTween
	self.Random = CS.UnityEngine.Random

	self.TweenExtensions = CS.DG.Tweening.TweenExtensions
	
	self.isHit=false
	self.currentHitTime=0
	self.hitTotalTime=0.15
	
	self.isShowingTipsContent=false

end

function FishBase:InitFishVo()
	self.FishVo={}		
	self.FishVo.FishId=0
	self.FishVo.UID=0
	self.FishVo.FishKindGroup={}
	self.FishVo.TraceId=0
	self.FishVo.StartPointIndex=0
	self.FishVo.OffsetIndex=0
	self.FishVo.byChairId=nil			--玩家位置
	self.FishVo.FishConfig=0
	self.FishVo.DelayBornTime = 0
	self.FishVo.DieEffectConfig = 0
end


function FishBase:UpdateFishVo(vo)
	self.FishVo=vo
end

function FishBase:UpdateDieEffectConfig(dieEffectcConfig)
	self.FishVo.DieEffectConfig  = dieEffectcConfig
end

function FishBase:BuildFishBase(vo,obj)
	self.gameObject=obj
	self.currentTransform=obj.transform
	self.FishVo=vo
	self.gameObject.tag=self._tag
	self.endPos=CSScript.Vector3.zero
	self.beginPos=CSScript.Vector3.zero
	self.localPosition=self.gameObject.transform.localPosition
	self.position=self.gameObject.transform.position
	self.eulerAngles=CSScript.Vector3.zero
	CommonHelper.SetActive(self.gameObject,true)

end


function FishBase:AddLuaBehaviourScript()
	self.LuaBehaviour=self.gameObject:GetComponent(typeof(CS.FishLuaBehaviour))
	if not self.LuaBehaviour then
		self.LuaBehaviour=self.gameObject:AddComponent(typeof(CS.FishLuaBehaviour))
		self.LuaBehaviour.m_luaTable=self
		self.LuaBehaviour.onPressCallBack=function(press) self:OnPressCallBack(press) end
	end
	self.colliders = self.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.BoxCollider))
	
end

function FishBase:OnPressCallBack(press)
	local tempPlayerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(self.gameData.PlayerChairId)
	if tempPlayerIns then
		tempPlayerIns:OnClickSetLockFish(press,self)
		tempPlayerIns:OnClickSendShootBullet(press)
	else
		Debug.LogError("获取玩家失败==>"..self.gameData.PlayerChairId)
	end
end


function FishBase:InitBaseFish(vo,obj)
	self:BuildFishBase(vo,obj)
	self:AddLuaBehaviourScript()
	self:SetFishChildTag()
	self:IsEnableBoxcollider(true)
end


function FishBase:ResetBaseFishStateData(vo)
	self:UpdateFishVo(vo)
	self:IsEnableBoxcollider(true)
	self.isCanDestroy=false
	
end


function FishBase:BeginMove()
	self.isCanSeen=false
	local fishWidth = 0
	local fishHeight = 0
	if self.collider then 
		local size = self.collider.size
		fishWidth =  size.x * 0.5 + 8
		fishHeight = size.y * 0.5 + 8
	end
	local curPointIndex = self.FishVo.StartPointIndex + self.FishVo.OffsetIndex
	self.LuaBehaviour:FishBeginMove(self.FishVo.TraceId,self.FishVo.OffsetPosX,self.FishVo.OffsetPoxY,fishWidth,fishHeight,curPointIndex,self.FishVo.DelayBornTime)
	self.fishMoveStatus = self.LuaBehaviour.curFishStatus
end


function FishBase:SetFishParent(parent)
	self.gameObject.transform:SetParent(parent)
	CSScript.FishManager.SetLocalEulerAngles(self.gameObject.transform,0,0,0)
	CSScript.FishManager.SetLocalPosition(self.gameObject.transform,0,0,0)
	CSScript.FishManager.SetLocalScale(self.gameObject.transform,1,1,1)
end


function FishBase:IsEnableBoxcollider(isEnable)
	if self.colliders then
		for i=0,self.colliders.Length-1 do
			self.colliders[i].enabled=isEnable
		end
	end
end

function FishBase:SetFishChildTag( )
	if self.colliders then
		for i=0,self.colliders.Length-1 do
			self.colliders[i].gameObject.tag=self._tag
		end
	end
end

function FishBase:GetPosition()
	return self.gameObject.transform.position
end
function FishBase:GetLocalPosition()
    return self.gameObject.transform.localPosition
end

function FishBase:GetIsDie()
	return self.isDie
end

function FishBase:SetIsDie(isDie)
	self.isDie=isDie
end

function FishBase:CheckBoundValid()
	return self.isCanSeen
end


function FishBase:GetFishMoveStatus(  )
	return self.fishMoveStatus
end

function FishBase:SetFishMoveStatus(status)
	self.fishMoveStatus=status
	self.LuaBehaviour.curFishStatus = status
end


function FishBase:GetIsDestoty()
	return self.isCanDestroy
end

function FishBase:SetDestory(isDestory)
	self.isCanDestroy=isDestory
end


function FishBase:FishBaseDie()
	self:SetFishMoveStatus(CS.FishLuaBehaviour.FishStatus.Stop)
	self:SetIsDie(true)
	
end

function FishBase:ShowCoinEffect(mTrans)
	local parentFishID=self.hitFishMsg.bombUID
	local coinEffectId=self.FishVo.DieEffectConfig.coinEffectId
	local fishConfigData = self.FishVo.FishConfig
	if coinEffectId and fishConfigData.coinEffectCount then	
		local endPos=self.playerIns:GetFlyCoinPos()
		GoldEffectManager.GetInstance():SetCoinEffectShowMode(mTrans,self.playerIns.ChairdID,self.FishVo.UID,coinEffectId,fishConfigData.coinEffectCount,endPos,self.FishVo.DieEffectConfig.fishDieBehavior)
		self:PlayCoinAudio()
	end
end

function FishBase:PlayCoinAudio()
	if (self.FishVo.DieEffectConfig.fishDieBehavior == 1) or (self.playerIns.ChairdID == self.gameData.PlayerChairId) then
		if self.FishVo.FishId <=14 then
			AudioManager.GetInstance():PlayNormalAudio(35)
		elseif self.FishVo.FishId >14 and self.FishVo.FishId <= 25 then
			AudioManager.GetInstance():PlayNormalAudio(36)
		else
			AudioManager.GetInstance():PlayNormalAudio(37)
		end
	end
end

function FishBase:ShowWinScoreEffect(beginPos)
	local scoreM=ScoreEffectManager.GetInstance()
	if self.FishVo.DieEffectConfig.winScoreID then
	local tempConfig=scoreM:GetScoreEffectConfig(self.FishVo.DieEffectConfig.winScoreID)
		if tempConfig then
			local parentFishID=self.hitFishMsg.bombUID
			local scoreType=tempConfig.scoreType
			if parentFishID and parentFishID==0 then
				if scoreType==scoreM.ScoreType.AllShow then
					scoreM:SetScoreEffectShowMode(beginPos,self.playerIns.ChairdID,self.hitFishMsg.mainScore,self.FishVo.DieEffectConfig.winScoreID,self.FishVo.DieEffectConfig.fishDieBehavior)
				elseif scoreType==scoreM.ScoreType.OnlyShow then
					scoreM:SetScoreEffectShowMode(beginPos,self.playerIns.ChairdID,self.hitFishMsg.totalScore,self.FishVo.DieEffectConfig.winScoreID,self.FishVo.DieEffectConfig.fishDieBehavior)
				end	
			else
				if scoreType==scoreM.ScoreType.AllShow then
					scoreM:SetScoreEffectShowMode(beginPos,self.playerIns.ChairdID,self.hitFishMsg.mainScore,self.FishVo.DieEffectConfig.winScoreID,self.FishVo.DieEffectConfig.fishDieBehavior)
				end
			end
		end
	end
end


function FishBase:SetTipsContentState(isShow)
	self.isShowingTipsContent=isShow
end

function FishBase:GetTipsContentState()
	return self.isShowingTipsContent
end


function FishBase:SetTipsContentInfo()
	local isTC=self.FishVo.FishConfig.isTipsContent
	if isTC and tonumber(isTC)==1 then
		if self:GetTipsContentState()==false then
			local probability=math.random(1,100)/100
			if probability<=self.FishVo.FishConfig.TCProbability then
				TipsContentManager.GetInstance():SetShowTipsContent(self)
			end
			
		end
	end
end


function FishBase:__delete()
	self:IsEnableBoxcollider(false)
	self.isDie=false
	self.fishMoveStatus=CS.FishLuaBehaviour.FishStatus.Stop
	self.isCanDestroy=false
	self.isCanSeen=false
	self.LuaBehaviour.curFishStatus = CS.FishLuaBehaviour.FishStatus.Stop
	self.gameObject.transform.localScale = CSScript.Vector3(1,1,1)
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end







