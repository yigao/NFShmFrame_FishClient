SingleGoldEffect=Class()

function SingleGoldEffect:ctor(obj)
	self.gameObject = obj
	self.transform = self.gameObject.transform
	self:Init(obj)
	
end


function SingleGoldEffect:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
	CommonHelper.AddUpdate(self)
end


function SingleGoldEffect:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.AnimName="Gold01"
	
	self.isCanDestory=false
	self.endPos=CSScript.Vector3.zero
	self.targetPos = CSScript.Vector3.zero
	self.initScale = 0.8
end


function SingleGoldEffect:InitView(gameObj)
	self:FindView()
	
end
local SEM = nil
function SingleGoldEffect:FindView()
	local tf=self.gameObject.transform
	SEM=GoldEffectManager.GetInstance()
	self.Anim=self.gameObject:GetComponent(typeof(SEM.Animator))
	self.GoldImageObj = tf:Find("Gold_Image").gameObject
end


function SingleGoldEffect:InitViewData()
	
end



function SingleGoldEffect:PlayAnim()
	self.Anim:Play(self.AnimName,0,0)
end


function SingleGoldEffect:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
end

function SingleGoldEffect:ResetState(beginPos,targetPos,endPos,delayTime,callBack)
	self.endPos=endPos
	self.targetPos = targetPos
	self.callBack=callBack
	CommonHelper.SetActive(self.GoldImageObj,false)
	self.transform.position = beginPos
	self.transform.localScale = CSScript.Vector3.one
	
	local sequence = SEM.DOTween.Sequence()
	if self.EffectVo.GoldEffectConfig.coinDelayTime ~= nil then
		delayTime = delayTime + self.EffectVo.GoldEffectConfig.coinDelayTime
	end

	sequence:AppendInterval(delayTime)
	local delyShowOverCallBack = function (  )
		self:DelyShowObjOver()
	end
	sequence:AppendCallback(delyShowOverCallBack)	
end

function SingleGoldEffect:DelyShowObjOver(  )
	CommonHelper.SetActive(self.GoldImageObj,true)
	self:PlayAnim()
	local duration = SEM.Random.Range(0.1,0.15)
	local tweener1 = self.transform:DOMove(self.targetPos, duration)
	tweener1:SetEase(SEM.Ease.Linear)
	local centerToBoundsCallBack = function (  )
		self:CenterToBounds()
	end
	tweener1.onComplete = centerToBoundsCallBack
end

function SingleGoldEffect:CenterToBounds(  )
	self.gameData.GoldEffectManager:GoldCenterToBounds(self)
end


function SingleGoldEffect:MoveToEndPoint(delay)
	local sequence = SEM.DOTween.Sequence()
	local duration5 = self.EffectVo.DurationTime
	if duration5 < 0.2 then
		duration5 = 0.2
	elseif  duration5 > 0.5 then
		duration5 = 0.5
	end

	local tweener5 = self.transform:DOMove(self.endPos, duration5)
	tweener5:SetEase(SEM.Ease.InQuint)

	sequence:AppendInterval(delay)
	sequence:Append(tweener5)

	local goldMoveOver = function (  )
		self:GoldMoveEnd()
	end
	sequence:AppendCallback(goldMoveOver)
end

function SingleGoldEffect:GoldMoveEnd(  )
	self.isCanDestory=true
	self:IsShowFlyCoinParticleEffect()
	self:EndCallBack()
end

function SingleGoldEffect:IsShowFlyCoinParticleEffect( )
	local playerIns = self.gameData.PlayerManager:GetPlayerInsByChairdId(self.EffectVo.ChairID)
	playerIns.Panel:IsShowFlyCoinParticleEffect(true)
end

function SingleGoldEffect:Update()
	
end


function SingleGoldEffect:EndCallBack()
	if self.callBack then
		self.callBack()
	end
	--self:Destroy()
end



function SingleGoldEffect:__delete()
	self.isPlayingAnim=false
	self.isCanMove=false
	self.isCanDestory=false
	self.callBack=nil
	self.gameObject.transform:DOKill()
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
	--GoldEffectManager.GetInstance():RecycleGoldEffect(self)
end

return SingleGoldEffect