LobbySettingView = Class()

function LobbySettingView:ctor()
    self.Setting_Form_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbySettingForm/LobbySettingForm.prefab"	
    self:Init()
end

function LobbySettingView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbySettingView:InitData(  )
    
end

function LobbySettingView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.head_icon_image = nil       
    self.user_name_text = nil
       
    self.music_turnOff_status_gameObject = nil
    self.music_open_status_gameObject = nil 
    self.sound_turnOff_status_gameObject = nil 
    self.sound_open_status_gameObject = nil 
    self.shake_turnOff_status_gameObject = nil 
    self.shake_open_status_gameObject =nil 

    self.changeAccountEventScript = nil 
    self.mucsicTurnOffEventScript = nil 
    self.mucsicOpenEventScript = nil 
    self.soundTurnOffEventScript = nil 
    self.soundOpenEventScript = nil 
    self.shakeTurnOffEventScript = nil 
    self.shakeOpenEventScript = nil 
    self.closeEventScript = nil 
end


function LobbySettingView:ReInit(  )
    
end

--初始化ui界面
function LobbySettingView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbySettingView:GetUIComponent()

    local form = CSScript.UIManager:OpenForm(self.Setting_Form_Path,true)

    if form == nil then
        Debug.LogError("打开设置窗口失败："..self.Setting_Form_Path)
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

    if self.user_name_text == nil then
        self.user_name_text = self.formTransform:Find("Animator/UserInfo/user_name"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.music_turnOff_status_gameObject == nil then
        self.music_turnOff_status_gameObject =self.formTransform:Find("Animator/SettingInfo/MusicInfo/music/TurnOff_Status").gameObject
    end

    if self.music_open_status_gameObject == nil then
        self.music_open_status_gameObject =self.formTransform:Find("Animator/SettingInfo/MusicInfo/music/Open_Status").gameObject
    end

    if self.sound_turnOff_status_gameObject == nil then
        self.sound_turnOff_status_gameObject =self.formTransform:Find("Animator/SettingInfo/SoundInfo/sound/TurnOff_Status").gameObject
    end

    if self.sound_open_status_gameObject == nil then
        self.sound_open_status_gameObject =self.formTransform:Find("Animator/SettingInfo/SoundInfo/sound/Open_Status").gameObject
    end

    if self.shake_turnOff_status_gameObject == nil then
        self.shake_turnOff_status_gameObject =self.formTransform:Find("Animator/SettingInfo/ShakeInfo/shake/TurnOff_Status").gameObject
    end

    if self.shake_open_status_gameObject == nil then
        self.shake_open_status_gameObject =self.formTransform:Find("Animator/SettingInfo/ShakeInfo/shake/Open_Status").gameObject
    end

    if self.changeAccountEventScript == nil then
        local go = self.formTransform:Find("Animator/UserInfo/ChangeAccount_Btn").gameObject
        self.changeAccountEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.changeAccountEventScript == nil then 
            self.changeAccountEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.changeAccountEventScript.onPointerClickCallBack = function(pointerEventData) self:ChangeAccountOnPointerClick(pointerEventData) end
    end

    if self.mucsicTurnOffEventScript == nil then
        local go = self.formTransform:Find("Animator/SettingInfo/MusicInfo/music/TurnOff_btn").gameObject
        self.mucsicTurnOffEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.mucsicTurnOffEventScript == nil then 
            self.mucsicTurnOffEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.mucsicTurnOffEventScript.onPointerClickCallBack = function(pointerEventData) self:MucsicTurnOffOnPointerClick(pointerEventData) end
    end

    if self.mucsicOpenEventScript == nil then
        local go = self.formTransform:Find("Animator/SettingInfo/MusicInfo/music/Open_btn").gameObject
        self.mucsicOpenEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.mucsicOpenEventScript == nil then 
            self.mucsicOpenEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.mucsicOpenEventScript.onPointerClickCallBack = function(pointerEventData) self:MucsicOpenOnPointerClick(pointerEventData) end
    end

    if self.soundTurnOffEventScript == nil then
        local go = self.formTransform:Find("Animator/SettingInfo/SoundInfo/sound/TurnOff_btn").gameObject
        self.soundTurnOffEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.soundTurnOffEventScript == nil then 
            self.soundTurnOffEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.soundTurnOffEventScript.onPointerClickCallBack = function(pointerEventData) self:SoundTurnOffOnPointerClick(pointerEventData) end
    end

    if self.soundOpenEventScript == nil then
        local go = self.formTransform:Find("Animator/SettingInfo/SoundInfo/sound/Open_btn").gameObject
        self.soundOpenEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.soundOpenEventScript == nil then 
            self.soundOpenEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.soundOpenEventScript.onPointerClickCallBack = function(pointerEventData) self:SoundOpenOnPointerClick(pointerEventData) end
    end

    if self.shakeTurnOffEventScript == nil then
        local go = self.formTransform:Find("Animator/SettingInfo/ShakeInfo/shake/TurnOff_btn").gameObject
        self.shakeTurnOffEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.shakeTurnOffEventScript == nil then 
            self.shakeTurnOffEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.shakeTurnOffEventScript.onPointerClickCallBack = function(pointerEventData) self:ShakeTurnOffOnPointerClick(pointerEventData) end
    end

    if self.shakeOpenEventScript == nil then
        local go = self.formTransform:Find("Animator/SettingInfo/ShakeInfo/shake/Open_btn").gameObject
        self.shakeOpenEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.shakeOpenEventScript == nil then 
            self.shakeOpenEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.shakeOpenEventScript.onPointerClickCallBack = function(pointerEventData) self:ShakeOpenOnPointerClick(pointerEventData) end
    end

    if self.closeEventScript == nil then
        local go = self.formTransform:Find("Animator/Close_Btn").gameObject
        self.closeEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.closeEventScript == nil then 
            self.closeEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.closeEventScript.onPointerClickCallBack = function(pointerEventData) self:CloseOnPointerClick(pointerEventData) end
    end
end

function LobbySettingView:ShowUIComponent()
    CommonHelper.SetActive(self.music_open_status_gameObject,LobbyAudioManager.GetInstance():GetMusicState() == 1)
    CommonHelper.SetActive(self.music_turnOff_status_gameObject,LobbyAudioManager.GetInstance():GetMusicState() == 0)

    CommonHelper.SetActive(self.sound_open_status_gameObject,LobbyAudioManager.GetInstance():GetSoundState() == 1)
    CommonHelper.SetActive(self.sound_turnOff_status_gameObject,LobbyAudioManager.GetInstance():GetSoundState() == 0)
	
	CommonHelper.SetActive(self.shake_turnOff_status_gameObject,not LobbySettingSystem.GetInstance():GetShake())
	CommonHelper.SetActive(self.shake_open_status_gameObject, LobbySettingSystem.GetInstance():GetShake())

    self.user_name_text.text = LobbyHallCoreSystem.GetInstance().playerInfoVo.nick_name
    self.head_icon_image.sprite =  LobbyManager.GetInstance().gameData.AllAtlasList["PersonalInformationSpriteAtlas"]:GetSprite("grxx_tx_"..LobbyHallCoreSystem.GetInstance().playerInfoVo.face_id)
end

function LobbySettingView:RefreshUIComponent( ... )
    -- self.isMusicOpen = CS.UnityEngine.PlayerPrefs.GetInt(self.Music_Key,1)
	-- self.isSoundOpen = CS.UnityEngine.PlayerPrefs.GetInt(self.Sound_Key,1)
    -- LobbyAudioManager.GetInstance().isMusicOpen
    -- LobbyAudioManager.GetInstance().isSoundOpen
   
end

function LobbySettingView:CloseOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)

    self:CloseForm()
