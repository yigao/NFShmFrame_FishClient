CaiShenManager=Class()

local Instance=nil
function CaiShenManager:ctor()
	Instance=self
	self:Init()
end

function CaiShenManager.GetInstance()
	if Instance==nil then
		Instance=CaiShenManager.New()
	end
	return Instance
end


function CaiShenManager:Init ()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:AddEventListenner()
end



function CaiShenManager:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.GameConfig=self.gameData.GameConfig
	self.IconCInsList={}					--所有图标挂载列实例表
	self.AllIconItemInsList={}				--列索引对齐的图标实例列表
	self.MainIconImagePrefixName="Item"		--主游戏图标前缀
	self.CaiShenResultList={}
end

function CaiShenManager:AddScripts()
	self.ScriptsPathList={
			"View/SmallGame/CaiShen/Icon/View/IconView",
			"View/SmallGame/CaiShen/Icon/IconItem/IconBase",
			"View/SmallGame/CaiShen/Icon/IconItem/IconItem",
			"View/SmallGame/CaiShen/Icon/SCIcon/SCIconControl",
		}
end


function CaiShenManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function CaiShenManager:InitInstance()
	self.IconView=IconView.New(self.gameObject)
	self.IconItem=IconItem
	self.SCIconControl=SCIconControl
end


function CaiShenManager:InitView()
	self.IconItemList=self.IconView.IconItemList
	self.IconMountGroup=self.IconView.IconMountGroup
end



function CaiShenManager:ResetCaiShenViewData(gameObj)
	if gameObj==nil then  Debug.LogError("CaiShenEffect为nil") return end
	self.gameObject=gameObj
	self:IsShowCaiShenPanel(false)
	CommonHelper.ResetTransform(gameObj.transform)
	self:InitInstance()
	self:InitView()
	self:InitViewData()
end

function CaiShenManager:InitViewData()
	self:CreateIconItemPool()
	self:BuildSCIconControl()
	self:RandomBuildAllIcon(0)
end


function CaiShenManager:CreateIconItemPool()
	for i=1,#self.IconItemList do
		GameObjectPoolManager.GetInstance():AddGameObjectPool(self.IconItemList[i],5,self.IconItemList[i].gameObject.name,GameObjectPoolManager.PoolType.OtherPool)
	end
end


function CaiShenManager:BuildSCIconControl()
	for i=1,#self.IconMountGroup do
		local iconCInsT=self.SCIconControl.New(self.IconMountGroup[i])
		iconCInsT:SetColumnIndex(i)
		table.insert(self.IconCInsList,iconCInsT)
	end
end



function CaiShenManager:RandomBuildAllIcon(iconNum)
	local tempIconNumList={}
	for i=1,self.GameConfig.Coordinate_COL do
		tempIconNumList[i]={}
		for j=1,self.GameConfig.Coordinate_ROW+1 do
			local randomNum= iconNum or math.random(0,self.GameConfig.IconItemTotalCount-1)
			table.insert(tempIconNumList[i],randomNum)
		end
	end
	self:InitAllIconItem(tempIconNumList)
end


function CaiShenManager:InitAllIconItem(iconNumList)
	for i=1,#iconNumList do
		self.AllIconItemInsList[i]={}
		for j=1,#iconNumList[i] do
			local tempIconIns=self:GetMainIconItemInsByIconNum(iconNumList[i][j])
			table.insert(self.AllIconItemInsList[i],tempIconIns)
		end
	end
	
	for i=1,#self.AllIconItemInsList do
		self.IconCInsList[i]:AddMountPoint(self.AllIconItemInsList[i])
		self.IconCInsList[i]:SetIconInsList(self.AllIconItemInsList[i])
	end
end


function CaiShenManager:GetIconItem(keyName,poolType)
	return GameObjectPoolManager.GetInstance():GetGameObject(keyName,poolType)
end


function CaiShenManager:GetIconItembyIconNum(iconNum,iconPrefixName,poolType)
	local iconName=iconPrefixName..iconNum
	local tempIconItem=self:GetIconItem(iconName,poolType)
	return tempIconItem
end


function CaiShenManager:GetIconItemInsByIconItem(iconItemObj)
	local iconIns=self.IconItem.New()
	iconIns:BuildIconItem(iconItemObj)
	return iconIns
end


--获取主游戏图标项
function CaiShenManager:GetMainIconItemByIconNum(iconNum)
	local tempIconItem=self:GetIconItembyIconNum(iconNum,self.MainIconImagePrefixName,GameObjectPoolManager.PoolType.OtherPool)
	if tempIconItem then
		return tempIconItem
	else
		Debug.LogError("获取图标项失败==>"..iconNum)
	end
