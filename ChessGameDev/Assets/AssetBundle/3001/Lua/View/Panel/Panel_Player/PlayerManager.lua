PlayerManager=Class()

local Instance=nil
function PlayerManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function PlayerManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Player
		local BuildPlayerPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				PlayerManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildPlayerPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function PlayerManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function PlayerManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function PlayerManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitPlayerIns()
end


function PlayerManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.PlayerInsList={}
	
end


function PlayerManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Player/View/PlayerView",
		"View/Panel/Panel_Player/Player/Player",
		"View/Panel/Panel_Player/Player/PlayerInfoView",
	}
end


function PlayerManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function PlayerManager:InitInstance()
	self.PlayerView=PlayerView.New(self.gameObject)
	self.Player=Player
	self.PlayerInfoView=PlayerInfoView
end


function PlayerManager:InitView()
	self.playerObjList=self.PlayerView.playerObjList
end


function PlayerManager:InitPlayerIns()
	for i=1,#self.playerObjList do
		local tempPlayerIns=self.Player.New(self.playerObjList[i])
		table.insert(self.PlayerInsList,tempPlayerIns)
	end
end



function PlayerManager:InitEnterPlayer(Players)
	for i=1,#Players do
		self:PlayerEnter(Players[i])
	end
end


function PlayerManager:ClearAllPlayerState()
	for i=1,#self.PlayerInsList do
		self.PlayerInsList[i]:LeaveGame()
	end
end


function PlayerManager:ResetAllPlayerPanelState()
	for i=1,#self.PlayerInsList do
		self.PlayerInsList[i]:InitAllPanel()
	end
end


function PlayerManager:ResetAllPlayerdStateData(playersInfo)
	for k,v in ipairs(playersInfo) do
		local playerIns=self:GetPlayerInsByChairdId(v.chairId)
		if playerIns then
			pt(v)
			playerIns:ResetPlayerStateData(v)
		end
	end
end


function PlayerManager:GetPlayerInsBySeatId(index)
	return self.PlayerInsList[index]
end

function PlayerManager:GetPlayerInsByChairdId(chairId)
	local playerIndex=GameManager.GetInstance():GetChessCardPlayerSeatByServerChairId(chairId)
	local playerIns=self:GetPlayerInsBySeatId(playerIndex)
	if playerIns then
		return playerIns
	else
		Debug.LogError("获取玩家实例异常==>"..chairId)
		return nil
	end
end


function PlayerManager:GetMyObservedState()
	local isMyObersevedState=false
	local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(self.gameData.PlayerChairId)
	if playerIns then
		isMyObersevedState=playerIns:GetObservedState()
	end
	return isMyObersevedState
end



function PlayerManager:PlayerEnter(playerInfo)
	local playerIns=self:GetPlayerInsByChairdId(playerInfo.chairId)
	if playerIns then
		playerIns:EnterGame(playerInfo)
	else
		Debug.LogError("当前位置玩家进入异常==>"..playerInfo.chairId)
	end
end


function PlayerManager:OtherPlayerLeave(playerChairID)
	local playerIns=self:GetPlayerInsByChairdId(playerChairID)
	if playerIns then
		playerIns:LeaveGame()
	else
		Debug.LogError("当前位置玩家离开异常==>"..playerChairID)
	end
end


function PlayerManager:SetPlayerQiangZhuangTips(qzInfo)
	local playerIns=self:GetPlayerInsByChairdId(qzInfo.usChairId)
	if playerIns then
		if qzInfo.bIsQiang then
			playerIns:SetQiangZhuangMultipleTipsValue(qzInfo.qiangIndex)
			playerIns:IsShowBetTips(2,true)
		else
			playerIns:IsShowBetTips(1,true)
		end
	end
end


function PlayerManager:SetPlayerBetTips(betInfo)
	local playerIns=self:GetPlayerInsByChairdId(betInfo.usChairId)
	if playerIns then
		playerIns:SetBetMultipleTipsValue(betInfo.n64BetMulIndex)
		playerIns:IsShowBetTips(3,true)
	end
end



function PlayerManager:AllocateZhuangJiaTips(zjInfo)
	local SelectZhuangJiaTipsFunc=function ()
		TimerManager.GetInstance():RecycleTimerIns(self.DelaySelectZhuangJiaTimer)
		local playerIns=self:GetPlayerInsByChairdId(zjInfo.usChairId)
		if playerIns then
			playerIns:SetSelectZhuangJia()
		end 
	end
	if zjInfo.maxMulQiangNt and #zjInfo.maxMulQiangNt>1 then
		for i=1,#zjInfo.maxMulQiangNt do
			local playerIns=self:GetPlayerInsByChairdId(zjInfo.maxMulQiangNt[i])
			if playerIns then
				playerIns:PlaySelectZhuangJiaEffect()
			end 
		end
		
		self.DelaySelectZhuangJiaTimer=TimerManager.GetInstance():CreateTimerInstance(0.8,SelectZhuangJiaTipsFunc)
	else
		self.DelaySelectZhuangJiaTimer=TimerManager.GetInstance():CreateTimerInstance(0.5,SelectZhuangJiaTipsFunc)
	end
	
