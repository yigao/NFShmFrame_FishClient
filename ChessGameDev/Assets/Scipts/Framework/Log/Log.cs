using System;
using UnityEngine;
using Object = UnityEngine.Object;

public class Log
{
    #region 【属性】

    public static bool IsOpen { set; get; }
    public static bool IsScreenOpen { set; get; }
    public static bool IsInfo { set; get; }
    public static bool IsDebug { set; get; }
    public static bool IsWarning { set; get; }
    public static bool IsError { set; get; }
    public static bool IsExcept { set; get; }
    public static bool IsCritical { set; get; }

    #endregion

    static Log()
    {
        IsOpen = true;
        IsScreenOpen = true;

        IsDebug = true;
        IsInfo = true;
        IsWarning = true;
        IsError = true;
        IsExcept = true;
        IsCritical = true;
    }

    #region 【公有方法】
    /// <summary>
    /// 屏幕日志
    /// </summary>
    public static void OpenReporter()
    {
        var o = Object.Instantiate(Resources.Load("Reporter")) as Transform;
        if (o != null) Object.DontDestroyOnLoad(o);
    }

    /// <summary>
    /// debug
    /// </summary>
    /// <param name="content"></param>
    public static void Debug(object content)
    {
        if (!IsDebug) return;

        string logstr = DateTime.Now.ToString("HH:mm:ss") + " [Debug] " + content;
        _SetDebugLog(logstr, LEVEL.debug);
    }

    /// <summary>
    /// 信息
    /// </summary>
    /// <param name="content"></param>
    public static void Info(object content)
    {
        if (!IsInfo) return;

        string logstr = DateTime.Now.ToString("HH:mm:ss") + " [Info] " + content;
        _SetDebugLog(logstr, (LEVEL.info));
    }

    /// <summary>
    /// 警告
    /// </summary>
    /// <param name="content"></param>
    public static void Warning(object content)
    {
        if (!IsWarning) return;

        string logstr = DateTime.Now.ToString("HH:mm:ss") + " [Warning] " + content;
        _SetDebugLog(logstr, LEVEL.warning);
    }

    /// <summary>
    /// 错误
    /// </summary>
    /// <param name="content"></param>
    public static void Error(object content)
    {
        if (!IsError) return;

        string logstr = DateTime.Now.ToString("HH:mm:ss") + " [Error] " + content;
        _SetDebugLog(logstr, LEVEL.error);
    }

    /// <summary>
    /// 异常
    /// </summary>
    /// <param name="content"></param>
    public static void Except(object content)
    {
        if (!IsExcept) return;

        string logstr = DateTime.Now.ToString("HH:mm:ss") + " [Except] " + content;
        _SetDebugLog(logstr, LEVEL.except);
    }

    /// <summary>
    /// 重要提示
    /// </summary>
    /// <param name="content"></param>
    public static void Critical(object content)
    {
        if (!IsCritical) return;

        string logstr = DateTime.Now.ToString("HH:mm:ss") + " [Critical] " + content;
        _SetDebugLog(logstr, LEVEL.critical);
    }

    #endregion

    #region 【私有方法】

    /// <summary>
    /// 设置输出log文本信息
    /// </summary>
    /// <param name="content"></param>
    /// <param name="level"></param>
    private static void _SetDebugLog(object content, LEVEL level)
    {
        //开发log
        if (IsOpen)
        {
            string color = _GetLogModeColor(level);
            if (level == LEVEL.error)
            {
                UnityEngine.Debug.LogError("<color=" + color + ">" + content + "</color>");
            }
            else if (level == LEVEL.warning)
            {
                UnityEngine.Debug.LogWarning("<color=" + color + ">" + content + "</color>");
            }
            else
            {
                UnityEngine.Debug.Log("<color=" + color + ">" + content + "</color>");
            }
        }
    }

    /// <summary>
    /// log输出颜色
    /// </summary>
    /// <param name="level"></param>
    /// <returns></returns>
    private static string _GetLogModeColor(LEVEL level)
    {
        string nColor = "#878787";

        switch (level)
        {
            case LEVEL.debug:
                nColor = "#FFFFFF";
                break;

            case LEVEL.info:
                nColor = "#0BCD32";
                break;

            case LEVEL.warning:
                nColor = "#DBDB00";
                break;

            case LEVEL.error:
                nColor = "#D40909";
                break;

            case LEVEL.except:
                nColor = "#0707D2";
                break;

            case LEVEL.critical:
                nColor = "#878787";
                break;
        }
        return nColor;
    }

    #endregion

    #region 【数据结构】
    /// <summary>
    /// log类型
    /// </summary>
    public enum LEVEL
    {
        normal,
        debug,
        info,
        warning,
        error,
        except,
        critical
    }
    #endregion
}