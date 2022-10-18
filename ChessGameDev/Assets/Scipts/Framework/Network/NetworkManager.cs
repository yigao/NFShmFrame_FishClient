using UnityEngine;
using System.Collections;
using System;
using System.IO;
using System.Net;
using System.Reflection;

public delegate void TcpLcStateNotifyCallBack(TcpLcClient.NetworkStatus state);
public class NetworkManager : MonoSingleton<NetworkManager>
{
	public class MyTcpLcStateNotify : TcpLcClient.NetworkStateCB
	{
		public void NetworkStateNotify(TcpLcClient.NetworkStatus state)
		{
			#if UNITY_EDITOR
            Log.Info("networkStateNotify, state=" + state);
			#endif  
			m_socketState = state;
        }
    }

    public Action<MsgNode> ReceiveNetworkMsg;

    public TcpLcStateNotifyCallBack LauchNetworkCallBack = null;

    private static TcpLcClient.NetworkStatus m_socketState = TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_IDLE;
	private TcpLcClient m_tcpLc = null;

    [HideInInspector][System.NonSerialized]public int Max_Message_Num_Per_Frame = 3;
    [HideInInspector][System.NonSerialized]public int HeartBeat_Response_Timeout = 3;
    [HideInInspector][System.NonSerialized]public int HeartBeat_Send_Interval = 5;
    [HideInInspector][System.NonSerialized]public int Reconnected_Max_Time_Interval = 60;


    [HideInInspector][System.NonSerialized]public float lastHeartTime = 0;
    [HideInInspector][System.NonSerialized]public float heartBeatResWaitTime = 0;
    [HideInInspector][System.NonSerialized]public float heartBeatTimeElapsed = 0;
    [HideInInspector][System.NonSerialized]public bool isWaittingHeartRes = false;


    [HideInInspector][System.NonSerialized]public float lastConnectedTime = 0;
    [HideInInspector][System.NonSerialized]public bool isReconectedNetwork = false;
    [HideInInspector][System.NonSerialized]public float reconnectedTimeElapsed = 0;

    [HideInInspector][System.NonSerialized]public bool isNetworkOffline = false;

    protected override void Init()
    {
        base.Init();
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();

        CloseNetwork();
    }

    public void OnApplicationFocus(bool focusStatus)
    {
        lastHeartTime = Time.time;
        lastConnectedTime = Time.time;
    }

    void Update()
    {
        NetWorkLoop(Time.deltaTime);
        TcpLcCheck(Time.deltaTime);
    }

	private void NetWorkLoop(float deltaTime)
	{
        if (m_tcpLc != null)
        {
            int queueLen = m_tcpLc.getRecvMsgQueueLen();
            queueLen = queueLen <= Max_Message_Num_Per_Frame ? queueLen : Max_Message_Num_Per_Frame;

            for (int i = 0; i < queueLen; i++)
            {
                if (m_tcpLc != null)
                {
                    MsgNode msg = null;
                    try
                    {
                        msg = m_tcpLc.ReadRecvMsgQueue();
                    }
                    catch (Exception e)
                    {
                        Log.Error("Recieve Queue is empty! :" + e.ToString());
                    }
                    if (msg != null)
                    {
                        ReceiveNetworkMsg(msg);
                    }
                }
            }
            if (m_socketState == TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED)
            {
                float currTime = Time.time;
                if (isWaittingHeartRes)
                {
                    heartBeatResWaitTime += (currTime - lastHeartTime);
                }
                heartBeatTimeElapsed += (currTime - lastHeartTime);
                lastHeartTime = currTime;

                if (heartBeatTimeElapsed >= HeartBeat_Send_Interval)
                {
                    heartBeatTimeElapsed = 0;

                    OnHeartBeatReq();
                    heartBeatResWaitTime = 0;
                    isWaittingHeartRes = true;
                }
               
                if ((isWaittingHeartRes) && (heartBeatResWaitTime >= HeartBeat_Response_Timeout))
                {
                    Log.Error("No Heart Beat Response!");
                    heartBeatResWaitTime = 0;
                    isWaittingHeartRes = false;
                    NetworkOffline();
                }
            }

            if (isNetworkOffline && isReconectedNetwork)
            {
                float currTime = Time.time;

                reconnectedTimeElapsed += (currTime - lastConnectedTime);

                lastConnectedTime = currTime;

                if (m_socketState == TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED)
                {
                    isNetworkOffline = false;
                    isReconectedNetwork = false;
                    lastHeartTime = Time.time;
                    Singleton<EventManager>.GetInstance().DispatchEvent(EventID.Reconnected_Network_Succed);
                }
               
                if (reconnectedTimeElapsed >= Reconnected_Max_Time_Interval)
                {
                    NetworkOffline();
                }
            }
        }
        else
        {
            heartBeatResWaitTime = 0;
            heartBeatTimeElapsed = 0;
            isWaittingHeartRes = false;

            lastHeartTime = Time.time;
            lastConnectedTime = Time.time;

            isReconectedNetwork = false;
            reconnectedTimeElapsed = 0;

            isNetworkOffline = false;
        }
    }

