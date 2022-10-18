SLBManager=Class()

local Instance=nil
function SLBManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function SLBManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_SLB
		local BuildSLBPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				SLBManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildSLBPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function SLBManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function SLBManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function SLBManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
end


function SLBManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	
end


function SLBManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_SLB/View/SLBView",
		
	}
end


function SLBManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function SLBManager:InitInstance()
	self.SLBView=SLBView.New(self.gameObject)
end


function SLBManager:InitView()
	self:IsShowSLBPanel(false)
end


function SLBManager:IsShowSLBPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end



function SLBManager:EnterSLBProcess(freeGameCount,totalCount)
	AudioManager.GetInstance():StopAllAudio()
	AudioManager.GetInstance():PlayNormalAudio(22)
	BaseFctManager.GetInstance():SetSpineCountTips(freeGameCount,totalCount)
	BaseFctManager.GetInstance():IsShowSpineBtn(true)
	self.SLBView:IsShowAllGetScoreEffect(false)
	self.SLBView:IsShowEnterSLBPanel(false)
	self.SLBView:IsShowQuitSLBPanel(false)
	self:IsShowSLBPanel(true)
	self.SLBView:IsShowEnterSLBPanel(true)
	self.SLBView:ResetAnimGameObjScale()
	self.SLBView:PlayEnterSLBAnim(1,false)
	local EnterSLBProcessFunc=function ()
		yield_return(WaitForSeconds(1.9))
		BGManager.GetInstance():IsShowSLBBKBGPanel(2,true)
		BGManager.GetInstance():IsShowIconBGPanel(3,true)
		self.SLBView:PlayEnterSLBAnim(2,true)
		yield_return(WaitForSeconds(3))
		self.SLBView:PlaySLBAnim(2)
		yield_return(WaitForSeconds(0.3))
		self.SLBView:IsShowEnterSLBPanel(false)
		self:EnterSLBCallBack()
	end
	
	startCorotine(EnterSLBProcessFunc)
end





function SLBManager:QuitSLBProcess(slbGameWinScore)
	local QuitSLBProcessFunc=function ()
		self:SLBReciveEffect()
		self.SLBView:SetQuitSLBTotalWinScoreTips(slbGameWinScore)
		yield_return(WaitForSeconds(1))
		self.SLBView:IsShowQuitSLBCount(false)
		self.SLBView:IsShowEnterSLBPanel(false)
		self.SLBView:IsShowQuitSLBPanel(true)
		self:IsShowSLBPanel(true)
		self.SLBView:PlayQuitSLBAnim(1,false)
		yield_return(WaitForSeconds(0.5))
		self.SLBView:IsShowQuitSLBCount(true)
		self.SLBView:PlayQuitSLBTipsAnim(1)
		yield_return(WaitForSeconds(1))
		self.SLBView:PlayQuitSLBAnim(2,true)
		yield_return(WaitForSeconds(3))
		self.SLBView:PlayQuitSLBTipsAnim(2)
		BGManager.GetInstance():IsShowSLBBKBGPanel(2,false)
		BGManager.GetInstance():IsShowIconBGPanel(3,false)
		yield_return(WaitForSeconds(0.5))
		BaseFctManager.GetInstance():SetPlayerMoney(GameManager.GetInstance().gameData.PlayerMoney)
		self:QuitSLBCallBack()
	end
	startCorotine(QuitSLBProcessFunc)

end


function SLBManager:SLBReciveEffect()
	if self.gameData.SLBExtScoreInfo then
		for i=1,#self.gameData.SLBExtScoreInfo do
			local pos=self.gameData.SLBExtScoreInfo[i].point
			local tempIns=IconManager.GetInstance():GetAllocateIconIns(pos.posX+1,pos.posY+2)
			tempIns:PlayShowAnim()
			tempIns:PlaySLBRecieveScoreAnim()
			local startPos=tempIns.gameObject.transform.position
			local endPos=BaseFctManager.GetInstance().PlayerWinScoreView.playerWinScore.gameObject.transform.position
			yield_return(WaitForSeconds(0.1))
			AudioManager.GetInstance():PlayNormalAudio(20)
			ParticleManager.GetInstance():SetParabolaItemEffect(startPos,endPos)
			yield_return(WaitForSeconds(0.3))
			tempIns:IsShowIconText(false)
			tempIns:IsShowWinImage(false)
			yield_return(WaitForSeconds(0.2))
			self:SetGetScoreEffect(i,self.gameData.SLBExtScoreInfo[i].score)
			BaseFctManager.GetInstance():SetPlayerWinScore(self.gameData.SLBExtScoreInfo[i].score,0.3,true)
		end
	
	end
	
end



function SLBManager:SetGetScoreEffect(index,score)
	self.SLBView:SetGetScoreEffect(index,score)
end



function SLBManager:EnterSLBCallBack()
	self:SLBStateCallBack()
end


function SLBManager:QuitSLBCallBack()
	self.SLBView:IsShowQuitSLBPanel(false)
	self:IsShowSLBPanel(false)
	self:SLBStateCallBack()
end


function SLBManager:SLBStateCallBack()
	StateManager.GetInstance():GameStateOverCallBack()
end

function SLBManager:__delete()

end