TipsManager=Class()

local Instance=nil
function TipsManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function TipsManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Tips
		local BuildTipsPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				TipsManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildTipsPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function TipsManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function TipsManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function TipsManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function TipsManager:InitData()
	
	
end


function TipsManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Tips/TimerTips/TimerTipsView",
		"View/Panel/Panel_Tips/OtherTips/BaseTipsView",
	}
end


function TipsManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function TipsManager:InitInstance()
	self.TimerTipsView=TimerTipsView.New(self.gameObject)
	self.BaseTipsView=BaseTipsView.New(self.gameObject)
end


function TipsManager:InitView()
	
end


function TipsManager:HideAllTipsPanel()
	self:HideAllTimer()
	self:HideAllOtherTips()
end


function TipsManager:HideAllTimer()
	self.TimerTipsView:InitViewData()
end


function TipsManager:HideAllOtherTips()
	self.BaseTipsView:ResetPanel()
end



function TipsManager:SetCountDownTimer(index,rTime)
	self.TimerTipsView:SetCountDownTimer(index,rTime)
end

function TipsManager:GetCurrentCountDoenTime()
	return self.TimerTipsView:GetCurrentRemainTime()
end




function TipsManager:SetBaseScoreTipsValue(score)
	self.BaseTipsView:SetBaseScoreTipsValue(score)
end


function TipsManager:PlayWaitTipsPanel(index,isShow)
	self.BaseTipsView:IsShowWaitTipsPanel(0,true)
	if isShow then
		self.BaseTipsView:IsShowWaitTipsPanel(index,isShow)
	end
end

function TipsManager:PlayGameResultTipsPanel(index,isShow)
	self.BaseTipsView:IsShowGameResultTipsPanel(0,true)
	if isShow then
		self.BaseTipsView:IsShowGameResultTipsPanel(index,isShow)
	end
end

function TipsManager:PlayTakeAllTipsPanel(index,isShow)
	self.BaseTipsView:IsShowTakeAllTipsPanel(0,true)
	if isShow then
		self.BaseTipsView:IsShowTakeAllTipsPanel(index,isShow)
	end
end

function TipsManager:PlayStartGameTipsAnim(isShow)
	if isShow then
		self.BaseTipsView:IsShowStartGameTipsAnim(not isShow)
	end
	self.BaseTipsView:IsShowStartGameTipsAnim(isShow)
end




function TipsManager:__delete()

end