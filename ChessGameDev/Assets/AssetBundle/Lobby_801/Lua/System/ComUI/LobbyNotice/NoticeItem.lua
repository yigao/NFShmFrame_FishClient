NoticeItem = Class()

function NoticeItem:ctor(gameObject)
    self:Init(gameObject)
end

function NoticeItem:Init(gameObject)
    self:InitData()
    self:InitView(gameObject)
end

function NoticeItem:InitData(  )
    self.beginPos = CSScript.Vector3(530,-3,0)
    self.Speed = 50
    self.beginMoving = false
    self.nextNotice = false
end

function NoticeItem:InitView(gameObject)
    self.gameObject = gameObject
    self:GetUIComponent()
end

function NoticeItem:ReInitItem(  )
    self.beginMoving = false
    self.nextNotice = false
    CommonHelper.SetActive(self.gameObject,false)
end


function NoticeItem:ShowNoticeItem(content)
    if self.notice_text ~= nil then
        CommonHelper.SetActive(self.gameObject,true)
        self.notice_text.text = content
        self.transform.localPosition = self.beginPos
        self.beginMoving = true
        self.nextNotice = false
    end
end

function NoticeItem:GetUIComponent()
    self.transform = self.gameObject.transform
    self.notice_text = self.gameObject:GetComponent(typeof(CS.UnityEngine.UI.Text))
end

function NoticeItem:Update()
    if self.notice_text == nil then return end

    if self.beginMoving == true then
        self.transform.localPosition = self.transform.localPosition + CSScript.Time.deltaTime * CSScript.Vector3.right * -1 * self.Speed
        if self.nextNotice == false then
            if ((self.transform.localPosition.x + self.notice_text.rectTransform.rect.width) <= LobbyNoticeSystem.GetInstance().noticeView.CenterPointX) then
                self:BeginNextNotice()
            end 
        end

        if (self.transform.localPosition.x + self.notice_text.rectTransform.rect.width) <= 0.0 then
            self:MoveFinished()
        end
    end
end

function NoticeItem:BeginNextNotice()
    self.nextNotice = true
    LobbyNoticeSystem.GetInstance().noticeView:ShowNoticeItem()
end

function NoticeItem:MoveFinished()
    self.beginMoving = false
    self.nextNotice = false
    CommonHelper.SetActive(self.gameObject,false)
end


function NoticeItem:RemoveUIComponent()
    self.gameObject = nil
    self.transform = nil
    self.notice_text = nil
end

function NoticeItem:__delete( )
    self:RemoveUIComponent()
end

