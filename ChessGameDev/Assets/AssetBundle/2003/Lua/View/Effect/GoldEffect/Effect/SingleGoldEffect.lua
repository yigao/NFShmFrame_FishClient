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
end


function SingleGoldEffect:InitData()
	self.gameUIManager=GameUIManager.GetInstance()
	self.gameData=self.gameUIManager.gameData
	self.MyAnimName="Gold01"
	self.OtherAnimName="Gold02"

	self.isCanDestory=false
	self.endPos=CSScript.Vector3.zero
	self.jumpHeight = 70
	self.yValue = 0
	self.speed = 470
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
end


function SingleGoldEffect:InitViewData()
	
end



function SingleGoldEffect:PlayAnim()
	if 	self.EffectVo.IsMe then
		self.Anim:Play(self.MyAnimName,0,0)
	else
		self.Anim:Play(self.OtherAnimName,0,0)
	end
end


function SingleGoldEffect:ResetEffectVo(vo)
	self.EffectVo=vo
	self.isCanDestory=false
	self.isPlayingAnim=false
end

function SingleGoldEffect:ResetState(beginPos,endPos,callBack)
	
	self.endPos=endPos
	self.callBack=callBack
	self:PlayAnim()

	self.transform.position = beginPos
	self.transform.localScale = CSScript.Vector3(self.initScale, self.initScale, 1)
	self.yValue = self.transform.localPosition.y

	local sequence = SEM.DOTween.Sequence()

	local  mul1 = SEM.Random.Range(0.2, 2)
	local tempJump1 = self.jumpHeight * mul1
	local duration1 =math.abs(tempJump1/(self.speed * 2))
	local y1 = tempJump1 + self.yValue
	
	local tweener1 = self.transform:DOLocalMoveY(y1, duration1)
	tweener1:SetEase(SEM.Ease.InOutQuart)

	local mul2 = SEM.Random.Range(-(1.5 - mul1),0)
	local tempJump2 = self.jumpHeight * mul2
	local duration2 = math.abs(tempJump2 /self.speed)
	local y2 = tempJump2 + self.yValue
	if duration2 < 0.1 then
		duration2 = 0.1
	elseif duration2 >= 0.2 then
		duration2 = 0.2
	end
	local tweener2 = self.transform:DOLocalMoveY(y2, duration2)
	tweener2:SetEase(SEM.Ease.InQuint)

	local tweenerScale = self.transform:DOScale(CSScript.Vector3(1,1,0), duration1)

	sequence:Append(tweener1)
	sequence:Join(tweenerScale)
	sequence:Append(tweener2)
	local twoStepJumpCallBack = function (  )
		self:TwoStepJump()
	end
	sequence:AppendCallback(twoStepJumpCallBack)	
end

function SingleGoldEffect :TwoStepJump(  )
	
	local sequence = SEM.DOTween.Sequence()
	local hValue =self.yValue --self.transform.localPosition.y
	local mul3 = SEM.Random.Range(0, 1)
	local tempJump3 = self.jumpHeight * mul3
	local duration3 = math.abs(tempJump3 /self.speed)
	local y3 = tempJump3 + hValue
	if duration3 < 0.1 then
		duration3 = 0.1
	elseif duration3 > 0.2 then
		duration3 = 0.2
	end
	local tweener3 = self.transform:DOLocalMoveY(y3, duration3)
	tweener3:SetEase(SEM.Ease.InOutQuart)

	local mul4 = SEM.Random.Range(-(1 - mul3), 0)
	local tempJump4 = self.jumpHeight * mul4
	local duration4 = math.abs(tempJump4 /self.speed)
	local y4 = tempJump4 + hValue
	if duration4 < 0.1 then
		duration4 = 0.1
	elseif duration4 > 0.2 then
		duration4 = 0.2
	end
	local tweener4 = self.transform:DOLocalMoveY(y4, duration4)
	tweener4:SetEase(SEM.Ease.InOutQuart)
	
	sequence:Append(tweener3)
	sequence:Append(tweener4)
	local centerToJumpOverCallBack = function (  )
		self:CenterToJumpOver()
	end
	sequence:AppendCallback(centerToJumpOverCallBack)		

end

function SingleGoldEffect:CenterToJumpOver(  )
	self.gameData.GoldEffectManager:GoldCenterToJumpOver(self)
end

function SingleGoldEffect:MoveToEndPoint(delay)
	local sequence = SEM.DOTween.Sequence()
	local duration5 = self.EffectVo.DurationTime
	if duration5 <= 0.1 then
		duration5 = 0.1
	elseif  duration5 >= 0.5 then
		duration5 = 0.5
	end

	local tweener5 = self.transform:DOMove(self.endPos, duration5)
	tweener5:SetEase(SEM.Ease.InQuint)

	local tweener6 = self.transform:DOScale(CSScript.Vector3(0.6, 0.6, 1),duration5)
	tweener6:SetEase(SEM.Ease.InQuint)

	sequence:AppendInterval(delay)
	sequence:Append(tweener5)
	sequence:Join(tweener6)
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