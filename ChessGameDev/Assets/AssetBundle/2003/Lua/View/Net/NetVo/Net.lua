Net=Class()

function Net:ctor(gameobj)
	self.gameObject=gameobj
	self:Init()
	CommonHelper.AddUpdate(self)
end


function Net:Init()
	self:InitData()
	self:FindView()
	self:InitViewData()
end


function Net:InitData()
	self.IsPlayAnim=false
	self.currentUpdateTime=0
	self.NetIntervalTime=1.5
	self.NetVo={}
end


function Net:FindView()
	local tf=self.gameObject.transform
	self.Animator=tf:Find("Net/pay"):GetComponent(typeof(CS.UnityEngine.Animation))
	
end

function Net:InitViewData()
	self:ResetNetState()
	
end

function Net:ResetNetState(netVo)
	self.currentUpdateTime=0
	self.NetVo=netVo
	self:SetPlayAnimSatate(false)
end



function Net:PlayNetAudio()
	
end

function Net:SetNetPosition(transPos)
	self.gameObject.transform.localPosition=transPos
end

function Net:IsEnabledAnimator(isEnabled)
	if self.Animator then
		self.Animator.enabled=isEnabled
	end
end

function Net:SetPlayAnimSatate(isEnabled)
	self.IsPlayAnim=isEnabled
end

function Net:PlayNetAnimator()
	if self.Animator then
		self:IsEnabledAnimator(true)
		self.Animator:Play()
	end
end

function Net:UpdateAnimaState()
	if self.IsPlayAnim then
		self.currentUpdateTime=self.currentUpdateTime+CSScript.Time.deltaTime
		if self.currentUpdateTime>=self.NetIntervalTime then
			self.IsPlayAnim=false
			self.currentUpdateTime=0
			NetManager.GetInstance():AddNet(self)
		end
	end
end

function Net:Update()
	self:UpdateAnimaState()
end


function Net:__delete()
	self.IsPlayAnim=false
	self:IsEnabledAnimator(false)
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end