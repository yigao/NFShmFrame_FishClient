using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class PoissonDiskSample
{
    public static List<Vector3> GetCoinCoordinate(float width, float height, float radius,Transform trans,float yOffset = 0, bool isInitRand = true)
    {
        List<Vector3> bornPosList = new List<Vector3>();
        List<Vector3> vectorList = SampleVector(width, height, radius, isInitRand);
        Vector3 tempPos = Vector3.zero;
        for (int i = 0; i < vectorList.Count; ++i)
        {
            tempPos = trans.localPosition + vectorList[i] + new Vector3(0, yOffset,0) - (new Vector3(width * 0.5f, height * 0.5f, 0));
            bornPosList.Add(tempPos); //trans.parent.TransformPoint(tempPos)
        }
        return bornPosList;
    }

    public static List<Vector3> SampleVector(float width, float height, float radius, bool isInitRand, int k = 30)
    {
        int n = 2;
        float cellSize = radius / Mathf.Sqrt(n);

        int cols = Mathf.CeilToInt(width / cellSize);
        int rows = Mathf.CeilToInt(height / cellSize);

        List<Vector3> cells = new List<Vector3>();
        int[,] grids = new int[rows, cols];
        for (int i = 0; i < rows; ++i)
        {
            for (int j = 0; j < cols; ++j)
            {
                grids[i, j] = -1;
            }
        }

        Vector2 x0 = Vector2.zero;
        int col = 0;
        int row = 0;
        if (isInitRand)
        {
            x0 = new Vector2(UnityEngine.Random.Range(0, width), UnityEngine.Random.Range(0, height));
            col = (int)Mathf.Floor(x0.x / cellSize);
            row = (int)Mathf.Floor(x0.y / cellSize);
        }
        else
        {
            x0 = new Vector2(width * 0.5f, height * 0.5f);
            col = (int)Mathf.Floor(x0.x / cellSize);
            row = (int)Mathf.Floor(x0.y / cellSize);
        }

        int x0_idx = cells.Count;
        cells.Add(x0);
        grids[row, col] = x0_idx;

        List<int> active_list = new List<int>();
        active_list.Add(x0_idx);

        while (active_list.Count > 0)
        {
            int xi_idx = active_list[UnityEngine.Random.Range(0, active_list.Count)];
            Vector3 xi = cells[xi_idx];
            bool found = false;

            for (int i = 0; i < k; ++i)
            {
                Vector2 dir = UnityEngine.Random.insideUnitCircle;
                Vector2 tempCircle = (dir.normalized * radius + dir * radius);
                Vector3 xk = xi + new Vector3(tempCircle.x, tempCircle.y, 0);
                if (xk.x < 0 || xk.x >= width || xk.y < 0 || xk.y >= height)
                {
                    continue;
                }

                col = (int)Mathf.Floor(xk.x / cellSize);
                row = (int)Mathf.Floor(xk.y / cellSize);
                if (grids[row, col] != -1)
                {
                    continue;
                }

                bool ok = true;
                int min_r = (int)Mathf.Floor((xk.y - radius) / cellSize);
                int max_r = (int)Mathf.Floor((xk.y + radius) / cellSize);
                int min_c = (int)Mathf.Floor((xk.x - radius) / cellSize);
                int max_c = (int)Mathf.Floor((xk.x + radius) / cellSize);

                for (int or = min_r; or <= max_r; ++or)
                {
                    if (or < 0 || or >= rows)
                    {
                        continue;
                    }
                    bool flag = false;

                    for (int oc = min_c; oc <= max_c; ++oc)
                    {
                        if (oc < 0 || oc >= cols)
                        {
                            continue;
                        }

                        int xj_idx = grids[or, oc];
                        if (xj_idx != -1)
                        {
                            Vector3 xj = cells[xj_idx];
                            float dist = (xj - xk).magnitude;
                            if (dist < radius)
                            {
                                ok = false;
                                flag = true;
                                break;
                            }
                        }
                    }
                    if (flag) break;
                }
                if (ok)
                {
                    int xk_idx = cells.Count;
                    cells.Add(xk);

                    grids[row, col] = xk_idx;
                    active_list.Add(xk_idx);

                    found = true;
                    break;
                }
            }
            if (!found)
            {
                active_list.Remove(xi_idx);
            }
        }
        return cells;
    }
}



