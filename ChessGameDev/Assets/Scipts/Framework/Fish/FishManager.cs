using System.Collections;
using System.IO;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Text;
using XLua;

public struct TracePoint
{
    public Vector3 pos;

    public Vector3 oriented;

    public TracePoint(Vector3 p, Vector3 o)
    {
        pos = p;
        oriented = o;
    }
}

public struct TraceHeader
{
    public UInt16 pointCount;
    public float timeInterval;
    public int traceId;
    public byte type;
    public byte[] byReserved;
}

public class FishManager
{
    public static float DefaultResolutionWidth = 1560;

    public static float DefaultesolutionHeight = 960;

    public static float curResolutionWidth;

    public static float curResolutionHeight;

    public static bool isLockShoot;

    public static int m_desk;

    private static bool m_rotationPoint = false;

    public static bool m_Fish3D = false;

    public static LuaFunction luaFunction;

    public static List<TracePoint> tracePointList;

    public static List<string> fileList = new List<string>();

    public static Dictionary<int, List<TracePoint>> tracePointMap = new Dictionary<int, List<TracePoint>>();

    public static Dictionary<int, TraceHeader> headerMap = new Dictionary<int, TraceHeader>();

    public static void Init(float resolutionWidth, float resolutionHeight)
    {
        tracePointMap.Clear();

        headerMap.Clear();

        fileList.Clear();

        curResolutionWidth = resolutionWidth;

        curResolutionHeight = resolutionHeight;

        luaFunction = null;

        isLockShoot = false;

        m_rotationPoint = false;
    }

    public static string GetTraceBasePath(int gameId)
    {

        StringBuilder sb = null;
        if (!MonoSingleton<GameMain>.GetInstance().DeveloperMode)
        {
            sb = new StringBuilder(FileManager.GetIFSExtractPath()).Append("/");
        }
        else
        {
            sb = new StringBuilder(Application.dataPath);
            sb.Append("/AssetBundle/");
        }
        sb.Append(gameId.ToString());
        sb.Append("/common/config");
        return sb.ToString();
    }

    public static int GetTraceFileCount(int gameID)
    {
        fileList.Clear();
        string path = GetTraceBasePath(gameID);
        string[] filePath = Directory.GetFiles(path);
        for (int i = 0; i < filePath.Length; ++i)
        {
            if (filePath[i].EndsWith(".pack"))
            {
                fileList.Add(filePath[i]);
            }
        }

        return ((fileList.Count / 10) + ((fileList.Count % 10) > 0 ? 1 : 0));
    }



    public static IEnumerator LoadBinaryTraceFile()
    {
        int number = 0;
        for (int i = 0; i < fileList.Count; ++i)
        {
            try
            {
                FileStream fs = File.Open(fileList[i], FileMode.Open);
                ParseBinaryTraceFile(fs);

                fs.Close();

            }
            catch (Exception ex)
            {
                Log.Error("File is Error :" + fileList[i] + "  " + ex.ToString());
            }
            number++;
            if (number % 10 == 0 || (i == fileList.Count - 1))
            {
                yield return 0;
            }
        }
        yield return 0;
        if (luaFunction != null)
        {
            luaFunction.Call();
            //luaFunction.Dispose();
            luaFunction = null;
        }
    }

    public static void ParseBinaryTraceFile(FileStream strem)
    {
        using (BinaryReader br = new BinaryReader(strem))
        {
            while (br.BaseStream.Position < br.BaseStream.Length)
            {

                TraceHeader traceHeader = new TraceHeader();
                traceHeader.pointCount = br.ReadUInt16();
                traceHeader.timeInterval = ((float)br.ReadUInt16()) * 0.001f;
                traceHeader.type = br.ReadByte();
                int centerX = br.ReadInt32();
                int centerY = br.ReadInt32();
                traceHeader.traceId = br.ReadInt32();

                traceHeader.byReserved = br.ReadBytes(15);

                if (headerMap.ContainsKey(traceHeader.traceId))
                {
                    headerMap[traceHeader.traceId] = traceHeader;
                }
                else
                {
                    headerMap.Add(traceHeader.traceId, traceHeader);
                }

                List<TracePoint> tracePointList = new List<TracePoint>();

                for (int i = 0; i < traceHeader.pointCount; ++i)
                {
                    float xPoint = ((float)br.ReadInt32()) * 0.0001f;
                    float yPoint = ((float)br.ReadInt32()) * 0.0001f;

                    Vector3 Vector3Pos = ScreenPointToRealPoint((float)xPoint, (float)yPoint);
                  
                    Vector3 Vector3Ori = new Vector3(999990000, 999990000, 0);

                    if (traceHeader.type == 1)
                    {
                        float xOri = ((float)br.ReadInt32()) * 0.0001f;
                        float yOri = ((float)br.ReadInt32()) * 0.0001f;
                        if (xOri == 99999.0 && yOri == 99999.0)
                        {
                            Vector3Ori = new Vector3(999990000, 999990000, 0);
                        }
                        else
                        {
                            Vector3Ori = ScreenPointToRealPoint(xOri, yOri);
                        }
                    }

                    TracePoint tp = new TracePoint(Vector3Pos, Vector3Ori);

                    tracePointList.Add(tp);
                }

                if (tracePointMap.ContainsKey(traceHeader.traceId))
                {
                    tracePointMap[traceHeader.traceId] = tracePointList;
                }
                else
                {
                    tracePointMap.Add(traceHeader.traceId, tracePointList);
                }
            }
            br.Close();
        }
    }

