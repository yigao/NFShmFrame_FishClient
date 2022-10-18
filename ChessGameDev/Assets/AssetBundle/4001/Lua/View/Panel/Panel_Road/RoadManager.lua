RoadManager=Class()

local Instance=nil
function RoadManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end

function RoadManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Road
		local BuildBGPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				RoadManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildBGPanelCallBack)
		
	else
		return Instance
	end
end


function RoadManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end

function RoadManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end

function RoadManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitView()
	self:InitInstance()
end


function RoadManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.history = {}
	self.eyeRoadDataList ={}
	self.smallRoadDataList = {}
	self.yueYouRoadDataList = {}
	self.Row = 6
end

function RoadManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Road/BeadPlateRoadView/BeadPlateRoadView",
		"View/Panel/Panel_Road/BeadPlateRoadView/BeadPlateRoadItem/BeadPlateRoadItem",--BigRoadView
		
		"View/Panel/Panel_Road/BigRoadView/BigRoadView",
		"View/Panel/Panel_Road/BigRoadView/BigRoadItem/BigRoadItem",
		
		"View/Panel/Panel_Road/EyeRoadView/EyeRoadView",
		"View/Panel/Panel_Road/EyeRoadView/EyeRoadItem/EyeRoadItem",
		
		"View/Panel/Panel_Road/SmallRoadView/SmallRoadView",
		"View/Panel/Panel_Road/SmallRoadView/SmallRoadItem/SmallRoadItem",
		
		"View/Panel/Panel_Road/YueYouRoadView/YueYouRoadView",
		"View/Panel/Panel_Road/YueYouRoadView/YueYouRoadItem/YueYouRoadItem",

		"View/Panel/Panel_Road/NextResultView/NextResultView",

		"View/Panel/Panel_Road/RoadView/RoadView",
	}
end

function RoadManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end

function RoadManager:InitView()
	self:IsShowRoadPanel(false)
end

function RoadManager:InitInstance()
	self.BeadPlateRoadItem = BeadPlateRoadItem
	self.BeadPlateRoadView = BeadPlateRoadView.New(self.gameObject)
	
	self.BigRoadItem = BigRoadItem
	self.BigRoadView = BigRoadView.New(self.gameObject)
	
	self.EyeRoadItem = EyeRoadItem
	self.EyeRoadView =EyeRoadView.New(self.gameObject)

	self.SmallRoadItem = SmallRoadItem
	self.SmallRoadView =SmallRoadView.New(self.gameObject)

	self.YueYouRoadItem = YueYouRoadItem
	self.YueYouRoadView = YueYouRoadView.New(self.gameObject)

	self.NextResultView = NextResultView.New(self.gameObject)

	self.RoadView = RoadView.New(self.gameObject)
end


function RoadManager:GetDragonNumber()
	local number = 0
	for i = 1,#self.gameData.PrizeHistoryRecord do
		if self.gameData.PrizeHistoryRecord[i] == 1 then
			number = number + 1
		end
	end
	return number
end

function RoadManager:GetTigerNumber()
	local number = 0
	for i = 1,#self.gameData.PrizeHistoryRecord do
		if self.gameData.PrizeHistoryRecord[i] == 3 then
			number = number + 1
		end
	end
	return number
end

function RoadManager:GetPeaceNumber()
	local number = 0
	for i = 1,#self.gameData.PrizeHistoryRecord do
		if self.gameData.PrizeHistoryRecord[i] == 2 then
			number = number + 1
		end
	end
	return number
end


