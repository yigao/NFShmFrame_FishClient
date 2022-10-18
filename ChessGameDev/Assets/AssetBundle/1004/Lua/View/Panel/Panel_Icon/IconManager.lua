IconManager=Class()

local Instance=nil
function IconManager:ctor(gameObj)
	Instance=self
	self.gameObject=gameObj
	self:AddRootGameObject()
	self:Init()
end


function IconManager.GetInstance()
	if Instance==nil then
		local aseetPath=GameManager.GetInstance().GameConfig.ModuleAssetPathList.Panel_Icon
		local BuildIconPanelCallBack=function (gameObj)
			if gameObj and gameObj.content then
				local gameObject=CommonHelper.Instantiate(gameObj.content)
				gameObject:GetComponent(typeof(GameManager.GetInstance().Canvas)).worldCamera=GameUIManager.GetInstance().RenderCamera
				IconManager.New(gameObject)
				Instance:LoadComplete()
				return Instance
			else
				Debug.LogError("资源加载失败==>"..aseetPath)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(aseetPath,typeof(CSScript.GameObject),BuildIconPanelCallBack)
		
	else
		return Instance
	end
	
	
end


function IconManager:LoadComplete()
	ModuleManager.GetInstance():PreLoadModuleCompleteCallBack()
end


function IconManager:AddRootGameObject()
	CommonHelper.AddToParentGameObject(self.gameObject,GameUIManager.GetInstance().GamePanelRoot)
end


function IconManager:Init()
	self:InitData()
	self:AddScripts()
	self:BuildScripts()
	self:InitInstance()
	self:InitView()
	self:InitViewData()
end


function IconManager:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.GameConfig=GameManager.GetInstance().GameConfig
	self.IconCInsList={}					--所有图标挂载列实例表
	self.IconMaskCInsList={}
	self.AllIconItemInsList={}				--列索引对齐的图标实例列表
	self.AllIconMaskItemInsList={}
	self.MainIconImagePrefixName="Item"		--主游戏图标前缀
	self.IconFuzzyName="_1"				--模糊图标标识
	
	self.BonusIconImagePrefixName="MidSelectItem"	--Bonus图标前缀
	self.SelectionIconCInsList={}
	self.PrizeTypeInsList={}
end


function IconManager:AddScripts()
	self.ScriptsPathList={
		"View/Panel/Panel_Icon/View/IconView",
		"View/Panel/Panel_Icon/IconItem/IconBase",
		"View/Panel/Panel_Icon/IconItem/IconItem",
		"View/Panel/Panel_Icon/SCIcon/SCIconControl",
		"View/Panel/Panel_Icon/IconSlide/IconSlide",
		"View/Panel/Panel_Icon/SelectionIcon/SelectionIconItem",
		"View/Panel/Panel_Icon/SelectionIcon/SelectionIconControl",
	}
end


function IconManager:BuildScripts()
	for i=1,#self.ScriptsPathList do
		local LoadScripts =GameManager.GetInstance():AddScriptsPath(self.ScriptsPathList[i])
		require(LoadScripts)
	end
end



function IconManager:InitInstance()
	self.IconSlide=IconSlide.New(self.gameObject)
	self.IconView=IconView.New(self.gameObject)
	self.IconItem=IconItem
	self.SCIconControl=SCIconControl
	self.SelectionIconItem=SelectionIconItem
	self.SelectionIconControl=SelectionIconControl
end

function IconManager:InitView()
	self.IconItemList=self.IconView.IconItemList
	self.IconMountGroup=self.IconView.IconMountGroup
	self.IconMaskMountGroup=self.IconView.IconMaskMountGroup
	self.SelectionIconItemList=self.IconView.SelectionIconItemList
	self.SelectionIconMountGroup=self.IconView.SelectionIconMountGroup
end



function IconManager:InitViewData()
	self:CreateSelectionIconIconItemPool()
	self:CreateIconItemPool()
	self:BuildSCIconControl()
	self:BuildIconMaskSCIconControl()
	self:RandomBuildAllIcon(12,2)
	
	self:BuildSelectionIconControl()
end




function IconManager:CreateSelectionIconIconItemPool()
	for i=1,#self.SelectionIconItemList do
		GameObjectPoolManager.GetInstance():AddGameObjectPool(self.SelectionIconItemList[i],8,self.SelectionIconItemList[i].gameObject.name,GameObjectPoolManager.PoolType.SelectionIconPool)
	end
end


function IconManager:CreateIconItemPool()
	for i=1,#self.IconItemList do
		GameObjectPoolManager.GetInstance():AddGameObjectPool(self.IconItemList[i],35,self.IconItemList[i].gameObject.name,GameObjectPoolManager.PoolType.IconPool)
	end
