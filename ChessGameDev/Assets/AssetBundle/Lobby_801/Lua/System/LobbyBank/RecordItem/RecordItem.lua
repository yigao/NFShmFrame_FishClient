RecordItem = Class()

function RecordItem:ctor(go)
    self:Init(go)
end

function RecordItem:Init(go)
    self:InitData()
    self:InitView(go)
end

function RecordItem:InitData(  )
    self.currentRecordVo = nil
end

function RecordItem:InitView(go)
    self.itemGameObject = go
    self.itemTransform = go.transform
    self:GetUIComponent()
end

function RecordItem:GetUIComponent()
    self.money_text =  self.itemTransform:Find("money"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.name_text = self.itemTransform:Find("name"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.id_text = self.itemTransform:Find("id"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.time_text = self.itemTransform:Find("time"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.topic_text = self.itemTransform:Find("topic"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    
    self.uiListElementScript = self.itemTransform:GetComponent(typeof(CS.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableRecordItem(index) end
end

function RecordItem:OnEnableRecordItem(index)
    self.currentRecordVo = LobbyBankSystem.GetInstance().bankGiftRecordPanel.giftRecordList[index + 1]
    self:ShowUIComponent()
end

function RecordItem:RefreshUIComponent(  )
    self:ShowUIComponent()
end

function RecordItem:ShowUIComponent()
    self.time_text.text = os.date("%Y-%m-%d      %H:%M:%S",self.currentRecordVo.create_time) 
    if self.currentRecordVo.user_id == LobbyHallCoreSystem.GetInstance().playerInfoVo.user_id then
        self.money_text.text ="-"..self.currentRecordVo.give_jetton
        self.money_text.color = CS.UnityEngine.Color(0.34,0.62,0.95,1)
        self.name_text.text = self.currentRecordVo.give_user_name
        self.id_text.text = "(ID："..self.currentRecordVo.give_user_id..")"
        self.topic_text.text = "[赠予]"
    else
        self.money_text.text = "+"..self.currentRecordVo.give_jetton
        self.money_text.color = CS.UnityEngine.Color(0.81,0.67,0.09,1)
        self.name_text.text = self.currentRecordVo.user_name
        self.id_text.text = "(ID："..self.currentRecordVo.user_id..")"
        self.topic_text.text = "[受赠]"        
    end
end



function RecordItem:RemoveUIComponent()
    self.itemGameObject = nil
    self.itemTransform = nil
end

function RecordItem:__delete()
	self:RemoveUIComponent()
end
