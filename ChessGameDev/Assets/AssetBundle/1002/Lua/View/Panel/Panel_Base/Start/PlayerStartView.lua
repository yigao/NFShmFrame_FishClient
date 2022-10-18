PlayerStartView=Class()

function PlayerStartView:ctor(gameObj)
	self:Init(gameObj)

end

function PlayerStartView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function PlayerStartView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	
end



function PlayerStartView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function PlayerStartView:FindView(tf)
	self:FindPlayerStartView(tf)
end


function PlayerStartView:FindPlayerStartView(tf)
	self.StartBtn=tf:Find("Down/Start/StartBtn"):GetComponent(typeof(self.Button))
	self.RecieveBtn=tf:Find("Down/RecieveScore/GetScore"):GetComponent(typeof(self.Button))
	self.StartBtnEffect=tf:Find("Down/Start/StartBtn/Effect").gameObject
	self.RecieveBtnEffect=tf:Find("Down/RecieveScore/GetScore/Effect").gameObject
end


function PlayerStartView:InitViewData()
	self:IsEnableRecieveButton(false)
	--self:IsShowStartEffect(false)
	self:IsShowRecieveEffect(false)
end


function PlayerStartView:AddEventListenner()
	self.StartBtn.onClick:AddListener(function () self:OnclickStart() end)
	self.RecieveBtn.onClick:AddListener(function () self:OnclickRecieve() end)
	
end


function PlayerStartView:OnclickStart()
	if StateManager.GetInstance():GetGameStateWaitResult() then
		Debug.LogError("状态等待中...无法点击开始游戏")
		return
	end
	
	if self.gameData.MainStation~=StateManager.MainState.Normal  then
		Debug.LogError("非Normal状态...无法点击开始游戏")
		return
	end
	
	AudioManager.GetInstance():PlayNormalAudio(17)
	GameLogicManager.GetInstance():StartGameIconRun()
	--self:IsEnableStartButton(false)
	
end



function PlayerStartView:OnclickRecieve()
	AudioManager.GetInstance():PlayNormalAudio(2)
	GameUIManager.GetInstance():RequestRecieveScoreMsg()

end




function PlayerStartView:IsEnableButton(button,isEnable)
	button.interactable=isEnable
end


function PlayerStartView:IsEnableStartButton(isEnable)
	self:IsEnableButton(self.StartBtn,isEnable)
end


function PlayerStartView:IsEnableRecieveButton(isEnable)
	self:IsEnableButton(self.RecieveBtn,isEnable)
end



function PlayerStartView:IsShowStartEffect(isShow)
	CommonHelper.SetActive(self.StartBtnEffect,isShow)
end


function PlayerStartView:IsShowRecieveEffect(isShow)
	CommonHelper.SetActive(self.RecieveBtnEffect,isShow)
end