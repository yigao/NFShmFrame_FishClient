using System;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.UI;

public class UIUtility 
{
    public static string s_ui_defaultShaderName = "Sprites/Default";

    public static Color s_Color_White = new Color(1f, 1f, 1f);

    public static Color s_Color_Grey = new Color(0.3137255f, 0.3137255f, 0.3137255f);

    public static string[] s_materianlParsKey = new string[]
	{
		"_StencilComp",
		"_Stencil",
		"_StencilOp",
		"_StencilWriteMask",
		"_StencilReadMask",
		"_ColorMask"
	};

    public static void SetGameObjectLayer(GameObject gameObject, int layer)
    {
        gameObject.layer = layer;
        for (int i = 0; i < gameObject.transform.childCount; ++i)
        {
            UIUtility.SetGameObjectLayer(gameObject.transform.GetChild(i).gameObject, layer);
        }
    }

    public static void GetComponentsInChildren<T>(GameObject go, T[] components, ref int count) where T : Component
    {
        T component = go.GetComponent<T>();
        if (component != null)
        {
            components[count] = component;
            count++;
        }
        for (int i = 0; i < go.transform.childCount; i++)
        {
            UIUtility.GetComponentsInChildren<T>(go.transform.GetChild(i).gameObject, components, ref count);
        }
    }

    public static string StringReplace(string scrStr, params string[] values)
    {
        return string.Format(scrStr, values);
    }

    public static Vector3 ScreenToWorldPoint(Camera camera, Vector2 screenPoint, float z)
    {
        return (!(camera == null)) ? camera.ViewportToWorldPoint(new Vector3(screenPoint.x / (float)Screen.width, screenPoint.y / (float)Screen.height, z)) : new Vector3(screenPoint.x, screenPoint.y, z);
    }

    public static Vector2 WorldToScreenPoint(Camera camera, Vector3 worldPoint)
    {
        return (!(camera == null)) ? (Vector2)camera.WorldToScreenPoint(worldPoint) : new Vector2(worldPoint.x, worldPoint.y);
    }

    public static float ValueInRange(float value, float min, float max)
    {
        if (value < min)
        {
            return min;
        }
        if (value > max)
        {
            return max;
        }
        return value;    
    }

    public static void ResetUIScale(GameObject target)
    {
        Vector3 localScale = target.transform.localScale;
        Transform parent = target.transform.parent;
        target.transform.SetParent(null);
        target.transform.localScale = localScale;
        target.transform.SetParent(parent);
    }

    public static float[] GetMaterailMaskPars(Material tarMat)
    {
        float[] array = new float[UIUtility.s_materianlParsKey.Length];
        for (int i = 0; i < UIUtility.s_materianlParsKey.Length; i++)
        {
            array[i] = tarMat.GetFloat(UIUtility.s_materianlParsKey[i]);
        }
        return array;
    }

    public static void SetMaterailMaskPars(float[] pars, Material tarMat)
    {
        for (int i = 0; i < UIUtility.s_materianlParsKey.Length; i++)
        {
            tarMat.SetFloat(UIUtility.s_materianlParsKey[i], pars[i]);
        }
    }

    public static void SetImageSprite(Image image, GameObject prefab, bool isShowSpecMatrial = false)
    {
        if (image == null)
        {
            return;
        }
        if (prefab == null)
        {
            image.sprite = null;
            return;
        }
        SpriteRenderer component = prefab.GetComponent<SpriteRenderer>();
        if (component != null)
        {
            image.sprite = component.sprite;
            isShowSpecMatrial = false;
            if (isShowSpecMatrial && component.sharedMaterial != null && component.sharedMaterial.shader != null && !component.sharedMaterial.shader.name.Equals(UIUtility.s_ui_defaultShaderName))
            {
                float[] materailMaskPars = UIUtility.GetMaterailMaskPars(image.material);
                image.material = component.sharedMaterial;
                image.material.shaderKeywords = component.sharedMaterial.shaderKeywords;
                UIUtility.SetMaterailMaskPars(materailMaskPars, image.material);
            }
            else if (isShowSpecMatrial)
            {
                image.material = null;
            }
        }
    }

    
    public static void SetImageGrey(Graphic graphic, bool isSetGrey)
    {
        UIUtility.SetImageGrey(graphic, isSetGrey, Color.white);
    }

    private static void SetImageGrey(Graphic graphic, bool isSetGrey, Color defaultColor)
    {
        if (graphic != null)
        {
            graphic.color = ((!isSetGrey) ? defaultColor : UIUtility.s_Color_Grey);
        }
    }

    public static void SetImageGrayMatrial(Image image)
    {

    }

    public static UIFormScript GetFormScript(Transform transform)
    {
        if (transform == null)
        {
            return null;
        }
        UIFormScript component = transform.gameObject.GetComponent<UIFormScript>();
        if (component != null)
        {
            return component;
        }
        return UIUtility.GetFormScript(transform.parent);
    }
}
