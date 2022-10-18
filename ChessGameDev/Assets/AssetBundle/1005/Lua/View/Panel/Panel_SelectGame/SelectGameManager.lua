SelectGameManager=Class()

local Instance=nil
function SelectGameManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function SelectGameManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_SelectGame
		local BuildSelectGamePanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				SelectGameManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildSelectGamePanelCallBack)
		
	else
		return Instance
	end
	
	
end


function SelectGameManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function SelectGameManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function SelectGameManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function SelectGameManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	
end


function SelectGameManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_SelectGame/View/SelectGameView",
	}
end


function SelectGameManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function SelectGameManager:InitInstance()
	self.SelectGameView=SelectGameView.New(self.gameObject)
end


function SelectGameManager:InitView()
	self:IsShowPanel(false)
end


function SelectGameManager:IsShowPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end



function SelectGameManager:SetSelectGameProcess()
	StopAllCorotines()
	IconManager.GetInstance():ClearAllIconItemInsListState()
	
	local SelectGameProcessFunc=function ()
		self.SelectGameView:InitViewData()
		self:IsShowPanel(true)
		AudioManager.GetInstance():PlayNormalAudio(23)
		self.SelectGameView:IsShowBGSpine(true)
		self.SelectGameView:PlayBGSpineAnim(1,false)
		yield_return(WaitForSeconds(0.5))
		AudioManager.GetInstance():PlayBGAudio(24)
		self.SelectGameView:IsShowSelectSpine(true)
		self.SelectGameView:PlaySelectSpineAnim(1,false)
		yield_return(WaitForSeconds(1))
		self.SelectGameView:IsShowTipsText(true)
		self.SelectGameView:PlayBGSpineAnim(2,true)
		yield_return(WaitForSeconds(1.5))
		self.SelectGameView:PlaySelectSpineAnim(2,true)
		
	end
	startCorotine(SelectGameProcessFunc)
end


function SelectGameManager:EndSelectGameCallBack(miniGameIndex)
	local EndSelectGameCallBackFunc=function ()
		AudioManager.GetInstance():PlayNormalAudio(20)
		local animIndex=3
		if miniGameIndex==self.SelectGameView.MiniType.BBG then
			animIndex=3
			BGManager.GetInstance():IsShowIconBGPanel(2,true)
			IconManager.GetInstance():ChangeAllRandomIconToDark()
		elseif miniGameIndex==self.SelectGameView.MiniType.FreeGame then
			animIndex=4
			BGManager.GetInstance():IsShowIconBGPanel(3,true)
		end
		self.SelectGameView:PlaySelectSpineAnim(animIndex,false)
		yield_return(WaitForSeconds(2.1))
		self.SelectGameView:IsShowTipsText(false)
		self.SelectGameView:IsShowSelectSpine(false)
		self.SelectGameView:PlayBGSpineAnim(3,false)
		AudioManager.GetInstance():PlayNormalAudio(25)
		yield_return(WaitForSeconds(2))
		self:IsShowPanel(false)
		HandselManager.GetInstance().HandselView:InitViewData()
		HandselManager.GetInstance().HandselView:ResetFXJJScorePostion()
		HandselManager.GetInstance():ChangeHandselState(true)
		if miniGameIndex==self.SelectGameView.MiniType.FreeGame then
			AudioManager.GetInstance():PlayBGAudio(4)
			HandselManager.GetInstance().HandselView:IsShowFreeGameTipsPanel(true)
			yield_return(WaitForSeconds(0.5))
			if self.gameData.BBGMultipleList and self.gameData.BBGMultipleList[1] then
				local addBBGScore=0
				for _k,_v in ipairs(self.gameData.BBGMultipleList[1]) do
					local tempIconIns=IconManager.GetInstance():GetSingleRunIconInsByCoordinate(_v.colmunIndex,_v.rowIndex)
					if tempIconIns then
						local flyIconText=ParticleManager.GetInstance():GetAllocateEffect("IconText".._v.iconNum)
						if flyIconText then
							flyIconText.transform:Find("IconText"):GetComponent(typeof(GameManager.GetInstance().Text)).text=_v.value
							flyIconText.transform.position=tempIconIns:GetIconTextPos()
							tempIconIns:IsShowIconText(false)
							local tempTween=flyIconText.transform:DOMove(HandselManager.GetInstance():GetFreeFFCJPostion(), 0.5)
							tempTween:SetEase(GameManager.GetInstance().Ease.Linear)
							AudioManager.GetInstance():PlayNormalAudio(32)
							yield_return(WaitForSeconds(0.51))
							ParticleManager.GetInstance():RecycleEffect(flyIconText)
							addBBGScore=addBBGScore+_v.value
							HandselManager.GetInstance():SetFreeFFCJAddScore(addBBGScore)
						end
						
					end
				end
				yield_return(WaitForSeconds(1))
			end
		else
			AudioManager.GetInstance():PlayBGAudio(18)
			HandselManager.GetInstance().HandselView:IsShowFreeGameTipsPanel(false)
		end
		
		StateManager.GetInstance():GameStateOverCallBack()
	end
	startCorotine(EndSelectGameCallBackFunc)
end




function SelectGameManager:ChangeBGScence()
	self:IsShowPanel(true)
	self.SelectGameView:IsShowBGSpine(true)
	AudioManager.GetInstance():PlayNormalAudio(23)
	self.SelectGameView:PlayBGSpineAnim(1,false)
	local DelayCloseBGSpineScenceFunc=function ()
		TimerManager.GetInstance():RecycleTimerIns(changeScenceTimer)
		self.SelectGameView:PlayBGSpineAnim(3,false)
		AudioManager.GetInstance():PlayNormalAudio(25)
	end
	local changeScenceTimer=TimerManager.GetInstance():CreateTimerInstance(2,DelayCloseBGSpineScenceFunc)
end

