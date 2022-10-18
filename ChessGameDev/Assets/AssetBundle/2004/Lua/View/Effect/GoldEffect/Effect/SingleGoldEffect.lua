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
	self.MyAnimName="Gold01"
	self.OtherAnimName="Gold02"

	self.isCanDestory=false
	self.endPos=CSScript.Vector3.zero
	self.jumpHeight = 200
	self.yValue = 0
	self.fishY = 0
	self.speed = 1000
	self.initScale = 0.8
	self.sequence01 = nil
	self.sequence02 = nil
	self.sequence03 = nil
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

function SingleGoldEffect:ResetState(beginPos,endPos,fishY,delayTime,callBack)
	self.endPos=endPos
	self.callBack=callBack
	self.Anim.enabled = true
	self.transform.position = beginPos
	self.transform.localScale = CSScript.Vector3.one
	CommonHelper.SetActive(self.GoldImageObj,false)
	self.fishY = fishY
	self.yValue = self.transform.localPosition.y
	
	if self.sequence01 then
		self.sequence01:Kill()
		self.sequence01 = nil
	end

	self.sequence01 = SEM.DOTween.Sequence()
	local showGoldCallBack = function (  )
		CommonHelper.SetActive(self.GoldImageObj,true)
		self:PlayAnim()
	end
	
	local duration1 = 0.2
	local y1 = self.jumpHeight + self.yValue
	
	local tweener1 = self.transform:DOLocalMoveY(y1, duration1)
	tweener1:SetEase(SEM.Ease.OutCubic)

	local tweener2 = self.transform:DOLocalMoveY(self.yValue, duration1)
	tweener2:SetEase(SEM.Ease.InCubic)
	--local tweenerScale = self.transform:DOScale(CSScript.Vector3(1,1,0), duration1)
	self.sequence01:PrependInterval(delayTime)
	self.sequence01:InsertCallback(delayTime,showGoldCallBack)
	self.sequence01:Append(tweener1)
	--sequence:Join(tweenerScale)
	self.sequence01:Append(tweener2)

	local twoStepJumpCallBack = function (  )
		self:TwoStepJump()
	end
	self.sequence01:AppendCallback(twoStepJumpCallBack)	
end

function SingleGoldEffect :TwoStepJump(  )
	if self.sequence02 then
		self.sequence02:Kill()
		self.sequence02 = nil
	end
	self.sequence02 = SEM.DOTween.Sequence()
	
	local duration2 = 0.1
	local y2 = self.jumpHeight * 0.4+self.fishY
	local tweener3 = self.transform:DOLocalMoveY(y2, duration2)
	tweener3:SetEase(SEM.Ease.OutCubic)
	local tweener4 = self.transform:DOLocalMoveY(self.yValue, duration2)
	tweener4:SetEase(SEM.Ease.InCubic)

	local duration3 = 0.07
	local y3 = self.jumpHeight * 0.3+self.fishY
	local tweener5 = self.transform:DOLocalMoveY(y2, duration3)
	tweener3:SetEase(SEM.Ease.OutCubic)
	local tweener6 = self.transform:DOLocalMoveY(self.yValue, duration3)
	tweener4:SetEase(SEM.Ease.InCubic)


	self.sequence02:Append(tweener3)
	self.sequence02:Append(tweener4)
	self.sequence02:Append(tweener5)
	self.sequence02:Append(tweener6)


	local centerToJumpOverCallBack = function (  )
		self:CenterToJumpOver()
	end
	self.sequence02:AppendCallback(centerToJumpOverCallBack)		

end

function SingleGoldEffect:CenterToJumpOver(  )
	self.gameData.GoldEffectManager:GoldCenterToJumpOver(self)
end

function SingleGoldEffect:MoveToEndPoint(delay)
	if self.sequence03 then
		self.sequence03:Kill()
		self.sequence03 = nil
	end
	self.sequence03 = SEM.DOTween.Sequence()
	local duration5 = self.EffectVo.DurationTime
	if duration5 <= 0.3 then
		duration5 = 0.3
	elseif  duration5 >= 0.5 then
		duration5 = 0.5
	end

	local tweener5 = self.transform:DOMove(self.endPos, duration5)
	tweener5:SetEase(SEM.Ease.InQuint)

	local tweener6 = self.transform:DOScale(CSScript.Vector3(0.6, 0.6, 1),duration5)
	tweener6:SetEase(SEM.Ease.InQuint)

	self.sequence03:AppendInterval(delay)
	self.sequence03:Append(tweener5)
	self.sequence03:Join(tweener6)
	local goldMoveOver = function (  )
		self:GoldMoveEnd()
	end
	self.sequence03:AppendCallback(goldMoveOver)
end

function SingleGoldEffect:GoldMoveEnd(  )
	self.isCanDestory=true
	self:EndCallBack()
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
	self.Anim.enabled = false
	self.gameObject.transform:DOKill()

	if self.sequence01 then
		self.sequence01:Kill()
		self.sequence01 = nil
	end

	if self.sequence02 then
		self.sequence02:Kill()
		self.sequence02 = nil
	end

	if self.sequence03 then
		self.sequence03:Kill()
		self.sequence03 = nil
	end
	self.gameObject.transform.localPosition=CSScript.Vector3(10000,10000,0)
end

return SingleGoldEffect