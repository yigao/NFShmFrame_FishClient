using System;
using System.Collections.Generic;
using System.Reflection;

public class StateMachine 
{
    private Dictionary<string, IState> m_registedState = new Dictionary<string, IState>();

    private Stack<IState> m_stateStack = new Stack<IState>();

    public IState tarState
    {
        get;
        private set;
    }

    public int Count
    {
        get
        {
            return m_stateStack.Count;
        }
    }
    
    public void RegisterState(string name, IState state)
    {
        if (name == null || state == null)
        {
            return;
        }

        if (m_registedState.ContainsKey(name))
        {
            return;
        }
        m_registedState.Add(name,state);
    }

    public ClassEnumerator RegisterStateByAttributes<TAttributeType>(Assembly inAssembly, params object[] args) where TAttributeType : AutoRegisterAttribute
    {
        ClassEnumerator classEnumerator = new ClassEnumerator(typeof(TAttributeType), typeof(IState), inAssembly, true, false, false);
        List<Type>.Enumerator enumerator = classEnumerator.results.GetEnumerator();
        while (enumerator.MoveNext())
        {
            Type current = enumerator.Current;
            IState state = (IState)Activator.CreateInstance(current, args);
            RegisterState<IState>(state, state.name);
        }
        return classEnumerator;
    }

    public ClassEnumerator RegisterStateByAttributes<TAttributeType>(Assembly inAssembly) where TAttributeType : AutoRegisterAttribute
    {
        ClassEnumerator classEnumerator = new ClassEnumerator(typeof(TAttributeType), typeof(IState), inAssembly, true, false, false);
        List<Type>.Enumerator enumerator = classEnumerator.results.GetEnumerator();
        while (enumerator.MoveNext())
        {
            Type current = enumerator.Current;
            IState state = (IState)Activator.CreateInstance(current);
            RegisterState<IState>(state, state.name);

        }
        return classEnumerator;
    }

    public void RegisterState<TStateImplType>(TStateImplType state, string name) where TStateImplType : IState
    {
        RegisterState(name,state);
    }

    public IState UnregisterState(string name)
    {
        if (name == null)
        {
            return null;
        }
        IState result;
        if (!m_registedState.TryGetValue(name, out result))
        {
            return null;
        }
        m_registedState.Remove(name);
        return result;
    }

    public IState GetState(string name)
    {
        if (name == null)
        {
            return null;
        }
        IState state;
        IState state3;
        if (m_registedState.TryGetValue(name, out state))
        {
            IState state2 = state;
            state3 = state2;
        }
        else
        {
            state3 = null;
        }
        return state3;
    }

    public string GetStateName(IState state)
    {
        if (state == null)
        {
            return null;
        }
        Dictionary<string, IState>.Enumerator enumerator = m_registedState.GetEnumerator();
        while (enumerator.MoveNext())
        {
            KeyValuePair<string, IState> current = enumerator.Current;
            if (current.Value == state)
            {
                return current.Key;
            }
        }
        return null;
    }

    public void Push(IState state)
    {
        if (state == null)
        {
            return;
        }
        if (m_stateStack.Count > 0)
        {
            m_stateStack.Peek().OnStateOverride();
        }
        m_stateStack.Push(state);
        state.OnStateEnter();
    }

    public void Push(string name)
    {
        if (name == null)
        {
            return;
        }
        IState state;
        if (!m_registedState.TryGetValue(name, out state))
        {
            return;
        }
        Push(state);
    }

    public IState PopState()
    {
        if (m_stateStack.Count <= 0)
        {
            return null;
        }
        IState state = m_stateStack.Pop();
        state.OnStateLeave();
        if (m_stateStack.Count > 0)
        {
            m_stateStack.Peek().OnStateResume();
        }
        return state;
    }

    public IState ChangeState(IState state)
    {
        if (state == null)
        {
            return null;
        }

        tarState = state;
        IState state2 = null;
        if (m_stateStack.Count > 0)
        {
            state2 = m_stateStack.Pop();
            state2.OnStateLeave();
        }
        m_stateStack.Push(state);
        state.OnStateEnter();
        return state2;
    }

    public IState ChangeState(string name)
    {
        if (name == null)
        {
            return null;
        }

        IState state;
        if (!m_registedState.TryGetValue(name, out state))
        {
            return null;
        }
        return ChangeState(state);
    }

    public IState TopState()
    {
        if (m_stateStack.Count <= 0)
        {
            return null;
        }
        return m_stateStack.Peek();
    }

    public string TopStateName()
    {
        if (m_stateStack.Count <= 0)
        {
            return null;
        }
        IState state = m_stateStack.Peek();
        return GetStateName(state);
    }

    public void Clear()
    {
        while (m_stateStack.Count > 0)
        {
            m_stateStack.Pop().OnStateLeave();
        }
    }
}
