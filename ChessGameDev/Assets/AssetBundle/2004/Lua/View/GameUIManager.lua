GameUIManager=Class()

local instance={}
function GameUIManager:ctor(obj)
	instance=self
	self.gameObject = obj
	self:Init(obj)
	
end


function GameUIManager.GetInstance()
	return instance
end


function GameUIManager:Init (gameObj)
	self.gameObject=gameObj
	self:InitData()
	self:InitView(gameObj)
	self:FindView()
	self:AddListennerEvent()
end


function GameUIManager:InitData()
	self.tideTime = 2.5
	self.gameData=GameManager.GetInstance().gameData 
	self.AllGameBG = {}
	self.GameIsPress = true
	self.changeSceneClearTimer = nil
end



function GameUIManager:InitView(gameObj)
	self:InitInstance(gameObj)
	self:InitUIViewData()
	
end


function GameUIManager:InitInstance(gameObj)
	local tf=gameObj.transform
	
	self.gameData.GameObjectPoolManager=GameObjectPoolManager.New(gameObj)
	self.gameData.FishManager=FishManager.New(gameObj)
	self.gameData.BulletManager=BulletManager.New(gameObj)
	self.gameData.PlayerManager=PlayerManager.New(gameObj)
	self.gameData.NetManager=NetManager.New(gameObj)
	self.gameData.GoldEffectManager=GoldEffectManager.New(gameObj)
	self.gameData.ScoreEffectManager=ScoreEffectManager.New(gameObj)
	self.gameData.PlusTipsEffectManager = PlusTipsEffectManager.New(gameObj)
	self.gameData.SpecialDeclareEffectManager = SpecialDeclareEffectManager.New(gameObj)
	self.gameData.SpiderCrabEffectManager = SpiderCrabEffectManager.New(gameObj)
	self.gameData.BombManager=BombManager.New(gameObj)
	self.gameData.FishEffectManager=FishEffectManager.New(gameObj)
	self.gameData.FishOutTipsEffectManager=FishOutTipsEffectManager.New(gameObj)
	self.gameData.LightningEffectManager = LightningEffectManager.New(gameObj)
	self.gameData.ElectricSkillManager = ElectricSkillManager.New(gameObj)
	self.gameData.FireStormSkillManager = FireStormSkillManager.New(gameObj)
	self.gameData.DrillSkillManager = DrillSkillManager.New(gameObj)
	self.gameData.SerialDrillSkillManager = SerialDrillSkillManager.New(gameObj)
	self.gameData.BisonSkillManager = BisonSkillManager.New(gameObj)
	self.gameData.BombSkillManager = BombSkillManager.New(gameObj)
	self.gameData.MultBombSkillManager = MultBombSkillManager.New(gameObj)
	TipsContentManager.New(gameObj)
	GameSetManager.GetInstance()
end


function GameUIManager:InitUIViewData()	
	CS.FishManager.Init(self.gameData.ResolutionWidth,self.gameData.ResolutionHeight)
	self:SetScreenResoulution()

end

function GameUIManager:SetScreenResoulution()
	self.canvasScaler=self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.UI.CanvasScaler))
	local ratio=1
	local tmpRatio=(CS.UnityEngine.Screen.width/CS.UnityEngine.Screen.height)
	if ratio~=tmpRatio then 
		ratio=tmpRatio
		self.gameData.ResolutionHeight=self.canvasScaler.referenceResolution.y
		self.gameData.ResolutionHeightHalf=math.floor(self.gameData.ResolutionHeight/2)
    	self.gameData.ResolutionWidth=math.floor(self.gameData.ResolutionHeight*ratio)
		self.gameData.ResolutionWidthHalf=math.floor(self.gameData.ResolutionWidth/2)
		CS.FishManager.curResolutionWidth = self.gameData.ResolutionWidth
		CS.FishManager.curResolutionHeight = self.gameData.ResolutionHeight
	end
end


function GameUIManager:FindView()
	self.GamePanelRoot=self.gameObject.transform:Find("GamePanel").gameObject
	self.Bg=self.gameObject.transform:Find("GamePanel/GameBGPanel/BGPanel/RawImage").gameObject
	self.HaiWang_Bg = self.gameObject.transform:Find("GamePanel/GameBGPanel/BGPanel/HaiWang_RawImage"):GetComponent(typeof(CS.UnityEngine.UI.RawImage))
	CommonHelper.SetActive(self.HaiWang_Bg.gameObject,false)
	self.GameBG = self.Bg:GetComponent(typeof(CS.UnityEngine.UI.RawImage))
	self.BG2 = self.gameObject.transform:Find("GamePanel/GameBGPanel/BGPanel/BG2"):GetComponent(typeof(CS.UnityEngine.UI.RawImage))
	CommonHelper.SetActive(self.BG2.gameObject,false)
	self.TideGroupRectTrans = self.gameObject.transform:Find("GamePanel/TidePanel/TideGroup"):GetComponent(typeof(CS.UnityEngine.RectTransform))
	CommonHelper.SetActive(self.TideGroupRectTrans.gameObject,false)
	self.UICamera=self.gameObject.transform:Find("Cameras/Camera_UI"):GetComponent(typeof(CS.UnityEngine.Camera))
	self.BGFishLuaBehaviour=self.Bg:AddComponent(typeof(CS.FishLuaBehaviour))
	self.GameEffectRoot=self.gameObject.transform:Find("GamePanel/GameEffectPanel/Group").gameObject
	self.TideSequence = nil
	self.ChangeBGSequence = nil
