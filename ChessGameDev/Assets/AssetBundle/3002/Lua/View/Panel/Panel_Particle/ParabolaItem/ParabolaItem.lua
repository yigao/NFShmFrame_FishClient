ParabolaItem=Class()

function ParabolaItem:ctor(gameObj)
	self.gameObject=gameObj
	self:Init()
	self.UpdateNum=CommonHelper.AddUpdate(self)
end

function ParabolaItem:Init ()
	self:InitData()
	self:InitView()
end


function ParabolaItem:InitData()
	--self.IsUse=false
	self.totalTime=0
	self.g=-5
	self.SpeedRatio=3
	self.gravity=CSScript.Vector3.zero
	self.currentTime=0
	self.startPos=CSScript.Vector3.zero
	self.endPos=CSScript.Vector3.zero
	self.flySpeed=CSScript.Vector3.zero
	self.isFly=false
end


function ParabolaItem:InitView()
	
end


function ParabolaItem:SetParabola(startPos,endPos,callbackFunc)
	self.startPos=startPos
	self.endPos=endPos
	self.callBackFunc=callbackFunc
	self.distance=CSScript.Vector3.Distance(endPos,startPos)
	self.totalTime=self.distance/self.SpeedRatio
	if self.totalTime>0.6 then
		self.totalTime=0.6
	end
	self.flySpeed=CSScript.Vector3((self.endPos.x-self.startPos.x)/self.totalTime,(self.endPos.y-self.startPos.y)/self.totalTime-0.5*self.g*self.totalTime,(self.endPos.z-self.startPos.z)/self.totalTime )
	self.currentTime=0
	self.gameObject.transform.position=startPos
	self.isFly=true
	self.hideTime=1
end



function ParabolaItem:Update()
	if self.isFly then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		self.gravity.y=self.currentTime*self.g
		if self.currentTime>self.totalTime and self.currentTime<self.hideTime then
			self.gameObject.transform.position=self.endPos
		elseif self.currentTime>self.hideTime then
			self.isFly=false
			self.currentTime=0
			self:Destroy()
		else
			self.gameObject.transform.position=self.gameObject.transform.position+(self.flySpeed+self.gravity)*CSScript.Time.deltaTime
		end
	end
end


function ParabolaItem:__delete()
	CommonHelper.RemoveUpdate(self.UpdateNum)
	ParticleManager.GetInstance():RecycleEffect(self.gameObject)
	self.gameObject=nil
	self=nil
end