    public static void AccordingDeskLoadBinaryTraceFile(int gameID, bool isRotationPoint, LuaFunction callBack,bool isFish3D=false)
    {
        if (fileList.Count == 0 || fileList == null)
        {
            GetTraceFileCount(gameID);
        }
        m_rotationPoint = isRotationPoint;

        luaFunction = callBack;

        m_Fish3D = isFish3D;

        MonoSingleton<GameMain>.GetInstance().StartCoroutine(LoadBinaryTraceFile());
    }


    public static float GetRealWidthRatio()
    {
        return curResolutionWidth / DefaultResolutionWidth;
    }

    public static float GetRealHeightRatio()
    {
        return curResolutionHeight / DefaultesolutionHeight;
    }

    public static bool LimitTracePoint(int trace, int index)
    {
        List<TracePoint> tracePointList = null;

        if (tracePointMap.TryGetValue(trace, out tracePointList))
        {
            if (index < (tracePointList.Count - 1)) return true;
        }
        else
            Log.Error("轨迹不存在==>" + trace);
        return false;
    }

    public static Vector3 ScreenPointToRealPoint(float x, float y)
    {

        float xPoint = x * (curResolutionWidth / DefaultResolutionWidth);

        float yPoint = y * (curResolutionHeight / DefaultesolutionHeight);
        if (m_rotationPoint)
        {
            xPoint = curResolutionWidth - xPoint;
            yPoint = curResolutionHeight - yPoint;
        }
        return new Vector3(xPoint - curResolutionWidth * 0.5f, curResolutionHeight * 0.5f - yPoint, 0);
        
    }

    public static Vector3 RealPointToScreenPoint(float x, float y)
    {
        float xPoint = x + curResolutionWidth/2;
        float yPoint = curResolutionHeight / 2 - y;
        if(m_rotationPoint)
        {
            xPoint = curResolutionWidth - xPoint;
            yPoint = curResolutionHeight - yPoint;
        }

        xPoint = xPoint * (DefaultResolutionWidth / curResolutionWidth);
        yPoint = yPoint * (DefaultesolutionHeight / curResolutionHeight);
        return new Vector3(xPoint, yPoint, 0);
    }

    public static void SetPosition(GameObject go, float x, float y, float z)
    {
        if (go == null)
        {
            return;
        }
        SetPosition(go.transform, x, y, z);
    }

    public static void SetLocalPosition(GameObject go, float x, float y, float z)
    {
        if (go == null)
        {
            return;
        }
        SetLocalPosition(go.transform, x, y, z);
    }

    public static void SetEulerAngles(GameObject go, float x, float y, float z)
    {
        if (go == null)
        {
            return;
        }
        SetEulerAngles(go.transform, x, y, z);
    }

    public static void SetLocalEulerAngles(GameObject go, float x, float y, float z)
    {
        if (go == null)
        {
            return;
        }
        SetLocalEulerAngles(go.transform, x, y, z);
    }

    public static void SetLocalScale(GameObject go, float x, float y, float z)
    {
        if (go == null)
        {
            return;
        }
        SetLocalScale(go.transform, x, y, z);
    }

    public static void SetPosition(Transform trans, float x, float y, float z)
    {
        if (trans == null)
        {
            return;
        }
        trans.position = new Vector3(x, y, z);
    }

    public static void SetLocalPosition(Transform trans, float x, float y, float z)
    {
        if (trans == null)
        {
            return;
        }
        trans.localPosition = new Vector3(x, y, z);
    }

    public static void SetEulerAngles(Transform trans, float x, float y, float z)
    {
        if (trans == null)
        {
            return;
        }
        trans.eulerAngles = new Vector3(x, y, z);
    }

    public static void SetLocalEulerAngles(Transform trans, float x, float y, float z)
    {
        if (trans == null)
        {
            return;
        }
        trans.localEulerAngles = new Vector3(x, y, z);
    }

    public static void SetLocalScale(Transform trans, float x, float y, float z)
    {
        if (trans == null)
        {
            return;
        }
        trans.localScale = new Vector3(x, y, z);
    }

    public static void FromToRotation(GameObject go, float x1, float y1, float z1, float x2, float y2, float z2)
    {
        if (go == null)
        {
            return;
        }
        FromToRotation(go.transform, x1, y1, z1, x2, y2, z2);
    }

    public static void FromToRotation(Transform trans, float x1, float y1, float z1, float x2, float y2, float z2)
    {
        if (trans == null)
        {
            return;
        }
        trans.rotation = Quaternion.FromToRotation(new Vector3(x1, y1, z1), new Vector3(x2, y2, z2));
    }


}
