LuaEventParams={}


----------------------------------网络消息事件-----------------------------------
--NetworkParams	
LuaEventParams.Login_EventName=1001				--登录游戏
LuaEventParams.LoginBack_EventName=1002	




---------------------------------游戏内部事件-----------------------------------------
--GameParams
LuaEventParams.Network_Reconnect_Succeed_EventName = "Network_Reconnect_Succeed"                    --网络断线重连连接成功
LuaEventParams.Reutun_To_Login_EventName = "Reutun_To_Login"                                        --返回到登陆
LuaEventParams.GameProgressBar_EventName="GameProgressBar"			                                --进度条
LuaEventParams.LoadLobbyAssetsComplete_EventName="LoadLobbyAssetsComplete"                          --加载大厅资源完成事件
LuaEventParams.EnteLobbyLogin_EventName = "EnteLobbyLogin"                                          --大厅资源加载完并进入登陆界面
LuaEventParams.LoadGameAssetsComplete_EventName="LoadGameAssetsComplete"			                --加载游戏资源完成事件
LuaEventParams.EnteGameRoom_EventName = "LoadResCompleteEnteGameRoom"                               --游戏资源加载完成并进入游戏的房间列表
LuaEventParams.UnloadGameAssets_EventName = "UnloadGameAssets"                                      --卸载游戏资源
LuaEventParams.EnterGame_EventName="PlayerEnterGame"						                        --进入游戏事件
LuaEventParams.QuitGame_EventName="QuitGame"								                        --退出游戏

LuaEventParams.GameNewEmailTips_EventName="GameNewEmailTips"					                    --新邮件红点提示
LuaEventParams.NoticeFormChangePosition_EventName = "NoticeFormPosition"                            --小跑马灯的位置改变
LuaEventParams.PaoMaDengChangePosition_EventName = "PaoMaDengChangePosition"                        --大跑马灯的位置改变

LuaEventParams.OpenGameIntroduction_EventName = "OpenGameIntroduction"                              --房间列表打开游戏介绍窗口

LuaEventParams.GameEventOpenTipsForm_EventName = "GameEventOpenTipsForm"                            --游戏通过事件打开提示窗口

LuaEventParams.EnterGameFailure_EventName = "EnterGameFailure"                                      --进入游戏失败

return LuaEventParams