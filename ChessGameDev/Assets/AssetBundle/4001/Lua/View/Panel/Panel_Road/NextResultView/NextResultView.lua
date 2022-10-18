NextResultView=Class()

function NextResultView:ctor(gameObj)
	self:Init(gameObj)
end

function NextResultView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function NextResultView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Button=GameManager.GetInstance().Button
	self.Image = GameManager.GetInstance().Image
	self.DragonEyeItemList = {}
	self.DragonSamllItemList = {}
	self.DragonYueYouItemList = {}

	self.TigerEyeItemList = {}
	self.TigerSamllItemList = {}
	self.TigerYueYouItemList = {}
end

function NextResultView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end

function NextResultView:FindView(tf)
	local tempObj = tf:Find("NextResult/Dragon/EyeItem/image01").gameObject
	table.insert(self.DragonEyeItemList,tempObj)
	tempObj = tf:Find("NextResult/Dragon/EyeItem/image02").gameObject
	table.insert(self.DragonEyeItemList,tempObj)

	tempObj = tf:Find("NextResult/Dragon/SamllItem/image01").gameObject
	table.insert(self.DragonSamllItemList,tempObj)
	tempObj = tf:Find("NextResult/Dragon/SamllItem/image02").gameObject
	table.insert(self.DragonSamllItemList,tempObj)

	tempObj = tf:Find("NextResult/Dragon/YueYouItem/image01").gameObject
	table.insert(self.DragonYueYouItemList,tempObj)
	tempObj = tf:Find("NextResult/Dragon/YueYouItem/image02").gameObject
	table.insert(self.DragonYueYouItemList,tempObj)

	tempObj = tf:Find("NextResult/Tiger/EyeItem/image01").gameObject
	table.insert(self.TigerEyeItemList,tempObj)
	tempObj = tf:Find("NextResult/Tiger/EyeItem/image02").gameObject
	table.insert(self.TigerEyeItemList,tempObj)

	tempObj = tf:Find("NextResult/Tiger/SamllItem/image01").gameObject
	table.insert(self.TigerSamllItemList,tempObj)
	tempObj = tf:Find("NextResult/Tiger/SamllItem/image02").gameObject
	table.insert(self.TigerSamllItemList,tempObj)

	tempObj = tf:Find("NextResult/Tiger/YueYouItem/image01").gameObject
	table.insert(self.TigerYueYouItemList,tempObj)
	tempObj = tf:Find("NextResult/Tiger/YueYouItem/image02").gameObject
	table.insert(self.TigerYueYouItemList,tempObj)
end

function NextResultView:InitViewData()
	self:HideNextResultObj()
end


function NextResultView:AddEventListenner()
	
end

function NextResultView:InitNextResultView()
	self:NextResultIsDragon()
end

function NextResultView:NextResultIsDragon()
	local tmpHistoryRecord = {}
	for i = 1,#self.gameData.PrizeHistoryRecord do
		table.insert(tmpHistoryRecord,self.gameData.PrizeHistoryRecord[i])
	end
	table.insert(tmpHistoryRecord,1)
	local NextDragonHistory = RoadManager.GetInstance():CreateBigRoadData(tmpHistoryRecord)
	local NextDragonEyeRoadDataList = RoadManager.GetInstance():CreateEyeRoadData(NextDragonHistory)
	local NextDragonSmallRoadDataList = RoadManager.GetInstance():CreateSmallRoadData(NextDragonHistory)
	local NextDragonYueYouRoadDataList = RoadManager.GetInstance():CreateYueYouRoadData(NextDragonHistory)
	self:ShowNextResultUI(NextDragonEyeRoadDataList,NextDragonSmallRoadDataList,NextDragonYueYouRoadDataList)
end