end


function IconManager:BuildSCIconControl()
	for i=1,#self.IconMountGroup do
		local iconCInsT=self.SCIconControl.New(self.IconMountGroup[i])
		iconCInsT:SetColumnIndex(i)
		table.insert(self.IconCInsList,iconCInsT)
	end
end


function IconManager:BuildIconMaskSCIconControl()
	for i=1,#self.IconMaskMountGroup do
		local iconCInsT=self.SCIconControl.New(self.IconMaskMountGroup[i])
		iconCInsT:SetColumnIndex(i)
		table.insert(self.IconMaskCInsList,iconCInsT)
	end
end



function IconManager:RandomBuildAllIcon(iconNum,iconType)
	local tempIconNumList={}
	for i=1,self.GameConfig.Coordinate_COL do
		tempIconNumList[i]={}
		for j=1,self.GameConfig.Coordinate_ROW+1 do
			local randomNum= iconNum or math.random(0,10)--self.GameConfig.IconItemTotalCount-1)
			table.insert(tempIconNumList[i],randomNum)
		end
	end
	if iconType==1 then
		self:InitAllIconItem(tempIconNumList)
	elseif iconType==2 then
		self:InitAllIconMaskItem(tempIconNumList)
	end
	
end


-----初始化IconMask
function IconManager:InitAllIconMaskItem(iconNumList)
	for i=1,self.GameConfig.Coordinate_COL do
		self.AllIconMaskItemInsList[i]={}
		for j=1,self.GameConfig.Coordinate_ROW+1 do
			local tempIconIns=self:GetMainIconItemInsByIconNum(iconNumList[i][j])
			table.insert(self.AllIconMaskItemInsList[i],tempIconIns)
		end
	end
	
	for i=1,#self.AllIconMaskItemInsList do
		self.IconMaskCInsList[i]:AddMountPoint(self.AllIconMaskItemInsList[i])
		self.IconMaskCInsList[i]:SetIconInsList(self.AllIconMaskItemInsList[i])
	end
	
	self:IsShowAllIconMask(false)
end



function IconManager:InitAllIconItem(iconNumList)
	for i=1,self.GameConfig.Coordinate_COL do
		self.AllIconItemInsList[i]={}
		for j=1,self.GameConfig.Coordinate_ROW+1 do
			local tempIconIns=self:GetMainIconItemInsByIconNum(iconNumList[i][j])
			if iconNumList[i][j]==12 then
				local iconValue=self.gameData.GameIconResult[5+i][j-1]
				self:SetBianPaoIconValue(iconValue,tempIconIns)	--第二行开始算正式结果
			end
			table.insert(self.AllIconItemInsList[i],tempIconIns)
		end
	end
	
	for i=1,#self.AllIconItemInsList do
		self.IconCInsList[i]:AddMountPoint(self.AllIconItemInsList[i])
		self.IconCInsList[i]:SetIconInsList(self.AllIconItemInsList[i])
	end
end


function IconManager:SetBianPaoIconValue(iconValue,iconIns)
	if iconValue then
		if iconValue>10 then
			iconIns:SetIconText(iconValue)
			iconIns:IsShowIconText(true)
			iconIns:IsShowWinImage(false)
		elseif iconValue>0 and iconValue <=10 then
			iconIns:SetWinImage(iconValue)
			iconIns:IsShowIconText(false)
			iconIns:IsShowWinImage(true)
		else
			Debug.LogError("icon12结果异常"..iconValue)
		end
	else
		Debug.LogError("SetBianPaoIconValue的iconValue为nil")
	end
end


function IconManager:GetIconItem(keyName,poolType)
	return GameObjectPoolManager.GetInstance():GetGameObject(keyName,poolType)
end


function IconManager:GetIconItembyIconNum(iconNum,iconPrefixName,poolType)
	local iconName=iconPrefixName..iconNum
	local tempIconItem=self:GetIconItem(iconName,poolType)
	return tempIconItem
end


function IconManager:GetIconItemInsByIconItem(iconItemObj)
	local iconIns=self.IconItem.New()
	iconIns:BuildIconItem(iconItemObj)
	return iconIns
end


--获取主游戏图标项
function IconManager:GetMainIconItemByIconNum(iconNum)
	local tempIconItem=self:GetIconItembyIconNum(iconNum,self.MainIconImagePrefixName,GameObjectPoolManager.PoolType.IconPool)
	if tempIconItem then
		return tempIconItem
	else
		Debug.LogError("获取图标项失败==>"..iconNum)
	end
end