--大路数据
function RoadManager:CreateBigRoadData(historyRecord)
	local tmpHistory = {}
	if historyRecord or #historyRecord > 0 then
		for i = 1,#historyRecord do
			local data = {}
			data.XPoint = 0
			data.YPoint = 0
			data.WinResult = historyRecord[i]
			table.insert(tmpHistory,data)
		end
	end

	local size = #tmpHistory
	local  data = {XPoint = -1,
				   YPoint = -1,
				   WinResult = -1,
				  }

	for i=1,size do 
		data.YPoint = tmpHistory[i].YPoint
		data.XPoint = tmpHistory[i].XPoint
		data.WinResult = tmpHistory[i].WinResult
		if i==1 then
			tmpHistory[i].XPoint = 1
			tmpHistory[i].YPoint = 1
		else
			local lastData = {
				YPoint = tmpHistory[i-1].YPoint,
				XPoint = tmpHistory[i-1].XPoint,
				WinResult = tmpHistory[i-1].WinResult,
			}

			--避免上个是和就换列
			local backNot2 = -1
			if lastData.WinResult == 2 and i >= 3 then
				for m = 2,i do
					if i > m and tmpHistory[i-m].WinResult ~= 2 then
						backNot2 = tmpHistory[i-m].WinResult
						break
					end
				end
			end

			--结果和上一个相等，而且结果不为和
			if data.WinResult==lastData.WinResult and data.WinResult~=2 then
				local flag = true
				for j=1 ,i-1 do
				   local oldHistory = {
						YPoint = tmpHistory[j].YPoint,
						XPoint = tmpHistory[j].XPoint,
						WinResult = tmpHistory[j].WinResult,
					}
					--检查同一列的下一个空格是否设置了结果,如果设置了结果x往右移
					if lastData.YPoint+1 == oldHistory.YPoint and  lastData.XPoint== oldHistory.XPoint then
						flag = false
						tmpHistory[i].XPoint= lastData.XPoint+1
						tmpHistory[i].YPoint= lastData.YPoint
					end
				end
				--当结果放置到同一列下标为6的空格时，竖坐标不变，横坐标往右移一
				if flag == true then
					if lastData.YPoint == 6 then
						tmpHistory[i].YPoint= 6
						tmpHistory[i].XPoint=lastData.XPoint+1
					else
						tmpHistory[i].XPoint= lastData.XPoint
						tmpHistory[i].YPoint= lastData.YPoint+1
					end
				end
			end
			-- 当结果和上一个相等，而且结果为和的时候
			if data.WinResult==lastData.WinResult  and data.WinResult==2 then
				tmpHistory[i].XPoint= lastData.XPoint
				tmpHistory[i].YPoint= lastData.YPoint
			end
			--当结果和上一个不相等的时候，而且不为和的时候
			if data.WinResult ~= lastData.WinResult  and data.WinResult~=2 then
				--结果在路子图第一行的有几个
				local oneLuziNum = 1
				for j=1,i-1 do
					local oldLuzi = {
						YPoint = tmpHistory[j].YPoint,
						XPoint = tmpHistory[j].XPoint,
						WinResult = tmpHistory[j].WinResult,
					}
					if oldLuzi.YPoint==1 and oldLuzi.WinResult~=2 then
						oneLuziNum = oneLuziNum+1
					end
				end
				if lastData.WinResult == 2 and data.WinResult == backNot2 then
					local flag = true
					for j=1 ,i-1 do
						local oldHistory = {
							 YPoint = tmpHistory[j].YPoint,
							 XPoint = tmpHistory[j].XPoint,
							 WinResult = tmpHistory[j].WinResult,
						 }
						 --检查同一列的下一个空格是否设置了结果,如果设置了结果x往右移
						 if lastData.YPoint+1 == oldHistory.YPoint and  lastData.XPoint== oldHistory.XPoint then
							 flag = false
							 tmpHistory[i].XPoint= lastData.XPoint+1
							 tmpHistory[i].YPoint= lastData.YPoint
						 end
					 end

					--当结果放置到同一列下标为6的空格时，竖坐标不变，横坐标往右移一
					if flag == true then
						if lastData.YPoint==6 then
							tmpHistory[i].YPoint=6
							tmpHistory[i].XPoint=lastData.XPoint+1
						else
							tmpHistory[i].XPoint= lastData.XPoint
							tmpHistory[i].YPoint= lastData.YPoint+1
						end
					end
				else
					tmpHistory[i].YPoint= 1
					tmpHistory[i].XPoint= oneLuziNum
				end
			end
			--当结果和上一个不相等，而且结果为和的时候
			if data.WinResult~=lastData.WinResult  and data.WinResult==2 then
				tmpHistory[i].XPoint= lastData.XPoint
				tmpHistory[i].YPoint= lastData.YPoint
			end
		end
	end
	return tmpHistory
end

--大眼仔数据
function RoadManager:CreateEyeRoadData(historyValue)
	local size =#historyValue
	
	local tmpEyeRoadList = {}
	
	local m_luzi = {YPoint = 0,
					XPoint = 0,
					WinResult = 0,
				   }

	for i=1 ,size do
		m_luzi.YPoint = historyValue[i].YPoint
		m_luzi.XPoint = historyValue[i].XPoint
		m_luzi.WinResult = historyValue[i].WinResult
	-- 	m_luzi.byCardtype = history[i].byCardtype
		local x = m_luzi.XPoint
		local y = m_luzi.YPoint
		if m_luzi.WinResult == 2 then --和局不判断
			x = -1
			y = -1
		end
		if y == 1 then
			if x >= 3 then
				local item = {XPoint=255,YPoint=255,WinResult=255}
				--前一列和前二列有相同的个数(齐脚用红，不齐脚用蓝)
				if self:GetDaluXDataNumber(historyValue,x,2) then
					item.WinResult = 1
				else
					item.WinResult = 0
				end
				table.insert(tmpEyeRoadList,item)
			end
		elseif y > 1 then
			if x >= 2 then
				local item = {XPoint=255,YPoint=255,WinResult=255}
				--水平向前有结果为红，没有结果为蓝
				--如果前两个水平对齐都为无值则为红色
				local lastOne =self:GetDaluXLastResultEqually(historyValue,x, y, 1)
				local lastTwo =self:GetDaluXLastResultEqually(historyValue,x, y-1, 1)
				if lastOne or (lastOne==false and lastTwo==false) then
					item.WinResult = 1
				else
					item.WinResult = 0
				end
				table.insert(tmpEyeRoadList,item)
			end
		end
	end
	return self:InitXiaSanLuXY(tmpEyeRoadList)
