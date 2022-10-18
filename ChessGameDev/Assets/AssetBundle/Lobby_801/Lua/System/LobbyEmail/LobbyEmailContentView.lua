LobbyEmailContentView = Class()

function LobbyEmailContentView:ctor()
    self.EmailContentForm_Path =CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyEmailForm/LobbyEmailContentForm.prefab"	
    self:Init()
end

function LobbyEmailContentView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyEmailContentView:InitData(  )
    self.currentEmailVo = nil
end

function LobbyEmailContentView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.closeEventScript = nil
    self.deleteEmailEventScript = nil 
end


--初始化ui界面
function LobbyEmailContentView:OpenForm(data)
    self.currentEmailVo = data
    self:GetUIComponent()

    self:ShowUIComponent()
end


function LobbyEmailContentView:GetUIComponent()
    local form =XLuaUIManager.GetInstance():OpenForm(self.EmailContentForm_Path,true)

    if form == nil then
        Debug.LogError("打开邮件窗口失败："..self.EmailContentForm_Path)
        return 
    end

    if self.uiFormScript~=nil and self.uiFormScript ~= form then
        self:RemoveUIComponent()
    end

    if self.uiFormScript == nil then
        self.uiFormScript = form
    end

    if self.formTransform == nil then
        self.formTransform = self.uiFormScript.transform
    end

    if self.formGameObject == nil then
        self.formGameObject = self.uiFormScript.gameObject
    end

    if  self.content_text== nil then
        self.content_text = self.formTransform:Find("Animator/EmailContentList/ScrollView/Viewport/ContentItem/content_text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.closeEventScript == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScript == nil then 
            self.closeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if  self.closeEventScript ~= nil and self.closeEventScript.onMiniPointerClickCallBack==nil then
        self.closeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end

    if self.deleteEmailEventScript == nil then
        local go = self.formTransform:Find("Animator/Delete_Btn").gameObject
        self.deleteEmailEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.deleteEmailEventScript == nil then
            self.deleteEmailEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.deleteEmailEventScript ~= nil and self.deleteEmailEventScript.onMiniPointerClickCallBack == nil then
        self.deleteEmailEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:DeleteEmailOnPointerClick(pointerEventData) end
    end
end

function LobbyEmailContentView:ShowUIComponent()
    self.content_text.text = self.currentEmailVo.content
end


function LobbyEmailContentView:CloseOnPointerClick(  )
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyEmailContentView:DeleteEmailOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local delteEamilList = {}
    table.insert(delteEamilList,self.currentEmailVo.id)
    LobbyEmailSystem.GetInstance():RequestDeleteEmailMsg(delteEamilList)
end

function LobbyEmailContentView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyEmailContentView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.content_text = nil

    if self.closeEventScript ~= nil then
        self.closeEventScript.onMiniPointerClickCallBack = nil
    end
    self.closeEventScript = nil

    if self.deleteEmailEventScript ~= nil then
        self.deleteEmailEventScript.onMiniPointerClickCallBack = nil 
    end
    self.deleteEmailEventScript = nil
end

function LobbyEmailContentView:__delete( )
    self:RemoveUIComponent()
end

