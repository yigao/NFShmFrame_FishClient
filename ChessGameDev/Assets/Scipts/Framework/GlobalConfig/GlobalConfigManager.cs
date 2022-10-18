using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Net;
using System.Net.Sockets;

public class GlobalConfigManager : Singleton<GlobalConfigManager>
{
    public string Hall_Name = "Lobby_801";

    public string Game_Config = "GameConfig";

    public string Contract_Number = "ubuntu37du_0000001";

    public string Account_Login_Ip = "8.136.154.98";//"120.79.47.22"; //"192.168.10.85";

    public int Account_Login_Port = 7051;

    public IPEndPoint m_accountLoginIPEndPoint;

    private List<IPEndPoint> m_userLoginGameIPEndPointList = new List<IPEndPoint>();

    public string Url_Path = "http://8.136.154.98/";

    public string GetDeviceUniqueIdentifier()
    {
        return UnityEngine.SystemInfo.deviceUniqueIdentifier;
    }

    public void SetAccountLoginIPEndPoint(string ip, int port)
    {
        m_accountLoginIPEndPoint = new IPEndPoint(IPAddress.Parse(Account_Login_Ip), Account_Login_Port);
    }

    public IPEndPoint GetAccountLoginIPEndPoint()
    {
        return new IPEndPoint(IPAddress.Parse(Account_Login_Ip), Account_Login_Port);
    }

    public void SetUserLoginGameIPEndPoint(string ip, int port)
    {
        IPEndPoint ipEndPoint = new IPEndPoint(IPAddress.Parse(ip), port);
        m_userLoginGameIPEndPointList.Add(ipEndPoint);
    }

    public IPEndPoint GetUserLoginGameIPEndPoint()
    {
        int index = Random.Range(0, m_userLoginGameIPEndPointList.Count);
        return m_userLoginGameIPEndPointList[index];
    }

    public void ClearUserLoginGameIPEndPoint()
    {
        m_userLoginGameIPEndPointList.Clear();
    }
}
