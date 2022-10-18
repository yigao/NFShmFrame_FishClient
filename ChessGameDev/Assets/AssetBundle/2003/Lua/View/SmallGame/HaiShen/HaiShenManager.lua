HaiShenManager=Class()

local Instance=nil
function HaiShenManager:ctor()
	Instance=self
	self:Init()
end

function HaiShenManager.GetInstance()
	if Instance==nil then
		Instance=HaiShenManager.New()
	end
	return Instance
end


function HaiShenManager:Init ()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView()
	self:InitInstance()
	self:AddEventListenner()
end



function HaiShenManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	
end

function HaiShenManager:AddScripts()
	self.ScriptsPathList={
			"/View/SmallGame/HaiShen/HSVo/HaiShenPanel",
		}
end


function HaiShenManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function HaiShenManager:InitView()
	
end


function HaiShenManager:InitInstance()
	self.HaiShenPanel=HaiShenPanel.New()
end



function HaiShenManager:InitHaiShenViewData(gameObj)
	if gameObj==nil then  Debug.LogError("海神Effect为nil") return end
	self.gameObject=gameObj
	self:IsShowHaiShenPanel(false)
	CommonHelper.ResetTransform(gameObj.transform)
	self.HaiShenPanel:ResetInit(gameObj)
end


function HaiShenManager:ResetHaiShenStateData(data)
	self.HaiShenPanel:IsShowLeavePanel(false)
	self.HaiShenPanel:IsShowWinScorePanel(0,true)
	self.HaiShenPanel:IsEnableBoxBtn(false)
	self.HaiShenPanel:ResetBox()
	self.HaiShenPanel:SetBaseScoreTips(data.baseScore)
	self.HaiShenPanel:SetScuessScoreTips(data.playCount,data.totalCount)
	self.HaiShenPanel:SetScuessScore(data.nextScore)
	self.HaiShenPanel:SetRetreatScore(data.totalScore)
	self.HaiShenPanel:SetCurrentScore(data.totalScore)
	self.HaiShenPanel:IsEnableBoxBtn(true)
	
	self:IsShowHaiShenPanel(true)
end



function HaiShenManager:IsShowHaiShenPanel(isShow)
	if self.gameObject then
		CommonHelper.SetActive(self.gameObject,isShow)
	end
end






--------------------------------------------------------------handle事件回调-----------------------------------------------------

function HaiShenManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_EnterMiniGameRsp"),self.ResponesEnterHaiShenMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_HaiShenResultRsp"),self.ResponesSelectBoxMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_FinishMiniGameRsp"),self.ResponesQuitMsg,self)
end


function HaiShenManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_EnterMiniGameRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_HaiShenResultRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_FinishMiniGameRsp"))	
end


function HaiShenManager:ResponesEnterHaiShenMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.EnterMiniGameRsp",msg)
	pt(data)
	
	if data.errorCode~=0 then
		Debug.LogError("海神玩法异常===>"..data.errorCode)
		return
	end
	
	if data.chair_id==self.gameData.PlayerChairId then
		SmallGameManager.GetInstance():EnterHaiShenGame(data)
	else
		--TODO设置其它玩家显示状态提示
		
	end
end


function HaiShenManager:RequestSelectBox(index)
	local sendMsg={}
	sendMsg.chair_id=self.gameData.PlayerChairId
	sendMsg.requestId=index
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.HaiShenResultReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_HaiShenResultReq"),bytes)
end


function HaiShenManager:ResponesSelectBoxMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.HaiShenResultRsp",msg)
	pt(data)
	if data.chair_id==self.gameData.PlayerChairId  then
		self:SetSelectBoxProcess(data)
	else
		
	end
end


function HaiShenManager:SetSelectBoxProcess(data)
	local SelectBoxProcessFunc=function ()
		
		
		local isWin=false
		if data.isReward== 1 then
			self.HaiShenPanel:IsShowSingleBoxPanel(data.requestId,2,true)
			isWin=true
			AudioManager.GetInstance():PlayNormalAudio(68)
		else
			self.HaiShenPanel:IsShowSingleBoxPanel(data.requestId,3,true)
			AudioManager.GetInstance():PlayNormalAudio(69)
		end
		yield_return(WaitForSeconds(1.5))
		if isWin then
			self.HaiShenPanel:SetTipsWinScore(data.totalScore)
			if data.playCount<data.totalCount then
				self.HaiShenPanel:IsShowWinScorePanel(2,true)
				yield_return(WaitForSeconds(1.5))
				self.HaiShenPanel:IsShowWinScorePanel(0,true)
				self.HaiShenPanel:ResetBox()
				yield_return(WaitForSeconds(0.5))
				self.HaiShenPanel:IsEnableBoxBtn(true)
			else
				self.HaiShenPanel:IsShowWinScorePanel(3,true)
			end
		else
			self.HaiShenPanel:SetTipsWinScore(data.baseScore)
			self.HaiShenPanel:IsShowWinScorePanel(1,true)
		end
		self.HaiShenPanel:SetScuessScoreTips(data.playCount,data.totalCount)
		self.HaiShenPanel:SetScuessScore(data.nextScore)
		self.HaiShenPanel:SetRetreatScore(data.totalScore)
		self.HaiShenPanel:SetCurrentScore(data.totalScore)
	end
	
	startCorotine(SelectBoxProcessFunc)
end


function HaiShenManager:RequestQuitGame()
	local sendMsg={}
	sendMsg.chair_id=self.gameData.PlayerChairId
	sendMsg.miniGameId=101
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.FinishMiniGameReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_FinishMiniGameReq"),bytes)
end

function HaiShenManager:ResponesQuitMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.FinishMiniGameRsp",msg)
	pt(data)
	if data.errorCode==0 then
		if data.chair_id==self.gameData.PlayerChairId then
			local DelayHideHaiShen=function ()
				if self.EndHaiShenTimer then
					TimerManager.GetInstance():RecycleTimerIns(self.EndHaiShenTimer)
				end
				self:IsShowHaiShenPanel(false)
				AudioManager.GetInstance():PlayBGAudio(40)
			end
			
			if data.finishType==0 then
				self.EndHaiShenTimer=TimerManager.GetInstance():CreateTimerInstance(4,DelayHideHaiShen)
			else
				DelayHideHaiShen()
			end
		end
	else
		Debug.LogError("海神结算异常===>>"..data.errorCode)
	end
end





function HaiShenManager:__delete()
	self:RemoveEventListenner()
	self.HaiShenPanel=nil
end