end

function LobbySettingView:ChangeAccountOnPointerClick(eventData)
    GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.Reutun_To_Login_EventName)
end

function LobbySettingView:MucsicTurnOffOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyAudioManager.GetInstance():ResetBGMusic(false)
    CommonHelper.SetActive(self.music_open_status_gameObject,false)
    CommonHelper.SetActive(self.music_turnOff_status_gameObject,true)
end

function LobbySettingView:MucsicOpenOnPointerClick( eventData )
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyAudioManager.GetInstance():ResetBGMusic(true)
    CommonHelper.SetActive(self.music_open_status_gameObject,true)
    CommonHelper.SetActive(self.music_turnOff_status_gameObject,false)  
end

function LobbySettingView:SoundTurnOffOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyAudioManager.GetInstance():ResetSoundEffects(false)
    CommonHelper.SetActive(self.sound_open_status_gameObject,false)
    CommonHelper.SetActive(self.sound_turnOff_status_gameObject,true)
end

function LobbySettingView:SoundOpenOnPointerClick( eventData )
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    LobbyAudioManager.GetInstance():ResetSoundEffects(true)
    CommonHelper.SetActive(self.sound_open_status_gameObject,true)
    CommonHelper.SetActive(self.sound_turnOff_status_gameObject,false)  
end


function LobbySettingView:ShakeTurnOffOnPointerClick(eventData)
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
	LobbySettingSystem.GetInstance():SetShake(false)
    CommonHelper.SetActive(self.shake_open_status_gameObject,false)
    CommonHelper.SetActive(self.shake_turnOff_status_gameObject,true)
end

function LobbySettingView:ShakeOpenOnPointerClick( eventData )
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
	LobbySettingSystem.GetInstance():SetShake(true)
    CommonHelper.SetActive(self.shake_open_status_gameObject,true)
    CommonHelper.SetActive(self.shake_turnOff_status_gameObject,false)  
end


function LobbySettingView:CloseForm()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
end

function LobbySettingView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        CSScript.UIManager:CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.music_turnOff_status_gameObject = nil
    self.music_open_status_gameObject = nil 
    self.sound_turnOff_status_gameObject = nil 
    self.sound_open_status_gameObject = nil 
    self.shake_turnOff_status_gameObject = nil 
    self.shake_open_status_gameObject =nil 

    if self.changeAccountEventScript ~= nil then
        self.changeAccountEventScript.onPointerClickCallBack = nil
    end
    self.changeAccountEventScript = nil 

    if self.mucsicTurnOffEventScript ~= nil then
        self.mucsicTurnOffEventScript.onPointerClickCallBack = nil
    end
    self.mucsicTurnOffEventScript = nil 

    if self.mucsicOpenEventScript ~= nil then
        self.mucsicOpenEventScript.onPointerClickCallBack = nil
    end
    self.mucsicOpenEventScript = nil 

    if self.soundTurnOffEventScript ~= nil then
        self.soundTurnOffEventScript.onPointerClickCallBack = nil
    end
    self.soundTurnOffEventScript = nil 

    if self.soundOpenEventScript ~= nil then
        self.soundOpenEventScript.onPointerClickCallBack = nil
    end
    self.soundOpenEventScript = nil 

    if self.shakeTurnOffEventScript ~= nil then
        self.shakeTurnOffEventScript.onPointerClickCallBack = nil
    end
    self.shakeTurnOffEventScript = nil 

    if self.shakeOpenEventScript ~= nil then
        self.shakeOpenEventScript.onPointerClickCallBack = nil
    end
    self.shakeOpenEventScript = nil 

    if self.closeEventScript ~= nil then
        self.closeEventScript.onPointerClickCallBack = nil
    end
    self.closeEventScript = nil 
end

function LobbySettingView:__delete( )
    self:RemoveUIComponent()
end

