BonusManager=Class()

local Instance=nil
function BonusManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function BonusManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Bonus
		local BuildBonusPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				BonusManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildBonusPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function BonusManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function BonusManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function BonusManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitViewData()
end


function BonusManager:InitData()
	self.gamedata=GameManager.GetInstance().gameData
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.IconMark=1
	self.MainIconItemInsList={}
	self.MainIconNumSortList={}
	self.RunIconItemInsList={}
	self.BonusTotalCount=1
	self.RemainBonusCount=1
	self.MidIconResult={}
	self.MidIconWinStateList={}
end


function BonusManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Bonus/View/BaseView",
		"View/Panel/Panel_Bonus/View/BonusView/BonusView",
		"View/Panel/Panel_Bonus/View/IconView/MainIconView",
		"View/Panel/Panel_Bonus/View/ItemView/MidRunItemView",
		"View/Panel/Panel_Bonus/BonusIcon/BonusIconItem",
		"View/Panel/Panel_Bonus/BonusIcon/BonusIconManager",
		"View/Panel/Panel_Bonus/BonusItem/BonusIconControl",
	}
end


function BonusManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function BonusManager:InitInstance()
	self.BaseView=BaseView.New(self.gameObject)
	self.BonusView=BonusView.New(self.gameObject)
	self.MainIconView=MainIconView.New(self.gameObject)
	self.BonusIconItem=BonusIconItem
	self.BonusIconManager=BonusIconManager.New()
	self.MidRunItemView=MidRunItemView.New(self.gameObject)
	self.BonusIconControl=BonusIconControl
end

function BonusManager:InitView()
	self.MainIconItemList=self.MainIconView.MainIconItemList
	self.MainIconParentList=self.MainIconView.MainIconParentList
	self.BaseIconMultipleList=self.BaseView.BaseIconMultipleList
	self.IconMultipleValueList=self.BaseView.IconMultipleValueList
	self.BounsIconMountGroup=self.MidRunItemView.BounsIconMountGroup
end



function BonusManager:InitViewData()
	self:IsShowBonusPanel(false)
end


function BonusManager:GetIconMark()
	self.IconMark=self.IconMark+1
	return self.IconMark
end


function BonusManager:IsShowBonusPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end



function BonusManager:BuildMainIconItemIns(iconNumList)
	if iconNumList and #iconNumList>0 then
		for i=1,#iconNumList do
			local tempIconItem=self.MainIconItemList[iconNumList[i]+1]
			if tempIconItem then
				local tempItem=CommonHelper.Instantiate(tempIconItem)
				CommonHelper.AddToParentGameObject(tempItem,self.MainIconParentList[i])
				CommonHelper.SetActive(tempItem,true)
				local IconIns=self.BonusIconItem.New(tempItem)
				table.insert(self.MainIconItemInsList,IconIns)
			else
				Debug.LogError("获取BonusItem异常")
			end
			
		end
	end
end


function BonusManager:CaculateBonusIconIndexPos(mainIconNumList)
	for i=1,#mainIconNumList do
		self:SortBonusIconIndex(i,mainIconNumList[i])
	end
	pt(self.MainIconNumSortList)
end


function BonusManager:SortBonusIconIndex(iconPos,iconIndex)
	if self.MainIconNumSortList[iconIndex]==nil then
		self.MainIconNumSortList[iconIndex]={}
	end
	table.insert(self.MainIconNumSortList[iconIndex],iconPos)
end



function BonusManager:EnterBonus(bonusMsg)
	self:SetShowEnterBonus()
	self:ResetBonusView(bonusMsg)
	
end


function BonusManager:SetShowEnterBonus()
	AudioManager.GetInstance():PlayNormalAudio(13)
	self.BonusView:HideAllBonusPanel()
	self.BonusView:IsShowEnterBonusPanel(true)
	self:IsShowBonusPanel(true)
	self.BonusView:PlayEnterBonusAnim(1)
	local DelayPlayEnterBonusFunc1=function ()
		self:ResetEnterBonusAnimTimer()
		self.BonusView:PlayEnterBonusAnim(2)
		local DelayPlayEnterBonusFunc2=function ()
			self:ResetEnterBonusAnimTimer()
			self.BonusView:HideAllBonusPanel()
			self.BonusView:IsShowStartBonusPanel(true)
			self.BonusView:IsShowMainBonusPanel(true)
		end
		self.EnterBonusAnimTimer2=TimerManager.GetInstance():CreateTimerInstance(0.8,DelayPlayEnterBonusFunc2)
	end
	self.EnterBonusAnimTimer1=TimerManager.GetInstance():CreateTimerInstance(2,DelayPlayEnterBonusFunc1)
	
	
