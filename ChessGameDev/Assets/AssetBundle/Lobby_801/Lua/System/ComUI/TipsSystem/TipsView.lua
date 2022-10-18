TipsView = Class()

function TipsView:ctor()
    self.TipsForm_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/ComUI/TipsForm.prefab"	
    self:Init()
end

function TipsView:Init(  )
    self:InitData()
    self:InitView()
end

function TipsView:InitData(  )
    self.UID = nil
    self.sequence = nil
    self.targetY = 300
    self.beinPos = CSScript.Vector3(0,70,0)
    self.delay =0.1
    self.duration = 1.5
end

function TipsView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.closeEventScript = nil
    self.Tips_Text = nil
    self.canvasGroup = nil
    self.contentTrans = nil

end

function TipsView:ReInit(UID,lifeTime)
    self.UID = UID
    self.duration = lifeTime or 1.5
end

--初始化ui界面
function TipsView:OpenForm(UID,str,color,lifeTime)
    self:ReInit(UID,lifeTime)
    self:GetUIComponent()
    self:ShowUIComponent(str,color)
end


function TipsView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.TipsForm_Path,true,true)

    if form == nil then
        Debug.LogError("打开操作提示窗口失败："..self.TipsForm_Path)
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

    if self.Tips_Text == nil then
        self.Tips_Text = self.formTransform:Find("Content/Tips_Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
    end

    if self.canvasGroup == nil then
        self.canvasGroup = self.formTransform:Find("Content"):GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    end

    if  self.contentTrans == nil then
        self.contentTrans = self.formTransform:Find("Content")
    end

end


function TipsView:ShowUIComponent(str,color)
    if self.sequence ~= nil then
        self.sequence:Kill()
        self.sequence = nil
    end
    self.Tips_Text.color = color
    self.Tips_Text.text = str
    self.canvasGroup.alpha = 1
    self.contentTrans.localPosition = self.beinPos
    
    self:PlayMoveAnimation()
end

function TipsView:PlayMoveAnimation(  )
    
    self.sequence = TipsSystem.GetInstance().DOTween.Sequence()
   
    local moveTweener = self.contentTrans:DOLocalMoveY(self.targetY, self.duration)
    
   
    local tempColor = CS.UnityEngine.Color(1,1,1,1)
    local callBack1 = function (  )
		return tempColor
	end
    local callBack2 = function (v)
		tempColor = v
	end
    local alPhaTweener =TipsSystem.GetInstance().DOTween.ToAlpha(callBack1,callBack2,0,self.duration) 
    alPhaTweener.onUpdate = function (  )
        self.canvasGroup.alpha = tempColor.a 
    end
    alPhaTweener:SetEase(TipsSystem.GetInstance().Ease.InQuad)

    self.sequence:PrependInterval(self.delay)
    self.sequence:Append(moveTweener)
    self.sequence:Join(alPhaTweener)

    local moveOverCallBack = function (  )
		TipsSystem.GetInstance():CloseForm(self.UID)
	end
	self.sequence:AppendCallback(moveOverCallBack)		
end

function TipsView:CloseForm()
    self:RemoveUIComponent()
end

function TipsView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end

    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    self.UID = nil
    self.Tips_Text = nil
    self.contentTrans =nil
end

function TipsView:__delete( )
    self:RemoveUIComponent()
end

