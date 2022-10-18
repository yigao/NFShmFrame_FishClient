BlackHoleFishType=Class(BombBaseFish)

function BlackHoleFishType:ctor()
	self:Init()
	
end


function BlackHoleFishType:Init ()
	self:InitData()
	self:InitView()

end


function BlackHoleFishType:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.IsRotation=false
	self.totalTime=10
	self.currentTime=0
	self.SubFishList={}
end


function BlackHoleFishType:InitView(gameObj)
	
	
end


function BlackHoleFishType:SetFishDieProcess(hitFishMsg,fishIns,playerIns)
	self.hitFishMsg=hitFishMsg
	self.fishIns=fishIns
	self.playerIns=playerIns
	
	fishIns:FishBaseDie()
	
	self:BaseShowFishSpecialEffect(fishIns,playerIns,hitFishMsg)

	if  hitFishMsg.subFishCount and hitFishMsg.subFishCount>0 then
		self:SubFishDieProcess(hitFishMsg.SubFishes,fishIns)
		
	else
		self:BaseFishDie(fishIns,hitFishMsg)
		
		self:BaseShowCoinEffect(fishIns,playerIns,hitFishMsg)
	
		self:BaseShowWinScoreEffect(fishIns,playerIns,hitFishMsg)
		
		self:BaseShowPlusTipsEffect(fishIns,playerIns,hitFishMsg)

		self:BaseShowBigAwardTipsEffect(fishIns,playerIns,hitFishMsg)

		self:Destroy()
	end
end

function BlackHoleFishType:SubFishDieProcess(subFishs,fishIns)
	if #subFishs>0 then
		self.SubFishList={}
		self.subFishMsg=subFishs
		for i=1,#subFishs do
			local tempSubFish=FishManager.GetInstance():GetUsingFishByFishUID(subFishs[i].mainFishUID)
			if tempSubFish then
				tempSubFish:FishBaseDie()
				table.insert(self.SubFishList,tempSubFish)
			end
		end
		
		if #self.SubFishList>0 then
			table.insert(self.SubFishList,fishIns)
			self.gameObject=fishIns.gameObject
			self.rotationPoint=self.gameObject.transform.position
			self.IsRotation=true
			self.currentTime=0
			self.UpdateNum=CommonHelper.AddUpdate(self)
		end
		
		
	end
end


function BlackHoleFishType:FinishCallBack()
	self:BaseFishDie(self.fishIns,self.hitFishMsg)
	
	self:BaseShakeOrVibrate(self.hitFishMsg,self.fishIns)
	
	self:BaseShowCoinEffect(self.fishIns,self.playerIns,self.hitFishMsg)

	self:BaseShowWinScoreEffect(self.fishIns,self.playerIns,self.hitFishMsg)
	
	self:BaseShowPlusTipsEffect(self.fishIns,self.playerIns,self.hitFishMsg)

	self:BaseShowBigAwardTipsEffect(self.fishIns,self.playerIns,self.hitFishMsg)
	
	self:SetSubFishDieProcess(self.subFishMsg)
	
	self:Destroy()
end

function BlackHoleFishType:SetSubFishDieProcess(subFishs)
	for i=1,#self.SubFishList do
		self.SubFishList[i]:FishNormalDie()
	end
end


function BlackHoleFishType:Update()
	if self.IsRotation and self.SubFishList then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime>=self.totalTime then
			self.IsRotation=false
			self:FinishCallBack()
			return
		end
		for i=1,#self.SubFishList do
			local tf=self.SubFishList[i].gameObject.transform
			if CSScript.Vector3.Distance(self.rotationPoint,tf.position)>0.3 then
				self.SubFishList[i].gameObject.transform.position=CSScript.Vector3.MoveTowards(tf.position,self.rotationPoint,0.3*CSScript.Time.deltaTime)
			end
			
			tf:RotateAround(self.rotationPoint,CSScript.Vector3.forward,100*CSScript.Time.deltaTime )
		end
	end
end



function BlackHoleFishType:__delete()
	self.IsRotation=false
	self.SubFishList=nil
	if self.UpdateNum then
		CommonHelper.RemoveUpdate(self.UpdateNum)
		self.UpdateNum=nil
	end
end