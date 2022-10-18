BaseFctView=Class()

function BaseFctView:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)
end

function BaseFctView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:AddEventListenner()
end

function BaseFctView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Image=GameManager.GetInstance().Image
	self.Time = GameManager.GetInstance().Time
	self.MeshRenderer = GameManager.GetInstance().MeshRenderer
	self.SkeletonAnimation = GameManager.GetInstance().SkeletonAnimation
	self.Tween = GameManager.GetInstance().Tween
	self.Sequence = GameManager.GetInstance().Sequence
	self.Ease = GameManager.GetInstance().Ease
	self.DOTween = GameManager.GetInstance().DOTween
	self.TweenExtensions = GameManager.GetInstance().TweenExtensions
	self.Animator = GameManager.GetInstance().Animator
	self.GameStartSequence = nil
	self.VSCardSequence = nil
	self.CardAtalsName = "LhdCardSpriteAtlas"
	self.VSAnimationName = {"BasePanel_VS_P0","BasePanel_VS_P1","BasePanel_VS_P2"}
	self.BetAreaWinAnimationName = "BetChipPanel_Aread"
	self.ClockAnimationName = {"BasePanel_Clock01","BasePanel_Clock02"}
	self.isClockPlaying = false
	self.BetAreaWinAnimatorList = {}
	self.addTime = 0
end


function BaseFctView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
	self.updateItemNum = CommonHelper.AddUpdate(self)
end


function BaseFctView:FindView(tf)
	self.Clock_GameObject = tf:Find("Clock").gameObject
	self.ClockTime_Text = tf:Find("Clock/time"):GetComponent(typeof(self.Text))
	self.Clock_Animator = self.Clock_GameObject:GetComponent(typeof(self.Animator)) 

	self.SplashScreenGameObject = tf:Find("SplashScreenAnimation").gameObject
	self.SplashScreenSkeletonAnimation = self.SplashScreenGameObject:GetComponent(typeof(self.SkeletonAnimation))

	self.VS_GameObject = tf:Find("VS").gameObject
	self.VS_Animator = tf:Find("VS"):GetComponent(typeof(self.Animator))
	self.Dragon_Card_Object =  tf:Find("VS/dragon_card").gameObject
	self.Dragon_card_Front_Image = tf:Find("VS/dragon_card/dragon_card_Front"):GetComponent(typeof(self.Image))
	self.Tiger_Card_Object =  tf:Find("VS/tiger_card").gameObject
	self.Tiger_card_Front_Image = tf:Find("VS/tiger_card/tiger_card_Front"):GetComponent(typeof(self.Image))

	local DragonBetAreaWin_Animator =  tf:Find("WinArea/Dragon"):GetComponent(typeof(self.Animator))
	table.insert(self.BetAreaWinAnimatorList,DragonBetAreaWin_Animator)
	local PeaceBetAreaWin_Animator = tf:Find("WinArea/Peace"):GetComponent(typeof(self.Animator))
	table.insert(self.BetAreaWinAnimatorList,PeaceBetAreaWin_Animator)
	local TigerBetAreaWin_Animator = tf:Find("WinArea/Tiger"):GetComponent(typeof(self.Animator))
	table.insert(self.BetAreaWinAnimatorList,TigerBetAreaWin_Animator)

	self.Effect_Begin_GameObject = tf:Find("Effect_Begin/Canvas").gameObject
	self.Effect_Over_GameObject = tf:Find("Effect_Over/Canvas").gameObject

	self.Effect_WaitNextGame_GameObject = tf:Find("WaitNextGame").gameObject
end


function BaseFctView:InitViewData()
	self:SetShowPanel(false)
end

function BaseFctView:AddEventListenner()
	
end

function BaseFctView:SetShowPanel(isDisplay)
	self:IsShowCardBackGameObject(isDisPlay)
	self:IsShowClockGameObject(isDisplay)
	self:IsShowSplashScreen(isDisplay)
	self:IsShowBeginEffect(isDisplay)
	self:IsShowOverEffect(isDisPlay)
	self:IsShowWaitNextGameEffect(isDisPlay)
	
	for i=1,#self.BetAreaWinAnimatorList do
		self:IsShowBetAreaWin(i,isDisPlay)
	end
