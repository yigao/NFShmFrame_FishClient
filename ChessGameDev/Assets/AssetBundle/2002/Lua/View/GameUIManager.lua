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
	self.gameData.BigAwardTipsEffectManager = BigAwardTipsEffectManager.New(gameObj)
	self.gameData.BombManager=BombManager.New(gameObj)
	self.gameData.FishEffectManager=FishEffectManager.New(gameObj)
	self.gameData.FishOutTipsEffectManager=FishOutTipsEffectManager.New(gameObj)
	self.gameData.LightningEffectManager = LightningEffectManager.New(gameObj)
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
	self.GameBG = self.Bg:GetComponent(typeof(CS.UnityEngine.UI.RawImage))
	self.BG2 = self.gameObject.transform:Find("GamePanel/TidePanel/TideGroup/BG2"):GetComponent(typeof(CS.UnityEngine.UI.RawImage))
	self.TideGroupRectTrans = self.gameObject.transform:Find("GamePanel/TidePanel/TideGroup"):GetComponent(typeof(CS.UnityEngine.RectTransform))
	CommonHelper.SetActive(self.TideGroupRectTrans.gameObject,false)
	self.UICamera=self.gameObject.transform:Find("Cameras/Camera_UI"):GetComponent(typeof(CS.UnityEngine.Camera))
	self.BGFishLuaBehaviour=self.Bg:AddComponent(typeof(CS.FishLuaBehaviour))
	self.GameEffectRoot=self.gameObject.transform:Find("GamePanel/GameEffectPanel/Group").gameObject
	self.TideTweener = nil
end



function GameUIManager:AddListennerEvent()
	self.BGFishLuaBehaviour.onPressCallBack=function (isPress) self:BGOnPress(isPress) end
end


function GameUIManager:BGOnPress(isPress)
	if isPress then
		AudioManager.GetInstance():PlayNormalAudio(42,0.3)
	end
	PlayerManager.GetInstance():GetPlayerInsByChairdId(self.gameData.PlayerChairId):OnClickSendShootBullet(isPress)
end

function GameUIManager:SysncGameSceneBG(scneId)
	self:SetBG(scneId + 1,self.GameBG)
end

function GameUIManager:SetBG(index,bgImage)
	if self.AllGameBG[index]==nil then
		local LoadBGCallBack=function (gameObj)
			if gameObj and gameObj.content then
				self.AllGameBG[index]=gameObj.content
				bgImage.texture = self.AllGameBG[index]
			else
				print("背景图片加载失败==>"..self.gameData.GameConfig.BGRes[index].path)
			end
		end
		GameManager.GetInstance():AsyncLoadResource(self.gameData.GameConfig.BGRes[index].path,typeof(CS.UnityEngine.Texture),LoadBGCallBack)
	else
		bgImage.texture = self.AllGameBG[index]
	end
end

function GameUIManager:SceneFishOutTips(tipsType,fishId)
	--[[print("SceneFishOutTips")
	print(tipsType)
	print(fishId)--]]
	if tipsType == LuaProtoBufManager.Enum("Fish_Msg.ePromptInfoType","eInfoType_YuChao_Come") then
		local tipsResource = "FishOutTips_Tide" 
		local lifeTime = 1.4
		self.gameData.FishOutTipsEffectManager:SetFishOutTipsEffectShowMode(tipsResource,lifeTime)
	else
		local fishConfig=self.gameData.gameConfigList.FishConfigList[fishId]
		if fishConfig ~= nil then
			self.gameData.FishOutTipsEffectManager:SetFishOutTipsEffectShowMode(fishConfig.fishOutTipsResource,fishConfig.fishOutTipsTime)	
		end
	end
end


function GameUIManager:ChangeGameScene(data)
	local sceneId = data.scene_id
	local changeType = data.scene_change_type
	local time = data.time_seconds
	--print(sceneId,changeType,time)
	if changeType == LuaProtoBufManager.Enum("Fish_Msg.eChangeSceneType","eType_WaveTide") then
		self:PlayFishTideAnimation(sceneId,time)
		self.gameData.FishManager:FishQuickOutScene(15)
	elseif changeType == LuaProtoBufManager.Enum("Fish_Msg.eChangeSceneType","eInfoType_FishOutScne") then
		self.gameData.FishManager:FishQuickOutScene(15)
		self:SysncGameSceneBG(sceneId)
	elseif changeType == LuaProtoBufManager.Enum("Fish_Msg.eChangeSceneType","eInfoType_ChangeSceneBG") then
		self:SysncGameSceneBG(sceneId)
	end
end

function GameUIManager:PlayFishTideAnimation(sceneId,time)
	if 	self.TideTweener ~= nil then
		self.TideTweener:Kill()
		self.TideTweener = nil
	end
	time=time or 0
	AudioManager.GetInstance():StopBgMusic()
	AudioManager.GetInstance():PlayNormalAudio(30)
	AudioManager.GetInstance():PlayNormalAudio(40)
	self:SetBG(sceneId + 1,self.BG2)
	self.TideGroupRectTrans.anchoredPosition = CS.UnityEngine.Vector2(-1750,0)
	CommonHelper.SetActive(self.TideGroupRectTrans.gameObject,true)
	local callBack1 = function (  )
		return self.TideGroupRectTrans.anchoredPosition
	end
	local callBack2 = function (v)
		self.TideGroupRectTrans.anchoredPosition = v
	end
	self.TideTweener = CS.DG.Tweening.DOTween.To(callBack1,callBack2,CS.UnityEngine.Vector2(0,0),time) 
	self.TideTweener:SetEase(CS.DG.Tweening.Ease.Linear) 
	local onCompleteCallBack = function ()
		self:FishTideOver(sceneId)
	end
	self.TideTweener.onComplete = onCompleteCallBack
end

function GameUIManager:FishTideOver(sceneId)
	self.TideTweener = nil
	AudioManager.GetInstance():StopNormalAudio(30)
	AudioManager.GetInstance():StopNormalAudio(40)
	AudioManager.GetInstance():PlayBGAudio(22 + sceneId)
	self.GameBG.texture = self.BG2.texture
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
	self.gameData=nil
	self.GamePanelRoot=nil
	self.Bg=nil
	self.UICamera=nil
	self.BGFishLuaBehaviour.onPressCallBack=nil
	self.BGFishLuaBehaviour=nil
	self.GameEffectRoot=nil
	
end