end

--小路数据
function RoadManager:CreateSmallRoadData(historyValue)
	local size =#historyValue
	local tmpSmallRoadList = {}
	local m_luzi = {YPoint = -1,
					XPoint = -1,
					WinResult = -1,
					}

	for i=1, size do
		--byWinResult//赢的区域 0=闲 1-庄 2-和,,byCardtype;0=闲对 1-庄对 2-庄对和闲对
		m_luzi.YPoint = historyValue[i].YPoint
		m_luzi.XPoint = historyValue[i].XPoint
		m_luzi.WinResult = historyValue[i].WinResult
		
		local x = m_luzi.XPoint
		local y = m_luzi.YPoint
		if m_luzi.WinResult == 2 then --和局不判断
			x = -1
			y = -1
		end
		if y == 1 then
			if x >= 4 then
				local item = {XPoint=255,YPoint=255,WinResult=255}
				--前一列和前三列有相同的个数(齐脚用红，不齐脚用蓝)
				if self:GetDaluXDataNumber(historyValue,x,3) then
					item.WinResult = 1
				else
					item.WinResult = 0
				end
				table.insert(tmpSmallRoadList,item)
			end
		elseif y > 1 then
			if x >= 3 then
				local item = {XPoint=255,YPoint=255,WinResult=255}
				--水平向前有结果为红，没有结果为蓝
				--如果前两个水平对齐都为无值则为红色
				local lastOne =self:GetDaluXLastResultEqually(historyValue,x, y, 2)
				local lastTwo =self:GetDaluXLastResultEqually(historyValue,x, y-1, 2)
				if lastOne or (lastOne==false and lastTwo==false) then
					item.WinResult = 1
				else
					item.WinResult = 0
				end
				table.insert(tmpSmallRoadList,item)
			end
		end

	end
	return self:InitXiaSanLuXY(tmpSmallRoadList)
end

--曱甴路
function RoadManager:CreateYueYouRoadData(historyValue)
	local size =#historyValue
	local tmpYueYouRoadList = {}
	local m_luzi = {YPoint = -1,
					XPoint = -1,
					WinResult = -1,
					}

	for i=1 ,size  do
		--byWinResult//赢的区域 0=闲 1-庄 2-和,,byCardtype;0=闲对 1-庄对 2-庄对和闲对

		m_luzi.YPoint = historyValue[i].YPoint
		m_luzi.XPoint = historyValue[i].XPoint
		m_luzi.WinResult = historyValue[i].WinResult

		local x = m_luzi.XPoint
		local y = m_luzi.YPoint
		if m_luzi.WinResult == 2 then --和局不判断
			x = -1
			y = -1
		end
		if y == 1 then
			if x >= 5 then
				local item = {XPoint=255,YPoint=255,WinResult=255}
				--前一列和前三列有相同的个数(齐脚用红，不齐脚用蓝)
			
				if self:GetDaluXDataNumber(historyValue,x,4) then
					item.WinResult = 1
				else
					item.WinResult = 0
				end
				table.insert(tmpYueYouRoadList,item)
			end
		elseif y > 1 then
			if x >= 4 then
				
				local item = {XPoint=255,YPoint=255,WinResult=255}
				--水平向前有结果为红，没有结果为蓝
				--如果前两个水平对齐都为无值则为红色
				local lastOne =self:GetDaluXLastResultEqually(historyValue,x, y, 3)
				local lastTwo =self:GetDaluXLastResultEqually(historyValue,x, y-1, 3)
				if lastOne or (lastOne==false and lastTwo==false) then
					item.WinResult = 1
				else
					item.WinResult = 0
				end
				table.insert(tmpYueYouRoadList,item)
			end
		end
	end
	return self:InitXiaSanLuXY(tmpYueYouRoadList)
end

--获取前showNum列对应的y是否有值
function RoadManager:GetDaluXLastResultEqually(historyValue,xIndex,yIndex,showNum)
	size = #historyValue
	local data ={YPoint = -1,
				 XPoint = -1,
				 WinResult = -1,}
	for i=1,size do
		--byWinResult//赢的区域 龙-1 虎-3 和-2
		data.YPoint = historyValue[i].YPoint
		data.XPoint = historyValue[i].XPoint
		data.WinResult = historyValue[i].WinResult
		if data.XPoint==(xIndex-showNum) and data.YPoint==yIndex and data.WinResult~=2 then
			return true
		end
	end
	return false
