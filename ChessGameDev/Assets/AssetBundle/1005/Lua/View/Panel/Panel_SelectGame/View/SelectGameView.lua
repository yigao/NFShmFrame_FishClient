SelectGameView=Class()

function SelectGameView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	
end

function SelectGameView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function SelectGameView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.SkeletonAnimation=GameManager.GetInstance().SkeletonAnimation
	self.BGSpineNameList={"01_Appear","02_Loop","03_Exit"}
	self.SelectSpineNameList={"01_Appear","02_Loop","03_Select_L","03_Select_R","04_SelectLoop_L","04_SelectLoop_R"}
	self.MiniType={
		BBG=1,
		FreeGame=2
	}
	self.TipsObjList={}
end



function SelectGameView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function SelectGameView:FindView(tf)
	self:FindSpineView(tf)
	self:FindBtnView(tf)
end


function SelectGameView:FindSpineView(tf)
	self.BGSpineAnim=tf:Find("Panel/SelectPanel/SelectBGSpine"):GetComponent(typeof(self.SkeletonAnimation))
	self.SelectSpineAnim=tf:Find("Panel/SelectPanel/SelectGameSpine"):GetComponent(typeof(self.SkeletonAnimation))
end


function SelectGameView:FindBtnView(tf)
	self.BBGBtn=tf:Find("Panel/SelectPanel/SelectBtn/BBGBtn"):GetComponent(typeof(self.Button))
	self.FreeGameBtn=tf:Find("Panel/SelectPanel/SelectBtn/FreeGameBtn"):GetComponent(typeof(self.Button))
	self.TextTips=tf:Find("Panel/SelectPanel/SelectGameSpine/TipsPanel").gameObject
	local tempObj=tf:Find("Panel/SelectPanel/SelectGameSpine/TipsPanel/Image").gameObject 
	table.insert(self.TipsObjList,tempObj)
	tempObj=tf:Find("Panel/SelectPanel/SelectGameSpine/TipsPanel/Image1").gameObject 
	table.insert(self.TipsObjList,tempObj)
end


function SelectGameView:InitViewData()
	self:IsShowBGSpine(false)
	self:IsShowSelectSpine(false)
	self:IsShowTipsText(false)
	--CommonHelper.SetActive(self.TipsObjList[1],true)
	--CommonHelper.SetActive(self.TipsObjList[2],true)
end


function SelectGameView:AddEventListenner()
	self.BBGBtn.onClick:AddListener(function () self:OnclickBBG() end)
	self.FreeGameBtn.onClick:AddListener(function () self:OnclickFreeGame() end)
end


function SelectGameView:OnclickBBG()
	GameUIManager.GetInstance():RequesSelectMiniGameResultMsg(StateManager.MainState.SelectMiniGame,self.MiniType.BBG)
end



function SelectGameView:OnclickFreeGame()
	GameUIManager.GetInstance():RequesSelectMiniGameResultMsg(StateManager.MainState.SelectMiniGame,self.MiniType.FreeGame)
end


function SelectGameView:IsShowBGSpine(isShow)
	CommonHelper.SetActive(self.BGSpineAnim.gameObject,isShow)
end

function SelectGameView:IsShowSelectSpine(isShow)
	CommonHelper.SetActive(self.SelectSpineAnim.gameObject,isShow)
end


function SelectGameView:IsShowTipsText(isShow)
	CommonHelper.SetActive(self.TextTips,isShow)
end


function SelectGameView:IsShowTipsPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.TipsObjList,isShow,true,false)
end


function SelectGameView:PlayBGSpineAnim(index,isLoop)
	local animName=self.BGSpineNameList[index]
	self.BGSpineAnim.state:SetAnimation(0,animName,isLoop)
end

function SelectGameView:PlaySelectSpineAnim(index,isLoop)
	local animName=self.SelectSpineNameList[index]
	self.SelectSpineAnim.state:SetAnimation(0,animName,isLoop)
end