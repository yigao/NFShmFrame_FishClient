using System.Text;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextManager : Singleton<TextManager>
{
    private int m_offset = 0;

    private byte[] m_buffer;

    private Dictionary<string, string> m_textMap;


    public override void Init()
    {
        base.Init();
        Load();
    }

    public void Load()
    {
        BinaryObject content = ResourceManager.GetInstance().GetResource("Databin/Text.txt", typeof(TextAsset)).content as BinaryObject;

        TextAsset m_content =  Resources.Load("Databin/Text", typeof(TextAsset)) as TextAsset;

        LoadText(m_content.bytes);
    }

    public void LoadText(byte[] datas)
    {
        if (datas == null)
        {
            return;
        }

        m_offset = 0;
        m_buffer = datas;
        m_textMap = new Dictionary<string, string>();

        char[] separator = new char[] { '=' };

        while (m_buffer != null && m_offset < m_buffer.Length)
        {
            string line = ReadLine();
            if (line == null) break;
            if (line.StartsWith("//")) continue;

#if UNITY_FLASH
			string[] split = line.Split(separator, System.StringSplitOptions.RemoveEmptyEntries);
#else
            string[] split = line.Split(separator, 2, System.StringSplitOptions.RemoveEmptyEntries);
#endif

            if (split.Length == 2)
            {
                string key = split[0].Trim();
                string val = split[1].Trim().Replace("\\n", "\n");
                m_textMap[key] = val;
            }
        }
    }

    public string ReadLine() 
    { 
        return ReadLine(true);
    }

    public string ReadLine(bool skipEmptyLines)
    {
        int max = m_buffer.Length;

        // Skip empty characters
        if (skipEmptyLines)
        {
            while (m_offset < max && m_buffer[m_offset] < 32) ++m_offset;
        }

        int end = m_offset;

        if (end < max)
        {
            for (; ; )
            {
                if (end < max)
                {
                    int ch = m_buffer[end++];
                    if (ch != '\n' && ch != '\r') continue;
                }
                else ++end;

                string line = ReadLine(m_buffer, m_offset, end - m_offset - 1);
                m_offset = end;
                return line;
            }
        }
        m_offset = max;
        return null;
    }

    static string ReadLine(byte[] buffer, int start, int count)
    {
        return Encoding.UTF8.GetString(buffer, start, count);
    }

    public bool IsTextLoaded()
    {
        return m_textMap != null;
    }

    public string GetText(string key)
    {
        string text = string.Empty;
        m_textMap.TryGetValue(key, out text);
        if (string.IsNullOrEmpty(text))
        {
            text = key;
        }
        return text;
    }

    public string GetText(string key, params string[] args)
    {
        string text = Singleton<TextManager>.GetInstance().GetText(key);
        if (text == null)
        {
            text = "text with tag [" + key + "] was not found!";
        }
        else
        {
            text = string.Format(text, args);
        }
        return text;
    }
}
