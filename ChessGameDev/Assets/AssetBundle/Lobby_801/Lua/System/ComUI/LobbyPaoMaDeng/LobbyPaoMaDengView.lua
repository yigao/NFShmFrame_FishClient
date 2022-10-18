LobbyPaoMaDengView = Class()

function LobbyPaoMaDengView:ctor()
    self.PaMaDeng_Form_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/ComUI/LobbyPaoMaDengForm.prefab"	
    self:Init()
end

function LobbyPaoMaDengView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyPaoMaDengView:InitData(  )
    self.sequence = nil
    
    self.PosList ={
        [1] = CS.UnityEngine.Vector2(-8,255),
        [2] = CS.UnityEngine.Vector2(0,325),
        [3] = CS.UnityEngine.Vector2(0,350),
    }
    self.beginPos = CSScript.Vector3(0,-40,0)

    self.bottomToCenterY = -2
    self.bottomToCenterDuration = 0.5
    self.centerDelayTime = 2
    self.centerToTopY = 38
    self.centerToTopDuration = 0.5
end

function LobbyPaoMaDengView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.content_rectTransform = nil
    self.content_gameObject = nil 
    self.pao_ma_deng_text = nil 
end

function LobbyPaoMaDengView:ReInit(  )
    
end

--初始化ui界面
function LobbyPaoMaDengView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
end


function LobbyPaoMaDengView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.PaMaDeng_Form_Path,true)

    if form == nil then
        Debug.LogError("打开跑马灯窗口失败："..self.PaMaDeng_Form_Path)
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

    if self.content_gameObject == nil then
        self.content_gameObject = self.formTransform:Find("Animator").gameObject
    end

    if self.content_rectTransform == nil then
        self.content_rectTransform = self.formTransform:Find("Animator"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    end

    if self.pao_ma_deng_text == nil then
        self.pao_ma_deng_text = self.formTransform:Find("Animator/mask/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end
end

function LobbyPaoMaDengView:ShowUIComponent()
    self:SetPaoMaDengPosition()
    self:ShowPaoMaDeng()
end

function LobbyPaoMaDengView:ShowPaoMaDeng()
    if self.content_gameObject == nil or LobbyPaoMaDengSystem.GetInstance().paoMaDengDataList == nil then
        return
    end
    if #LobbyPaoMaDengSystem.GetInstance().paoMaDengDataList >= 1 then
        local contentData = LobbyPaoMaDengSystem.GetInstance().paoMaDengDataList[1]
        table.remove(LobbyPaoMaDengSystem.GetInstance().paoMaDengDataList,1)
        self.pao_ma_deng_text.text =string.format(HallLuaDefine.PaoMaDengBaseStr,contentData.user_name,contentData.game_name,contentData.win_jetton)
        self.pao_ma_deng_text.transform.localPosition = self.beginPos
        self:PlayPaoMaDengAnimation()
    else
        self:CloseForm()
    end
end

function LobbyPaoMaDengView:SetPaoMaDengPosition(  )
    if self.uiFormScript ~= nil  then --and self.uiFormScript:IsCanvasEnabled() == true
        self.content_rectTransform.anchoredPosition = self.PosList[LobbyPaoMaDengSystem.GetInstance().indexPostion]
    end
end


function LobbyPaoMaDengView:PlayPaoMaDengAnimation()
    if self.sequence ~= nil then
        self.sequence:Kill()
        self.sequence = nil
    end
    self.sequence = LobbyPaoMaDengSystem.GetInstance().DOTween.Sequence()

    local bottomToCenterTweener = self.pao_ma_deng_text.transform:DOLocalMoveY(self.bottomToCenterY, self.bottomToCenterDuration)
    self.sequence:Append(bottomToCenterTweener)
    self.sequence:AppendInterval(self.centerDelayTime)
    local centerToTopTweener = self.pao_ma_deng_text.transform:DOLocalMoveY(self.centerToTopY, self.centerToTopDuration)
    self.sequence:Append(centerToTopTweener)
   
    local moveOverCallBack = function (  )
		self:ShowPaoMaDeng()
	end
	self.sequence:AppendCallback(moveOverCallBack)		
end

function LobbyPaoMaDengView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    if self.sequence ~= nil then
        self.sequence:Kill()
    end
    self.sequence = nil
end

function LobbyPaoMaDengView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.content_rectTransform = nil
    self.content_gameObject = nil 
    self.pao_ma_deng_text = nil 
   
    if self.sequence ~= nil then
        self.sequence:Kill()
    end
    self.sequence = nil
end

function LobbyPaoMaDengView:__delete( )
    self:RemoveUIComponent()
end

