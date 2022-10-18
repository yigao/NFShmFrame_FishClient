LobbyRankListView = Class()

function LobbyRankListView:ctor()
    self.RankList_Form_Path = CSScript.GlobalConfigManager.Hall_Name.."/Prefabs/LobbyRankListForm/LobbyRankListForm.prefab"	
    self:Init()
end

function LobbyRankListView:Init(  )
    self:InitData()
    self:InitView()
end

function LobbyRankListView:InitData(  )
    self.rankItemList = {}
end

function LobbyRankListView:InitView(  )
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil
    self.empty_gameObject = nil
    self.listRank_gameObject = nil
    self.uiListScript = nil
    self.returnEventScript = nil
    self.btns_bg_list = nil
    self.btns_text_list = nil
end

function LobbyRankListView:ReInit()

end
--初始化ui界面
function LobbyRankListView:OpenForm()
    self:ReInit()

    self:GetUIComponent()
end


function LobbyRankListView:GetUIComponent()

    local form = XLuaUIManager.GetInstance():OpenForm(self.RankList_Form_Path,true)

    if form == nil then
        Debug.LogError("打开排行榜窗口失败："..self.RankList_Form_Path)
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

    if self.empty_gameObject == nil then
        self.empty_gameObject = self.formTransform:Find("Empty").gameObject
    end

    if  self.empty_gameObject ~= nil then
        self.empty_gameObject:SetActive(false)
    end
   
    if self.listRank_gameObject == nil then
        self.listRank_gameObject = self.formTransform:Find("RankItemList").gameObject
    end

    if self.listRank_gameObject ~= nil then
        self.listRank_gameObject:SetActive(false)
    end

    if self.uiListScript == nil then
        self.uiListScript = self.formTransform:Find("RankItemList"):GetComponent(typeof(CS.UIListScript))
        self.uiListScript.InstantiateElementCallback = function (go) self:CreateRankItem(go) end
    end

    
    if self.btns_bg_list == nil then
        self.btns_bg_list = {}
        local rank_btn_bg_01 = self.formTransform:Find("BtnFunctionList/rank_btn_01/bg").gameObject
        local rank_btn_bg_02 = self.formTransform:Find("BtnFunctionList/rank_btn_02/bg").gameObject
        table.insert(self.btns_bg_list,rank_btn_bg_01)
        table.insert(self.btns_bg_list,rank_btn_bg_02)
    end


    if self.btns_text_list == nil then
        self.btns_text_list = {}
        local rank_btn_text_01 = self.formTransform:Find("BtnFunctionList/rank_btn_01/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        local rank_btn_text_02 = self.formTransform:Find("BtnFunctionList/rank_btn_02/Text"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        table.insert(self.btns_text_list,rank_btn_text_01)
        table.insert(self.btns_text_list,rank_btn_text_02)
    end

    if self.rankBtn01EventScript == nil then 
        local go = self.formTransform:Find("BtnFunctionList/rank_btn_01").gameObject
        self.rankBtn01EventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.rankBtn01EventScript == nil then
            self.rankBtn01EventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.rankBtn01EventScript.onPointerClickCallBack = function(pointerEventData) self:RankBtn01OnPointerClick(pointerEventData) end
    end

    if self.rankBtn02EventScript == nil then 
        local go = self.formTransform:Find("BtnFunctionList/rank_btn_02").gameObject
        self.rankBtn02EventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.rankBtn02EventScript == nil then
            self.rankBtn02EventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.rankBtn02EventScript.onPointerClickCallBack = function(pointerEventData) self:RankBtn02OnPointerClick(pointerEventData) end
    end

    if self.returnEventScript == nil then
        local go = self.formTransform:Find("Return_Btn").gameObject
        self.returnEventScript = go:GetComponent(typeof(CS.UIEventScript))
        if self.returnEventScript == nil then 
            self.returnEventScript = go:AddComponent(typeof(CS.UIEventScript))
        end
        self.returnEventScript.onPointerClickCallBack = function(pointerEventData) self:ReturnOnPointerClick(pointerEventData) end
    end
end

function LobbyRankListView:ShowUIComponent()
    if self.uiFormScript ~= nil and self.uiFormScript:IsCanvasEnabled() == true then
        if self.uiListScript ~= nil then
            self.uiListScript:ResetContentPosition()
        end
        
        if LobbyRankListSystem.GetInstance().rankInfoList and #LobbyRankListSystem.GetInstance().rankInfoList > 0 then
            self:IsDisplayRankItem(true)
            self.uiListScript:SetElementAmount(#LobbyRankListSystem.GetInstance().rankInfoList)
        else
            self:IsDisplayRankItem(false)
        end
    end
    GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.NoticeFormChangePosition_EventName,false,2)
end

function LobbyRankListView:CreateRankItem(go)
    local rankItem = RankItem.New(go)
    table.insert(self.rankItemList,rankItem)
end

function LobbyRankListView:IsDisplayRankItem(isDisplay)
    CommonHelper.SetActive(self.listRank_gameObject,isDisplay)
    CommonHelper.SetActive(self.empty_gameObject,not isDisplay)
end

function LobbyRankListView:ReturnOnPointerClick(  )
    LobbyAudioManager.GetInstance():PlayNormalAudio(3)
    self:CloseForm()
end

function LobbyRankListView:RankBtn01OnPointerClick(  )
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self:IsDisplayRankBtn(1)
    LobbyRankListSystem.GetInstance():RequestRankListMsg(LuaProtoBufManager.Enum("proto_ranklist.enRankType","E_RANK_TYPE_GOLD"))
end

function LobbyRankListView:RankBtn02OnPointerClick(  )
    LobbyAudioManager.GetInstance():PlayNormalAudio(2)
    self:IsDisplayRankBtn(2)
    LobbyRankListSystem.GetInstance():RequestRankListMsg(LuaProtoBufManager.Enum("proto_ranklist.enRankType","E_RANK_TYPE_TODAY_WIN_GOLD"))
end


function LobbyRankListView:IsDisplayRankBtn(index)
    for i = 1,#self.btns_bg_list do
        if i == index then
            CommonHelper.SetActive(self.btns_bg_list[i],true)
        else
            CommonHelper.SetActive(self.btns_bg_list[i],false)
        end
    end

    for i = 1,#self.btns_text_list do
        if i == index then
            self.btns_text_list[i].color = CS.UnityEngine.Color(1,1,1,1)
        else
            self.btns_text_list[i].color = CS.UnityEngine.Color(0.72,0.68,0.91,1)
        end
    end
end


function LobbyRankListView:CloseForm()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    GlobalEventManager.GetInstance():DispatchEvent(LuaEventParams.NoticeFormChangePosition_EventName,false,1)
end

function LobbyRankListView:RemoveUIComponent()
    if self.uiFormScript ~= nil then
        XLuaUIManager.GetInstance():CloseForm(self.uiFormScript)
    end
    
    self.uiFormScript = nil
    self.formTransform = nil
    self.formGameObject = nil

    if self.returnEventScript ~= nil then
        self.returnEventScript.onPointerClickCallBack = nil
    end
    self.returnEventScript = nil
end

function LobbyRankListView:__delete( )
    self:RemoveUIComponent()
end