end

function BaseFctView:EnterGameStart()
	self:HideAllWinArea()
	self:IsShowWaitNextGameEffect(false)
	self:IsShowClockGameObject(false)
	self:IsPlayClockAnimation(false)

	if self.gameData.CurStationLifeTime<=0.1 then
		AudioManager.GetInstance():PlayNormalAudio(21)
		self:IsShowSplashScreen(true)
		self:PlaySplashScreenAnimation()	
	else
		self:IsShowSplashScreen(false)
	end

	if self.GameStartSequence ~= nil then
		self.GameStartSequence:Kill()
		self.GameStartSequence = nil
	end

	if self.gameData.CurStationLifeTime < 1.4 then
		self:IsShowCardBackGameObject(false)
		self.GameStartSequence = self.DOTween.Sequence()
		local VSAnimationCallBack = function()
			AudioManager.GetInstance():PlayNormalAudio(22)
			self:IsShowCardBackGameObject(true)
			self:PlayVSAnimation(self.VSAnimationName[2],0)
		end
		self.GameStartSequence:InsertCallback((1.4 -self.gameData.CurStationLifeTime) ,VSAnimationCallBack)
	elseif self.gameData.CurStationLifeTime >= 1.4 and self.gameData.CurStationLifeTime <= 1.5 then
		self:IsShowCardBackGameObject(true)
		AudioManager.GetInstance():PlayNormalAudio(22)
		self:PlayVSAnimation(self.VSAnimationName[2],0)
	else
		self:IsShowCardBackGameObject(true)
		self:PlayVSAnimation(self.VSAnimationName[1],0)
	end
end


function BaseFctView:EnterBetChip()
	self:HideAllWinArea()
	self:IsShowWaitNextGameEffect(false)
	self:IsShowSplashScreen(false)
	self:IsShowCardBackGameObject(true)
	self:PlayVSAnimation(self.VSAnimationName[1],0)
	if self.gameData.CurStationLifeTime <= 0.1 then
		AudioManager.GetInstance():PlayNormalAudio(18)
		self:IsShowBeginEffect(true)
	else
		self:IsShowBeginEffect(false)
	end
	self.Clock_Animator:Play(self.ClockAnimationName[1],0,0)
	self:IsShowClockGameObject(true)
end

function BaseFctView:EnterOpenPrize(dragonAreaCard,tigerAreaCard,prizeType)
	self:HideAllWinArea()
	self:IsShowSplashScreen(false)
	self:IsShowClockGameObject(false)
	self:IsShowBeginEffect(false)
	self:IsShowOverEffect(false)
	self:IsPlayClockAnimation(false)
	if self.VSCardSequence ~= nil then
		self.VSCardSequence:Kill()
		self.VSCardSequence = nil
	end
	
	self.VSCardSequence = self.DOTween.Sequence()
	self:SetVsCardValue(dragonAreaCard,tigerAreaCard)
	self:IsShowCardBackGameObject(true)
	
	local animationTime = self.gameData.CurStationLifeTime/3.167
	self:PlayVSAnimation(self.VSAnimationName[3],animationTime)

	local PlayOpenCardAudioCallBack = function()
		AudioManager.GetInstance():PlayNormalAudio(23)
	end

	local PlayDragonCardValueAudioCallBack = function()
		AudioManager.GetInstance():PlayNormalAudio(dragonAreaCard.point + 1)
	end

	local PlayTigerCardValueAudioCallBack = function()
		AudioManager.GetInstance():PlayNormalAudio(tigerAreaCard.point + 1)
	end

	local PlayAreaWinAnimationCallBack = function()
		self:IsShowBetAreaWin(prizeType,true)	
		AudioManager.GetInstance():PlayNormalAudio(14+prizeType)
		self:PlayBetAreaWinAnimation(prizeType)
		BaseFctManager.GetInstance().HistoryRecordView:UpdateRecordItemView()
	end

	local MoveBetChipToWinCallBack = function()
		BetChipManager.GetInstance():BeginMoveBetChipToWinArea(prizeType)
	end
	
	if self.gameData.CurStationLifeTime <= 0.5 then
		self.VSCardSequence:InsertCallback(0.5 - self.gameData.CurStationLifeTime,PlayOpenCardAudioCallBack)
	end

	if self.gameData.CurStationLifeTime <= 1.1 then
		self.VSCardSequence:InsertCallback(1.1 - self.gameData.CurStationLifeTime,PlayDragonCardValueAudioCallBack)
	end

	if self.gameData.CurStationLifeTime <= 1.5 then
		self.VSCardSequence:InsertCallback(1.5 - self.gameData.CurStationLifeTime,PlayOpenCardAudioCallBack)
	end
	
	if self.gameData.CurStationLifeTime <= 2.2 then
		self.VSCardSequence:InsertCallback(2.2 - self.gameData.CurStationLifeTime,PlayTigerCardValueAudioCallBack)
	end

	if self.gameData.CurStationLifeTime <= 3.2 then
		self.VSCardSequence:InsertCallback(3.2 - self.gameData.CurStationLifeTime,PlayAreaWinAnimationCallBack)
	else
		self:IsShowBetAreaWin(prizeType,true)	
		BaseFctManager.GetInstance().HistoryRecordView:UpdateRecordItemView()
	end

	if self.gameData.CurStationLifeTime <= 4.5 then
		self.VSCardSequence:InsertCallback(4.5 - self.gameData.CurStationLifeTime,MoveBetChipToWinCallBack)
	else
		BaseFctManager.GetInstance().BaseFctView:HideAllWinArea()
		BaseFctManager.GetInstance().BankerSimpleView:UpdateBankerScoreValue()
		PlayerManager.GetInstance():SetResultScoreValue()
	end
