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
	self.g=-10
	self.SpeedRatio=2
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
	--print(self.totalTime)
	self.flySpeed=CSScript.Vector3((self.endPos.x-self.startPos.x)/self.totalTime,(self.endPos.y-self.startPos.y)/self.totalTime-0.5*self.g*self.totalTime,(self.endPos.z-self.startPos.z)/self.totalTime )
	self.currentTime=0
	self.gameObject.transform.position=startPos
	self.isFly=true
end



function ParabolaItem:Update()
	if self.isFly then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		self.gravity.y=self.currentTime*self.g
		self.gameObject.transform.position=self.gameObject.transform.position+(self.flySpeed+self.gravity)*CSScript.Time.deltaTime
		if self.currentTime>self.totalTime then
			self.isFly=false
			self.currentTime=0
			self:Destroy()
		end
	end
end


function ParabolaItem:__delete()
	CommonHelper.RemoveUpdate(self.UpdateNum)
	self.gameObject=nil
end