end


--获取主游戏中的图标实例
function CaiShenManager:GetMainIconItemInsByIconNum(iconNum)
	local tempIconItem=self:GetMainIconItemByIconNum(iconNum)
	if tempIconItem then
		return self:GetIconItemInsByIconItem(tempIconItem)
	end
	
end

--获取图标名字
function CaiShenManager:GetIconItemImageNameByIconNum(IconImagePrefixName,iconNum)
	return IconImagePrefixName..iconNum
end

--获取主图标名字
function CaiShenManager:GetMainIconItemImageNameByIconNum(iconNum)
	return self:GetIconItemImageNameByIconNum(self.MainIconImagePrefixName,iconNum)
end



function CaiShenManager:StartSingleColumnIconRun(columnIndex,speed,isFuzzy)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:NormalStartRun(speed,isFuzzy)
		else
			Debug.LogError("Start获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end



function CaiShenManager:StopSingleCoumnIconRun(columnIndex,columnIconResult,callBack)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:NormalStopRun(columnIconResult,callBack)
		else
			Debug.LogError("Stop获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end









function CaiShenManager:IsShowCaiShenPanel(isShow)
	if self.gameObject then
		CommonHelper.SetActive(self.gameObject,isShow)
	end
end



function CaiShenManager:ResetCaiShenStateData(data)
	self.CaiShenResultList =self:MapValue(data.winMul)
	self.WinScore=data.totalScore
	self.IconView:SetResultText(self.WinScore)
	self.IconView:IsShowResultPanel(false)
	self.IconView:IsShowStartPanel(true)
	self:StartRun(3)
	self:IsShowCaiShenPanel(true)
end



function CaiShenManager:StartRun(speed)
	local StartRunFunc=function ()
		for i=1,4 do
			self:StartSingleColumnIconRun(i,speed)
			yield_return(WaitForSeconds(0.2))
		end
		yield_return(WaitForSeconds(0.5))
		self:StopRun(1)
	end
	startCorotine(StartRunFunc)
end



function CaiShenManager:StopRun(index)
	local StopCallBackFunc=function (index)
		index=index+1
		if index<=4 then
			self:StopRun(index)
		else
			self.IconView:IsShowStartPanel(false)
			self.IconView:IsShowResultPanel(true)
			AudioManager.GetInstance():PlayNormalAudio(49)
			local DelayHideCaiShenFunc=function ()
				if self.CaiShenEndTimer then
					TimerManager.GetInstance():RecycleTimerIns(self.CaiShenEndTimer)
				end
				self:IsShowCaiShenPanel(false)
			end
			self.CaiShenEndTimer=TimerManager.GetInstance():CreateTimerInstance(2,DelayHideCaiShenFunc)
		end
	end
	
	self:StopSingleCoumnIconRun(index,self.CaiShenResultList[index],StopCallBackFunc)
end



function CaiShenManager:CheckScoreValue(score)
	local tempV={}
	local tempScore=CommonHelper.FormatBaseProportionalScore(score)
	tempScore=tostring(tempScore)
	for i=1,#tempScore do
		local v=string.sub(tempScore,i,i)
		if v=="." then
			return tempV
		else
			table.insert(tempV,v)
		end
	end
	return tempV
end


function CaiShenManager:MapValue(score)
	local tempV={0,0,0,0}
	local valueT =self:CheckScoreValue(score)
	local index=4
	for i=#valueT,1,-1 do
		tempV[index]=tonumber(valueT[i]) or 0
		index=index-1
	end
	return tempV
end




--------------------------------------------------------------handle事件回调-----------------------------------------------------

function CaiShenManager:AddEventListenner()
	LuaNetwork.RegisterNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_EnterCaiShenRsp"),self.ResponesEnterCaiShenMsg,self)
end

function CaiShenManager:RemoveEventListenner()
	LuaNetwork.RemoveNetMessage(LuaProtoBufManager.Enum("Fish_Msg.Proto_Fish_CMD","MSG_FishMiniGame_EnterCaiShenRsp"))
end

function CaiShenManager:ResponesEnterCaiShenMsg(msg)
	local data=LuaProtoBufManager.Decode("Fish_Msg.EnterCaiShenRsp",msg)
	pt(data)
	if data.chair_id==self.gameData.PlayerChairId then
		SmallGameManager.GetInstance():EnterCaiShenGame(data)
	end
end





function CaiShenManager:__delete()
	self:RemoveEventListenner()
	
end