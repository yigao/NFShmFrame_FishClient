SLBView=Class()

function SLBView:ctor(gameObj)
	self:Init(gameObj)

end

function SLBView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function SLBView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Animation=GameManager.GetInstance().Animation
	self.SkeletonGraphic=GameManager.GetInstance().SkeletonGraphic
	
	self.SLBAnimNameList={"EnterSLB","HideSLB"}
	self.QuitSLBAnimNameList={"QuitFreeOpen","QuitFree"}
	self.SLBSpineAnimNameList={"FeatureTurnBoard_Appear_zh_Hans","FeatureTurnBoard_Loop_zh_Hans"}
	self.EndSLBSpineAnimNameList={"YouWinBoard_Appear_zh_Hans","YouWinBoard_Loop_zh_Hans"}
	self.GetScoreTextList={}
end



function SLBView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
	self:InitGetScore()
end


function SLBView:FindView(tf)
	self:FindSLBView(tf)
end


function SLBView:FindSLBView(tf)
	self.EnterSLB=tf:Find("StartSLB").gameObject
	self.EnterSLBSpineAnim=tf:Find("StartSLB/SkeletonGraphic (FeatureTurnBoard)"):GetComponent(typeof(self.SkeletonGraphic))
	self.SLBAnim=tf:Find("StartSLB/SkeletonGraphic (FeatureTurnBoard)"):GetComponent(typeof(self.Animation))
	
	self.QuitSLB=tf:Find("EndSLB").gameObject
	self.QuitSLBTips=tf:Find("EndSLB/SettleAccountsPanel/RawImageBG"):GetComponent(typeof(self.Animation))
	self.SLBEndSpineAnim=tf:Find("EndSLB/SettleAccountsPanel/RawImageBG/SkeletonGraphic (YouWinBoard)"):GetComponent(typeof(self.SkeletonGraphic))
	self.TotalWinScore=tf:Find("EndSLB/SettleAccountsPanel/RawImageBG/WinScore"):GetComponent(typeof(self.Text))
	
	self.GetScore=tf:Find("GoldPanel/Panel/Text1").gameObject
end


function SLBView:InitViewData()
	self:IsShowEnterSLBPanel(false)
	self:IsShowQuitSLBPanel(false)
	
end


function SLBView:InitGetScore()
	CommonHelper.SetActive(self.GetScore,false)
	for i=1,25 do
		local tempScore=CommonHelper.Instantiate(self.GetScore)
		CommonHelper.AddToParentGameObject(tempScore,self.GetScore.transform.parent.gameObject)
		local tempText=tempScore:GetComponent(typeof(self.Text))
		table.insert(self.GetScoreTextList,tempText)
	end
end


function SLBView:IsShowEnterSLBPanel(isShow)
	CommonHelper.SetActive(self.EnterSLB,isShow)
end

function SLBView:IsShowQuitSLBPanel(isShow)
	CommonHelper.SetActive(self.QuitSLB,isShow)
end



function SLBView:IsShowQuitSLBCount(isShow)
	CommonHelper.SetActive(self.TotalWinScore.gameObject,isShow)
end

function SLBView:SetQuitSLBTotalWinScoreTips(score)
	self.TotalWinScore.text=score
end


function SLBView:PlaySLBAnim(animIndex)
	self.SLBAnim:Play(self.SLBAnimNameList[animIndex])
end


function SLBView:PlayEnterSLBAnim(animIndex,isLoop)
	local currentAnim=self.SLBSpineAnimNameList[animIndex]
	self.EnterSLBSpineAnim.AnimationState:SetAnimation(0,currentAnim,isLoop)
end


function SLBView:PlayQuitSLBAnim(animIndex,isLoop)
	local currentAnim=self.EndSLBSpineAnimNameList[animIndex]
	self.SLBEndSpineAnim.AnimationState:SetAnimation(0,currentAnim,isLoop)
end



function SLBView:PlayQuitSLBTipsAnim(animIndex)
	local currentAnim=self.QuitSLBAnimNameList[animIndex]
	self.QuitSLBTips:Play(currentAnim)
end


function SLBView:ResetAnimGameObjScale()
	self.QuitSLBTips.gameObject.transform.localScale=CSScript.Vector3(1,1,1)
	self.EnterSLBSpineAnim.gameObject.transform.localScale=CSScript.Vector3(1,1,1)
end


function SLBView:SetGetScoreEffect(index,score)
	if index<=#self.GetScoreTextList then
		local scoreText=self.GetScoreTextList[index]
		scoreText.text="+"..CommonHelper.FormatUnitProportionalScore(score)
		CommonHelper.SetActive(scoreText.gameObject,true)
	end
end


function SLBView:IsShowAllGetScoreEffect(isShow)
	for i=1,#self.GetScoreTextList do
		CommonHelper.SetActive(self.GetScoreTextList[i].gameObject,isShow)
	end
end