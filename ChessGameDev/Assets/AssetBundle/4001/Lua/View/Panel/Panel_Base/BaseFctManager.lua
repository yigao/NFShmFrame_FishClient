BaseFctManager=Class()

local Instance=nil
function BaseFctManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function BaseFctManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Base
		local BuildBasePanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				BaseFctManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildBasePanelCallBack)
		
	else
		return Instance
	end
end


function BaseFctManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function BaseFctManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function BaseFctManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function BaseFctManager:InitData()
	
	
end


function BaseFctManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Base/FunctionBtn/FunctionBtnView",
		"View/Panel/Panel_Base/BetChipBtn/BetChipBtnView",
		"View/Panel/Panel_Base/BaseFctView/BaseFctView",
		"View/Panel/Panel_Base/BankerSimpleView/BankerSimpleView",
		"View/Panel/Panel_Base/HistoryRecord/HistoryRecordView",
		"View/Panel/Panel_Base/HistoryRecord/HistoryRecordItem/HistoryRecordItem",
	}
end


function BaseFctManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function BaseFctManager:InitInstance()
	self.HistoryRecordItem = HistoryRecordItem
	self.FunctionBtnView=FunctionBtnView.New(self.gameObject)
	self.BetChipBtnView=BetChipBtnView.New(self.gameObject)
	self.BaseFctView = BaseFctView.New(self.gameObject)
	self.BankerSimpleView = BankerSimpleView.New(self.gameObject)
	self.HistoryRecordView = HistoryRecordView.New(self.gameObject)

end

function BaseFctManager:InitView()
	
end



function BaseFctManager:InitBetChipValue()
	self.BetChipBtnView:InitBetChipValue()
end

function BaseFctManager:InitSoundState()
	self.FunctionBtnView:ResetSound()
end


--进入游戏开始状态
function BaseFctManager:EnterGameStart()
	self.BetChipBtnView:EnterGameStart()
	self.BaseFctView:EnterGameStart()
	self.BankerSimpleView:HideAllScoreResultPanel()
	self.BankerSimpleView:SetCurBankerValue()
	self.FunctionBtnView:EnterGameStart()
end

--进入游戏押注状态
function BaseFctManager:EnterBetChipStatus()
	self.BetChipBtnView:EnterBetChip()
	self.BaseFctView:EnterBetChip()
	self.FunctionBtnView:EnterBetChip()
end

--进入游戏开奖状态
function BaseFctManager:EnterOpenPrizeStatus(dragonAreaCard,tigerAreaCard,prizeType)
	self.BetChipBtnView:EnterOpenPrize()
	self.BaseFctView:EnterOpenPrize(dragonAreaCard,tigerAreaCard,prizeType)
	self.FunctionBtnView:EnterBetChip()
end

function BaseFctManager:ResetOpenPrize()
	self.BetChipBtnView:EnterOpenPrize()
	self.FunctionBtnView:EnterOpenPrize()
	self.BaseFctView:IsShowWaitNextGameEffect(true)
end

function BaseFctManager:GetOtherPlayerBetInitPosition()
	return self.FunctionBtnView:GetOtherPlayerBetInitPos()
end


function BaseFctManager:GetBankerBetInitPos()
	return self.BankerSimpleView:GetBankerBetPos()
end

function BaseFctManager:__delete()
	Instance=nil
	self.BetChipBtnView:Destroy()
	self.BaseFctView:Destroy()
	self.BankerSimpleView:Destroy()
end