    private void TcpLcCheck(float deltaTime)
    {
       
        if (m_tcpLc != null)
        {
            if (m_socketState == TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_ERROR) // m_socketState == TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_LOGIN_FAILED
            {
                LauchNetworkCallBack = null;
                NetworkOffline();
            }
            else if ( m_socketState == TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_CONNECTED || m_socketState == TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_LOGIN_FAILED)
            {
                if (LauchNetworkCallBack != null)
                {
                    lastHeartTime = Time.time;
                    LauchNetworkCallBack(m_socketState);
                    LauchNetworkCallBack = null;
                }
                if (m_socketState == TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_LOGIN_FAILED)
                {
                    CloseNetwork();
                }
            }
        }
    }

    private void SendNetworkMsg(Int16 mainMsgCode,Int16 subMsgCode, int protobufLen, Byte[] msg)
	{
		#if UNITY_EDITOR
       // Log.Info("SendNetworkMsg cmd = " + msgCode + ", length = " + protobufLen);
		#endif
		if(m_tcpLc != null)
		{
			try
			{
				m_tcpLc.WriteSendMsgQueue(mainMsgCode, subMsgCode, protobufLen, msg);
			}
			catch(Exception e)
			{
				#if UNITY_EDITOR
                Log.Info("Send Queue is full! e=" + e.ToString());
				#endif
			}
		}
	}

    public  void SendNetworkMsgLua(int mainMsgCode,int subMsgCode,byte[] msg)
    {
        SendNetworkMsg((Int16)mainMsgCode,(Int16)subMsgCode, msg.Length, msg);
    }

    public void NetworkOffline()
    {
        CloseNetwork();
        isNetworkOffline = true;
        m_socketState = TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_IDLE;
        Singleton<EventManager>.GetInstance().DispatchEvent(EventID.Game_Network_Offline);
    }

    //public void ReconnectToNetwork()
    //{
    //    //reconnectedTimeElapsed = 0;
    //    //isReconectedNetwork = true;
    //    //Singleton<UIManager>.GetInstance().OpenNetWaitForm(0,2,null);
    //    //LaunchNetwork("120.79.47.22", 6001);
    //}

    //public void ReturnToLogin()
    //{
    //    //reconnectedTimeElapsed = 0;
    //    //isNetworkOffline = false;
    //    //isReconectedNetwork = false;

    //    //Singleton<EventManager>.GetInstance().DispatchEvent(EventID.Disconnect_Return_Login);
    //}

    public void LuaLaunchNetwork(IPEndPoint iPEndPoint, TcpLcStateNotifyCallBack tcpStateCallBack)
    {
        CloseNetwork();
        LauchNetworkCallBack = tcpStateCallBack;
        if (m_tcpLc == null)
        {
            m_socketState = TcpLcClient.NetworkStatus.E_LC_NETWORK_STATE_IDLE;
            m_tcpLc = new TcpLcClient();
            m_tcpLc.Connect(iPEndPoint);
            m_tcpLc.SetStateCB(new MyTcpLcStateNotify());
            isWaittingHeartRes = false;
            heartBeatResWaitTime = 0;
            heartBeatTimeElapsed = 0;
            lastHeartTime = Time.time;
        }
    }

    public  void CloseNetwork()
	{
		#if UNITY_EDITOR
        Log.Info("CloseLcNetwork, m_tcpLc=" + m_tcpLc);
		#endif

		if (m_tcpLc != null)
		{
			m_tcpLc.ForceToClose();
			
			m_tcpLc = null;
            LauchNetworkCallBack = null;
            isWaittingHeartRes = false;
            heartBeatResWaitTime = 0;
            heartBeatTimeElapsed = 0;
            lastHeartTime = Time.time;
		}
	}

    public void OnHeartBeatReq()
    {
        Singleton<EventManager>.GetInstance().DispatchEvent(EventID.Game_Network_Heart_Beat);
    }
    //public  void OnHeartBeatRsp(MsgNode msg)
    //{
    //    isWaittingHeartRes = false;
    //    heartBeatTimeElapsed = 0;
    //}

    
    public void ClearRecieveMsgQueue()
    {
        if(m_tcpLc!=null)
        {
            m_tcpLc.ClearRecvmsgQueue();
        }
    }
}
