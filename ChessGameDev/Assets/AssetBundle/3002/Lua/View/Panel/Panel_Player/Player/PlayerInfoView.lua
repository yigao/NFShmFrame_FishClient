PlayerInfoView=Class()

function PlayerInfoView:ctor(gameObj)
	self:Init(gameObj)

end

function PlayerInfoView:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
	self:InitViewData()
end


function PlayerInfoView:InitData()
	self.gameData=GameManager.GetInstance().gameData
	self.Text=GameManager.GetInstance().Text
	self.Image=GameManager.GetInstance().Image
	
	self.CardAtalsName="TBNNCardSpriteAtlas"
	self.GameAtlasName="TBNNBaseSpriteAtlas"
	self.CardName="UI_Efect_Niu_"
	self.CardAnimObjList={}
	self.KanPaiCardImageList={}
	self.TanPaiCardImageList={}
	self.BetTipsList={}
	self.ScoreResultObjList={}
	self.ScoreResultTextList={}
end



function PlayerInfoView:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	
end


function PlayerInfoView:InitViewData()
	self:HideAllCardPanel()
	self:HideAllBetTipsPanel()
	self:HideAllScoreResultPanel()
	self:IsShowWaitEnterDeskPanel(false)
	self:IsShowZhuangJiaTipsPanel(false)
	self:IsShowSelectZJAnimTipsPanel(false)
	self:IsShowNNOpenResultPanel(false)
end


function PlayerInfoView:FindView(tf)
	self:FindCardView(tf)
	self:FindCardImageView(tf)
	self:FindPlayerView(tf)
	self:FindBetTipsView(tf)
	self:FindResultView(tf)
end


function PlayerInfoView:FindCardView(tf)
	local tempCard=tf:Find("PlayerCard/FaPai").gameObject
	table.insert(self.CardAnimObjList,tempCard)
	tempCard=tf:Find("PlayerCard/KanPai").gameObject
	table.insert(self.CardAnimObjList,tempCard)
	tempCard=tf:Find("PlayerCard/TanPai").gameObject
	table.insert(self.CardAnimObjList,tempCard)
end


function PlayerInfoView:FindCardImageView(tf)
	local tempCardImage=nil
	for i=1,5 do
		tempCardImage=tf:Find("PlayerCard/TanPai/Card/ImageCard"..i):GetComponent(typeof(self.Image))
		table.insert(self.TanPaiCardImageList,tempCardImage)
	end
	
	local tempKanPai=tf:Find("PlayerCard/KanPai/Card")
	if tempKanPai then
		for i=1,5 do
			tempCardImage=tf:Find("PlayerCard/KanPai/Card/ImageCard"..i):GetComponent(typeof(self.Image))
			table.insert(self.KanPaiCardImageList,tempCardImage)
		end
	end
end


function PlayerInfoView:FindPlayerView(tf)
	self.playerName=tf:Find("PlayerSetPanel/PlayerInfo/PlayerName/Text"):GetComponent(typeof(self.Text))
	self.playerMoney=tf:Find("PlayerSetPanel/PlayerInfo/PlayerMoney/Text"):GetComponent(typeof(self.Text))
	self.playerHeadImage=tf:Find("PlayerSetPanel/PlayerInfo/PlayerHead/Image"):GetComponent(typeof(self.Image))
	self.waitEnterDeskTips=tf:Find("PlayerSetPanel/PlayerInfo/PlayerState").gameObject
	self.zhuangJiaTips=tf:Find("PlayerSetPanel/PlayerInfo/ZhuangJiaState/SelectZJ").gameObject
	self.selectZJAnimTips=tf:Find("PlayerSetPanel/PlayerInfo/ZhuangJiaState/SelectZJEffect").gameObject
	self.goldFlyEffect=tf:Find("PlayerSetPanel/GoldFlyPos").gameObject
end


function PlayerInfoView:FindBetTipsView(tf)
	local tempObj=tf:Find("PlayerBetTips/NoQiang").gameObject
	table.insert(self.BetTipsList,tempObj)
	tempObj=tf:Find("PlayerBetTips/QiangZhuang").gameObject
	self.QZMultipleText=tf:Find("PlayerBetTips/QiangZhuang/Text"):GetComponent(typeof(self.Text))
	table.insert(self.BetTipsList,tempObj)
	tempObj=tf:Find("PlayerBetTips/Bet").gameObject
	self.BetMultpleText=tf:Find("PlayerBetTips/Bet/Text"):GetComponent(typeof(self.Text))
	table.insert(self.BetTipsList,tempObj)
end


