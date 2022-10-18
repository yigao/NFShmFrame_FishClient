HaiShenPanel=Class()

function HaiShenPanel:ctor()
	self:InitData()
end


function HaiShenPanel:InitData()
	self.Text=GameManager.GetInstance().Text
	self.Button=GameManager.GetInstance().Button
end


function HaiShenPanel:ResetInit(gameObj)
	self.gameObject=gameObj
	self:FindView()
	self:InitViewData()
	self:AddBtnEventListenner()
end



function HaiShenPanel:FindView()
	local tf=self.gameObject.transform
	self.MainPanel=tf:Find("PoseidonDialog").gameObject
	
	self:FindBoxView(tf)
	self:FindGetScoreView(tf)
	self:FindOtherView(tf)
	
end

function HaiShenPanel:FindBoxView(tf)
	self.BoxPanel=tf:Find("PoseidonDialog/Image_Bg/Panel_Game").gameObject
	self.BoxList={}
	self.Box1=tf:Find("PoseidonDialog/Image_Bg/Panel_Game/Panel_Box1"):GetComponent(typeof(self.Button))
	local tempBoxList={}
	for i=1,3 do
		local boxT=self.Box1.transform:Find("FX_haishen_box_0"..i).gameObject
		table.insert(tempBoxList,boxT)
	end
	table.insert(self.BoxList,tempBoxList)
	tempBoxList={}
	self.Box2=tf:Find("PoseidonDialog/Image_Bg/Panel_Game/Panel_Box2"):GetComponent(typeof(self.Button))
	for i=1,3 do
		local boxT=self.Box2.transform:Find("FX_haishen_box_0"..i).gameObject
		table.insert(tempBoxList,boxT)
	end
	table.insert(self.BoxList,tempBoxList)
end


function HaiShenPanel:FindGetScoreView(tf)
	self.GetScoreObjList={}
	self.ScoreTextList={}
	for i=1,3 do
		local scoreObj=tf:Find("PanelResult/PoseidonDialog"..i).gameObject
		table.insert(self.GetScoreObjList,scoreObj)
		local scoreText=nil
		if i==3 then
			scoreText=scoreObj.transform:Find("UI/diban/Text/number"):GetComponent(typeof(self.Text))
		else
			scoreText=scoreObj.transform:Find("UI_VIP/img_cannons_icon/img_shouji_jianglidi/Text"):GetComponent(typeof(self.Text))
		end
		table.insert(self.ScoreTextList,scoreText)
	end
end

function HaiShenPanel:FindOtherView(tf)
	self.LeavePanel=tf:Find("PoseidonDialog/Image_Bg/Panel_LeaveConfirm").gameObject
	self.Text_CurrReward=tf:Find("PoseidonDialog/Image_Bg/Panel_LeaveConfirm/Image_Bg/Text_CurrReward"):GetComponent(typeof(self.Text))
	self.ConfirmBtn=tf:Find("PoseidonDialog/Image_Bg/Panel_LeaveConfirm/Image_Bg/Button_Confirm"):GetComponent(typeof(self.Button))
	self.CancelBtn=tf:Find("PoseidonDialog/Image_Bg/Panel_LeaveConfirm/Image_Bg/Button_Cancel"):GetComponent(typeof(self.Button))
	
	self.RetreatBtn=tf:Find("PoseidonDialog/Image_Bg/Panel_Info/Button_Leave"):GetComponent(typeof(self.Button))
	self.RetreatText=tf:Find("PoseidonDialog/Image_Bg/Panel_Info/Text_CurrRewardTips/Text_CurrReward"):GetComponent(typeof(self.Text))
	self.TipsGuessScucessText=tf:Find("PoseidonDialog/Image_Bg/Panel_Info/Text_RewardTips"):GetComponent(typeof(self.Text))
	self.GuessScucessText=tf:Find("PoseidonDialog/Image_Bg/Panel_Info/Text_RewardTips/Panel/Text_Reward"):GetComponent(typeof(self.Text))
	self.BaseTipsText=tf:Find("PoseidonDialog/Image_Bg/Panel_Info/Text_WrongTips"):GetComponent(typeof(self.Text))
	self.CloseBtn=tf:Find("PoseidonDialog/Image_Bg/Button_Close"):GetComponent(typeof(self.Button))
