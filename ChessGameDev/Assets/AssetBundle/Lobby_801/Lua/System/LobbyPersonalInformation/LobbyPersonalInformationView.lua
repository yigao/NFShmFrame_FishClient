LobbyPersonalInformationView = Class()

function LobbyPersonalInformationView:ctor()
    self.PersonalInformation_Form_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyPersonalInformationForm/LobbyPersonalInformationForm.prefab"	
    self:Init()
end

function LobbyPersonalInformationView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyPersonalInformationView:InitData(  )
    
end

function LobbyPersonalInformationView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.head_icon_image = nil 
    self.male_icon_gameObject = nil 
    self.female_icon_gameObject = nil 
    self.user_name_text = nil 
    self.user_id_text = nil 
    self.referrer_id_text = nil 
    self.bind_text = nil 
    self.bind_phone_gameObject = nil

    self.changeHeadIconEventScript = nil
    self.copyEventScript = nil
    self.bindPhoneEventScript = nil
    self.closeEventScript = nil
end

function LobbyPersonalInformationView:ReInit(  )
    
end

--初始化ui界面
function LobbyPersonalInformationView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbyPersonalInformationView:GetUIComponent()

    local form =  XLuaUIManager.GetInstance():OpenForm(self.PersonalInformation_Form_Path,true)

    if form == nil then
        Debug.LogError("打开个人信息窗口失败："..self.PersonalInformation_Form_Path)
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

    if self.head_icon_image == nil then
        self.head_icon_image = self.formTransform:Find("Animator/UserInfo/head/head_Icon"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    end

    if self.male_icon_gameObject == nil then
        self.male_icon_gameObject = self.formTransform:Find("Animator/UserInfo/NameInfo/male").gameObject
    end

    if self.female_icon_gameObject == nil then
        self.female_icon_gameObject = self.formTransform:Find("Animator/UserInfo/NameInfo/female").gameObject
    end

    if self.user_name_text == nil then
        self.user_name_text = self.formTransform:Find("Animator/UserInfo/NameInfo/user_name"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.user_id_text == nil then
        self.user_id_text = self.formTransform:Find("Animator/UserInfo/IDInfo/user_id"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.referrer_id_text == nil then
        self.referrer_id_text = self.formTransform:Find("Animator/UserInfo/ReferrerInfo/referrer_id"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.bind_text == nil then
        self.bind_text = self.formTransform:Find("Animator/UserInfo/PhoneInfo/bind"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.changeHeadIconEventScript == nil then
        local go = self.formTransform:Find("Animator/UserInfo/change_head_btn").gameObject
        self.changeHeadIconEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.changeHeadIconEventScript == nil then 
            self.changeHeadIconEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.changeHeadIconEventScript ~= nil and self.changeHeadIconEventScript.onMiniPointerClickCallBack == nil then
        self.changeHeadIconEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:ChangeHeadIconOnPointerClick(pointerEventData) end
    end

    if self.copyEventScript == nil then
        local go = self.formTransform:Find("Animator/UserInfo/IDInfo/Copy_Btn").gameObject
        self.copyEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.copyEventScript == nil then 
            self.copyEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
    end
    if self.copyEventScript ~= nil and self.copyEventScript.onMiniPointerClickCallBack == nil then
        self.copyEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CopyOnPointerClick(pointerEventData) end
    end

    if self.bind_phone_gameObject == nil then
        self.bind_phone_gameObject = self.formTransform:Find("Animator/UserInfo/PhoneInfo/bind_phone_btn").gameObject
    end

    if self.bindPhoneEventScript == nil then
        local go = self.formTransform:Find("Animator/UserInfo/PhoneInfo/bind_phone_btn").gameObject
        self.bindPhoneEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.bindPhoneEventScript == nil then 
            self.bindPhoneEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        self.bindPhoneEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:BindPhoneOnPointerClick(pointerEventData) end
    end

    if self.closeEventScript == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIMiniEventScript))
        if self.closeEventScript == nil then 
            self.closeEventScript = go:AddComponent(typeof(CS.UIMiniEventScript))
        end
        self.closeEventScript.onMiniPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end
end

function LobbyPersonalInformationView:ShowUIComponent()
    self.head_icon_image.sprite =  LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..LobbyHallCoreSystem.GetInstance().playerInfoVo.face_id)

    if LobbyHallCoreSystem.GetInstance().playerInfoVo.gender == 0 then
        CommonHelper.SetActive(self.male_icon_gameObject,true)
        CommonHelper.SetActive(self.female_icon_gameObject,false)
    else
        CommonHelper.SetActive(self.male_icon_gameObject,false)
        CommonHelper.SetActive(self.female_icon_gameObject,true)
    end

    self.user_name_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.nick_name

    self.user_id_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.user_id
    if LobbyHallCoreSystem.GetInstance().playerInfoVo.referrer_id == nil or LobbyHallCoreSystem.GetInstance().playerInfoVo.referrer_id == 0 then
        self.referrer_id_text.text = "无"
    else
        self.referrer_id_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.referrer_id
    end

    if LobbyHallCoreSystem.GetInstance().playerInfoVo.phonenum == nil or LobbyHallCoreSystem.GetInstance().playerInfoVo.phonenum == 0 then
        self.bind_text.text = "未绑定"
        CommonHelper.SetActive(self.bind_phone_gameObject,true)
    else
        self.bind_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.phonenum
        CommonHelper.SetActive(self.bind_phone_gameObject,false)
    end
end

function LobbyPersonalInformationView:RefreshUIComponent( ... )
    self.head_icon_image.sprite =  LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..LobbyHallCoreSystem.GetInstance().playerInfoVo.face_id)
end

function LobbyPersonalInformationView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyPersonalInformationView:ChangeHeadIconOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyPersonalChangeHeadIconSystem.GetInstance():Open()
end

function LobbyPersonalInformationView:CopyOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
end

function LobbyPersonalInformationView:BindPhoneOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self:CloseForm()
    LobbyBindMobilePhoneSystem.GetInstance():OpenForm()
end

function LobbyPersonalInformationView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyPersonalInformationView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.head_icon_image = nil 
    self.male_icon_gameObject = nil 
    self.female_icon_gameObject = nil 
    self.user_name_text = nil 
    self.user_id_text = nil 
    self.referrer_id_text = nil 
    self.bind_text = nil 
    self.bind_phone_gameObject = nil

    if self.changeHeadIconEventScript ~= nil then
        self.changeHeadIconEventScript.onPointerClickCallBack = nil
    end
    self.changeHeadIconEventScript = nil 

    if self.copyEventScript ~= nil then
        self.copyEventScript.onPointerClickCallBack = nil
    end
    self.copyEventScript = nil 

    if self.bindPhoneEventScript ~= nil then
        self.bindPhoneEventScript.onPointerClickCallBack = nil
    end
    self.bindPhoneEventScript = nil 

    if self.closeEventScript ~= nil then
        self.closeEventScript.onPointerClickCallBack = nil
    end
    self.closeEventScript = nil 
end

function LobbyPersonalInformationView:__delete( )
    self:RemoveUIComponent()
end

