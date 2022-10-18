FreeGameManager=Class()

local Instance=nil
function FreeGameManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function FreeGameManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_FreeGame
		local BuildFreeGamePanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				FreeGameManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildFreeGamePanelCallBack)
		
	else
		return Instance
	end
	
	
end


function FreeGameManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function FreeGameManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function FreeGameManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function FreeGameManager:InitData()
	
	
end


function FreeGameManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_FreeGame/View/FreeGameView",
		
	}
end


function FreeGameManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function FreeGameManager:InitInstance()
	self.FreeGameView=FreeGameView.New(self.gameObject)
end


function FreeGameManager:InitView()
	self:IsShowFreeGamePanel(false)
end


function FreeGameManager:IsShowFreeGamePanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end



function FreeGameManager:EnterFreeGameProcess(freeGameCount)
	AudioManager.GetInstance():StopAllAudio()
	AudioManager.GetInstance():PlayNormalAudio(30)
	BaseFctManager.GetInstance():SetFreeGameCountTips(freeGameCount)
	BaseFctManager.GetInstance():IsShowFreeGameBtn(true)
	self.FreeGameView:SetEnterFreeGameCountTips(freeGameCount)
	--self.FreeGameView:IsShowFreeGameBtn(false)
	self.FreeGameView:IsShowEnterFreeGamePanel(false)
	self.FreeGameView:IsShowQuitFreeGamePanel(false)
	self:IsShowFreeGamePanel(true)
	self.FreeGameView:IsShowEnterFreeGamePanel(true)
	self.FreeGameView:ResetAnimGameObjScale()
	self.FreeGameView:PlayEnterFreeGameAnim(1,false)
	BGManager.GetInstance():IsShowMainBGPanel(2,true)
	BGManager.GetInstance():IsShowIconBGPanel(2,true)
	local EnterFreeGameProcessFunc=function ()
		yield_return(WaitForSeconds(0.5))
		--self.FreeGameView:IsShowFreeGameBtn(true)
		self.FreeGameView:PlayEnterFreeGameTipsAnim(1)
		yield_return(WaitForSeconds(1))
		self.FreeGameView:PlayEnterFreeGameAnim(2,true)
		yield_return(WaitForSeconds(3))
		self.FreeGameView:PlayEnterFreeGameTipsAnim(2)
		yield_return(WaitForSeconds(0.5))
		self.FreeGameView:IsShowEnterFreeGamePanel(false)
		self:EnterFreeGameCallBack()
	end
	
	startCorotine(EnterFreeGameProcessFunc)
end





function FreeGameManager:QuitFreeGameProcess(freeGameCount,freeGameWinScore)
	AudioManager.GetInstance():PlayNormalAudio(24)
	self.FreeGameView:SetFreeGameTotalWinScoreTips(freeGameWinScore)
	self.FreeGameView:IsShowQuitFreeGameCount(false)
	self.FreeGameView:IsShowEnterFreeGamePanel(false)
	self.FreeGameView:IsShowQuitFreeGamePanel(true)
	self:IsShowFreeGamePanel(true)
	BGManager.GetInstance():IsShowMainBGPanel(2,false)
	BGManager.GetInstance():IsShowIconBGPanel(2,false)
	local QuitFreeGameProcessFunc=function ()
		self.FreeGameView:PlayQuitFreeGameAnim(1,false)
		yield_return(WaitForSeconds(0.5))
		self.FreeGameView:IsShowQuitFreeGameCount(true)
		self.FreeGameView:PlayQuitEnterFreeGameTipsAnim(1)
		yield_return(WaitForSeconds(1))
		self.FreeGameView:PlayQuitFreeGameAnim(2,true)
		yield_return(WaitForSeconds(3))
		AudioManager.GetInstance():StopAllNormalAudio()
		AudioManager.GetInstance():PlayNormalAudio(31)
		self.FreeGameView:PlayQuitEnterFreeGameTipsAnim(2)
		yield_return(WaitForSeconds(0.5))
		BaseFctManager.GetInstance():SetPlayerMoney(GameManager.GetInstance().gameData.PlayerMoney)
		self:QuitFreeGameCallBack()
	end
	startCorotine(QuitFreeGameProcessFunc)
end



function FreeGameManager:EnterFreeGameCallBack()
	self:FreeGameStateCallBack()
end


function FreeGameManager:QuitFreeGameCallBack()
	self.FreeGameView:IsShowQuitFreeGamePanel(false)
	self:IsShowFreeGamePanel(false)
	self:FreeGameStateCallBack()
end


function FreeGameManager:FreeGameStateCallBack()
	StateManager.GetInstance():GameStateOverCallBack()
end



function FreeGameManager:__delete()

end