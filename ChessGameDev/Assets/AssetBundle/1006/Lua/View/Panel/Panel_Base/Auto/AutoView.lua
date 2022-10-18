AutoView=Class()

function AutoView:ctor(gameObj)
	self:Init(gameObj)

end

function AutoView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function AutoView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Animation=GameManager.GetInstance().Animation
	self.AutoLevel={20,50,100,10000}
	self.maxLabel="∞"
	self.AutoBtnList={}
	self.AutoAnimNameList={"OpenAuto","CloseAuto"}
end



function AutoView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function AutoView:FindView(tf)
	self:FindAutoView(tf)
end


function AutoView:FindAutoView(tf)
	self.AutoBtn=tf:Find("Down/Auto/Button"):GetComponent(typeof(self.Button))
	self.AutoCanselBtn=tf:Find("Down/AutoCansel/Button"):GetComponent(typeof(self.Button))
end




function AutoView:InitViewData()
	self:IsShowAutoPanel(true)
	self:IsShowCanselAutoPanel(false)
end


function AutoView:IsShowAutoPanel(isShow)
	CommonHelper.SetActive(self.AutoBtn.gameObject,isShow)
end


function AutoView:IsShowCanselAutoPanel(isShow)
	CommonHelper.SetActive(self.AutoCanselBtn.gameObject,isShow)
end


function AutoView:AddEventListenner()
	self.AutoBtn.onClick:AddListener(function () self:OnclickAutoBtn() end)
	self.AutoCanselBtn.onClick:AddListener(function () self:OnclickAutoCanselBtn() end)
end


function AutoView:OnclickAutoBtn()
	if GameLogicManager.GetInstance():IsCanIconRunState()==false then  return end 
	self:SetAutoButtonState(false)
	self:OnclickMaxAtuo()
end


function AutoView:OnclickAutoCanselBtn()
	AudioManager.GetInstance():PlayNormalAudio(19)
	self:SetStopAutoState()
	self:SetAutoButtonState(true)
end


function AutoView:SetAutoButtonState(isShow)
	self:IsShowAutoPanel(isShow)
	self:IsShowCanselAutoPanel(not isShow)
end


function AutoView:OnclickMaxAtuo()
	self:SetAutoProcess(self.AutoLevel[4])
	AudioManager.GetInstance():PlayNormalAudio(19)
end



function AutoView:SetAutoProcess(count)
	self:SetAutoCount(count)
	self:AutoStartGame()
end


function AutoView:SetAutoCountTips(count)
	
end


function AutoView:SetAutoCount(count)
	self.gameData.AutoCount=count
	self.gameData.IsAutoState=true
end

function AutoView:GetAutoCount()
	return self.gameData.AutoCount
end


function AutoView:SetReaminAutoCount()
	self.gameData.AutoCount=self.gameData.AutoCount-1
	if self.gameData.AutoCount>1000 then
		
	elseif self.gameData.AutoCount>0 then
		
	elseif self.gameData.AutoCount==0 then
		self:SetStopAutoState()
	end
end

function AutoView:SetStopAutoState()
	self.gameData.IsAutoState=false
	self.gameData.AutoCount=0
end



function AutoView:AutoStartGame()
	if self.gameData.MainStation==StateManager.MainState.FreeGame then
		
	else
		self:SetReaminAutoCount()
	end
	
	GameLogicManager.GetInstance():StartGameIconRun()
end
