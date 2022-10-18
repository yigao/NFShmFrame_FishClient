BaseView=Class()

function BaseView:ctor(gameObj)
	self:Init(gameObj)

end

function BaseView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	
end


function BaseView:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
	self.Animation=GameManager.GetInstance().Animation
	
	self.BaseIconMultipleList={}
	self.IconMultipleValueList={}
end



function BaseView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function BaseView:FindView(tf)
	self:FindBaseIconView(tf)
	self:FindIconMultipleView(tf)
	self:FindOtherView(tf)
end


function BaseView:FindBaseIconView(tf)
	for i=1,7 do
		local tempIconText=tf:Find("BasePanel/MainPanel/IconMultiplePanel/Icon0"..i.."/Text"):GetComponent(typeof(self.Text))
		if tempIconText then
			table.insert(self.BaseIconMultipleList,tempIconText)
		else
			Debug.LogError("查找bonus基础图标倍数异常")
		end
	end
end


function BaseView:FindIconMultipleView(tf)
	local tempIconText=tf:Find("BasePanel/MainPanel/BetMultiplePanel/MidPanel/LeftBet/Text"):GetComponent(typeof(self.Text))
	table.insert(self.IconMultipleValueList,tempIconText)
	tempIconText=tf:Find("BasePanel/MainPanel/BetMultiplePanel/MidPanel/MidBet/Text"):GetComponent(typeof(self.Text))
	table.insert(self.IconMultipleValueList,tempIconText)
	tempIconText=tf:Find("BasePanel/MainPanel/BetMultiplePanel/MidPanel/RightBet/Text"):GetComponent(typeof(self.Text))
	table.insert(self.IconMultipleValueList,tempIconText)
	
end


function BaseView:FindOtherView(tf)
	self.BonusRemainCount=tf:Find("BasePanel/MainPanel/OtherSetPanel/BonusCount/Text"):GetComponent(typeof(self.Text))
	self.PlayerChipValue=tf:Find("BasePanel/MainPanel/OtherSetPanel/Chip/Text"):GetComponent(typeof(self.Text))
	self.BonusWinScoreValue=tf:Find("BasePanel/MainPanel/OtherSetPanel/Score/Text"):GetComponent(typeof(self.Text))
	self.PlayerBetValue=tf:Find("BasePanel/MainPanel/OtherSetPanel/Bet/Text"):GetComponent(typeof(self.Text))
end



function BaseView:SetBonusRemainCount(count)
	self.BonusRemainCount.text=count
end

function BaseView:SetBonusPlayerChipValue(count)
	self.PlayerChipValue.text=count
end

function BaseView:SetBonusWinScoreValue(count)
	self.BonusWinScoreValue.text=count
end

function BaseView:SetPlayerBetValue(count)
	self.PlayerBetValue.text=count
end



function BaseView:InitViewData()
	self:SetBonusRemainCount(0)
	self:SetBonusPlayerChipValue(0)
	self:SetBonusWinScoreValue(0)
	self:SetPlayerBetValue(0)
end



function BaseView:__delete()

end