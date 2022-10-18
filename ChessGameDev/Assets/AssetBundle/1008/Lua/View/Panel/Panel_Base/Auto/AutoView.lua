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
	self:FindAutoBtnView(tf)
end


function AutoView:FindAutoView(tf)
	self.AutoPanel=tf:Find("Down/Auto").gameObject
	self.BoxColliderPanel=tf:Find("Down/Auto/Mount/bg/BoxImage"):GetComponent(typeof(self.Button))
	self.AutoAnim=tf:Find("Down/Auto/Mount"):GetComponent(typeof(self.Animation))
end

function AutoView:FindAutoBtnView(tf)
	for i=1,4 do
		local tempBtn=tf:Find("Down/Auto/Mount/Set/Auto"..i):GetComponent(typeof(self.Button))
		table.insert(self.AutoBtnList,tempBtn)
		local textCount=tf:Find("Down/Auto/Mount/Set/Auto"..i.."/Text"):GetComponent(typeof(self.Text))
		if i==4 then
			textCount.text=self.maxLabel
		else
			textCount.text=self.AutoLevel[i]
		end
	end
end


function AutoView:InitViewData()
	
end


function AutoView:AddEventListenner()
	self.BoxColliderPanel.onClick:AddListener(function () self:OnclickCloseAuto() end)
	self.AutoBtnList[1].onClick:AddListener(function () self:OnclickFristAtuo() end)
	self.AutoBtnList[2].onClick:AddListener(function () self:OnclickSecondAtuo() end)
	self.AutoBtnList[3].onClick:AddListener(function () self:OnclickThirdAtuo() end)
	self.AutoBtnList[4].onClick:AddListener(function () self:OnclickMaxAtuo() end)
	
end


function AutoView:OnclickCloseAuto()
	self:PlayAutoAnim(2)
	AudioManager.GetInstance():PlayNormalAudio(2)
end


function AutoView:OnclickFristAtuo()
	self:PlayAutoAnim(2)
	self:SetAutoProcess(self.AutoLevel[1])
	BaseFctManager.GetInstance().PlayerStartView:IsShowAutoTextPanel(true)
	AudioManager.GetInstance():PlayNormalAudio(2)
end

function AutoView:OnclickSecondAtuo()
	self:PlayAutoAnim(2)
	self:SetAutoProcess(self.AutoLevel[2])
	BaseFctManager.GetInstance().PlayerStartView:IsShowAutoTextPanel(true)
	AudioManager.GetInstance():PlayNormalAudio(2)
end

function AutoView:OnclickThirdAtuo()
	self:PlayAutoAnim(2)
	self:SetAutoProcess(self.AutoLevel[3])
	BaseFctManager.GetInstance().PlayerStartView:IsShowAutoTextPanel(true)
	AudioManager.GetInstance():PlayNormalAudio(2)
end

function AutoView:OnclickMaxAtuo()
	self:PlayAutoAnim(2)
	self:SetAutoProcess(self.AutoLevel[4])
	BaseFctManager.GetInstance().PlayerStartView:IsShowAutoTextPanel(true)
	AudioManager.GetInstance():PlayNormalAudio(2)
end


function AutoView:PlayAutoAnim(index)
	self.AutoAnim:Play(self.AutoAnimNameList[index])
end



function AutoView:SetAutoProcess(count)
	self:SetAutoCount(count)
	self:AutoStartGame()
end


function AutoView:SetAutoCountTips(count)
	if count>1000 then count=self.maxLabel end
	BaseFctManager.GetInstance().PlayerStartView:SetAutoCount(count)
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
	BaseFctManager.GetInstance().PlayerStartView:IsShowAutoTextPanel(false)
	self.gameData.IsAutoState=false
	self.gameData.AutoCount=0
end



function AutoView:AutoStartGame()
	if self.gameData.MainStation==StateManager.MainState.FreeGame then
		
	else
		self:SetAutoCountTips(self.gameData.AutoCount)
		self:SetReaminAutoCount()
	end
	
	GameLogicManager.GetInstance():StartGameIconRun()
end
