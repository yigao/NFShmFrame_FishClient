using System;

public class GameStateCtrl : Singleton<GameStateCtrl> 
{
    private StateMachine m_gameState = new StateMachine();

    public string CurrentStateName
    {
        get
        {
            IState currentState = GetCurrentState();
            return (currentState == null) ? "unkown state" : currentState.name;
        }
    }

    public void Initialize()
    {
        m_gameState.RegisterStateByAttributes<GameStateAttribute>(typeof(GameStateAttribute).Assembly);    
    }

    public void Uninitialize()
    {
        m_gameState.Clear();
        m_gameState = null;
    }

    public void GotoState(string name)
    {
        m_gameState.ChangeState(name);
    }

    public IState GetCurrentState()
    {
        return m_gameState.TopState();
    }
}