end


function BonusManager:ResetEnterBonusAnimTimer()
	if self.EnterBonusAnimTimer1 then
		TimerManager.GetInstance():RecycleTimerIns(self.EnterBonusAnimTimer1)
		self.EnterBonusAnimTimer1=nil
	end
	
	if self.EnterBonusAnimTimer2 then
		TimerManager.GetInstance():RecycleTimerIns(self.EnterBonusAnimTimer2)
		self.EnterBonusAnimTimer2=nil
	end
	
end


function BonusManager:ResetBonusView(bonusMsg)
	self:InitMainIcon(bonusMsg.outerIcons)
	self:InitBaseIconMultiple(bonusMsg.iconMuls)
	self:InitChipBetMultiple()
	self:InitBonusBaseData(bonusMsg)
	self:InitMidIcon()
	self:ResetMindIconAnimState()
	self.BaseView:SetBonusWinScoreValue(0)
end


function BonusManager:InitMainIcon(mainIconNumList)
	if mainIconNumList and self.MainIconItemInsList and #self.MainIconItemInsList<=0 then
		self:BuildMainIconItemIns(mainIconNumList)
		self:CaculateBonusIconIndexPos(mainIconNumList)
	end
end


function BonusManager:InitBaseIconMultiple(baseIconMultipleList)
	if baseIconMultipleList then
		for i=1,#self.BaseIconMultipleList do
			self.BaseIconMultipleList[i].text="x"..baseIconMultipleList[i]
		end
	end
end


function BonusManager:InitChipBetMultiple(iconMultipleValueList)

end


function BonusManager:InitBonusBaseData(bonusMsg)
	self.BonusTotalCount=bonusMsg.leftPlayCount
	self.PlayerMoney=bonusMsg.userScore
	self.BonusTotalWinScore=bonusMsg.maryGameScore
	self.GameMainWinScore=bonusMsg.mainGameScore
	self.BetChipValue=bonusMsg.chipScore
	self:SetBonusRemainCount(bonusMsg.leftPlayCount)
	self:RefreshBonusViewData()
end

function BonusManager:SetBonusRemainCount(count)
	self.RemainBonusCount=count
end


function BonusManager:SetMidIconResult(midResult)
	if midResult and #midResult==4 then
		self.MidIconResult=midResult
	else
		Debug.LogError("Bonus中间图标结果异常")
	end
	
end



function BonusManager:InitMidIcon()
	if self.RunIconItemInsList and #self.RunIconItemInsList>0 then  return end

	for i=1,4 do
		local tempRunMountItem=self.BounsIconMountGroup[i]
		if tempRunMountItem then
			local tempRunItemIns=self.BonusIconControl.New(tempRunMountItem)
			table.insert(self.RunIconItemInsList,tempRunItemIns)
		else
			Debug.LogError("bonus滚动图标坐标项异常")
		end
	end
	
	self:InitMidIconData({1,2,3,4})
	
end



function BonusManager:InitMidIconData(midItemValueList)
	if midItemValueList then
		local bonusIconInsLsit={}
		for i=1,#midItemValueList do
			bonusIconInsLsit[i]={}
			local iconItemValueList={1}	--第一个位置占位
			table.insert(iconItemValueList,midItemValueList[i])
			for j=1,#iconItemValueList do
				local tempBounsIconIns=IconManager.GetInstance():GetBonusIconItemInsByIconNum(iconItemValueList[j])
				if tempBounsIconIns then
					table.insert(bonusIconInsLsit[i],tempBounsIconIns)
				else
					Debug.LogError("初始化Bonus滚动图标实例异常")
				end
			end
			
		end
		
		for i=1,#bonusIconInsLsit do
			self.RunIconItemInsList[i]:AddMountPoint(bonusIconInsLsit[i])
			self.RunIconItemInsList[i]:SetIconInsList(bonusIconInsLsit[i])
		end
		
	end
end


function BonusManager:ResetMindIconAnimState()
	if self.RunIconItemInsList and #self.RunIconItemInsList>0 then 
		for i=1,4 do
			if self.RunIconItemInsList[i] then
				IconManager.GetInstance():StopPlayAssignIconInsAnim(self.RunIconItemInsList[i]:GetIconInsList())
			end
		end
	end
end



function BonusManager:StartRunMidIcon(isFuzzy)
	if self.RunIconItemInsList and #self.RunIconItemInsList>0 then 
		for i=1,4 do
			if self.RunIconItemInsList[i] then
				self.RunIconItemInsList[i]:NormalStartRun(3,isFuzzy)
			end
		end
	end
	
end