function PlayerInfoView:FindResultView(tf)
	local tempObj=tf:Find("WinTips/Win").gameObject
	table.insert(self.ScoreResultObjList,tempObj)
	tempObj=tf:Find("WinTips/Win/Text"):GetComponent(typeof(self.Text))
	table.insert(self.ScoreResultTextList,tempObj)
	tempObj=tf:Find("WinTips/Lose").gameObject
	table.insert(self.ScoreResultObjList,tempObj)
	tempObj=tf:Find("WinTips/Lose/Text"):GetComponent(typeof(self.Text))
	table.insert(self.ScoreResultTextList,tempObj)
	
	self.ResultPanel=tf:Find("NNResult").gameObject
	self.ResultBGImage=tf:Find("NNResult/SelectResult/ImageBG"):GetComponent(typeof(self.Image))
	self.ResultImage=tf:Find("NNResult/SelectResult/ImageBG/ImageResult"):GetComponent(typeof(self.Image))
end


function PlayerInfoView:HideAllCardPanel()
	self:IsShowCardAnimPanel(0,true)
end


function PlayerInfoView:HideAllBetTipsPanel()
	self:IsShowBetTipsPanel(0,true)
end


function PlayerInfoView:HideAllScoreResultPanel()
	self:IsShowScoreResultPanel(0,true)
end




function PlayerInfoView:IsShowCardAnimPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.CardAnimObjList,isShow,true,false)
end

function PlayerInfoView:IsShowBetTipsPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.BetTipsList,isShow,true,false)
end

function PlayerInfoView:IsShowScoreResultPanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.ScoreResultObjList,isShow,true,false)
end


function PlayerInfoView:IsShowWaitEnterDeskPanel(isShow)
	CommonHelper.SetActive(self.waitEnterDeskTips,isShow)
end

function PlayerInfoView:IsShowZhuangJiaTipsPanel(isShow)
	CommonHelper.SetActive(self.zhuangJiaTips,isShow)
end

function PlayerInfoView:IsShowSelectZJAnimTipsPanel(isShow)
	CommonHelper.SetActive(self.selectZJAnimTips,isShow)
end


function PlayerInfoView:IsShowNNOpenResultPanel(isShow)
	CommonHelper.SetActive(self.ResultPanel,isShow)
end


function PlayerInfoView:SetKanPaiImageValue(tempValueList)
	self:SetCardImageValue(self.KanPaiCardImageList,tempValueList)
end


function PlayerInfoView:SetTanPaiImageValue(tempValueList)
	self:SetCardImageValue(self.TanPaiCardImageList,tempValueList)
end


function PlayerInfoView:SetCardImageValue(targetCardList,tempValueList)
	if #targetCardList>0 then
		for i=1,#targetCardList do
			local cardValue=tempValueList[i].cardType.."_"..tempValueList[i].cardPoint
			targetCardList[i].sprite=self.gameData.AllAtlasList[self.CardAtalsName]:GetSprite(cardValue)
		end
	end
end


function PlayerInfoView:SetQiangZhuangMultipleValue(value)
	self.QZMultipleText.text=value
end

function PlayerInfoView:SetBetMultipleValue(value)
	self.BetMultpleText.text=value
end


function PlayerInfoView:SetResultScoreValue(value)
	self:HideAllScoreResultPanel()
	local tempV=CommonHelper.FormatBaseProportionalScore(math.abs(value))
	for i=1,#self.ScoreResultTextList do
		if tonumber(value)>0 then 
			value="+"..tempV 
			self.ScoreResultTextList[i].text=value
			self:IsShowScoreResultPanel(1,true)
		elseif tonumber(value)<0 then 
			value="-"..tempV 
			self.ScoreResultTextList[i].text=value
			self:IsShowScoreResultPanel(2,true)
		end
		
	end
end


function PlayerInfoView:SetNNOpenResultBgImage(isNN)
	local bgName="UI_Sign_TongPeiBox"
	if isNN then
		bgName="UI_Sign_TongShaBox"
	end
	self.ResultBGImage.sprite=self.gameData.AllAtlasList[self.GameAtlasName]:GetSprite(bgName)
end

function PlayerInfoView:SetNNOpenResultImage(result)
	local currentName=self.CardName..result
	self.ResultImage.sprite=self.gameData.AllAtlasList[self.GameAtlasName]:GetSprite(currentName)
end


function PlayerInfoView:SetPlayerName(name)
	self.playerName.text=name
end

function PlayerInfoView:SetPlayerMoney(money)
	self.playerMoney.text=CommonHelper.FormatBaseProportionalScore(money)
end

function PlayerInfoView:SetPlayerHead(headImage)
	self.playerHeadImage.sprite=headImage
end



function PlayerInfoView:GetGoldFlyEffectPos()
	return self.goldFlyEffect.transform.position
end