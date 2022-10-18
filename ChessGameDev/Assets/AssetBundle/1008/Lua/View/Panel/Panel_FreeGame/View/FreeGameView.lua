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
	self.EnterGamePanel=tf:Find("Panel/EnterFree").gameObject
	self.FreeGameCount=tf:Find("Panel/EnterFree/FreeGameCountTips/Text"):GetComponent(typeof(self.Text))
	self.QuitFreeGamePanel=tf:Find("Panel/LeaveFree").gameObject
	self.TotalWinScore=tf:Find("Panel/LeaveFree/Panel/Result/FreeCount/Text"):GetComponent(typeof(self.Text))
	self.QuitFreeGameButton=tf:Find("Panel/LeaveFree/Panel/Result/Button"):GetComponent(typeof(self.Button))
end


function FreeGameView:InitViewData()
	self:IsShowEnterFreeGamePanel(false)
	self:IsShowQuitFreeGamePanel(false)
	self:SetEnterFreeGameCountTips(0)
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




function FreeGameView:SetFreeGameTotalWinScoreTips(score)
	self.TotalWinScore.text=score
end



function FreeGameView:OnclickQuitFreeGame()
	AudioManager.GetInstance():PlayNormalAudio(4)
	FreeGameManager.GetInstance():QuitFreeGameCallBack()
end





function FreeGameView:__delete()

end