function BonusManager:StopRunMidIcon()
	local StopRunMidIconFunc=function ()
		if self.RunIconItemInsList and #self.RunIconItemInsList>0 then 
			for i=1,4 do
				if self.RunIconItemInsList[i] then
					local midRt={}
					local result=self.MidIconResult[i]
					if result then
						table.insert(midRt,result)
					else
						midRt={math.random(1,7)}
						Debug.LogError("Bonus的Mid结果异常")
					end
					self.RunIconItemInsList[i]:NormalStopRun(midRt)
					yield_return(WaitForSeconds(0.2))
				end
			end
		else
			Debug.LogError("Mid图标停止异常--初始化图标实例异常实例未找到")
		end
	end
	startCorotine(StopRunMidIconFunc)
end



function BonusManager:PlayMidSelectIconEffect(selectIndexList)
	self.MidRunItemView:HideAllSelectEffect()
	if selectIndexList and #selectIndexList>0 then
		for i=1,#selectIndexList do
			self.MidRunItemView:IsShowSelectEffect(selectIndexList[i])
		end
	end
	
end


function BonusManager:PlayMidWinIconInsAnim(winIconIndexList)
	self:ResetMindIconAnimState()
	if winIconIndexList and #winIconIndexList>0 then
		for i=1,#winIconIndexList do
			self.RunIconItemInsList[i]:GetSingleIconIns(2):PlayBaseIconAnim()
		end
	end
end


function BonusManager:PlayBonus(bonusMsg)
	self.PlayerMoney=bonusMsg.userScore
	self.BetChipValue=bonusMsg.chipScore
	self.PlayerWinScore=bonusMsg.winScore
	self.BonusTotalWinScore=bonusMsg.maryGameScore
	self.MidIconWinStateList=bonusMsg.innerWinIndex
	self:ResetMindIconAnimState()
	self:SetBonusRunResult(bonusMsg.outerIconId)
	self:SetBonusRemainCount(bonusMsg.leftPlayCount)
	self:SetMidIconResult(bonusMsg.innerIconId)
	self.MidRunItemView:HideAllSelectEffect()
	self:StartRunMidIcon(false)
end


function BonusManager:SetBonusRunResult(mainIconID)
	self.BonusMainIconID=mainIconID
	if mainIconID then
		local tempId=self.MainIconNumSortList[mainIconID][CommonHelper.GetRandomTwo(1,#self.MainIconNumSortList[mainIconID])]
		Debug.LogError("当前结果位置为==>"..tempId)
		local startPos=self.BonusIconManager:GetStartRunPos()
		self.BonusIconManager:SetMainIconRun(startPos,tempId)
	else
		Debug.LogError("Bonus主图标异常")
	end
end


function BonusManager:RefreshBonusViewData()
	self.BaseView:SetBonusRemainCount(self.RemainBonusCount)
	self.BaseView:SetBonusPlayerChipValue(self.PlayerMoney)
	self.BaseView:SetBonusWinScoreValue(self.BonusTotalWinScore)
	self.BaseView:SetPlayerBetValue(self.BetChipValue)
	
end


function BonusManager:SetMidIconWinState()
	if self.MidIconWinStateList  then
		local tempWinList={}
		--local midWinIconCoord={}
		for i=1,#self.MidIconWinStateList do
			if self.MidIconWinStateList[i]==1 then
				table.insert(tempWinList,i)
			end
		end
		self:PlayMidSelectIconEffect(tempWinList)
		self:PlayMidWinIconInsAnim()
	end
end


function BonusManager:SetMainIconEndRunCallBack()
	self:RefreshBonusViewData()
	self:SetMidIconWinState()
	self:PlayWinAuido()
end


function BonusManager:IsContinuePlayBonus()
	if self.RemainBonusCount>0 then
		GameUIManager.GetInstance():RequesBonusResultMsg(2)
	else
		self:SetEndBonus()
	end
end

function BonusManager:SetEndBonus()
	self.BonusView:SetBonusTotalWinScore(self.BonusTotalWinScore)
	self.BonusView:SetGameMainWinScore(self.GameMainWinScore)
	self.BonusView:IsShowEndBonusPanel(true)
end


function BonusManager:QuitBonus()
	self:IsShowBonusPanel(false)
	StateManager.GetInstance():GameStateOverCallBack()
end


function BonusManager:PlayWinAuido()
	if self.BonusMainIconID and self.RemainBonusCount>0 then
		if self.BonusMainIconID==0 then
			AudioManager.GetInstance():PlayNormalAudio(16)
		else
			AudioManager.GetInstance():PlayNormalAudio(17)
		end
	else
		if self.RemainBonusCount<=0 then
			AudioManager.GetInstance():PlayNormalAudio(15)
		end
	end
end





function BonusManager:__delete()
	
end