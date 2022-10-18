BetChipItem=Class()

function BetChipItem:ctor(gameObj)
	self:Init(gameObj)
	
end

function BetChipItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function BetChipItem:InitData()
	self.betChipVo = nil
	
	self.gameData=GameManager.GetInstance().gameData
	self.Tween = GameManager.GetInstance().Tween
	self.Sequence = GameManager.GetInstance().Sequence
	self.Ease = GameManager.GetInstance().Ease
	self.DOTween = GameManager.GetInstance().DOTween
	self.TweenExtensions = GameManager.GetInstance().TweenExtensions
	self.Text=GameManager.GetInstance().Text
	self.Vector3 = GameManager.GetInstance().Vector3
	self.BetChipItemList = {}
	self.BeginPos = self.Vector3.zero
end

function BetChipItem:InitView(gameObj)
	self.gameObject = gameObj
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BetChipItem:FindView(tf)
	self.BetChipTrans = tf
	self.BetChipNumber = tf:Find("Content/Number"):GetComponent(typeof(self.Text))
end

function BetChipItem:InitViewData()

end

function BetChipItem:ResetBetChipVo(betChipVo)
	self.betChipVo = betChipVo
end

function BetChipItem:ShowBetChipItem(siblingIndex,delayTimeInterval,betChipValue,beginPos,targetPos)
	self.BetChipTrans:SetSiblingIndex(siblingIndex)
	self.BeginPos = beginPos
	self.BetChipTrans.position = self.Vector3(10000,10000,0)
	self:SetBetChipValue(betChipValue)

	self:MoveToBetArea(delayTimeInterval,targetPos)
end

function BetChipItem:SetBetChipValue(betChipValue)
	self.BetChipNumber.text = betChipValue
end

function BetChipItem:MoveToBetArea(delayTimeInterval,targetPos,callback)
	local moveEnd = function()
		
		if callback then
			callback(self)
		end
	end

	local beginPosCallBack = function()
		local random = math.random(1,100)
		if random >= 70 then
			AudioManager.GetInstance():PlayNormalAudio(25)
		end
		self.BetChipTrans.position = self.BeginPos
	end

	local tweener1 = self.BetChipTrans:DOMove(targetPos,0.3)
	tweener1:OnComplete(moveEnd)

	if self.moveSequence ~= nil then
		self.moveSequence:Kill()
		self.moveSequence = nil
	end
	self.moveSequence = self.DOTween.Sequence()
	self.moveSequence:InsertCallback(delayTimeInterval,beginPosCallBack)
	self.moveSequence:Insert(delayTimeInterval,tweener1)
end

function BetChipItem:MoveToPlayer(delayTimeInterval,targetPos,callback)
	local moveEnd = function()
		if callback then
			callback(self)
		end
	end

	local tweener1 = self.BetChipTrans:DOMove(targetPos,0.3)
	tweener1:OnComplete(moveEnd)
	if self.moveSequence ~= nil then
		self.moveSequence:Kill()
		self.moveSequence = nil
	end
	self.moveSequence = self.DOTween.Sequence()
	self.moveSequence:Insert(delayTimeInterval,tweener1)
end

function BetChipItem:MoveToWinArea(timeInterval,bankerPos,targetAreaPos,callback)
	local moveEnd = function()
		if callback then
			callback()
		end
	end
	
	local moveTwoStepCallBack = function()
		local tweener2 = self.BetChipTrans:DOMove(targetAreaPos,0.3)
		tweener2:SetEase(self.Ease.InOutQuint)
		tweener2:OnComplete(moveEnd)
	end
	local tweener1 = self.BetChipTrans:DOMove(bankerPos,0.6 + timeInterval):OnComplete(moveTwoStepCallBack)
	tweener1:SetEase(self.Ease.InQuint)
	tweener1:OnComplete(moveTwoStepCallBack)
end

function BetChipItem:__delete()
	if self.moveSequence ~= nil then
		self.moveSequence:Kill()
		self.moveSequence = nil
	end
	self.BetChipTrans:DOKill()
	self.BetChipTrans.localPosition=self.Vector3(10000,10000,0)
end
