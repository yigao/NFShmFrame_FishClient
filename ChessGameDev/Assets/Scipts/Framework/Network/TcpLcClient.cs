using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.IO;
using UnityEngine;

public class MsgNode
{
    public char[] Head = new char[4] { 'h','e','a','d'};
    public int MsgLength = 0;
    public Int16 SubMsgID = 0;
    public Int16 MainMsgID = 0;
	public Byte[] MsgBody = null;
}

public class TcpLcClient
{
    private TcpClient lcClient = new TcpClient();
    private short seqID = 0;
	
	//private string m_ip = null;
	//private int m_port = 0;

    private IPEndPoint m_iPEndPoint;

    private bool isConnect = false;

    private TcpLcQueue.Queue<MsgNode> sendMsgQueue = new TcpLcQueue.Queue<MsgNode>();
    private TcpLcQueue.Queue<MsgNode> recvMsgQueue = new TcpLcQueue.Queue<MsgNode>();

    private NetworkStatus networkState = 0;
	public static byte[] NetEncodeKey = null;
	public static short NetCheckCode = 0;

    private const int SEND_DATA_SLEEP_DELAY = 5;
    private const int RECV_DATA_SLEEP_DELAY = 5;

    // for pack msg...
    private const int MAX_HEADER_LEN = 12;
    //private const int MAX_HEADER_BUF_LEN = 20;
	private const int MAX_MSG_POOL_LEN = 2097152;

	Byte[] msgHeader = new Byte[MAX_HEADER_LEN];
	//Byte[] msgPool = new Byte[MAX_MSG_POOL_LEN];
    private int headerCount = 0;
    Byte[] msgBody = null;
    private int bodyCount = 0;

    private ParserState parserState = ParserState.E_LC_PARSER_STATE_HEADER;

    private MsgHeaderCntx msgHeaderCntx = new MsgHeaderCntx();
	
	bool forceToClose = false;

    private Thread connectedThread;

    private Thread sendThread;

    private Thread recvThread;

    private enum ParserState
    {
        E_LC_PARSER_STATE_HEADER = 0,
        E_LC_PARSER_STATE_BODY,
        E_LC_PARSER_STATE_MAX
    }

    public enum NetworkStatus
    {
        E_LC_NETWORK_STATE_IDLE = 0,
        E_LC_NETWORK_STATE_CONNECTING,
        E_LC_NETWORK_STATE_CONNECTED,
        E_LC_NETWORK_STATE_ERROR,
		E_LC_NETWORK_STATE_LOGIN_FAILED,
    }

    // network status call back.
    public interface NetworkStateCB
    {
        void NetworkStateNotify(NetworkStatus state);
    }

    private NetworkStateCB stateCB = null;

    public void SetStateCB(NetworkStateCB cb)
    {
        stateCB = cb;
    }

    public class MsgHeaderCntx
    {
        public char[] Head;
        public int BodyLength = 0;
        public Int16 SubMsgID = 0;
		public Int16 MainMsgID = 0;
		
    }

    public TcpClient getLcClient()
    {
        return lcClient;
    }
	
	public int getSendMsgQueueLen()
	{
		return sendMsgQueue.Count;
	}
	
	public int getRecvMsgQueueLen()
	{
		return recvMsgQueue.Count;
	}

    public void ClearRecvmsgQueue()
    {
        recvMsgQueue.Clear();
    }

    public void WriteSendMsgQueue(Int16 mainMsgID,Int16 subMsgID,int protobufLen, Byte[] msg)
    {
        MsgNode node = new MsgNode();
		node.SubMsgID = subMsgID;
        node.MsgLength = protobufLen; // header len without msgLen attr
        node.MsgBody = msg;
        node.Head = new char[4]{'h','e','l','o'};
        node.MainMsgID = mainMsgID;
        int j = 0;
        //String str = "Loveless";
        //Byte[] encodeKey = System.Text.Encoding.ASCII.GetBytes(str);
#if UNITY_EDITOR
		//Debug.Log("WriteSendMsgQueue, NetEncodeKey.Len=" + NetEncodeKey.Length);
#endif
		if (NetEncodeKey != null && NetEncodeKey.Length > 0)
		{
			for (int i = 0; i < node.MsgBody.Length; i++)
	        {
				node.MsgBody[i] ^= NetEncodeKey[j++];

				if (j >= NetEncodeKey.Length)
	            {
	                j = 0;
	            }
	        } 
		}
		
		try
		{
        	WriteSendMsgQueue(node);
		}
		catch(Exception e)
		{
			throw e;
		}
    }

