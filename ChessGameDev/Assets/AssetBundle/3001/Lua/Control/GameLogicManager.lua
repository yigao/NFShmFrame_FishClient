GameLogicManager=Class()

local Instance=nil
function GameLogicManager:ctor()
	Instance=self
	self:Init()
end

function GameLogicManager.GetInstance()
	return Instance
end



function GameLogicManager:Init()
	self:InitData()
	
end




function GameLogicManager:InitData()
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.gameData=GameManager.GetInstance().gameData
	self.DOTween = GameManager.GetInstance().DOTween
	self.Ease =GameManager.GetInstance().Ease
	
	
end


function GameLogicManager:HideAllGamePanel()
	self:ResetAllGamePanelState()
	PlayerManager.GetInstance():ClearAllPlayerState()
end


function GameLogicManager:ResetAllGamePanelState()
	TipsManager.GetInstance():HideAllTipsPanel()
	SetManager.GetInstance():InitPlayerSetPanel()
end


function GameLogicManager:SetMyObsevedStateProcessTips()
	local isObservedState =PlayerManager.GetInstance():GetMyObservedState()
	if isObservedState then
		TipsManager.GetInstance():PlayWaitTipsPanel(2,true)
	end	
end




function GameLogicManager:InitQiangZhuangState(data)
	for i=1,#data.Players do
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(data.Players[i].chairId)
		if playerIns then
			local isObservedState=playerIns:GetObservedState()	
			if isObservedState==false then
				local isQiangZhuang=data.Players[i].isQiang
				if isQiangZhuang then
					if data.Players[i].index>0 then
						playerIns:SetQiangZhuangMultipleTipsValue(data.Players[i].index)
						playerIns:IsShowBetTips(2,true)
					else
						playerIns:IsShowBetTips(1,true)
					end
					
				else
					if data.Players[i].chairId==self.gameData.PlayerChairId then
						if data.Players[i].index<0 then
							TipsManager.GetInstance():SetCountDownTimer(2,data.curStausLeftTime)
							SetManager.GetInstance():IsShowQiangZhunagBtnPanel(true)
						else
							TipsManager.GetInstance():SetCountDownTimer(3,data.curStausLeftTime)
							playerIns:IsShowBetTips(1,true)
						end
					end
				end
								
			end

		end
		
	end
	
	
end



function GameLogicManager:InitAllocateGrabTheVillage(data)
	for i=1,#data.Players do
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(data.Players[i].chairId)
		if playerIns then
			local isObservedState=playerIns:GetObservedState()
			if isObservedState==false then
				
				if data.Players[i].index>0 then
					playerIns:SetQiangZhuangMultipleTipsValue(data.Players[i].index)
					playerIns:IsShowBetTips(2,true)
				else
					playerIns:IsShowBetTips(1,true)
				end
			
				if data.Players[i].chairId==self.gameData.ZJChairId then
					playerIns:SetSelectZhuangJia()
				end
				
			end
		end
	end
end


function GameLogicManager:InitBetState(data)
	for i=1,#data.Players do
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(data.Players[i].chairId)
		if playerIns then
			local isObservedState=playerIns:GetObservedState()
			if isObservedState==false then
				if data.Players[i].chairId==self.gameData.ZJChairId then
					playerIns:SetQiangZhuangMultipleTipsValue(data.Players[i].index)
					playerIns:IsShowBetTips(2,true)
					playerIns:SetSelectZhuangJia()
				end
				
				local isXiaZhu=data.Players[i].isXiaZhu
				if isXiaZhu then
					playerIns:SetBetMultipleTipsValue(data.Players[i].index)
					playerIns:IsShowBetTips(3,true)
				end
				
				if data.Players[i].chairId==self.gameData.PlayerChairId then
					if isXiaZhu then
						TipsManager.GetInstance():SetCountDownTimer(5,data.curStausLeftTime)
					else
						if self.gameData.PlayerChairId==self.gameData.ZJChairId then
							TipsManager.GetInstance():SetCountDownTimer(5,data.curStausLeftTime)
						else
							TipsManager.GetInstance():SetCountDownTimer(4,data.curStausLeftTime)
							SetManager.GetInstance():IsShowBetBtnPanel(true)
						end
						
					end
					
				end
				
			end
		end
	end
end


function GameLogicManager:InitSendCardState(data)
	for i=1,#data.Players do
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(data.Players[i].chairId)
		if playerIns then
			local isObservedState=playerIns:GetObservedState()
			if isObservedState==false then
				if data.Players[i].chairId==self.gameData.ZJChairId then
					playerIns:SetQiangZhuangMultipleTipsValue(data.Players[i].index)
					playerIns:IsShowBetTips(2,true)
					playerIns:SetSelectZhuangJia()
				else
					playerIns:SetBetMultipleTipsValue(data.Players[i].index)
					playerIns:IsShowBetTips(3,true)
				end
				
				AudioManager.GetInstance():PlayNormalAudio(22)
				playerIns:IsShowCard(1,true)
				if data.Players[i].chairId==self.gameData.PlayerChairId then
					local DelayShowKanPaiFunc=function ()
						TimerManager.GetInstance():RecycleTimerIns(self.DelayKanPaiTimer)
						--local playerIns=self:GetPlayerInsByChairdId(self.gameData.PlayerChairId)
						if playerIns then
							playerIns:IsShowCard(2,true)
						end 
					end
					
					playerIns:SetKanPaiValue(data.Players[i].cards)
					self.DelayKanPaiTimer=TimerManager.GetInstance():CreateTimerInstance(0.8,DelayShowKanPaiFunc)
					
				end
				
			end
		end
	end
end



function GameLogicManager:InitOpenCardState(data)
	for i=1,#data.Players do
		local playerIns=PlayerManager.GetInstance():GetPlayerInsByChairdId(data.Players[i].chairId)
		if playerIns then
			local isObservedState=playerIns:GetObservedState()
			if isObservedState==false then
				if data.Players[i].chairId==self.gameData.ZJChairId then
					playerIns:SetQiangZhuangMultipleTipsValue(data.Players[i].index)
					playerIns:IsShowBetTips(2,true)
					playerIns:SetSelectZhuangJia()
				else
					playerIns:SetBetMultipleTipsValue(data.Players[i].index)
					playerIns:IsShowBetTips(3,true)
				end
				
				playerIns:SetKanPaiValue(data.Players[i].cards)
				playerIns:IsShowCard(2,true)
				
				local isKaiPai=data.Players[i].isKaiPai
				if isKaiPai then
					playerIns:SetTanPaiValue(data.Players[i].cards)
					playerIns:IsShowCard(3,true)
					playerIns:SetOpenAward(data.Players[i].cardType)
				end
				
				if data.Players[i].chairId==self.gameData.PlayerChairId then
					if isKaiPai then
						TipsManager.GetInstance():SetCountDownTimer(7,data.curStausLeftTime)
					else
						TipsManager.GetInstance():SetCountDownTimer(6,data.curStausLeftTime)
						SetManager.GetInstance():IsShowTanPaiBtnPanel(true)
					end
					
				end
				
			end
		end
	end
end







function GameLogicManager:__delete()

end


