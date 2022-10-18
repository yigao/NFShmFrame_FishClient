JinNiuManager=Class()

local Instance=nil
function JinNiuManager:ctor()
	Instance=self
	self:Init()
end

function JinNiuManager.GetInstance()
	if Instance==nil then
		Instance=JinNiuManager.New()
	end
	return Instance
end


function JinNiuManager:Init ()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView()
	self:InitInstance()
	self:AddEventListenner()
end



function JinNiuManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	
end

function JinNiuManager:AddScripts()
	self.ScriptsPathList={
			"/View/SmallGame/JinNiu/JNVo/JinNiuPanel",
		}
end


function JinNiuManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end


function JinNiuManager:InitView()
	
end


function JinNiuManager:InitInstance()
	self.JinNiuPanel=JinNiuPanel.New()
end



function JinNiuManager:ResetJinNiuViewData(gameObj)
	if gameObj==nil then  Debug.LogError("JinNiuEffect为nil") return end
	self.gameObject=gameObj
	self:IsShowJinNiuPanel(false)
	CommonHelper.ResetTransform(gameObj.transform)
	self.JinNiuPanel:ResetInit(gameObj)
end



function JinNiuManager:IsShowJinNiuPanel(isShow)
	if self.gameObject then
		CommonHelper.SetActive(self.gameObject,isShow)
	end
end



function JinNiuManager:ResetXYJinNiuStateData(data)
	self.prizeValues=data.prizeValues
	self.JinNiuPanel:SetAllItemPrizeResult(data.prizeValues)
	self.JinNiuPanel:IsShowResultPanel(false)
	self.JinNiuPanel:IsEnableStartBtn(true)
	self:IsShowJinNiuPanel(true)
end






--------------------------------------------------------------handle事件回调-----------------------------------------------------

function JinNiuManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_EnterGoldenBullRsp"),self.ResponesEnterJinNiuMsg,self)
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_GoldenBullResultRsp"),self.ResponesResultJinNiuMsg,self)
end


function JinNiuManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_EnterGoldenBullRsp"))
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_GoldenBullResultRsp"))
end



function JinNiuManager:ResponesEnterJinNiuMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.EnterGoldenBullRsp",msg)
	pt(data)
	if data.chair_id==self.gameData.PlayerChairId then
		SmallGameManager.GetInstance():EnterXYJiNiuGame(data)
	end
	
end


function JinNiuManager:RequestStart()
	local sendMsg={}
	sendMsg.chair_id=self.gameData.PlayerChairId
	local bytes = LuaProtoBufManager.Encode("Fish_Msg.GoldenBullResultReq",sendMsg)
	GameManager.GetInstance():SendNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_GoldenBullResultReq"),bytes)
end


function JinNiuManager:ResponesResultJinNiuMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.GoldenBullResultRsp",msg)
	pt(data)
	if data.chair_id==self.gameData.PlayerChairId then
		local PlayXYJNFunc=function ()
			self.JinNiuPanel:PlayAnim()
			yield_return(WaitForSeconds(0.3))
			self.JinNiuPanel:SetJinNiuResult(data.prizeIndex,data.totalScore)
			self.JinNiuPanel:SetSelectResult(data.prizeIndex,data.totalScore)
			yield_return(WaitForSeconds(1))
			self.JinNiuPanel:IsShowResultPanel(true)
			yield_return(WaitForSeconds(3))
			self:IsShowJinNiuPanel(false)
		end
		
		startCorotine(PlayXYJNFunc)
	end
end


function JinNiuManager:__delete()
	self:RemoveEventListenner()
	self.JinNiuPanel=nil
end