end

-- function BaseFctView:EnterOpenPrize(dragonAreaCard,tigerAreaCard,prizeType)
-- 	self:HideAllWinArea()
-- 	self:IsShowSplashScreen(false)
-- 	self:IsShowClockGameObject(false)
-- 	self:IsShowBeginEffect(false)
-- 	self:IsShowOverEffect(false)
-- 	self:IsPlayClockAnimation(false)
-- 	if self.VSCardSequence ~= nil then
-- 		self.VSCardSequence:Kill()
-- 		self.VSCardSequence = nil
-- 	end
	
-- 	self.VSCardSequence = self.DOTween.Sequence()
-- 	self:SetVsCardValue(dragonAreaCard,tigerAreaCard)
-- 	self:IsShowCardBackGameObject(true)
-- 	self:PlayVSAnimation(self.VSAnimationName[3])
	
-- 	local PlayOpenCardAudioCallBack = function()
-- 		AudioManager.GetInstance():PlayNormalAudio(23)
-- 	end

-- 	local PlayDragonCardValueAudioCallBack = function()
-- 		AudioManager.GetInstance():PlayNormalAudio(dragonAreaCard.point + 1)
-- 	end

-- 	local PlayTigerCardValueAudioCallBack = function()
-- 		AudioManager.GetInstance():PlayNormalAudio(tigerAreaCard.point + 1)
-- 	end

-- 	local PlayAreaWinAnimationCallBack = function()
-- 		self:IsShowBetAreaWin(prizeType,true)	
-- 		AudioManager.GetInstance():PlayNormalAudio(14+prizeType)
-- 		self:PlayBetAreaWinAnimation(prizeType)
-- 		BaseFctManager.GetInstance().HistoryRecordView:UpdateRecordItemView()
-- 	end
-- 	local MoveBetChipToWinCallBack = function()
-- 		BetChipManager.GetInstance():BeginMoveBetChipToWinArea(prizeType)
-- 	end
-- 	self.VSCardSequence:InsertCallback(0.5,PlayOpenCardAudioCallBack)
-- 	self.VSCardSequence:InsertCallback(1.1,PlayDragonCardValueAudioCallBack)
-- 	self.VSCardSequence:InsertCallback(1.5,PlayOpenCardAudioCallBack)
-- 	self.VSCardSequence:InsertCallback(2.2,PlayTigerCardValueAudioCallBack)
-- 	self.VSCardSequence:InsertCallback(3.2,PlayAreaWinAnimationCallBack)
-- 	self.VSCardSequence:InsertCallback(4.5,MoveBetChipToWinCallBack)
-- end

