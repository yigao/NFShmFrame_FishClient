WinView=Class()

function WinView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
	CommonHelper.AddUpdate(self)
end

function WinView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end


function WinView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.WinList={}
	self.WinTextList={}
	self.currentWinScoreText=nil
	self.currentWinIndex=0
	self.totalTime=0
	self.currentTime=0
	self.totalWinScore=0
	self.isPlayWin=false
end



function WinView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function WinView:FindView(tf)
	self.BoxQuit=tf:Find("Panel"):GetComponent(typeof(self.Button))
	self.MaskImage=tf:Find("Panel"):GetComponent(typeof(self.Image))
	self:FindWinView(tf)
	self:FindSmallWinView(tf)
end


function WinView:FindWinView(tf)
	for i=1,3 do
		local tempWin=tf:Find("Panel/Win"..i).gameObject
		table.insert(self.WinList,tempWin)
		tempWin=tf:Find("Panel/Win"..i.."/WinAnim/Panel/WinImage/Text"):GetComponent(typeof(self.Text))
		table.insert(self.WinTextList,tempWin)
	end
end


function WinView:FindSmallWinView(tf)
	self.smallWin=tf:Find("Panel/Win4").gameObject
end



function WinView:InitViewData()
	self:HideAllWinPanel()
end


function WinView:AddEventListenner()
	self.BoxQuit.onClick:AddListener(function () self:OnclickQuit() end)
end


function WinView:OnclickQuit()
	if self.currentTime<self.showTime then
		self.currentTime=self.showTime
	end
end


function WinView:HideAllWinPanel()
	CommonHelper.IsShowPanel(0,self.WinList,true,true,false)
	self:IsShowSmallWinPanel(false)
end

function WinView:IsShowWinPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.WinList,isShow,true,false)
end


function WinView:IsShowSmallWinPanel(isShow)
	CommonHelper.SetActive(self.smallWin,isShow)
end

function WinView:IsEnableMaskPanel(isEnable)
	self.MaskImage.enabled=isEnable
end


function WinView:SetWinScore(score)
	if self.currentWinScoreText then
		self.currentWinScoreText.text="+"..score
	end
end


function WinView:EnterSmallWinProcess(showTime,winScore)
	self:IsEnableMaskPanel(false)
	self:HideAllWinPanel()
	self:IsShowSmallWinPanel(true)
	local DelayHideSmallWinFunc=function ()
		self:ResetSmallWinTimer()
		AudioManager.GetInstance():PlayNormalAudio(32)
	end
	self.smallWinTimer=TimerManager.GetInstance():CreateTimerInstance(0.5,DelayHideSmallWinFunc)
	AudioManager.GetInstance():PlayNormalAudio(32)
end


function WinView:ResetSmallWinTimer()
	if self.smallWinTimer then
		TimerManager.GetInstance():RecycleTimerIns(self.smallWinTimer)
		self.smallWinTimer=nil
	end
end



local winAudioList={29,30,31}
function WinView:EnterWin(index,showTime,winScore)
	AudioManager.GetInstance():IsEnableBGAudio(false)
	self:IsEnableMaskPanel(true)
	self:HideAllWinPanel()
	self:IsShowSmallWinPanel(false)
	self.currentWinIndex=index
	self.totalTime=showTime
	self.showTime=showTime-1
	self.totalWinScore=winScore
	self.currentWinScoreText=self.WinTextList[index]
	self:SetWinScore(0)
	self:IsShowWinPanel(index,true)
	AudioManager.GetInstance():PlayNormalAudio(winAudioList[self.currentWinIndex])
	self.isPlayWin=true
	self.isStop=false
end



function WinView:Update()
	if self.isPlayWin then
		self.currentTime=self.currentTime+CSScript.Time.deltaTime
		if self.currentTime<self.showTime then
			local curentScore=math.ceil(self.totalWinScore*(self.currentTime/self.showTime))
			self:SetWinScore(curentScore)
		elseif self.currentTime>self.showTime and self.currentTime<self.totalTime then
			self:SetWinScore(self.totalWinScore)
			if self.isStop==false then
				self.isStop=true
				GameLogicManager.GetInstance():SetBaseWinScoreProcess(0.1)
			end
		elseif self.currentTime>=self.totalTime then
			self.isPlayWin=false
			self.currentTime=0
			self:WinFinishCallBack()
		end
	end
end



function WinView:WinFinishCallBack()
	AudioManager.GetInstance():IsEnableBGAudio(true)
	AudioManager.GetInstance():StopNormalAudio(winAudioList[self.currentWinIndex])
	self:HideAllWinPanel()
	WinManager.GetInstance():WinStateCallBack()
end


function WinView:__delete()

end