--获取主游戏中的图标实例
function IconManager:GetMainIconItemInsByIconNum(iconNum)
	local tempIconItem=self:GetMainIconItemByIconNum(iconNum)
	if tempIconItem then
		return self:GetIconItemInsByIconItem(tempIconItem)
	end
	
end

--获取图标名字
function IconManager:GetIconItemImageNameByIconNum(IconImagePrefixName,iconNum)
	return IconImagePrefixName..iconNum
end

--获取主图标名字
function IconManager:GetMainIconItemImageNameByIconNum(iconNum)
	return self:GetIconItemImageNameByIconNum(self.MainIconImagePrefixName,iconNum)
end

--获取主模糊图标名字
function IconManager:GetMainIconItemFuzzyImageNameByIconNum(iconNum)
	return self:GetMainIconItemImageNameByIconNum(iconNum)..self.IconFuzzyName
end


--获取Bonus游戏图标项
function IconManager:GetBonusIconItemByIconNum(iconNum)
	local tempIconItem=self:GetIconItembyIconNum(iconNum,self.BonusIconImagePrefixName,GameObjectPoolManager.PoolType.SelectionIconPool)
	if tempIconItem then
		return tempIconItem
	else
		Debug.LogError("获取Bonus图标项失败==>"..iconNum)
	end
end


--获取Bonus游戏中的图标实例
function IconManager:GetBonusIconItemInsByIconNum(iconNum)
	local tempIconItem=self:GetBonusIconItemByIconNum(iconNum)
	if tempIconItem then
		return self:GetIconItemInsByIconItem(tempIconItem)
	end
	
end


function IconManager:GetBonusIconItemImageNameByIconNum(iconNum)
	return self:GetIconItemImageNameByIconNum(self.BonusIconImagePrefixName,iconNum)
end


--获取Bonus模糊图标名字
function IconManager:GetBonusIconItemFuzzyImageNameByIconNum(iconNum)
	return self:GetIconItemImageNameByIconNum(self.BonusIconImagePrefixName,iconNum)..self.IconFuzzyName
end





