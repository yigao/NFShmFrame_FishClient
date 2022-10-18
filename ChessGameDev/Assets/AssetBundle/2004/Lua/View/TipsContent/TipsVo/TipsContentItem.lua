TipsContentItem=Class()

function TipsContentItem:ctor(gameobj)
	self.gameObject=gameobj
	self:Init()
	CommonHelper.AddUpdate(self)
end


function TipsContentItem:Init()
	self:InitData()
	self:FindView()
	self:InitViewData()
end


function TipsContentItem:InitData()
	self.Text=GameManager.GetInstance().Text
	self.UID=0
	self.targetObjIns=nil
	self.isShowTips=false
	self.showTime=5
	self.currentTime=0
	self.isCanDestroy=false
end


function TipsContentItem:FindView()
	self.tF=self.gameObject.transform
	self.bg_gameObject = self.tF:Find("bg").gameObject
	self.tipsText=self.tF:Find("bg/Text"):GetComponent(typeof(self.Text))
	
end

function TipsContentItem:InitViewData()
	
end


function TipsContentItem:ResetState(tempIns,uID)
	self.targetObjIns=tempIns
	self.showTime=tempIns.FishVo.FishConfig.tCShowTime
	self:SetUID(uID)
	self.isShowTips=true
	self:SetCurrentPos()
	self:SetShowText(tempIns.FishVo.FishConfig.TipsContentInfo)
	self:IsShowText(true)
	self.currentTime=0
	self.isCanDestroy=false
	self:SetTargetObjInsTipsContentState(true)
end


function TipsContentItem:SetShowText(content)
	if self.tipsText then
		self.tipsText.text=content
	end
end


function TipsContentItem:IsShowText(isShow)
	CommonHelper.SetActive(self.bg_gameObject,isShow)
	CommonHelper.SetActive(self.tipsText.gameObject,isShow)
end


function TipsContentItem:SetUID(uid)
	self.UID=uid
end


function TipsContentItem:SetCurrentPos()
	if self.targetObjIns then
		self.tF.localPosition=self.targetObjIns.currentTransform.localPosition
	end
end



function TipsContentItem:SetTargetObjInsTipsContentState(isShow)
	if self.targetObjIns then
		self.targetObjIns:SetTipsContentState(isShow)
	end
end



function TipsContentItem:Update()
	if self.isShowTips then
		self:SetCurrentPos()
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if (self.currentTime>=self.showTime) or (self.targetObjIns:GetIsDie() == true) then
			self.isShowTips=false
			self.currentTime=0
			self.isCanDestroy=true
			
		end
	end
end

function TipsContentItem:__delete()
	self:SetTargetObjInsTipsContentState(false)
	self.targetObjIns=nil
	self.isShowTips=false
	self:IsShowText(false)
	self.isCanDestroy=false
end