function NextResultView:ShowNextResultUI(NextDragonEyeRoadDataList,NextDragonSmallRoadDataList,NextDragonYueYouRoadDataList)
	if RoadManager.GetInstance().eyeRoadDataList and  #RoadManager.GetInstance().eyeRoadDataList >= 1 then
		if NextDragonEyeRoadDataList and #NextDragonEyeRoadDataList >=1 then
			if NextDragonEyeRoadDataList[#NextDragonEyeRoadDataList].WinResult == 1 then
				CommonHelper.SetActive(self.DragonEyeItemList[1],true)
				CommonHelper.SetActive(self.DragonEyeItemList[2],false)
			
				CommonHelper.SetActive(self.TigerEyeItemList[1],false)
				CommonHelper.SetActive(self.TigerEyeItemList[2],true)
			else
				CommonHelper.SetActive(self.DragonEyeItemList[1],false)
				CommonHelper.SetActive(self.DragonEyeItemList[2],true)
				
				CommonHelper.SetActive(self.TigerEyeItemList[1],true)
				CommonHelper.SetActive(self.TigerEyeItemList[2],false)
			end
		end
	else
		CommonHelper.SetActive(self.DragonEyeItemList[1],false)
		CommonHelper.SetActive(self.DragonEyeItemList[2],false)

		CommonHelper.SetActive(self.TigerEyeItemList[1],false)
		CommonHelper.SetActive(self.TigerEyeItemList[2],false)
	end

	if RoadManager.GetInstance().smallRoadDataList and  #RoadManager.GetInstance().smallRoadDataList >= 1 then
		if NextDragonSmallRoadDataList and #NextDragonSmallRoadDataList >=1 then
			if NextDragonSmallRoadDataList[#NextDragonSmallRoadDataList].WinResult == 1 then
				CommonHelper.SetActive(self.DragonSamllItemList[1],true)
				CommonHelper.SetActive(self.DragonSamllItemList[2],false)
	
				CommonHelper.SetActive(self.TigerSamllItemList[1],false)
				CommonHelper.SetActive(self.TigerSamllItemList[2],true)
			else
				CommonHelper.SetActive(self.DragonSamllItemList[1],false)
				CommonHelper.SetActive(self.DragonSamllItemList[2],true)
	
				CommonHelper.SetActive(self.TigerSamllItemList[1],true)
				CommonHelper.SetActive(self.TigerSamllItemList[2],false)
			end
		end
	else
		CommonHelper.SetActive(self.DragonSamllItemList[1],false)
		CommonHelper.SetActive(self.DragonSamllItemList[2],false)

		CommonHelper.SetActive(self.TigerSamllItemList[1],false)
		CommonHelper.SetActive(self.TigerSamllItemList[2],false)	
	end

	if RoadManager.GetInstance().yueYouRoadDataList and  #RoadManager.GetInstance().yueYouRoadDataList >= 1 then
		if NextDragonYueYouRoadDataList and #NextDragonYueYouRoadDataList >=1 then
			if NextDragonYueYouRoadDataList[#NextDragonYueYouRoadDataList].WinResult == 1 then
				CommonHelper.SetActive(self.DragonYueYouItemList[1],true)
				CommonHelper.SetActive(self.DragonYueYouItemList[2],false)
	
				CommonHelper.SetActive(self.TigerYueYouItemList[1],false)
				CommonHelper.SetActive(self.TigerYueYouItemList[2],true)
			else
				CommonHelper.SetActive(self.DragonYueYouItemList[1],false)
				CommonHelper.SetActive(self.DragonYueYouItemList[2],true)
	
				CommonHelper.SetActive(self.TigerYueYouItemList[1],true)
				CommonHelper.SetActive(self.TigerYueYouItemList[2],false)
			end
		end
	else
		CommonHelper.SetActive(self.DragonYueYouItemList[1],false)
		CommonHelper.SetActive(self.DragonYueYouItemList[2],false)

		CommonHelper.SetActive(self.TigerYueYouItemList[1],false)
		CommonHelper.SetActive(self.TigerYueYouItemList[2],false)
	end
end

function NextResultView:HideNextResultObj()
	for i = 1,#self.DragonEyeItemList do
		CommonHelper.SetActive(self.DragonEyeItemList[i],false)
	end

	for i = 1,#self.DragonSamllItemList do
		CommonHelper.SetActive(self.DragonSamllItemList[i],false)
	end

	for i = 1,#self.DragonYueYouItemList do
		CommonHelper.SetActive(self.DragonYueYouItemList[i],false)
	end

	for i = 1,#self.TigerEyeItemList do
		CommonHelper.SetActive(self.TigerEyeItemList[i],false)
	end

	for i = 1,#self.TigerSamllItemList do
		CommonHelper.SetActive(self.TigerSamllItemList[i],false)
	end

	for i = 1,#self.TigerYueYouItemList do
		CommonHelper.SetActive(self.TigerYueYouItemList[i],false)
	end
end

