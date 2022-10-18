LotteryHostoryItem=Class()

function LotteryHostoryItem:ctor(gameObj)
	self.gameObject=gameObj
	self:Init(gameObj)

end

function LotteryHostoryItem:Init (gameObj)
	self:InitData()
	self:InitView(gameObj)
end


function LotteryHostoryItem:InitData()
	self.Animation=GameManager.GetInstance().Animation
	self.Image=GameManager.GetInstance().Image
	self.LotteryHostoryAtlasName="SHZSpriteAtlas"
	self.ResultSpriteNameList={"UI_LD_Da","UI_LD_He","UI_LD_Xiao"}
end



function LotteryHostoryItem:InitView(gameObj)
	local mtrans=gameObj.transform
	self:FindView(mtrans)
	self:InitViewData()
end


function LotteryHostoryItem:FindView(tf)
	self.IconImage=tf:GetComponent(typeof(self.Image))
	self.SelectAnim=tf:GetComponent(typeof(self.Animation))
end


function LotteryHostoryItem:InitViewData()
	self:IsShowLotteryHostoryPanel(false)
end


function LotteryHostoryItem:IsShowLotteryHostoryPanel(isShow)
	CommonHelper.SetActive(self.gameObject,isShow)
end


function LotteryHostoryItem:PlaySelectAnim()
	self.SelectAnim:Play()
end


function LotteryHostoryItem:SetSpriteName(index)
	local imageName=self.ResultSpriteNameList[index]
	self.IconImage.sprite=GameManager.GetInstance().gameData.AllAtlasList[self.LotteryHostoryAtlasName]:GetSprite(imageName)
end


function LotteryHostoryItem:SetSpriteProcess(index)
	self:SetSpriteName(index)
	self:IsShowLotteryHostoryPanel(true)
end