function BaseFctView:Update()
	if self.gameData.MainStation == StateManager.MainState.STATE_BetChip  then
		self.gameData.CurStationLifeTime = self.gameData.CurStationLifeTime + self.Time.deltaTime
		self:SetBetChipCountdown()
	end
end

function BaseFctView:SetBetChipCountdown()
	local time =math.ceil(self.gameData.CurStationTotalTime -  self.gameData.CurStationLifeTime)
	self.ClockTime_Text.text =  time
	if time <= 3 and self.isClockPlaying == false then
		self.addTime = 1
		self:IsPlayClockAnimation(true)
	end

	if time <= 3 and time>0 then
		self.addTime=self.addTime + self.Time.deltaTime
		if self.addTime>=1 then
			AudioManager.GetInstance():PlayNormalAudio(20)
			self.addTime=0
		end
	end

	if time <= 1 and CommonHelper.IsActive(self.Effect_Over_GameObject) == false then
		AudioManager.GetInstance():PlayNormalAudio(21,0.4)
		AudioManager.GetInstance():PlayNormalAudio(19)
		self:IsShowOverEffect(true)
	end
end

function BaseFctView:PlaySplashScreenAnimation()
	self.SplashScreenSkeletonAnimation.state:SetAnimation(0,"Animation",false)
end

function BaseFctView:IsShowCardBackGameObject(isDisPlay)
	CommonHelper.SetActive(self.Dragon_Card_Object,isDisPlay)
	CommonHelper.SetActive(self.Tiger_Card_Object,isDisPlay)
end

function BaseFctView:IsShowClockGameObject(isDisPlay)
	CommonHelper.SetActive(self.Clock_GameObject,isDisPlay)
end

function BaseFctView:IsShowSplashScreen(isDisPlay)
	CommonHelper.SetActive(self.SplashScreenGameObject,isDisPlay)
end

function BaseFctView:HideAllWinArea()
	for i = 1,#self.BetAreaWinAnimatorList do 
		self:IsShowBetAreaWin(i,false)
	end
end

function BaseFctView:IsShowBetAreaWin(index,isDisPlay)
	CommonHelper.SetActive(self.BetAreaWinAnimatorList[index].gameObject,isDisPlay)
end

function BaseFctView:IsShowBeginEffect(isDisPlay)
	CommonHelper.SetActive(self.Effect_Begin_GameObject,isDisPlay)
end

function BaseFctView:IsShowOverEffect(isDisPlay)
	CommonHelper.SetActive(self.Effect_Over_GameObject,isDisPlay)
end

function BaseFctView:IsShowWaitNextGameEffect(isDisPlay)
	CommonHelper.SetActive(self.Effect_WaitNextGame_GameObject,isDisPlay)
end

function BaseFctView:SetVsCardValue(dragonAreaCard,tigerAreaCard)
	local dragonCardValue = dragonAreaCard.type.."_"..dragonAreaCard.point
	local tigerCardValue = tigerAreaCard.type.."_"..tigerAreaCard.point
	self.Dragon_card_Front_Image.sprite =self.gameData.AllAtlasList[self.CardAtalsName]:GetSprite(dragonCardValue)
	self.Tiger_card_Front_Image.sprite =self.gameData.AllAtlasList[self.CardAtalsName]:GetSprite(tigerCardValue)
end

function BaseFctView:PlayVSAnimation(animationName,animationTime)
	self.VS_Animator:Play(animationName,0,animationTime)
end

function BaseFctView:PlayBetAreaWinAnimation(index)
	self.BetAreaWinAnimatorList[index]:Play(self.BetAreaWinAnimationName,0,0)
end

function BaseFctView:IsPlayClockAnimation(isPlaying)
	if isPlaying == true then
		self.isClockPlaying = true
		self.Clock_Animator:Play(self.ClockAnimationName[2],0,0)
	else
		self.isClockPlaying = false
	end
end

function BaseFctView:__delete()
	if self.VSCardSequence ~= nil then
		self.VSCardSequence:Kill()
		self.VSCardSequence = nil
	end

	if self.GameStartSequence ~= nil then
		self.GameStartSequence:Kill()
		self.GameStartSequence = nil
	end
	CommonHelper.RemoveUpdate(self.updateItemNum)
end