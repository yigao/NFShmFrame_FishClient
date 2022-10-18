using UnityEngine;
using System.Collections;

public static class StringExtension
{
    public static int JavaHashCode(this string s)
    {
        int num = 0;
        int length = s.Length;
        if (length > 0)
        {
            int num2 = 0;
            for (int i = 0; i < length; i++)
            {
                char c = s[num2++];
                num = 31 * num + (int)c;
            }
        }
        return num;
    }

    public static int JavaHashCodeIgnoreCase(this string s)
    {
        int num = 0;
        int length = s.Length;
        if (length > 0)
        {
            int num2 = 0;
            for (int i = 0; i < length; i++)
            {
                char c = s[num2++];
                if (c >= 'A' && c <= 'Z')
                {
                    c += ' ';
                }
                num = 31 * num + (int)c;
            }
        }
        return num;
    }
}
