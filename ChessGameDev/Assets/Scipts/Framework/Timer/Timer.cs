using System;

public class Timer 
{
    public delegate void OnTimeUpHandler(int timerSequence);

    private Timer.OnTimeUpHandler m_timeUpHandler;

    private int m_loop = 1;

    private int m_totalTime;

    private int m_currentTime;

    private bool m_isFinished;

    private bool m_isRunning;

    private int m_sequence;

    public int currentTime
    {
        get
        {
            return m_currentTime;
        }
    }

    public Timer(int time, int loop, Timer.OnTimeUpHandler timeUpHandler, int sequence)
	{
		if (loop == 0)
		{
			loop = -1;
		}
		this.m_totalTime = time;
		this.m_loop = loop;
		this.m_timeUpHandler = timeUpHandler;
		this.m_sequence = sequence;
		this.m_currentTime = 0;
		this.m_isRunning = true;
		this.m_isFinished = false;
	}

	public void Update(int deltaTime)
	{
		if (m_isFinished || !m_isRunning)
		{
			return;
		}
		if (m_loop == 0)
		{
			m_isFinished = true;
		}
		else
		{
			m_currentTime += deltaTime;
			if (m_currentTime >= m_totalTime)
			{
				if (m_timeUpHandler != null)
				{
					m_timeUpHandler(this.m_sequence);
				}
				m_currentTime = 0;
				m_loop--;
			}
		}
	}

	public int GetLeftTime()
	{
		return m_totalTime - m_currentTime;
	}

	public void Finish()
	{
	    m_isFinished = true;
	}

	public bool IsFinished()
	{
		return m_isFinished;
	}

	public void Pause()
	{
		m_isRunning = false;
	}

	public void Resume()
	{
		m_isRunning = true;
	}

	public void Reset()
	{
		m_currentTime = 0;
	}

	public void ResetTotalTime(int totalTime)
	{
		if (m_totalTime == totalTime)
		{
			return;
		}
	    m_currentTime = 0;
		m_totalTime = totalTime;
	}

    public void ModifyTotalTime(int totalTime)
    {
        m_totalTime = totalTime;
    }



    public bool IsSequenceMatched(int sequence)
	{
		return m_sequence == sequence;
	}

	public bool IsDelegateMatched(Timer.OnTimeUpHandler timeUpHandler)
	{
		return m_timeUpHandler == timeUpHandler;
	}
}