end



function GameUIManager:AddListennerEvent()
	self.BGFishLuaBehaviour.onPressCallBack=function (isPress) self:BGOnPress(isPress) end
end

function GameUIManager:IsGamePress(press)
	self.GameIsPress = press
end


function GameUIManager:BGOnPress(isPress)

	ElectricSkillManager.GetInstance():ElectricAimOnClick(isPress)
	DrillSkillManager.GetInstance():DrillAimOnClick(isPress)

	if self.GameIsPress == false then 
		return 
	end
	PlayerManager.GetInstance():GetPlayerInsByChairdId(self.gameData.PlayerChairId):OnClickSendShootBullet(isPress)
end

function GameUIManager:SysncGameSceneBG(scneId)
	self:SetGameBG(scneId + 1,self.GameBG,false)
end

function GameUIManager:SetGameBG(index,bgImage,isFadeAnimation)
	if self.AllGameBG[index]==nil then
		local LoadBGCallBack=function (gameObj)
			if gameObj and gameObj.content then
				self.AllGameBG[index]=gameObj.content
				bgImage.texture = self.AllGameBG[index]
				self:ChangeSceneBGImage(index,isFadeAnimation)
			else
				print("背景图片加载失败==>"..self.gameData.GameConfig.BGRes[index].path)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(self.gameData.GameConfig.BGRes[index].path,typeof(CS.UnityEngine.Texture),LoadBGCallBack)
	else
		bgImage.texture = self.AllGameBG[index]
		self:ChangeSceneBGImage(index,isFadeAnimation)
	end
end

function GameUIManager:SceneFishOutTips(tipsType,fishId)
	if tipsType == LuaProtoBufManager.Enum("Fish_Msg.ePromptInfoType","eInfoType_YuChao_Come") then
		local tipsResource = "YuChao_Coming" 
		local lifeTime = 5
		self.gameData.FishOutTipsEffectManager:SetFishOutTipsEffectShowMode(tipsResource,tipsResource,lifeTime)
	else
		local fishConfig=self.gameData.gameConfigList.FishConfigList[fishId]
		if fishConfig ~= nil then
			self.gameData.FishOutTipsEffectManager:SetFishOutTipsEffectShowMode(fishConfig.fishOutTipsResource,fishConfig.fishOutTipsAnimation,fishConfig.fishOutTipsTime)	
		end
	
		if fishConfig.BornEffectName and fishConfig.BornEffectName ~= "0" then
			local name =fishConfig.BornEffectName
			local type = fishConfig.BornEffectType
			local delayTime = 0
			local lifeTime = fishConfig.BornEffectLifeTime
			local effectAudio = nil
			local beginPos = GameObjectPoolManager.GetInstance():GetPoolParent(GameObjectPoolManager.PoolType.EffectPool).transform.position
			FishEffectManager.GetInstance():ShowFishEffect(beginPos,type,name,delayTime,lifeTime,effectAudio)
		end

		if fishConfig.fishBornAudio and fishConfig.fishBornAudio ~= "0" then
			AudioManager.GetInstance():PlayNormalAudio(tonumber(fishConfig.fishBornAudio))
		end
	end
end


function GameUIManager:ChangeGameScene(data)
	local sceneId = data.scene_id
	local changeType = data.scene_change_type
	local time = data.time_seconds
	if changeType == LuaProtoBufManager.Enum("Fish_Msg.eChangeSceneType","eType_WaveTide") then
		self:PlayFishTideAnimation(sceneId,time)
		self:ChangeSceneClearFish(time)
	elseif changeType == LuaProtoBufManager.Enum("Fish_Msg.eChangeSceneType","eInfoType_FishOutScne") then
		self:ChangeSceneClearFish(time)
		self:SetBG2Image()
		self:SetGameBG(sceneId + 1,self.GameBG,true)
	elseif changeType == LuaProtoBufManager.Enum("Fish_Msg.eChangeSceneType","eInfoType_ChangeSceneBG") then
		self:SetBG2Image()
		self:SetGameBG(sceneId + 1,self.GameBG,true)
	end
end

function GameUIManager:ChangeSceneClearFish(time)
	self.gameData.FishManager:FishQuickOutScene(15)
	local clearSceneFishCallBack = function( )
		TimerManager.GetInstance():RecycleTimerIns(self.changeSceneClearTimer)
		self.changeSceneClearTimer = nil
		FishManager.GetInstance():ClearAllUsingFish()
	end
	self.changeSceneClearTimer = TimerManager.GetInstance():CreateTimerInstance((time-0.3),clearSceneFishCallBack) 