end


function HaiShenPanel:InitViewData()
	
end


function HaiShenPanel:AddBtnEventListenner()
	self.Box1.onClick:AddListener(function () self:OnclickBox1Btn() end)
	self.Box2.onClick:AddListener(function () self:OnclickBox2Btn() end)
	self.CloseBtn.onClick:AddListener(function () self:OnclickCloseBtn() end)
	self.RetreatBtn.onClick:AddListener(function () self:OnclickRetreatBtn() end)
	self.ConfirmBtn.onClick:AddListener(function () self:OnclickConfirmBtn() end)
	self.CancelBtn.onClick:AddListener(function () self:OnclickCancelBtn() end)
end


function HaiShenPanel:IsShowMainPanel(isShow)
	CommonHelper.SetActive(self.MainPanel,isShow)
end

function HaiShenPanel:IsShowLeavePanel(isShow)
	CommonHelper.SetActive(self.LeavePanel,isShow)
end

function HaiShenPanel:IsShowBoxPanel(isShow)
	CommonHelper.SetActive(self.BoxPanel,isShow)
end

function HaiShenPanel:IsShowWinScorePanel(index,isShow)
	CommonHelper.IsShowPanel(index,self.GetScoreObjList,isShow,true,false)
end

function HaiShenPanel:IsShowSingleBoxPanel(boxListIndex,boxIndex,isShow)
	CommonHelper.IsShowPanel(boxIndex,self.BoxList[boxListIndex],isShow,true,false)
end


function HaiShenPanel:SetRetreatScore(score)
	self.RetreatText.text=CommonHelper.FormatBaseProportionalScore(score)
end


function HaiShenPanel:SetScuessScore(score)
	self.GuessScucessText.text=CommonHelper.FormatBaseProportionalScore(score)
end


function HaiShenPanel:SetCurrentScore(score)
	self.Text_CurrReward.text=CommonHelper.FormatBaseProportionalScore(score)
end


function HaiShenPanel:SetTipsWinScore(score)
	for i=1,#self.ScoreTextList do
		self.ScoreTextList[i].text=CommonHelper.FormatBaseProportionalScore(score)
	end
end


function HaiShenPanel:SetBaseScoreTips(score)
	self.BaseTipsText.text="（猜对游戏奖励翻倍，猜错获得基础奖励"..CommonHelper.FormatBaseProportionalScore(score).."金币）"
end


function HaiShenPanel:SetScuessScoreTips(count,totalCount)
	self.TipsGuessScucessText.text="["..count.."/"..totalCount.."轮]本轮猜对可获得奖励"
end


function HaiShenPanel:IsEnableBoxBtn(isEnabled)
	self.Box1.enabled=isEnabled
	self.Box2.enabled=isEnabled
end


function HaiShenPanel:OnclickBox1Btn()
	self:IsEnableBoxBtn(false)
	HaiShenManager.GetInstance():RequestSelectBox(1)
end

function HaiShenPanel:OnclickBox2Btn()
	self:IsEnableBoxBtn(false)
	HaiShenManager.GetInstance():RequestSelectBox(2)
end

function HaiShenPanel:OnclickCloseBtn()
	self:IsShowLeavePanel(true)
end

function HaiShenPanel:OnclickRetreatBtn()
	self:IsShowLeavePanel(true)
end

function HaiShenPanel:OnclickConfirmBtn()
	HaiShenManager.GetInstance():RequestQuitGame()
end

function HaiShenPanel:OnclickCancelBtn()
	self:IsShowLeavePanel(false)
end


function HaiShenPanel:ResetBox()
	self:IsShowSingleBoxPanel(1,0,true)
	self:IsShowSingleBoxPanel(2,0,true)
	self:IsShowSingleBoxPanel(1,1,true)
	self:IsShowSingleBoxPanel(2,1,true)
end







