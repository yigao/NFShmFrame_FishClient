BonusView=Class()

function BonusView:ctor(gameObj)
	self:Init(gameObj)

end

function BonusView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function BonusView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Animation=GameManager.GetInstance().Animation
	self.BonusAnimNameList={"BonusOpen","BonusClose"}
end



function BonusView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BonusView:FindView(tf)
	self.BonusPanel=tf:Find("Down/Bonus/BonusTips").gameObject
	--self.BonusAnim=self.BonusPanel:GetComponent(typeof(self.Animation))
	self.JackpotPanel=tf:Find("Down/SpecialWin/Show").gameObject
	self.JackpotAnim=self.JackpotPanel:GetComponent(typeof(self.Animation))
	self.JackpotWinScore=tf:Find("Down/SpecialWin/Show/TextWin"):GetComponent(typeof(self.Text))
end



function BonusView:InitViewData()
	self:IsShowBonusPanel(false)
end


function BonusView:IsShowBonusPanel(isShow)
	CommonHelper.SetActive(self.BonusPanel,isShow)
end

function BonusView:IsShowJackpotPanel(isShow)
	CommonHelper.SetActive(self.JackpotPanel,isShow)
end


function BonusView:PlayAnim(index)
	--self.BonusAnim:Play(self.BonusAnimNameList[index])
end

function BonusView:PlayJackAnim(index)
	self.JackpotAnim:Play(self.BonusAnimNameList[index])
end


function BonusView:SetJackpotScore(score)
	self.JackpotWinScore.text=CommonHelper.FormatBaseProportionalScore(score)
end	


function BonusView:SetBonusProcess(callBackFunc)
	local BonusProcessFunc=function ()
		self:IsShowBonusPanel(true)
		--self:PlayAnim(1)
		yield_return(WaitForSeconds(6))
		self:IsShowBonusPanel(false)
		--self:PlayAnim(2)
		--yield_return(WaitForSeconds(0.5))
		if callBackFunc then
			callBackFunc()
		end
	end
	
	startCorotine(BonusProcessFunc)
end


function BonusView:SetJackpotProcess(score,callBackFunc)
	local JackpotProcessFunc=function ()
		self:SetJackpotScore(score)
		self:IsShowJackpotPanel(true)
		self:PlayJackAnim(1)
		yield_return(WaitForSeconds(3))
		self:PlayJackAnim(2)
		yield_return(WaitForSeconds(0.5))
		if callBackFunc then
			callBackFunc()
		end
	end
	
	startCorotine(JackpotProcessFunc)
end