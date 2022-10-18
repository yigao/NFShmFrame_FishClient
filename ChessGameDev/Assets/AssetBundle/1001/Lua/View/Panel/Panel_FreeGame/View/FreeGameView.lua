FreeGameView=Class()

function FreeGameView:ctor(gameObj)
	self:Init(gameObj)

end

function FreeGameView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function FreeGameView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Animation=GameManager.GetInstance().Animation
	self.EnterFreeGameAnimNameList={"EnterFree","EnterFreeEnd"}
end



function FreeGameView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function FreeGameView:FindView(tf)
	self:FindFreeGameView(tf)
end


function FreeGameView:FindFreeGameView(tf)
	self.EnterGamePanel=tf:Find("EnterFreeGame").gameObject
	self.EnterFreeGameAnim=tf:Find("EnterFreeGame/FreeGameTips/ImageBG"):GetComponent(typeof(self.Animation))
	self.FreeGameCount=tf:Find("EnterFreeGame/FreeGameTips/ImageBG/Text"):GetComponent(typeof(self.Text))
	self.QuitFreeGamePanel=tf:Find("EndFreeGame").gameObject
	self.FreeGameTotalCount=tf:Find("EndFreeGame/SettleAccountsPanel/RawImageBG/FreeGameCount"):GetComponent(typeof(self.Text))
	self.TotalWinScore=tf:Find("EndFreeGame/SettleAccountsPanel/RawImageBG/WinScore"):GetComponent(typeof(self.Text))
	self.QuitFreeGameButton=tf:Find("EndFreeGame/SettleAccountsPanel/ButtonClose"):GetComponent(typeof(self.Button))
end


function FreeGameView:InitViewData()
	self:IsShowEnterFreeGamePanel(false)
	self:IsShowQuitFreeGamePanel(false)
	self:SetEnterFreeGameCountTips(0)
	self:SetQuitFreeGameCountTips(0)
	self:SetFreeGameTotalWinScoreTips(0)
end


function FreeGameView:AddEventListenner()
	self.QuitFreeGameButton.onClick:AddListener(function () self:OnclickQuitFreeGame() end)
end


function FreeGameView:IsShowEnterFreeGamePanel(isShow)
	CommonHelper.SetActive(self.EnterGamePanel,isShow)
end

function FreeGameView:IsShowQuitFreeGamePanel(isShow)
	CommonHelper.SetActive(self.QuitFreeGamePanel,isShow)
end

function FreeGameView:SetEnterFreeGameCountTips(count)
	self.FreeGameCount.text=count
end

function FreeGameView:SetQuitFreeGameCountTips(count)
	self.FreeGameTotalCount.text=count
end

function FreeGameView:SetFreeGameTotalWinScoreTips(score)
	self.TotalWinScore.text=score
end


function FreeGameView:PlayEnterFreeGameAnim(animIndex)
	local currentAnim=self.EnterFreeGameAnimNameList[animIndex]
	self.EnterFreeGameAnim:Play(currentAnim)
end


function FreeGameView:OnclickQuitFreeGame()
	AudioManager.GetInstance():PlayNormalAudio(7)
	FreeGameManager.GetInstance():QuitFreeGameCallBack()
end





function FreeGameView:__delete()

end