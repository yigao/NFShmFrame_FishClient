BaseTipsView=Class()


function BaseTipsView:ctor(obj)
	self:Init(obj)
end

function BaseTipsView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function BaseTipsView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.WaitTipsObjList={}
	self.WinTipsObjList={}
	self.TakeAllTipsObjList={}
	
end



function BaseTipsView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BaseTipsView:InitViewData()
	self:IsShowWaitTipsPanel(0,true)
	self:IsShowTakeAllTipsPanel(0,true)
	self:IsShowStartGameTipsAnim(false)
	self:IsShowGameResultTipsPanel(0,true)
end


function BaseTipsView:FindView(tf)
	self:FindWaitTipsView(tf)
	self:FindGameResultTipsView(tf)
	self:FindTakeAllTipsView(tf)
	self:FindOtherTipsView(tf)
end


function BaseTipsView:FindWaitTipsView(tf)
	local tempObj=tf:Find("Panel/WaitTips/WaitOthersJoinTips").gameObject	
	table.insert(self.WaitTipsObjList,tempObj)
	tempObj=tf:Find("Panel/WaitTips/WaitNextTips").gameObject	
	table.insert(self.WaitTipsObjList,tempObj)
	tempObj=tf:Find("Panel/WaitTips/NotExitTips").gameObject	
	table.insert(self.WaitTipsObjList,tempObj)
end


function BaseTipsView:FindGameResultTipsView(tf)
	local tempObj=tf:Find("Panel/GameResultTips/WinTips/Win").gameObject	
	table.insert(self.WinTipsObjList,tempObj)
	tempObj=tf:Find("Panel/GameResultTips/WinTips/Lose").gameObject	
	table.insert(self.WinTipsObjList,tempObj)
end


function BaseTipsView:FindTakeAllTipsView(tf)
	local tempObj=tf:Find("Panel/GameResultTips/TakeAllTips/TongSha").gameObject	
	table.insert(self.TakeAllTipsObjList,tempObj)
	tempObj=tf:Find("Panel/GameResultTips/TakeAllTips/TongPei").gameObject	
	table.insert(self.TakeAllTipsObjList,tempObj)
end



function BaseTipsView:FindOtherTipsView(tf)
	self.StartGameTips=tf:Find("Panel/StartGameTips").gameObject
	self.BaseScoreText=tf:Find("Panel/BaseTips/Image/Text"):GetComponent(typeof(self.Text))
end


function BaseTipsView:ResetBaseTipsPanel()
	self:IsShowWaitTipsPanel(0,true)
	self:IsShowTakeAllTipsPanel(0,true)
	self:IsShowStartGameTipsAnim(false)
	self:IsShowGameResultTipsPanel(0,true)
end


function BaseTipsView:ResetPanel()
	self:IsShowTakeAllTipsPanel(0,true)
	self:IsShowStartGameTipsAnim(false)
	self:IsShowGameResultTipsPanel(0,true)
	if PlayerManager.GetInstance():GetMyObservedState() then  return end
	self:IsShowWaitTipsPanel(0,true)
	
end


function BaseTipsView:IsShowWaitTipsPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.WaitTipsObjList,isShow,true,false,false)
end

function BaseTipsView:IsShowGameResultTipsPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.WinTipsObjList,isShow,true,false,false)
end

function BaseTipsView:IsShowTakeAllTipsPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.TakeAllTipsObjList,isShow,true,false,false)
end

function BaseTipsView:IsShowStartGameTipsAnim(isShow)
	CommonHelper.SetActive(self.StartGameTips,isShow)
end


function BaseTipsView:SetBaseScoreTipsValue(score)
	self.BaseScoreText.text=CommonHelper.FormatBaseProportionalScore(score)
end