function IconManager:StartSingleColumnIconRun(columnIndex,speed,isFuzzy)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:NormalStartRun(speed,isFuzzy)
		else
			Debug.LogError("Start获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end



function IconManager:StopSingleCoumnIconRun(columnIndex,columnIconResult)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:NormalStopRun(columnIconResult)
		else
			Debug.LogError("Stop获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end


function IconManager:GetSingleRunIconInsByCoordinate(colCoord,rowCoord)
	local tempSingeColumnIconInsList=self.IconCInsList[colCoord]
	local tempIconIns=tempSingeColumnIconInsList:GetSingleIconIns(rowCoord)
	if tempIconIns then
		return tempIconIns
	end
end


function IconManager:PlayAssignIconInsAnim(iconInsList)
	if iconInsList and #iconInsList>0 then
		for i=1,#iconInsList do
			iconInsList[i]:PlayBaseIconAnim()
		end
	end
end


function IconManager:StopPlayAssignIconInsAnim(iconInsList)
	if iconInsList and #iconInsList>0 then
		for i=1,#iconInsList do
			iconInsList[i]:StopPlayBaseIconAnim()
		end
	end
end



function IconManager:ClearAllIconItemInsListState()
	for i=1,#self.IconCInsList do
		self:StopPlayAssignIconInsAnim(self.IconCInsList[i]:GetIconInsList())
	end
end


function IconManager:GetAllocateIconInsByIconValue(iconValue)
	local tempInsList={}
	for i=1,#self.AllIconItemInsList do
		for j=1,#self.AllIconItemInsList[i] do
			if self.AllIconItemInsList[i][j] then
				if self.AllIconItemInsList[i][j]:GetIconValue()==iconValue then
					table.insert(tempInsList,self.AllIconItemInsList[i][j])
				end
			end
		end
	end
	return tempInsList
end



function IconManager:GetAllocateIconIns(clomunIndex,rowIndex)
	return self.IconCInsList[clomunIndex]:GetIconInsList()[rowIndex]
end


function IconManager:ChangeAllocateIconIns(clomunIndex,rowIndex,iconNum)
	local tempIconIns=self.IconCInsList[clomunIndex]:GetIconInsList()[rowIndex]
	if tempIconIns then
		tempIconIns:RecycleIconToGameObjectPool(GameObjectPoolManager.PoolType.IconPool)
		local tempIconItem=self:GetMainIconItemByIconNum(iconNum)
		if tempIconItem then
			tempIconIns:BuildIconItem(tempIconItem)
			tempIconIns:SetIocnParent(self.IconCInsList[clomunIndex].MountList[rowIndex])
			return tempIconIns
		else
			Debug.LogError("获取IconItem异常==>"..iconNum)
		end
	end
end


function IconManager:GetAllocateIconCInsMountPoint(clomunIndex,rowIndex)
	local iconCIns=self.IconCInsList[clomunIndex]
	local mount=iconCIns:GetMountPoint(rowIndex)
	return mount
end



function IconManager:IsShowAllIconMask(isShow)
	for i=1,#self.AllIconMaskItemInsList do
		for j=1,#self.AllIconMaskItemInsList[i] do
			self.AllIconMaskItemInsList[i][j]:IsShowIconPanel(isShow)
		end
	end
end


function IconManager:IsShowAllocateIconMask(columnIndex,rowIndex,isShow)
	local tempIns=self:GetAllocateIconMaskIns(columnIndex,rowIndex)
	if tempIns then
		tempIns:IsShowIconPanel(isShow)
	end
end


function IconManager:GetAllocateIconMaskIns(columnIndex,rowIndex)
	if self.AllIconMaskItemInsList[columnIndex] and self.AllIconMaskItemInsList[columnIndex][rowIndex] then
		return self.AllIconMaskItemInsList[columnIndex][rowIndex]
	else
		Debug.LogError("获取iconMask实例失败==>")
	end
end

function IconManager:ChangeAllocateIconMaskInsIcon(columnIndex,rowIndex,iconNum,iconValue)
	local tempIns=self:GetAllocateIconMaskIns(columnIndex,rowIndex)
	if tempIns then
		tempIns:SetParentSiblingIndex(rowIndex)
		self:SetBianPaoIconValue(iconValue,tempIns)
		tempIns:IsShowIconPanel(true)
	end
	
	
end


-------SelectionIcon------------


function IconManager:BuildSelectionIconControl()
	for i=1,#self.SelectionIconMountGroup do
		local iconCInsT=self.SelectionIconControl.New(self.SelectionIconMountGroup[i])
		iconCInsT:SetColumnIndex(i)
		table.insert(self.SelectionIconCInsList,iconCInsT)
	end
end


function IconManager:BuildSelectionIconIns(selectionIconNumList)
	if selectionIconNumList then
		local tempSelectionInsList={}
		for i=1,#selectionIconNumList do
			local selectionItem=self:GetBonusIconItemByIconNum(selectionIconNumList[i])
			if selectionItem then
				local selectionIconIns=self.SelectionIconItem.New(selectionItem)
				selectionIconIns:SetSelectionType(selectionIconNumList[i])
				table.insert(tempSelectionInsList,selectionIconIns)
			end
		end
		
		return tempSelectionInsList
	end
	return nil
end



function IconManager:InitSelectionIocnControlData(index,selectionIconNumList,isShow)
	local selectionIconInsList=self:BuildSelectionIconIns(selectionIconNumList)
	if selectionIconInsList then
		local SIControlIns=self.SelectionIconCInsList[index]
		if SIControlIns then
			SIControlIns:AddMountPoint(selectionIconInsList)
			SIControlIns:SetIconInsList(selectionIconInsList)
			SIControlIns:IsShowSelectionPanel(isShow)
		end
	end
end


function IconManager:InitSelectionPrizeTypeInsList()
	self.PrizeTypeInsList={}
	for _,v in pairs(self.SelectionIconCInsList[1]:GetIconInsList()) do
		if v.SelectionType<=6 then
			table.insert(self.PrizeTypeInsList,v)
		end
	end
end


function IconManager:StartSelectionIconRun(index,speed)
	speed=speed or 0.05
	self.SelectionIconCInsList[index]:NormalStartRun(speed)
end



function IconManager:StopSelectionIconRun(index,stopIndex)
	self.SelectionIconCInsList[index]:NormalStopRun(stopIndex)
end



function IconManager:SetSelectionPrizeValue(index,value)
	self.PrizeTypeInsList[index]:SetIconValue(value)
end

function IconManager:GetSelectionIconRunState(index)
	return self.SelectionIconCInsList[index].IsIconRun
end




function IconManager:IsShowIconMask(isShow)
	CommonHelper.SetActive(self.IconView.iconMaskObj,isShow)
end


function IconManager:IsCloseSilderTipsPanel()
	if CommonHelper.IsActive(self.IconView.sliderTipskObj) then
		CommonHelper.SetActive(self.IconView.sliderTipskObj,false)
	end
end


function IconManager:SetSingleColumnIconSpeedRun(columnIndex,runSpeed)
	if self.IconCInsList then
		if self.IconCInsList[columnIndex] then
			self.IconCInsList[columnIndex]:SetRunSpeed(runSpeed)
		else
			Debug.LogError("获取列滚动图标实例失败==>"..columnIndex)
		end
	end
end



function IconManager:__delete()
	Instance=nil
end
