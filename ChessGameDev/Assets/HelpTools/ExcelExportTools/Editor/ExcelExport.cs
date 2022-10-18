using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.HSSF.UserModel;
using System.IO;
using System.Data;
using System;

namespace Kengine.Tools
{
    public class ExcelExport
    {
        public static void ExcelToTxt()
        {
            foreach (var kvp in ReadExcels())
            {
                string outFilePath = kvp.Key + ".txt";
                DataTable table = kvp.Value;
                if (File.Exists(outFilePath)) File.Delete(outFilePath);
                
                string content = "";
                for (int j = 0; j < table.Rows.Count; j++)
                {
                    DataRow dr = table.Rows[j];
                    for (int i = 0; i < table.Columns.Count; i++)
                    {
                        if (dr[i] != null)
                        {
                            string str = i < table.Columns.Count - 1 ? "\t" : "";
                            content += dr[i] + str;
                        }
                        if (i == table.Columns.Count - 1 && j < table.Rows.Count - 1)
                        {
                            content += "\n";
                        }
                    }
                }
                FileWriteByCreate(content, outFilePath);
                AssetDatabase.Refresh();
            }
        }

        public static void ExcelToCsv()
        {
            foreach (var kvp in ReadExcels())
            {
                string outFilePath = kvp.Key + ".txt";
                DataTable table = kvp.Value;
                if (File.Exists(outFilePath)) File.Delete(outFilePath);

                string content = "";
                for (int j = 0; j < table.Rows.Count; j++)
                {
                    DataRow dr = table.Rows[j];
                    for (int i = 0; i < table.Columns.Count; i++)
                    {
                        if (dr[i] != null)
                        {
                            string str = i < table.Columns.Count - 1 ? "," : "";
                            content += dr[i] + str;
                        }
                        if (i == table.Columns.Count - 1 && j < table.Rows.Count - 1)
                        {
                            content += "\n";
                        }
                    }
                }
                FileWriteByCreate(content, outFilePath);
                AssetDatabase.Refresh();
            }
        }

        public static void ExcelToJson()
        {
            foreach (var kvp in ReadExcels())
            {
                string outFilePath = kvp.Key + ".json";
                DataTable table = kvp.Value;
                if (File.Exists(outFilePath)) File.Delete(outFilePath);

                string content = "[";
                for (int j = 2; j < table.Rows.Count; j++)
                {
                    DataRow fields = table.Rows[1];
                    DataRow dr = table.Rows[j];
                    content += "{\n";
                    for (int i = 0; i < table.Columns.Count; i++)
                    {
                        if (dr[i] == null) continue;

                        string strFormat = i < table.Columns.Count - 1 ? "," : "";
                        string field = fields[i].ToString();
                        string[] fieldSplits = field.Split('#');
                        if (fieldSplits.Length < 0)continue;

                        string value = dr[i].ToString();
                        string[] valueSplits = value.Split('|');
                        
                        if (valueSplits.Length > 1)
                        {
                            value = "[";
                            for (int k = 0; k < valueSplits.Length; k++)
                            {
                                if (fieldSplits[1] == "string")
                                {
                                    value += "@" + valueSplits[k] + "@";
                                }
                                else
                                {
                                    value += valueSplits[k];
                                }
                                if (k < valueSplits.Length - 1) value += ",";
                            }
                            value += "]";
                            content += "    @" + fieldSplits[0] + "@:" + value + strFormat + "\n";
                        }
                        else
                        {
                            if (fieldSplits[1] == "string")
                            {
                                content += "    @" + fieldSplits[0] + "@:@" + value + "@" + strFormat + "\n";
                            }
                            else
                            {
                                content += "    @" + fieldSplits[0] + "@:" + value + strFormat + "\n";
                            }
                        }
                    }
                    string str = j < table.Rows.Count - 1 ? ",\n" : "";
                    content += "}" + str;
                }
                content += "]";
                content = content.Replace('@', '"');
                FileWriteByCreate(content, outFilePath);
                AssetDatabase.Refresh();
            }
        }

