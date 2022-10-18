LobbyRegisterInformationView = Class()

function LobbyRegisterInformationView:ctor()
	self:Init()
    self.LobbyRegisterInformationForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyLoginForm/LobbyRegisteForm/LobbyRegisterInformationForm.prefab"	
end

function LobbyRegisterInformationView:Init()
	self:InitData()
	self:InitView()
end

function LobbyRegisterInformationView:InitData()
    
end

function LobbyRegisterInformationView:InitView()
	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
	
	self.inputFieldNickname = nil
    self.inputFieldPassword = nil 
    self.inputAgainPassword = nil 

    self.randNickNameEventScirpt = nil
    self.closeEventScirpt = nil
    self.confirmEventScirpt = nil
end

--初始化ui界面
function LobbyRegisterInformationView:OpenForm()

    self:GetUIComponent()

    self:ShowUIComponent()
end


function LobbyRegisterInformationView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.LobbyRegisterInformationForm_Path,true)

    if form == nil then
        Debug.LogError("打开注册信息窗口失败："..self.LobbyRegisterInformationForm_Path)
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


	if self.inputFieldNickname == nil then
		self.inputFieldNickname = self.formTransform:Find("Animator/InputNicknamePanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

	if self.inputFieldPassword == nil then
		self.inputFieldPassword = self.formTransform:Find("Animator/InputPasswordPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end

    if self.inputAgainPassword == nil then
		self.inputAgainPassword = self.formTransform:Find("Animator/InputAgainPasswordPanel/InputField"):GetComponent(typeof(CS.UnityEngine.UI.InputField))
	end
  
    if self.closeEventScirpt == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScirpt == nil then
            self.closeEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.closeEventScirpt ~= nil and self.closeEventScirpt.onMiniPointerClickCallBack == nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end

    if self.randNickNameEventScirpt == nil then
        local go = self.formTransform:Find("Animator/InputNicknamePanel/GetNickName_Btn").gameObject
        self.randNickNameEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.randNickNameEventScirpt == nil then
            self.randNickNameEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.randNickNameEventScirpt ~= nil and self.randNickNameEventScirpt.onMiniPointerClickCallBack == nil then
        self.randNickNameEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:RandNickNamePointerClick(pointerEventData) end
    end

    if self.confirmEventScirpt == nil then 
        local go = self.formTransform:Find("Animator/Confirm_Btn").gameObject
        self.confirmEventScirpt = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.confirmEventScirpt == nil then
            self.confirmEventScirpt = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.confirmEventScirpt ~= nil and self.confirmEventScirpt.onMiniPointerClickCallBack == nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = function(pointerEventData) self:ConfirmOnPointerClick(pointerEventData) end
    end
end

function LobbyRegisterInformationView:ShowUIComponent()
    if self.inputFieldNickname ~= nil then
        self.inputFieldNickname.text = nil
    end

    if self.inputFieldPassword ~= nil then
		self.inputFieldPassword.text = nil
	end

    if self.inputAgainPassword ~= nil then
		self.inputAgainPassword.text = nil
	end
end

function LobbyRegisterInformationView:RandNickNamePointerClick()
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    local nickName =HallLuaDefine.Game_Nickame_Str[math.random(1,#HallLuaDefine.Game_Nickame_Str)]
    self.inputFieldNickname.text = nickName
end

function LobbyRegisterInformationView:CloseOnPointerClick(eventData)
	self:CloseForm()
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
end

function LobbyRegisterInformationView:ConfirmOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)

    local onePassword = CommonHelper.TrimStr(self.inputFieldPassword.text)
    local twoPassword= CommonHelper.TrimStr(self.inputAgainPassword.text)
    local nickName = CommonHelper.TrimStr(self.inputFieldNickname.text)
    
    if nickName == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Nickname)
        return
    end

    if onePassword == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Input_Password)
        return
    end

    if twoPassword == "" then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Please_Again_Input_Password)
        return
    end

    if string.len(onePassword)< 6 or string.len(onePassword)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end

    if string.len(twoPassword)< 6 or string.len(twoPassword)>10 then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Psd_Lenght_Error)
        return
    end

    if onePassword~= twoPassword then
        XLuaUIManager.GetInstance():OpenTipsForm(HallLuaDefine.Client_Failure_Code.C_Enter_Password_Inconsistent)
        return
    end
 
    LobbyLoginSystem.GetInstance().loginVo:SetPassword(onePassword)
    LobbyLoginSystem.GetInstance().loginVo:SetNickname(nickName)
	LobbyLoginSystem.GetInstance():RequestRegisterAccountMsg()
end

function LobbyRegisterInformationView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyRegisterInformationView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end

	self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    
    self.inputFieldNickname = nil
    self.inputFieldPassword = nil 
    self.inputAgainPassword = nil 

	if self.randNickNameEventScirpt ~= nil then
        self.randNickNameEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.randNickNameEventScirpt = nil

	if self.closeEventScirpt ~= nil then
        self.closeEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.closeEventScirpt = nil
	
	if self.confirmEventScirpt ~= nil then
        self.confirmEventScirpt.onMiniPointerClickCallBack = nil
    end
	self.confirmEventScirpt = nil
end

function LobbyRegisterInformationView:__delete( )
    self:RemoveUIComponent()
end