end

function GameUIManager:SetBG2Image()
	self.BG2.texture = self.GameBG.texture
	self.BG2.color = CS.UnityEngine.Color(1,1,1,1)
	CommonHelper.SetActive(self.BG2.gameObject,true)	
end

function GameUIManager:ChangeSceneBGImage(sceneId,isFadeAnimation)
	if isFadeAnimation == true then
		if 	self.ChangeBGSequence ~= nil then
			self.ChangeBGSequence:Kill()
			self.ChangeBGSequence = nil
		end
		self.ChangeBGSequence = CS.DG.Tweening.DOTween.Sequence()
		local tempColor = CS.UnityEngine.Color(1,1,1,1)

		local callBack1 = function (  )
			return tempColor
		end
		local callBack2 = function (v)
			tempColor = v
		end

		local alPhaTweener = CS.DG.Tweening.DOTween.ToAlpha(callBack1,callBack2,0,0.5) 
		alPhaTweener.onUpdate = function (  )
			self.BG2.color = tempColor
			self.HaiWang_Bg.color = tempColor
		end
		alPhaTweener:SetEase(CS.DG.Tweening.Ease.InQuad)

		local changeBGComplate =function()
			CommonHelper.SetActive(self.BG2.gameObject,false)
			if sceneId == 6 then
				self.HaiWang_Bg.color = CS.UnityEngine.Color(1,1,1,1)
				CommonHelper.SetActive(self.HaiWang_Bg.gameObject,true)
			else
				CommonHelper.SetActive(self.HaiWang_Bg.gameObject,false)
			end
		end
		
		self.ChangeBGSequence:Append(alPhaTweener)
		self.ChangeBGSequence:AppendCallback(changeBGComplate)		
	else
		CommonHelper.SetActive(self.BG2.gameObject,false)
		if sceneId == 6 then
			self.HaiWang_Bg.color = CS.UnityEngine.Color(1,1,1,1)
			CommonHelper.SetActive(self.HaiWang_Bg.gameObject,true)
		else
			CommonHelper.SetActive(self.HaiWang_Bg.gameObject,false)
		end
	end
end

function GameUIManager:PlayFishTideAnimation(sceneId,time)
	if 	self.TideSequence ~= nil then
		self.TideSequence:Kill()
		self.TideSequence = nil
	end
	AudioManager.GetInstance():StopBgMusic()
	AudioManager.GetInstance():PlayNormalAudio(68)
	CommonHelper.SetActive(self.TideGroupRectTrans.gameObject,true)

	self.TideSequence =  CS.DG.Tweening.DOTween.Sequence()
	local changeSceneBGCallBack = function( )
		self:SetGameBG(sceneId + 1,self.GameBG,true)
	end

	local tideCompleteCallBack = function( )
		self:FishTideOver(sceneId)
	end

	self.TideSequence:InsertCallback(1,changeSceneBGCallBack)
	self.TideSequence:InsertCallback(2,tideCompleteCallBack)
end

function GameUIManager:FishTideOver(sceneId)
	AudioManager.GetInstance():StopNormalAudio(68)
	if sceneId == 5 then
		AudioManager.GetInstance():PlayBGAudio(math.random(66,67),0.4)
	else
		AudioManager.GetInstance():PlayBGAudio(22 + math.random(0,2),0.4)
	end
	if 	self.TideSequence ~= nil then
		self.TideSequence:Kill()
		self.TideSequence = nil
	end
	CommonHelper.SetActive(self.TideGroupRectTrans.gameObject,false)
end


function GameUIManager:SetShake(isVibrate)
	if isVibrate == nil then
		isVibrate = false
	end
	if LobbySettingSystem.GetInstance():GetShake()==false then
		isVibrate = false
	end
	local shakeCamer=GameObjectPoolManager.GetInstance():GetPoolFishRootObj()
	if shakeCamer then
		local positionShake=CSScript.Vector3(math.random(7,9),math.random(1,9),0)
		local angleShake=CSScript.Vector3.zero
		local cycleTime=0.15
		local cycleCount=2 --math.random(2,4)
		shakeCamer:Restart(positionShake,angleShake,cycleTime,cycleCount,isVibrate)
	end
end

function GameUIManager:__delete()
	self.gameData:Destroy()
	if 	self.TideSequence ~= nil then
		self.TideSequence:Kill()
		self.TideSequence = nil
	end

	if 	self.ChangeBGSequence ~= nil then
		self.ChangeBGSequence:Kill()
		self.ChangeBGSequence = nil
	end

	self.gameData=nil
	self.GamePanelRoot=nil
	self.Bg=nil
	self.UICamera=nil
	self.BGFishLuaBehaviour.onPressCallBack=nil
	self.BGFishLuaBehaviour=nil
	self.GameEffectRoot=nil
end