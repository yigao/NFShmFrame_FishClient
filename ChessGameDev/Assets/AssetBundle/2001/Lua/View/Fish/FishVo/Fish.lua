Fish=Class(FishBase)

function Fish:ctor()
	self:Init()
end

function Fish:Init ()
	self:InitData()
end


function Fish:InitData()
	self.AnimParams={"Fish_Move","Fish_Die"}
	self.isRedFish=false
end


function Fish:BuildFish(vo,obj)
	self:InitBaseFish(vo,obj)
	self:FindView()
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function Fish:ResetFishState(vo)
	self:ResetBaseFishStateData(vo)
	self:IsEnableRenderer(true)
	self:IsEnableAnimator(true)
	self:PlayAnim(1)
end


function Fish:FindView()
	local mTransfrom=self.gameObject.transform
	self:FindMainFishRenderView(mTransfrom)
	self:FindSpecialFishRenderView(mTransfrom)
	self.animator=self.gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
	
end


function Fish:FindMainFishRenderView(tf)
	local tempObj=tf:Find("Bone/Fish")
	if tempObj then
		self.MainFishSpriteRender=tempObj:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
	end
	
end


function Fish:FindSpecialFishRenderView(tf)
	
end


function Fish:InitViewData()
	self:PlayAnim(1)
	
end






function Fish:PlayAnim(index)
	if self.animator then
		local animP=self.AnimParams[index]
		self.animator:Play(animP)
	end
	
end


function Fish:IsEnableAnimator(isEnabled)
	if self.animator then
		self.animator.enabled=isEnabled
	end
end


function Fish:SetMainFishOrder(orderIndex)
	if self.MainFishSpriteRender then
		self.MainFishSpriteRender.sortingOrder=orderIndex
	end
end


function Fish:SetRedFishColor()
	self.isRedFish=true
	self:SetMainFishColor(CS.UnityEngine.Color(1,0,0,1))
end


function Fish:SetBeHitColor()
	if(self.isHit==false and self.isRedFish==false) then
		self:SetMainFishColor(self.beHitColor)
		self.isHit=true
	end
	
end

function Fish:IsEnableRenderer(isEnabled)
	if self.MainFishSpriteRender then
		self.MainFishSpriteRender.enabled=isEnabled
	end
end



function Fish:ResetNormalColor( ... )
	self:SetMainFishColor(self.NormalColor)
	self.isHit=false
	self.currentHitTime=0
	self.isRedFish=false
end

function Fish:SetMainFishColor(color)
	self.MainFishSpriteRender.color = color
end


function Fish:FishNormalDie()
	self:FishBaseDie()
	self:ResetNormalColor()
	self:PlayAnim(2)
	self:SetMainFishOrder(self.FishVo.FishConfig.fishDieLayer)
	self.gameObject.transform.localScale = CSScript.Vector3(self.FishVo.FishConfig.dieScaleX,self.FishVo.FishConfig.dieScaleY,self.FishVo.FishConfig.dieScaleZ)
	self.delayDestoryFishTimer=TimerManager.GetInstance():CreateTimerInstance(self.FishVo.FishConfig.fishDieTime,self.DelayDestoryDieFish,self)
	
end


function Fish:DelayDestoryDieFish()
	self:SetDestory(true)
	self.gameObject.transform.localScale = CSScript.Vector3(1,1,1)
	TimerManager.GetInstance():RecycleTimerIns(self.delayDestoryFishTimer)
end


function Fish:UpdateHit()
	if self.isHit then
		self.currentHitTime=self.currentHitTime+CSScript.Time.deltaTime
		if self.currentHitTime>=self.hitTotalTime then
			self:ResetNormalColor()	
		end
	end
end


function Fish:Update()
	self:UpdateHit()
end




function Fish:__delete()
	self:ResetNormalColor()
	self:IsEnableRenderer(false)
	self:IsEnableAnimator(false)
end