    public void WriteSendMsgQueue(MsgNode node)
    {
        if (node != null)
        {
			try
			{
            	sendMsgQueue.Enqueue(node);
			}
			catch(Exception e)
			{
				throw e;
			}
        }
    }

    public MsgNode ReadSendMsgQueue()
    {
        MsgNode node = null;
        try
        {
            node = sendMsgQueue.Dequeue();
        }
        catch (Exception e)
        {
            throw e;
        }

        return node;
    }



    // recv queue....
    public void WriteRecvMsgQueue(Int16 mainMsgID,Int16 subMsgID,int protobufLen, Int16 reserved, char[] head, Byte[] msg)
    {
        MsgNode node = new MsgNode();
        node.SubMsgID = subMsgID;
        node.MsgLength = protobufLen; // header len without msgLen attr
        node.MsgBody = msg;
        node.Head = head;
        node.MainMsgID = mainMsgID;

        if (node.MsgBody != null) // may be null...
		{
	        int j = 0;
	        //String str = "Loveless";
	        //Byte[] encodeKey = System.Text.Encoding.ASCII.GetBytes(str);
			if (NetEncodeKey != null && NetEncodeKey.Length > 0)
			{
				for (int i = 0; i < node.MsgBody.Length; i++)
		        {
					node.MsgBody[i] ^= NetEncodeKey[j++];
		
					if (j >= NetEncodeKey.Length)
		            {
		                j = 0;
		            }
		        } 
			}
		}
		else
		{
			node.MsgBody = new Byte[0];
		}
        
		try
		{
        	WriteRecvMsgQueue(node);

		}
		catch(Exception e)
		{
			throw e;
		}
    }

    public void WriteRecvMsgQueue(MsgNode node)
    {
        if (node != null)
        {
			try
			{
            	recvMsgQueue.Enqueue(node);
			}
			catch(Exception e)
			{
				throw e;
			}
        }
    }

    public MsgNode ReadRecvMsgQueue()
    {
        MsgNode node = null;
		
		try
		{
			node = recvMsgQueue.Dequeue();
		}
		catch(Exception e)
		{
			throw e;
		}
	
        return node;
    }

    private void SendDataProc()
    {
        if (networkState == NetworkStatus.E_LC_NETWORK_STATE_CONNECTED)
        {
            try
            {
                NetworkStream stream = lcClient.GetStream();
            
                do
                {
                    if (forceToClose == true || lcClient.Connected == false)
                    {
                        break;
                    }

                    MsgNode node = null;

                    try
                    {
                        node = ReadSendMsgQueue();
						//#if UNITY_EDITOR	
						////Log.Warning("SendDataProc, have some data to send..CMD=" + node.SubMsgID);
						//#endif
                        
                    }
                    catch (Exception e)
                    {
                       // Log.Info("maybe queue is empty :" + e);
                    }

                    if (stream.CanWrite && node != null)
                    {
                        string strHead = new string(node.Head);
                        byte[] headBytes = Encoding.Default.GetBytes(strHead);
                        stream.Write(headBytes, 0, headBytes.Length);

                        Byte[] msgLenBuf = BitConverter.GetBytes(node.MsgLength);
                        stream.Write(msgLenBuf, 0, msgLenBuf.Length);
                        
						Byte[] msgIDeBuf = BitConverter.GetBytes(node.SubMsgID);
						stream.Write(msgIDeBuf, 0, msgIDeBuf.Length);
                        
						Byte[] reservedBuf = BitConverter.GetBytes(node.MainMsgID);
						stream.Write(reservedBuf, 0, reservedBuf.Length);

						stream.Write(node.MsgBody, 0, node.MsgBody.Length);

                        stream.Flush();  
                    }

                	Thread.Sleep(SEND_DATA_SLEEP_DELAY);
            	} while (true);
	        }
	        catch (Exception e)
	        {
	            networkState = NetworkStatus.E_LC_NETWORK_STATE_ERROR;
	            if (stateCB != null)
	            {
					if (forceToClose == false)
					{
	                    stateCB.NetworkStateNotify(NetworkStatus.E_LC_NETWORK_STATE_ERROR);
					}
	            }
	        }
            isConnect = false;
        }
    }