        public static void ExcelToLua()
        {
            foreach (var kvp in ReadExcels())
            {
                string outFilePath = kvp.Key + ".lua";
                DataTable table = kvp.Value;
                if (File.Exists(outFilePath)) File.Delete(outFilePath);

                string content = Path.GetFileNameWithoutExtension(outFilePath) + " = {\n";
                for (int j = 2; j < table.Rows.Count; j++)
                {
                    DataRow fields = table.Rows[1];
                    DataRow dr = table.Rows[j];
                    content += "    [" + dr[0] + "] = ";
                    content += "{";
                    for (int i = 0; i < table.Columns.Count; i++)
                    {
                        if (dr[i] == null) continue;
                        string strFormat = i < table.Columns.Count - 1 ? "," : "";
                        string field = fields[i].ToString();
                        string[] fieldSplits = field.Split('#');
                        if (fieldSplits.Length < 0) continue;

                        string value = dr[i].ToString();
                        string[] valueSplits = value.Split('|');
                        if (valueSplits.Length > 1)
                        {
                            value = "{";
                            for (int k = 0; k < valueSplits.Length; k++)
                            {
                                if (fieldSplits[1] == "string")
                                {
                                    value += "@" + valueSplits[k] + "@";
                                }
                                else
                                {
                                    value += valueSplits[k];
                                }
                                if (k < valueSplits.Length - 1) value += ",";
                            }
                            value += "}";
                            content += fieldSplits[0] + " = " + value + strFormat;
                        }
                        else
                        {
                            if (fieldSplits[1] == "string")
                            {
                                content += fieldSplits[0] + " = @" + value + "@" + strFormat;
                            }
                            else
                            {
                                content += fieldSplits[0] + " = " + value + strFormat;
                            }
                        }
                    }
                    string str = j < table.Rows.Count - 1 ? ",\n" : "";
                    content += "}" + str;
                }
                content += "\n}";
                content = content.Replace('@', '"');
                FileWriteByCreate(content, outFilePath);
                AssetDatabase.Refresh();
            }
        }

        /// <summary>
        /// 文件写入
        /// </summary>
        /// <param name="content"></param>
        /// <param name="outFilePath"></param>
        private static void FileWriteByCreate(string content, string outFilePath)
        {
            FileStream fs = new FileStream(outFilePath, FileMode.Create);
            StreamWriter sw = new StreamWriter(fs);
            sw.Write(content);
            sw.Flush();
            sw.Close();
            fs.Close();
        }

        /// <summary>
        /// 读取excel表
        /// </summary>
        /// <returns></returns>
        private static Dictionary<string, DataTable> ReadExcels()
        {
            UnityEngine.Object[] selects = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
            if (selects.Length < 0)
            {
                Debug.LogError("Please select somthing");
                return null;
            }

            Clear();

            Dictionary<string, DataTable> dict = new Dictionary<string, DataTable>();
            for (int i = 0; i < selects.Length; i++)
            {
                string oriPath = AssetDatabase.GetAssetPath(selects[i]);
                if (oriPath.EndsWith(".xlsx") || oriPath.EndsWith(".xls"))
                {
                    string key = oriPath.Substring(0, oriPath.Length - Path.GetExtension(oriPath).Length);
                    dict.Add(key, GetDataTable(oriPath));
                }
            }
            return dict;
        }

        public static void Clear()
        {
            UnityEngine.Object[] selects = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.DeepAssets);
            if (selects.Length < 0)
            {
                Debug.LogError("Please select somthing");
                return;
            }
            
            for (int i = 0; i < selects.Length; i++)
            {
                string oriPath = AssetDatabase.GetAssetPath(selects[i]);
                if (oriPath.EndsWith(".xlsx") || oriPath.EndsWith(".xls")) continue;
                if (Path.HasExtension(oriPath))
                {
                    File.Delete(oriPath);
                }
            }
            AssetDatabase.Refresh();
        }

        private static DataTable GetDataTable(string fliePath)
        {
            IWorkbook workbook = null;
            ISheet sheet;
            DataTable data = new DataTable();
            FileStream fs = new FileStream(fliePath, FileMode.Open, FileAccess.Read);

            if (Path.GetExtension(fliePath) == ".xlsx")
            {
                workbook = new XSSFWorkbook(fs);
            }
            else 
            {
                workbook = new HSSFWorkbook(fs);
            }

            sheet = workbook.GetSheetAt(0);

            if (sheet != null)
            {
                IRow row;
                DataRow dataRow;
                int colMax = 0;
                for (int i = 0; i <= sheet.LastRowNum; i++)
                {
                    row = sheet.GetRow(i);
                    if (row.LastCellNum > colMax)
                    {
                        colMax = row.LastCellNum;
                    }
                }
                for (int i = 0; i < colMax; i++)
                {
                    data.Columns.Add(new DataColumn());
                }
                for (int i = 0; i <= sheet.LastRowNum; i++)
                {
                    row = sheet.GetRow(i);   //row读入第i行数据
                    if (row != null)
                    {
                        dataRow = data.NewRow();
                        for (int j = 0; j < row.LastCellNum; j++)  //对工作表每一列
                        {
                            ICell cell = row.GetCell(j);
                            string cellValue = cell == null ? "" : cell.ToString(); //获取i行j列数据
                            dataRow[j] = cellValue;
                        }
                        data.Rows.Add(dataRow);
                    }
                }
            }
            fs.Close();
            return data;
        }
    }
}
