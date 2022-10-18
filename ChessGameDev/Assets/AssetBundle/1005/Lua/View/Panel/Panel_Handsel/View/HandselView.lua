HandselView=Class()

function HandselView:ctor(gameObj)
	self:Init(gameObj)

end

function HandselView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function HandselView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.SkeletonGraphic=GameManager.GetInstance().SkeletonGraphic
	self.Animation=GameManager.GetInstance().Animation
	self.Text=GameManager.GetInstance().Text
	self.HandselObjList={}
	self.settleAccountsTextList={}
	self.settleAccountsAnimNameList={"OpenBBGAnim","OpenFreeAnim"}
end



function HandselView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
end


function HandselView:FindView(tf)
	self:FindHandselView(tf)
	self:FindCollectHandselView(tf)
	self:FindSmallGameView(tf)
end

function HandselView:InitViewData()
	self:IsShowHandselPanel(true)
	self:IsShowFreeGameTipsPanel(false)
	self:IsShowResultPanel(false)
	self:IsShowSmallGamePanel(false)
	self:SetSettleAccountsScore({0,0,0})
	self:SetFXJJScore(0)
	self:SetJJJackpotSocre(0)
	self:SetFreeGameAddSocre(0)
end



function HandselView:FindHandselView(tf)
	for i=1,4 do
		local tempObj=tf:Find("Panel/Handsel"..i).gameObject
		table.insert(self.HandselObjList,tempObj)
	end
end


function HandselView:FindCollectHandselView(tf)
	self.OpenJackpotSpineAnim=tf:Find("Panel/SkeletonGraphic (GoldenPot)"):GetComponent(typeof(self.SkeletonGraphic))
end


function HandselView:FindSmallGameView(tf)
	self.HandselPanel=tf:Find("Panel").gameObject
	self.SmallGamePanel=tf:Find("SmallGamePanel").gameObject
	self.ResultPanel=tf:Find("SmallGamePanel/ResultPanel").gameObject
	self.ScorePanel=tf:Find("SmallGamePanel/ScorePanel").gameObject
	self.FXJJPanel=tf:Find("SmallGamePanel/ScorePanel/FXJJPanel").gameObject
	self.FXJJScoreText=tf:Find("SmallGamePanel/ScorePanel/FXJJPanel/Image/Text"):GetComponent(typeof(self.Text))
	self.FXJJScorePanelPos=self.FXJJScoreText.transform.parent.localPosition
	self.JJJackpotSocre=tf:Find("SmallGamePanel/ScorePanel/JJScore/Text"):GetComponent(typeof(self.Text))
	self.settleAccountsAnim=tf:Find("SmallGamePanel"):GetComponent(typeof(self.Animation))
	
	self.settleAccountsPanel=tf:Find("SmallGamePanel/ResultPanel/BBGPanel").gameObject
	local textScore=tf:Find("SmallGamePanel/ResultPanel/BBGPanel/FX/Text"):GetComponent(typeof(self.Text))
	table.insert(self.settleAccountsTextList,textScore)
	textScore=tf:Find("SmallGamePanel/ResultPanel/BBGPanel/YZ/Text"):GetComponent(typeof(self.Text))
	table.insert(self.settleAccountsTextList,textScore)
	textScore=tf:Find("SmallGamePanel/ResultPanel/TotalPanel/Text"):GetComponent(typeof(self.Text))
	table.insert(self.settleAccountsTextList,textScore)
	
	self.FreeGameScore=tf:Find("SmallGamePanel/ResultPanel/BBGPanel/ZF/Text"):GetComponent(typeof(self.Text))
	self.FreeGameTipsPanel=tf:Find("SmallGamePanel/ScorePanel/FreePanel").gameObject
	self.FreeGameTipsScore=tf:Find("SmallGamePanel/ScorePanel/FreePanel/Image/Text"):GetComponent(typeof(self.Text))
	self.FH_X=tf:Find("SmallGamePanel/ResultPanel/BBGPanel/FH/Imagex").gameObject
	self.FH_Add=tf:Find("SmallGamePanel/ResultPanel/BBGPanel/FH/Image+").gameObject
	
	
end


function HandselView:IsShowHandselPanel(isShow)
	CommonHelper.SetActive(self.HandselPanel,isShow)
end


function HandselView:IsShowSmallGamePanel(isShow)
	CommonHelper.SetActive(self.SmallGamePanel,isShow)
end

function HandselView:IsShowResultPanel(isShow)
	CommonHelper.SetActive(self.ResultPanel,isShow)
end

function HandselView:IsShowScorePanel(isShow)
	CommonHelper.SetActive(self.ScorePanel,isShow)
end

function HandselView:IsShowFXJJPanel(isShow)
	CommonHelper.SetActive(self.FXJJPanel,isShow)
end

function HandselView:IsShowFreeGameTipsPanel(isShow)
	CommonHelper.SetActive(self.FreeGameTipsPanel,isShow)
end


function HandselView:ResetFXJJScorePostion()
	self.FXJJScoreText.transform.parent.localPosition=self.FXJJScorePanelPos
	self:IsShowFXJJPanel(true)
end


function HandselView:SetFXJJScore(score)
	self.FXJJScoreText.text=score
end

function HandselView:SetJJJackpotSocre(score)
	self.JJJackpotSocre.text=CommonHelper.FormatBaseProportionalScore(score)
end

function HandselView:SetFreeGameAddSocre(score)
	self.FreeGameScore.text=CommonHelper.FormatBaseProportionalScore(score)
end


function HandselView:SetSettleAccountsScore(scoreList)
	for i=1,#scoreList do
		self.settleAccountsTextList[i].text=CommonHelper.FormatBaseProportionalScore(scoreList[i])
	end
end


function HandselView:PlaySetsettleAccountsAnim(index)
	local animName=self.settleAccountsAnimNameList[index]
	self.settleAccountsAnim:Play(animName)
end


function HandselView:SetFreeGameTipsScore(score)
	self.FreeGameTipsScore.text=score
end