    private void RecvDataProc()
    {
		Byte[] buffer = new Byte[2048];
		
        if (networkState == NetworkStatus.E_LC_NETWORK_STATE_CONNECTED)
        {
            try
            {
                NetworkStream stream = lcClient.GetStream();
            
                do
                {
                    if (forceToClose == true || lcClient.Connected == false)
                    {
                        break;
                    }

                    if (stream.CanRead)
                    {
                        //Byte[] buffer = new Byte[2048];
                        int readBytes = 0;
                        readBytes = stream.Read(buffer, 0, 2048);

                        if (readBytes > 0)
                        {
                            try
                            {
                                RecvResponse(buffer, readBytes);
                            }
                            catch (Exception e)
                            {
                                //Log.Info("maybe queue is empty :" + e);
                            }
                        }
                    }

                    Thread.Sleep(RECV_DATA_SLEEP_DELAY);
                    
                } while (true);
            }
            catch (Exception e)
            {
                networkState = NetworkStatus.E_LC_NETWORK_STATE_ERROR;
                if (stateCB != null)
                {
                    if (forceToClose == false)
                    {
                        stateCB.NetworkStateNotify(NetworkStatus.E_LC_NETWORK_STATE_ERROR);
                    }
                }
            }

            isConnect = false;
        }
    }

    private bool RecvResponse(Byte[] data, int length)
    {
		int leftBytes = length;
        int offset = 0;
        bool ret = true;

        do
        {
            //Log.Info ("recv rsp pack msg, parserState =" + parserState );
            switch (parserState)
            {
                case ParserState.E_LC_PARSER_STATE_HEADER:
                {
                    if (leftBytes - (MAX_HEADER_LEN - headerCount) >= 0)
                    {
                        //memcpy(m_msgPackage.m_header + m_msgPackage.m_headerCount, pOffset, sizeof(T_LC_Protocol_MsgHeader) - m_msgPackage.m_headerCount);
                        Array.Copy(data, offset, msgHeader, headerCount, MAX_HEADER_LEN - headerCount);
                        
                        offset += MAX_HEADER_LEN - headerCount;
                        leftBytes -= MAX_HEADER_LEN - headerCount;
                        
                        headerCount = 0;

                        string strHead = BitConverter.ToString(msgHeader, 0);

                        int bodyLen = BitConverter.ToInt32(msgHeader, 4);

                        Int16 msgID = BitConverter.ToInt16(msgHeader, 8);

                        Int16 value = BitConverter.ToInt16(msgHeader, 10);

                        msgHeaderCntx.BodyLength = bodyLen;
						msgHeaderCntx.SubMsgID = msgID;
						msgHeaderCntx.MainMsgID = value;
						msgHeaderCntx.Head = strHead.ToCharArray();
					
      //                  #if UNITY_EDITOR		
      //                 // Log.Info("recv rsp pack msg, cmd=" + msgID + ", bodyLen=" + bodyLen);
						//#endif                        
                        if (bodyLen > 0)
                        {
                            if (msgBody == null)
                            {
                                msgBody = new Byte[bodyLen];

                                if (msgBody == null)
                                {
                                    return false;
                                }
                            }

                            bodyCount = 0;
                            parserState = ParserState.E_LC_PARSER_STATE_BODY;
                        }
                        else if (bodyLen == 0)
                        {
							try
							{
								WriteRecvMsgQueue(msgHeaderCntx.MainMsgID,msgHeaderCntx.SubMsgID, msgHeaderCntx.BodyLength, msgHeaderCntx.MainMsgID, msgHeaderCntx.Head,null);
							}
							catch(Exception e)
							{
								#if UNITY_EDITOR
                                Log.Error("Recieve Queue is full!" + e);
                                #endif
							}
                            msgHeader.Initialize();
                            parserState = ParserState.E_LC_PARSER_STATE_HEADER;
                        }
                        else
                        {
                            return false;
                        }
                    }
                    else
                    {
                        //memcpy(m_msgPackage.m_header + m_msgPackage.m_headerCount, pOffset, leftBytes);
                        Array.Copy(data, offset, msgHeader, headerCount, leftBytes);
                        headerCount += leftBytes;
                        
                        return true;
                    }

                    break;
                }
                case ParserState.E_LC_PARSER_STATE_BODY:
                {
					if (leftBytes - (msgHeaderCntx.BodyLength - bodyCount) >= 0)
                    {
                        //memcpy(m_msgPackage.m_body + m_msgPackage.m_bodyCount, pOffset, m_msgPackage.m_bodyLen - m_msgPackage.m_bodyCount);
						Array.Copy(data, offset, msgBody, bodyCount, msgHeaderCntx.BodyLength - bodyCount);
                        
						offset += msgHeaderCntx.BodyLength - bodyCount;
						leftBytes -= msgHeaderCntx.BodyLength - bodyCount;

						try
						{
							WriteRecvMsgQueue(msgHeaderCntx.MainMsgID,msgHeaderCntx.SubMsgID,msgHeaderCntx.BodyLength, msgHeaderCntx.MainMsgID, msgHeaderCntx.Head,msgBody);
						}
						catch(Exception e)
						{
							#if UNITY_EDITOR
                            Log.Error("Recieve Queue is full!" + e);
							#endif
						}
                        //msgHeader = null;
                        msgHeader.Initialize();
                        msgBody = null;
                        headerCount = 0;
                        bodyCount = 0;

                        parserState = ParserState.E_LC_PARSER_STATE_HEADER;
                    }
                    else
                    {
                        //memcpy(m_msgPackage.m_body + m_msgPackage.m_bodyCount, pOffset, leftBytes);
                        Array.Copy(data, offset, msgBody, bodyCount, leftBytes);
                        bodyCount += leftBytes;

                        return true;
                    }
                    
                    break;
                }
                default:
                {
                    ret = false;
                    break;
                }
            }
            //Log.Info("recv rsp pack msg, leftBytes =" + leftBytes);
        } while (leftBytes > 0);

        return ret;
    }

