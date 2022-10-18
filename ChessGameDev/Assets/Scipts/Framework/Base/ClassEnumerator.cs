using System;
using System.Reflection;
using UnityEngine;
using System.Collections.Generic;

public class ClassEnumerator 
{
    protected List<Type> m_results = new List<Type>();

    private Type m_attributeType;

    private Type m_interfaceType;

    public List<Type> results
    {
        get
        {
            return m_results;
        }
    }

    public ClassEnumerator(Type inAttributeType, Type inInterfaceType, Assembly inAssembly, bool bIgnoreAbstract = true, bool bInheritAttribute = false, bool bShouldCrossAssembly = false)
    {
        m_attributeType = inAttributeType;
        m_interfaceType = inInterfaceType;
        try
        {
            if (bShouldCrossAssembly)
            {
                Assembly[] assemblies = AppDomain.CurrentDomain.GetAssemblies();
                if (assemblies != null)
                {
                    for (int i = 0; i < assemblies.Length; ++i)
                    {
                        Assembly tInAssembly = assemblies[i];
                        CheckInAssembly(tInAssembly, bIgnoreAbstract, bInheritAttribute);
                    }
                }
            }
            else
            {
                CheckInAssembly(inAssembly, bIgnoreAbstract, bInheritAttribute);
            }
        }
        catch(Exception ex)
        {
            Debug.LogError("Error in enumerate classes :" + ex.Message);
        }
    }

    protected void CheckInAssembly(Assembly inAssembly, bool bInIgnoreAbstract, bool bInInheritAttribute)
    {
        Type[] types = inAssembly.GetTypes();
        if (types != null)
        {
            for (int i = 0; i < types.Length; ++i)
            {
                Type type = types[i];
                if ((m_interfaceType == null || m_interfaceType.IsAssignableFrom(type)) && (!bInIgnoreAbstract || (bInIgnoreAbstract && !type.IsAbstract)) && type.GetCustomAttributes(m_attributeType, bInInheritAttribute).Length > 0)
                {
                    m_results.Add(type);
                }
            }
        }
    }
}
