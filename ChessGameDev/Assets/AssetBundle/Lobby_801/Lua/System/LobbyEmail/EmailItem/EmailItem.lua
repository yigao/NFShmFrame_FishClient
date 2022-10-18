EmailItem = Class()

function EmailItem:ctor(go)
    self:Init(go)
end

function EmailItem:Init(go)
    self:InitData()
    self:InitView(go)
end

function EmailItem:InitData(  )
    self.currentEmailVo = nil
end

function EmailItem:InitView(go)
    self.itemGameObject = go
    self.itemTransform = go.transform
    self:GetUIComponent()
end

function EmailItem:GetUIComponent()
    self.title_text =  self.itemTransform:Find("title"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.send_text = self.itemTransform:Find("send"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.date_text = self.itemTransform:Find("date"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    self.alread_gameObject = self.itemTransform:Find("alread_icon").gameObject
    self.unread_gameObject = self.itemTransform:Find("unread_icon").gameObject

    self.uiListElementScript = self.itemTransform:GetComponent(typeof(CS.UIListElementScript))
    self.uiListElementScript.OnEnableElement = function(index) self:OnEnableEmailItem(index) end

    self.selectBtnGo = self.itemTransform:Find("Select_Btn").gameObject
    self.selectEventScript =self.selectBtnGo:GetComponent(typeof(CS.UIMiniEventScript))
    if self.selectEventScript == nil then
        self.selectEventScript = self.selectBtnGo:AddComponent(typeof(CS.UIMiniEventScript))
    end
    if self.selectEventScript ~= nil and self.selectEventScript.onMiniPointerClickCallBack == nil then
        self.selectEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:SelectOnPointerClick(pointerEventData) end
    end

    self.gou_gameObject = self.itemTransform:Find("Select_Btn/gou_image").gameObject
    
    self.itemEventScipt = self.itemGameObject:GetComponent(typeof(CS.UIEventScript))
    if self.itemEventScipt == nil then 
        self.itemEventScipt = self.itemGameObject:AddComponent(typeof(CS.UIEventScript))
        self.itemEventScipt:Initialize(LobbyEmailSystem.emailMainView.uiFormScript)
    end
    self.itemEventScipt.onPointerClickCallBack = function(pointerEventData) self:ItemOnPointerClick(pointerEventData) end
end

function EmailItem:OnEnableEmailItem(index)
    self.currentEmailVo = LobbyEmailSystem.GetInstance().emailVoList[index + 1]
    self:ShowUIComponent()

end

function EmailItem:RefreshUIComponent(  )
    self:ShowUIComponent()
end

function EmailItem:ShowUIComponent()
    self.title_text.text =  self.currentEmailVo.title
    self.send_text.text = self.currentEmailVo.sendName
    self.date_text.text = self.currentEmailVo.sendTime
    if self.currentEmailVo.emailStatus == 0 then
        CommonHelper.SetActive(self.alread_gameObject,false)
        CommonHelper.SetActive(self.unread_gameObject,true)
        CommonHelper.SetActive(self.selectBtnGo,false)
    else
        CommonHelper.SetActive(self.alread_gameObject,true)
        CommonHelper.SetActive(self.unread_gameObject,false)
        CommonHelper.SetActive(self.selectBtnGo,true)
    end
    self:IsDisplayGouXuan()
    
    if self.selectEventScript ~= nil and self.selectEventScript.onMiniPointerClickCallBack == nil then
        self.selectEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:SelectOnPointerClick(pointerEventData) end
    end

    if self.itemEventScipt~= nil and self.itemEventScipt.onPointerClickCallBack == nil then
        self.itemEventScipt.onPointerClickCallBack = function(pointerEventData) self:ItemOnPointerClick(pointerEventData) end
    end
end


function EmailItem:SelectOnPointerClick(eventData)
    if self.currentEmailVo.isGouXuan == false then
        self.currentEmailVo.isGouXuan = true
    else
        self.currentEmailVo.isGouXuan = false
    end
    self:IsDisplayGouXuan(self.isGouXuan)
end

function EmailItem:IsDisplayGouXuan()
    if self.currentEmailVo.isGouXuan == false then
        CommonHelper.SetActive(self.gou_gameObject,false)
    else
        CommonHelper.SetActive(self.gou_gameObject,true)
    end
end

function EmailItem:ItemOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    if self.currentEmailVo.emailStatus == 0 then
        LobbyEmailSystem.GetInstance():RequestReadEmailMsg(self.currentEmailVo.id)
    end
    LobbyEmailSystem.GetInstance().emailContentView:OpenForm(self.currentEmailVo)
end

function EmailItem:RemoveUIComponent()
    self.itemGameObject = nil
    self.itemTransform = nil
   
    self.title_text = nil
    self.send_text = nil
    self.date_text = nil
    self.alread_image = nil
    self.unread_image = nil

    self.selectEventScript = nil 
    self.selectBtnGo = nil
    self.gou_gameObject = nil

    if self.itemEventScipt ~= nil then
        self.itemEventScipt.onPointerClickCallBack = nil
    end
    self.itemEventScipt = nil 

    if self.selectEventScript ~= nil then
        self.selectEventScript.onMiniPointerClickCallBack = nil
    end

    if  self.uiListElementScript ~= nil then
        self.uiListElementScript.OnEnableElement = nil
    end
    self.uiListElementScript = nil
end

function EmailItem:__delete()
	self:RemoveUIComponent()
end
