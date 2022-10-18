SpineFish=Class(FishBase)

function SpineFish:ctor()
	self:Init()

end

function SpineFish:Init ()
	self:InitData()
end


function SpineFish:InitData()
	self.AnimParams={"Fish_Move","Fish_Die"}
	
end


function SpineFish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:FindView()
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function SpineFish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:IsEnableAnimator(true)
	self:PlayAnim(1,true)
end



function SpineFish:FindView()
	local mTransfrom=self.gameObject.transform
	self.centerPoint = mTransfrom:Find("CenterPoint")
	self.SpineAnim=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.Spine.Unity.SkeletonAnimation))
	self.SpineMeshRenderer=mTransfrom:Find("Bone/Fish"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
end



function SpineFish:InitViewData()
	self:PlayAnim(1,true)
	
end


function SpineFish:PlayAnim(index,isLoop)
	if self.SpineAnim then
		local animName=self.AnimParams[index]
		if animName then
			self.SpineAnim.loop=isLoop
			self.SpineAnim.state:SetAnimation(0,animName,isLoop)
		end
	end
end


function SpineFish:IsEnableAnimator(isEnabled)
	if self.SpineAnim then
		self.SpineAnim.enabled=isEnabled
	end
end

function SpineFish:SetMainFishOrder(orderIndex)
	if self.SpineMeshRenderer then
		self.SpineMeshRenderer.sortingOrder=orderIndex
	end
end

function SpineFish:SetBeHitColor()
	if(self.isHit==false) then
		self:SetMainFishColor(self.beHitColor)
		self.isHit=true
	end
	
end

function SpineFish:ResetNormalColor( ... )
	self:SetMainFishColor(self.NormalColor)
	self.isHit=false
	self.currentHitTime=0
end

function SpineFish:SetMainFishColor(color)
	self.SpineAnim.skeleton.R = color.r
	self.SpineAnim.skeleton.G = color.g
	self.SpineAnim.skeleton.B = color.b
	self.SpineAnim.skeleton.A = color.a
end




function SpineFish:FishNormalDie()
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PlayAnim(2,false)
	self:SetMainFishOrder(self.FishVo.FishConfig.fishDieLayer)
	self.gameObject.transform.localScale = CSScript.Vector3(self.FishVo.FishConfig.dieScaleX,self.FishVo.FishConfig.dieScaleY,self.FishVo.FishConfig.dieScaleZ)
	self.delayDestoryFishTimer=TimerManager.GetInstance():CreateTimerInstance(self.FishVo.FishConfig.fishDieTime,self.DelayDestoryDieFish,self)
	
end


function SpineFish:DelayDestoryDieFish()
	self:SetDestory(true)
	self.gameObject.transform.localScale = CSScript.Vector3(1,1,1)
	TimerManager.GetInstance():RecycleTimerIns(self.delayDestoryFishTimer)
end


function SpineFish:UpdateHit()
	if self.isHit then
		self.currentHitTime=self.currentHitTime+CSScript.Time.deltaTime
		if self.currentHitTime>=self.hitTotalTime then
			self:ResetNormalColor()	
		end
	end
end


function SpineFish:Update()
	self:UpdateHit()
end


function SpineFish:__delete()
	self:ResetNormalColor()
	self:IsEnableAnimator(false)
end