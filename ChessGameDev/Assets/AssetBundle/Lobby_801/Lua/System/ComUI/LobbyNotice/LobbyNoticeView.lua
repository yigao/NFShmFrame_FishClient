LobbyNoticeView = Class()

function LobbyNoticeView:ctor()
    self.Notice_Form_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/ComUI/LobbyNoticeForm.prefab"	
    self:Init()
end

function LobbyNoticeView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyNoticeView:InitData(  )
    self.index = 1
    self.updateItemNum = -1

    self.PosList ={
        [1] = CS.UnityEngine.Vector2(-530,-43),
        [2] = CS.UnityEngine.Vector2(-307,-35),
    }
end

function LobbyNoticeView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil

    self.content_gameObject = nil

    self.mask_image = nil

    self.CenterPointX = 0

    self.updateItemNum = -1
    
    self.noticeItemList = nil
end

function LobbyNoticeView:ReInit(  )
    self.index = 1
end

--初始化ui界面
function LobbyNoticeView:OpenForm()
    self:ReInit()
    self:GetUIComponent()
    self:ShowUIComponent()
    if self.updateItemNum == -1 then
        self.updateItemNum = CommonHelper.AddUpdate(self)
    end
end


function LobbyNoticeView:GetUIComponent()

    local form =  XLuaUIManager.GetInstance():OpenForm(self.Notice_Form_Path,true)

    if form == nil then
        Debug.LogError("打开跑马灯窗口失败："..self.Notice_Form_Path)
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

    if self.gameObject == nil then
        self.gameObject = self.formGameObject
    end

    if self.content_rectTransform == nil then
        self.content_rectTransform = self.formTransform:Find("Content"):GetComponent(typeof(CS.UnityEngine.RectTransform))
    end

    if self.mask_image == nil then
        self.mask_image = self.formTransform:Find("Content/mask"):GetComponent(typeof(CS.UnityEngine.UI.Image))
    end

    self.CenterPointX = self.mask_image.rectTransform.sizeDelta.x * 0.8

    if self.noticeItemList == nil then
        self.noticeItemList = {}
        
        local text_gameObject_01 = self.formTransform:Find("Content/mask/Text01").gameObject
        local item1 = NoticeItem.New(text_gameObject_01)
        table.insert(self.noticeItemList,item1)

        local text_gameObject_02 = self.formTransform:Find("Content/mask/Text02").gameObject
        local item2 = NoticeItem.New(text_gameObject_02)
        table.insert(self.noticeItemList,item2)
    end
end

function LobbyNoticeView:ShowUIComponent()
    if self.noticeItemList then
        for i = 1,#self.noticeItemList do 
            self.noticeItemList[i]:ReInitItem()
        end
    end
    self:SetNoticePosition()
    self:ShowNoticeItem()
end

function LobbyNoticeView:ShowNoticeItem()
    if self.index > #LobbyNoticeSystem.GetInstance().noticeDataList then
        self.index = 1
    end
    
    local contentData = LobbyNoticeSystem.GetInstance().noticeDataList[self.index]
    if self.noticeItemList then
        for i = 1,#self.noticeItemList do 
            if self.noticeItemList[i].beginMoving == false then
                self.noticeItemList[i]:ShowNoticeItem(contentData)
                break
            end
        end
    end
    self.index = self.index + 1
end

function LobbyNoticeView:SetNoticePosition(  )
    if self.uiFormScript ~= nil and self.uiFormScript:IsCanvasEnabled() == true then
        self.content_rectTransform.anchoredPosition = self.PosList[LobbyNoticeSystem.GetInstance().indexPostion]
    end
end

function LobbyNoticeView:Update()
    for i = 1,#self.noticeItemList do
        self.noticeItemList[i]:Update()
    end
end

function LobbyNoticeView:CloseForm()
    if self.uiFormScript ~= nil then
         XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
end

function LobbyNoticeView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
         XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.gameObject = nil

    self.content_gameObject = nil

    self.mask_image = nil

    self.CenterPointX = 0

    for i = 1,#self.noticeItemList do 
        self.noticeItemList[i]:Destroy()
    end
    self.noticeItemList = nil
end

function LobbyNoticeView:__delete( )
    self:RemoveUIComponent()
end

