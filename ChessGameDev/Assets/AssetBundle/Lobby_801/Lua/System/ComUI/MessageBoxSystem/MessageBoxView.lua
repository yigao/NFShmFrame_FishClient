MessageBoxView = Class()

function MessageBoxView:ctor()
    self.MessageBoxForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/ComUI/MessageBoxForm.prefab"	
    self:Init()
end

function MessageBoxView:Init(  )
    self:InitData()
    self:InitView()
end

function MessageBoxView:InitData(  )
    self.strContent = ""
    self.isHaveCancelBtn = false
    self.confrimCallback = nil
    self.cancelCallback = nil
    self.confirmStr = ""
    self.cancelStr = ""
    self.autoCloseTime = 0
end

function MessageBoxView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
 
    self.info_Text = nil

    self.closeTimer = nil

    self.confirmBtn_Text = nil
    self.confirmBtn_GameObject = nil
    self.confirmBtnEventScript = nil

    self.cancelBtn_Text = nil
    self.cancelBtn_GameObject = nil
    self.cancelBtnEventScript = nil

    self.autoCloseEventScript = nil
    
    self.closeBtn_GameObject = nil
    self.closeEventScript = nil
end

function MessageBoxView:ReInit(strContent,isHaveConfirmBtn,isHaveCancelBtn,isHaveCloseBtn,confirmCallBack,cancelCallBack,closeCallBack,confirmStr, cancelStr, autoCloseTime)
    self.strContent = strContent
    self.isHaveConfirmBtn = isHaveConfirmBtn
    self.isHaveCancelBtn = isHaveCancelBtn
    self.isHaveCloseBtn = isHaveCloseBtn
    self.confirmCallBack = confirmCallBack
    self.cancelCallback = cancelCallBack
    self.closeCallBack = closeCallBack
    self.confirmStr = confirmStr
    self.cancelStr = cancelStr
    self.autoCloseTime = autoCloseTime
end

--初始化ui界面
function MessageBoxView:OpenForm(strContent,isHaveConfirmBtn,isHaveCancelBtn,isHaveCloseBtn,confirmCallBack,cancelCallBack,closeCallBack,confirmStr, cancelStr, autoCloseTime)
    self:ReInit(strContent,isHaveConfirmBtn,isHaveCancelBtn,isHaveCloseBtn,confirmCallBack,cancelCallBack,closeCallBack,confirmStr, cancelStr, autoCloseTime)
    self:GetUIComponent()
    self:ShowUIComponent()
end


function MessageBoxView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.MessageBoxForm_Path,true)

    if form == nil then
        Debug.LogError("打开MessageBox窗口失败："..self.MessageBoxForm_Path)
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

    if self.confirmBtn_GameObject == nil then
        self.confirmBtn_GameObject = self.formTransform:Find("Content/btnGroup/Button_Confirm").gameObject
    end

    if self.confirmBtnEventScript == nil then
        local go = self.formTransform:Find("Content/btnGroup/Button_Confirm").gameObject
        self.confirmBtnEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.confirmBtnEventScript == nil then 
            self.confirmBtnEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        self.confirmBtnEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ConfirmOnPointerClick(pointerEventData) end
    end

    if self.confirmBtn_Text == nil then
        self.confirmBtn_Text = self.formTransform:Find("Content/btnGroup/Button_Confirm/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end


    if self.cancelBtn_GameObject == nil then
        self.cancelBtn_GameObject = self.formTransform:Find("Content/btnGroup/Button_Cancel").gameObject
    end

    if self.cancelBtnEventScript == nil then
        local go = self.formTransform:Find("Content/btnGroup/Button_Cancel").gameObject
        self.cancelBtnEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.cancelBtnEventScript == nil then 
            self.cancelBtnEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        self.cancelBtnEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CancelOnPointerClick(pointerEventData) end
    end

    if self.cancelBtn_Text == nil then
        self.cancelBtn_Text = self.formTransform:Find("Content/btnGroup/Button_Cancel/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.info_Text == nil then
        self.info_Text = self.formTransform:Find("Content/Info_Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.autoCloseEventScript == nil then
       self.autoCloseEventScript = self.formTransform:Find("Content/closeTimer"):GetComponent(typeof(CS.UITimerScript))
    end

    if self.closeBtn_GameObject == nil then
        self.closeBtn_GameObject = self.formTransform:Find("Content/Close_Btn").gameObject
    end

    if self.closeEventScript == nil then
        local go = self.formTransform:Find("Content/Close_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScript == nil then 
            self.closeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        self.closeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end
end

function MessageBoxView:ShowUIComponent()
    if self.confirmStr == "" then
        self.confirmStr = "确定"
    end

    if self.cancelStr == "" then
        self.cancelStr = "取消"
    end

    self.confirmBtn_Text.text = self.confirmStr
    self.cancelBtn_Text.text = self.cancelStr
    self.info_Text.text = self.strContent

    if self.isHaveConfirmBtn == true then
        CommonHelper.SetActive(self.confirmBtn_GameObject,true)
    else
        CommonHelper.SetActive(self.confirmBtn_GameObject,false)
    end

    if self.isHaveCancelBtn==true then
        CommonHelper.SetActive(self.cancelBtn_GameObject,true)
    else
        CommonHelper.SetActive(self.cancelBtn_GameObject,false)
    end

    if self.isHaveCloseBtn == true then
        CommonHelper.SetActive(self.closeBtn_GameObject,true)
    else
        CommonHelper.SetActive(self.closeBtn_GameObject,false)
    end

    if self.autoCloseTime ~= 0 then
        self.autoCloseEventScript.timerUpCallBack = function (  ) self:AutoCloseForm() end
        self.autoCloseEventScript:SetTotalTime(self.autoCloseTime)
        self.autoCloseEventScript:StartTimer()
    else
        self.autoCloseEventScript.timerUpCallBack = nil 
    end 
end

function MessageBoxView:ConfirmOnPointerClick(eventData)
    if self.confirmCallBack then
        self.confirmCallBack()
    end
    self:CloseForm()
end

function MessageBoxView:CancelOnPointerClick(eventData)
    if self.cancelCallback then
        self.cancelCallback()
    end
    self:CloseForm()
end

function MessageBoxView:CloseOnPointerClick(eventData)
    if self.closeCallBack then
        self.closeCallBack()
    end
    self:CloseForm()
end

function MessageBoxView:AutoCloseForm(  )
    self:CloseForm()
end


function MessageBoxView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function MessageBoxView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.info_Text = nil

    self.closeTimer = nil

    if self.autoCloseEventScript.timerUpCallBack ~= nil then
        self.autoCloseEventScript.timerUpCallBack = nil
    end
    self.autoCloseEventScript = nil

    if self.confirmBtnEventScript ~= nil then
        self.confirmBtnEventScript.onPointerClickCallBack = nil
    end
    self.confirmBtn_Text = nil
    self.confirmBtn_GameObject = nil
    self.confirmBtnEventScript = nil

    if self.cancelBtnEventScript ~= nil then
        self.cancelBtnEventScript.onPointerClickCallBack = nil
    end
    self.cancelBtn_Text = nil
    self.cancelBtn_GameObject = nil
    self.cancelBtnEventScript = nil

    self.closeBtn_GameObject = nil
    if self.closeEventScript ~= nil then
        self.closeEventScript.onPointerClickCallBack = nil
    end
    self.closeEventScript = nil
end

function MessageBoxView:__delete( )
    self:RemoveUIComponent()
end

