using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 定时器管理器,是以毫秒(ms)为单位,比如定时1s = 1000ms.
/// </summary>
public class TimerManager : Singleton<TimerManager>
{
    private List<Timer>m_timers;

    private int m_timerSequence;

    public override void Init()
    {
        m_timers = new List<Timer>();
        m_timerSequence = 0;
    }

    public void Update()
    {
        UpdateTimer((int)(Time.deltaTime * 1000f));
    }

    public void UpdateTimer(int delta)
    {
        int i = 0;
        while (i < m_timers.Count)
        {
            if (m_timers[i].IsFinished())
            {
                m_timers.RemoveAt(i);
            }
            else
            {
                m_timers[i].Update(delta);
                i++;
            }
        }    
    }

    /// <summary>
    /// 开启一个定时器,以毫秒(ms)为单位
    /// </summary>
    /// <param name="time">时间(毫秒为单位)</param>
    /// <param name="loop">重复次数</param>
    /// <param name="onTimeUpHandler"></param>
    /// <returns></returns>
    public int AddTimer(int time, int loop, Timer.OnTimeUpHandler onTimeUpHandler)
    {
        m_timerSequence++;
        m_timers.Add(new Timer(time, loop, onTimeUpHandler, m_timerSequence));
        return m_timerSequence;
    }

    public void RemoveTimer(int sequence)
    {
        for (int i = 0; i < m_timers.Count; i++)
		{
			if (m_timers[i].IsSequenceMatched(sequence))
			{
                m_timers[i].Finish();
				return;
			}
		}
    }

    public void RemoveTimerSafely(ref int sequence)
    {
        if (sequence != 0)
        {
            RemoveTimer(sequence);
            sequence = 0;
        }
    }

    public void PauseTimer(int sequence)
    {
        Timer timer = GetTimer(sequence);
        if (timer != null)
        {
            timer.Pause();
        }
    }

    public void ResumeTimer(int sequence)
    {
        Timer timer = GetTimer(sequence);
        if (timer != null)
        {
            timer.Resume();
        }
    }

    public void ResetTimer(int sequence)
    {
        Timer timer = GetTimer(sequence);
        if (timer != null)
        {
            timer.Reset();
        }
    }

    public void ResetTimerTotalTime(int sequence, int totalTime)
    {
        Timer timer = GetTimer(sequence);
        if (timer != null)
        {
            timer.ResetTotalTime(totalTime);
        }
    }


    public void ModifyTimerTotalTime(int sequence, int totalTime)
    {
        Timer timer = GetTimer(sequence);
        if (timer != null)
        {
            timer.ModifyTotalTime(totalTime);
        }
    }

    public int GetTimerCurrent(int sequence)
    {
        Timer timer = GetTimer(sequence);
        if (timer != null)
        {
            return timer.currentTime;
        }
        return -1;
    }

    public float GetLeftTime(int sequence)
    {
        Timer timer = GetTimer(sequence);
        if (timer != null)
        {
            return timer.GetLeftTime() / 1000.0f;
        }
        return -1;
    }

    public Timer GetTimer(int sequence)
    {
        for (int i = 0; i < m_timers.Count; ++i)
        {
            if (m_timers[i].IsSequenceMatched(sequence))
            {
                return m_timers[i];
            }
        }
        return null;
    }

    public void RemoveTimer(Timer.OnTimeUpHandler onTimeUpHandler)
    {
        for (int i = 0; i < m_timers.Count; i++)
        {
            if (m_timers[i].IsDelegateMatched(onTimeUpHandler))
            {
                m_timers[i].Finish();
            }
        }
    }

    public void RemoveAllTimer()
    {
        m_timers.Clear();
    }
}