end



function PlayerManager:SendCard(playerCardInfo)
	local DelayShowKanPaiFunc=function ()
		TimerManager.GetInstance():RecycleTimerIns(self.DelayKanPaiTimer)
		local playerIns=self:GetPlayerInsByChairdId(self.gameData.PlayerChairId)
		if playerIns then
			playerIns:IsShowCard(2,true)
		end 
	end
	if playerCardInfo and #playerCardInfo>1 then
		for i=1,#playerCardInfo do
			local playerIns=self:GetPlayerInsByChairdId(playerCardInfo[i].usChairId)
			if playerIns then
				if playerCardInfo[i].usChairId==self.gameData.PlayerChairId and playerIns:GetObservedState()==false then
					playerIns:SetKanPaiValue(playerCardInfo[i].cards)
					self.DelayKanPaiTimer=TimerManager.GetInstance():CreateTimerInstance(1,DelayShowKanPaiFunc)
				end
				if playerIns:GetObservedState()==false then
					playerIns:IsShowCard(1,true)
				end
				
			end 
		end
		
	end
end


function PlayerManager:TPCard(playerCardInfo)
	local playerIns=self:GetPlayerInsByChairdId(playerCardInfo.usChairId)
	if playerIns then
		playerIns:SetTanPaiValue(playerCardInfo.cards)
		playerIns:IsShowCard(3,true)
		playerIns:SetOpenAward(playerCardInfo.cardType)
		if playerCardInfo.cardType<11 then
			AudioManager.GetInstance():PlayNormalAudio(playerCardInfo.cardType+2)
		end
		
	end
end



function PlayerManager:SetSettleAccounts(playerInfoList)
	if playerInfoList and #playerInfoList>0 then
		local playerAccountStatelist={}
		playerAccountStatelist.WinInsList={}
		playerAccountStatelist.LoseInsList={}
		for i=1,#playerInfoList do
			local playerIns=self:GetPlayerInsByChairdId(playerInfoList[i].chairId)
			if playerIns then
				playerIns:SetPlayerGetScoreTips(playerInfoList[i].userWinMoney)
				playerIns:SetPlayerMoney(playerInfoList[i].userMoney)
				
				if self.gameData.PlayerChairId==playerInfoList[i].chairId then
					if playerInfoList[i].userWinMoney>0 then
						AudioManager.GetInstance():PlayNormalAudio(20)
						TipsManager.GetInstance():PlayGameResultTipsPanel(1,true)
					elseif playerInfoList[i].userWinMoney<0 then
						AudioManager.GetInstance():PlayNormalAudio(19)
						TipsManager.GetInstance():PlayGameResultTipsPanel(2,true)
					end
				end
				
				if self.gameData.ZJChairId==playerInfoList[i].chairId then
					playerAccountStatelist.ZhuangJiaIns=playerIns
				else
					if playerInfoList[i].userWinMoney>0 then
						table.insert(playerAccountStatelist.WinInsList,playerIns)
					else
						table.insert(playerAccountStatelist.LoseInsList,playerIns)
					end
				end
			end
		end
		
		
		self:SetPlayerGoldFlyEffect(playerAccountStatelist)
		
	end
end


function PlayerManager:SetPlayerGoldFlyEffect(playerAccountStatelist)
	local GoldFlyEffectFunc=function ()
		local zhuangJiaEffectPos=playerAccountStatelist.ZhuangJiaIns:GetGoldFlyEffectPos()
		if #playerAccountStatelist.LoseInsList>0 then
			AudioManager.GetInstance():PlayNormalAudio(18)
			for i=1,#playerAccountStatelist.LoseInsList do
				local losePos=playerAccountStatelist.LoseInsList[i]:GetGoldFlyEffectPos()
				ParticleManager.GetInstance():SetParabolaItemEffect(losePos,zhuangJiaEffectPos)
			end
			yield_return(WaitForSeconds(1))
		end
		
		if #playerAccountStatelist.WinInsList>0 then
			AudioManager.GetInstance():PlayNormalAudio(18)
			for i=1,#playerAccountStatelist.WinInsList do
				local winPos=playerAccountStatelist.WinInsList[i]:GetGoldFlyEffectPos()
				ParticleManager.GetInstance():SetParabolaItemEffect(zhuangJiaEffectPos,winPos)
			end
			yield_return(WaitForSeconds(1))
		end
		
	end
	
	startCorotine(GoldFlyEffectFunc)
end




function PlayerManager:__delete()

end