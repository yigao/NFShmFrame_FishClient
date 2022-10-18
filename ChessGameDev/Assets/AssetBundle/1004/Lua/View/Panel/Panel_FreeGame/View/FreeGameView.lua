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
	self.SkeletonGraphic=GameManager.GetInstance().SkeletonGraphic
	
	self.EnterFreeGameAnimNameList={"EnterFreeOpen","EnterFree"}
	self.QuitFreeGameAnimNameList={"QuitFreeOpen","QuitFree"}
	self.EnterFreeGameSpineAnimNameList={"FreeGameBoard_Appear_zh_Hans","FreeGameBoard_Loop_zh_Hans"}
	self.EndFreeGameSpineAnimNameList={"YouWinBoard_Appear_zh_Hans","YouWinBoard_Loop_zh_Hans"}
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
	self.FreeGameTips=tf:Find("EnterFreeGame/FreeGameTips"):GetComponent(typeof(self.Animation))
	self.EnterFreeGameSpineAnim=tf:Find("EnterFreeGame/FreeGameTips/SkeletonGraphic (FreeGameBoard)"):GetComponent(typeof(self.SkeletonGraphic))
	self.FreeGameCount=tf:Find("EnterFreeGame/FreeGameTips/Text"):GetComponent(typeof(self.Text))
	self.QuitFreeGamePanel=tf:Find("EndFreeGame").gameObject
	self.QuitFreeGameTips=tf:Find("EndFreeGame/SettleAccountsPanel/RawImageBG"):GetComponent(typeof(self.Animation))
	self.FreeGameEndSpineAnim=tf:Find("EndFreeGame/SettleAccountsPanel/RawImageBG/SkeletonGraphic (YouWinBoard)"):GetComponent(typeof(self.SkeletonGraphic))
	self.TotalWinScore=tf:Find("EndFreeGame/SettleAccountsPanel/RawImageBG/WinScore"):GetComponent(typeof(self.Text))
	--self.QuitFreeGameButton=tf:Find("EndFreeGame/SettleAccountsPanel/ButtonClose"):GetComponent(typeof(self.Button))
end


function FreeGameView:InitViewData()
	self:IsShowEnterFreeGamePanel(false)
	self:IsShowQuitFreeGamePanel(false)
	self:SetEnterFreeGameCountTips(0)
	--self:SetQuitFreeGameCountTips(0)
	self:SetFreeGameTotalWinScoreTips(0)
	
end


function FreeGameView:AddEventListenner()
	--self.QuitFreeGameButton.onClick:AddListener(function () self:OnclickQuitFreeGame() end)
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

function FreeGameView:IsShowFreeGameCount(isShow)
	CommonHelper.SetActive(self.FreeGameCount.gameObject,isShow)
end

function FreeGameView:IsShowQuitFreeGameCount(isShow)
	CommonHelper.SetActive(self.TotalWinScore.gameObject,isShow)
end

function FreeGameView:SetFreeGameTotalWinScoreTips(score)
	self.TotalWinScore.text=score
end


function FreeGameView:PlayEnterFreeGameAnim(animIndex,isLoop)
	local currentAnim=self.EnterFreeGameSpineAnimNameList[animIndex]
	self.EnterFreeGameSpineAnim.AnimationState:SetAnimation(0,currentAnim,isLoop)
end


function FreeGameView:PlayQuitFreeGameAnim(animIndex,isLoop)
	local currentAnim=self.EndFreeGameSpineAnimNameList[animIndex]
	self.FreeGameEndSpineAnim.AnimationState:SetAnimation(0,currentAnim,isLoop)
end


function FreeGameView:PlayEnterFreeGameTipsAnim(animIndex)
	local currentAnim=self.EnterFreeGameAnimNameList[animIndex]
	self.FreeGameTips:Play(currentAnim)
end

function FreeGameView:PlayQuitEnterFreeGameTipsAnim(animIndex)
	local currentAnim=self.QuitFreeGameAnimNameList[animIndex]
	self.QuitFreeGameTips:Play(currentAnim)
end


function FreeGameView:ResetAnimGameObjScale()
	self.FreeGameTips.gameObject.transform.localScale=CSScript.Vector3(1,1,1)
	self.QuitFreeGameTips.gameObject.transform.localScale=CSScript.Vector3(1,1,1)
end



function FreeGameView:OnclickQuitFreeGame()
	AudioManager.GetInstance():PlayNormalAudio(9)
	FreeGameManager.GetInstance():QuitFreeGameCallBack()
end





function FreeGameView:__delete()

end