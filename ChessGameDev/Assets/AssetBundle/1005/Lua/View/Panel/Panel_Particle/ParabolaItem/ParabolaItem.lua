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
	self.currentTime=0
	self.startPos=CSScript.Vector3.zero
	self.endPos=CSScript.Vector3.zero
	self.flySpeed=CSScript.Vector3.zero
	self.isFly=false
end


function ParabolaItem:InitView()
	
end


function ParabolaItem:SetParabola(startPos,endPos,totalTime,callbackFunc)
	self.startPos=startPos
	self.endPos=endPos
	self.totalTime=totalTime
	self.callBackFunc=callbackFunc
	self.currentTime=0
	self.gameObject.transform.position=startPos
	self.isFly=true
end



function ParabolaItem:Update()
	if self.isFly then
		--[[self.currentTime=self.currentTime+CSScript.Time.deltaTime
		self.gameObject.transform.position=self.gameObject.transform.position+(self.flySpeed+self.gravity)*CSScript.Time.deltaTime
		if self.currentTime>self.totalTime then
			self.isFly=false
			self.currentTime=0
			self:Destroy()
		end--]]
	end
end


function ParabolaItem:__delete()
	CommonHelper.RemoveUpdate(self.UpdateNum)
	self.gameObject=nil
end