    public void ConnectProc()
    {
        try
        {
            networkState = NetworkStatus.E_LC_NETWORK_STATE_CONNECTING;

            //Log.Info("Start Login, ip=" + m_iPEndPoint.Address + ", port=" + m_iPEndPoint.Port);

            lcClient.Connect(m_iPEndPoint);//IPAddress.Parse(m_ip), m_port

            networkState = NetworkStatus.E_LC_NETWORK_STATE_CONNECTED;

            stateCB.NetworkStateNotify(networkState);

            Log.Info("Start Login,  Connected...");

            isConnect = true;
        }
        catch (Exception e)
        {
            networkState = NetworkStatus.E_LC_NETWORK_STATE_LOGIN_FAILED;

            Log.Info("Start Login, error=" + e.ToString());

            if (stateCB != null)
            {
                if (forceToClose == false)
                {
                    stateCB.NetworkStateNotify(NetworkStatus.E_LC_NETWORK_STATE_LOGIN_FAILED);
                }
            }

            lcClient.Close();

            return;
        }

        ThreadStart threadStart1 = new ThreadStart(SendDataProc);
        ThreadStart threadStart2 = new ThreadStart(RecvDataProc);
        
        sendThread = new Thread(threadStart1);
        recvThread = new Thread(threadStart2);
        sendThread.Start();
        recvThread.Start();
    }



    public void Connect(IPEndPoint iPEndPoint)
    {
        if (isConnect == true)
        {
            ForceToClose();
        }

        //m_ip = ip;
        //m_port = port;
        m_iPEndPoint = iPEndPoint;

        sendMsgQueue.Clear();
        recvMsgQueue.Clear();

        ThreadStart threadStart = new ThreadStart(ConnectProc);
        connectedThread = new Thread(threadStart);
        connectedThread.IsBackground = true;
        connectedThread.Start();
    }

	public void ForceToClose()
	{
		if (isConnect == true)
        {
			forceToClose = true;
	
			lcClient.Close();
			
			isConnect = false;
		}
        
		sendMsgQueue.Clear();
		recvMsgQueue.Clear();

        if (sendThread != null)
        {
            sendThread.Abort();
        }
        sendThread = null;

        if (recvThread != null)
        {
            recvThread.Abort();
        }
        recvThread = null;

        if (connectedThread != null)
        {
            connectedThread.Abort();
        }
        connectedThread = null;
	}
}