end


--获取大路前一列和前面第三列是否有一样个数的结果
function RoadManager:GetDaluXDataNumber(historyValue,xIndex,showNum)
	local  size = #historyValue
	local xNumber=0               --前一列列个数
	local lastXNumber=0           --前二列个数
	local data = {YPoint = -1,
				  XPoint = -1,
				  WinResult = -1,}

	for i=1,size do
		--WinResult//赢的区域 龙-1  和-2 虎-3
		data.YPoint = historyValue[i].YPoint
		data.XPoint = historyValue[i].XPoint
		data.WinResult = historyValue[i].WinResult
		
		if data.XPoint==xIndex-1 and data.WinResult~=2 then --xIndex列的前一列结果不等于和的个数
			xNumber= xNumber+1
		end
		if data.XPoint==(xIndex-showNum) and data.WinResult~=2 then--xIndex前showNum列的结果不等于和的个数
			lastXNumber = lastXNumber+1
		end
	end
	return xNumber==lastXNumber
end

--初始化下三路的坐标数据
function RoadManager:InitXiaSanLuXY(tab)
	local dataSize = #tab
	local data = {}
	for i=1 ,dataSize do
		data ={
			XPoint = tab[i].XPoint,
			YPoint = tab[i].YPoint,
			WinResult = tab[i].WinResult,
		}
		if  i==1 then
			tab[i].XPoint=1
			tab[i].YPoint=1
		else
			local  lastData ={
				XPoint = tab[i-1].XPoint,
				YPoint = tab[i-1].YPoint,
				WinResult = tab[i-1].WinResult,
			}
			--结果和上一个相等，而且结果不为和
			if data.WinResult==lastData.WinResult then
				for j=1 ,i do
					local  oldHistory ={
						XPoint = tab[j].XPoint,
						YPoint = tab[j].YPoint,
						WinResult = tab[j].WinResult,
					}
					--检查同一列的下一个空格是否设置了结果,如果设置了结果x往右移
					if lastData.YPoint+1==oldHistory.YPoint and lastData.XPoint==oldHistory.XPoint then
						tab[i].XPoint = lastData.XPoint+1
						tab[i].YPoint = lastData.YPoint
					end
				end
				--当结果放置到同一列下标为5的空格时，竖坐标不变，横坐标往右移一
				if lastData.YPoint==6 then
					tab[i].YPoint=6
					tab[i].XPoint=lastData.XPoint+1
				else
					tab[i].XPoint = lastData.XPoint
					tab[i].YPoint = lastData.YPoint+1
				end
			end

		   --当结果和上一个不相等的时候，而且不为和的时候
			if data.WinResult~=lastData.WinResult then
				--结果在路子图第一行的有几个
				local  oneLuziNum = 1
				for j=1,i do
					local  oldLuzi = {
						XPoint = tab[j].XPoint,
						YPoint = tab[j].YPoint,
						WinResult = tab[j].WinResult,
					}
					if  oldLuzi.YPoint==1  then
						oneLuziNum = oneLuziNum+1
					end
				end
				tab[i].YPoint= 1
				tab[i].XPoint = oneLuziNum
			end
		end
	end
	return tab
end

function RoadManager:OpenRoadPanel()
	self:IsShowRoadPanel(true)
	self:SetRoadPanelData()
	self:SetRoadPanelView()
end

function RoadManager:UpdateRoadPanel()
	if CommonHelper.IsActive(self.gameObject) == true then
		self:SetRoadPanelData()
		self:SetRoadPanelView()
	end
end

function RoadManager:SetRoadPanelData()
	self.history = {}
	self.eyeRoadDataList ={}
	self.smallRoadDataList = {}
	self.yueYouRoadDataList = {}

	self.history = self:CreateBigRoadData(self.gameData.PrizeHistoryRecord)
	self.eyeRoadDataList = self:CreateEyeRoadData(self.history)
	self.smallRoadDataList = self:CreateSmallRoadData(self.history)
	self.yueYouRoadDataList = self:CreateYueYouRoadData(self.history)
end

function RoadManager:SetRoadPanelView()
	self.BeadPlateRoadView:InitBeadPlateRoadView()
	self.BigRoadView:InitBigRoadView()
	self.EyeRoadView:InitEyeRoadView()
	self.SmallRoadView:InitSmallRoadView()
	self.YueYouRoadView:InitYueYouRoadView()
	self.NextResultView:InitNextResultView()
	self.RoadView:InitRoadView()
end

function RoadManager:IsShowRoadPanel(isDisplay)
	CommonHelper.SetActive(self.gameObject,isDisplay)
end

function RoadManager:__delete()
	Instance=nil
	self.RoadView:Destroy()
	self.RoadView = nil
end