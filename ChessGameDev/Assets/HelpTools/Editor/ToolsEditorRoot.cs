using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Kengine.Tools
{
    public class ToolsEditorRoot
    {
        [MenuItem("Tools/1.Excel工具/使用说明：选中Excel文件目录", false, 101)]
        [MenuItem("Tools/1.Excel工具/Excel To Txt", false, 121)]
        public static void ExcelToTxt()
        {
            ExcelExport.ExcelToTxt();
        }

        [MenuItem("Tools/1.Excel工具/Excel To Csv", false, 122)]
        public static void ExcelToCsv()
        {
            ExcelExport.ExcelToCsv();
        }

        [MenuItem("Tools/1.Excel工具/Excel To Json", false, 123)]
        public static void ExcelToJson()
        {
            ExcelExport.ExcelToJson();
        }

        [MenuItem("Tools/1.Excel工具/Excel To Lua", false, 124)]
        public static void ExcelToLua()
        {
            ExcelExport.ExcelToLua();
        }

        [MenuItem("Tools/1.Excel工具/Clear Excel Config", false, 141)]
        public static void ClearExcelConfig()
        {
            ExcelExport.Clear();
        }
    }
}