using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using XLua;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class FishLuaBehaviour : BaseLuaBehaviour, IPointerDownHandler, IPointerUpHandler//, IPointerClickHandler
{
    public enum ObjType
    {
        None,
        Fish,
        Bullet,
    }

    public enum FishStatus
    {
        Born,
        Move,
        Pause,
        Stop,
    }

    public int Smooth = 4;


    public Action<Collider> onTriggerCallBack;
    public Action onUpdate;
    public Action<bool> onPressCallBack;
    public LuaTable m_luaTable;

    public Transform m_targetTrans;

    private ObjType m_objType = ObjType.None;

    [HideInInspector][System.NonSerialized]public FishStatus curFishStatus = FishStatus.Born;

    private Vector3 m_orientation;

    [HideInInspector][System.NonSerialized]public Vector3 m_direction;

    private float m_delayBornTime = 0.0f;

    private float m_moveSpeed;

    private float m_rotationSpeed;

    private bool m_isFishSeen;

    private bool m_isFishOutBounds;

    private int m_fishPointIndex;

    private int currentFishPointIndex = 0;

    [HideInInspector]
    public int fishPointSmooth = 10;

    private float m_fishTimeElapse;

    private TraceHeader m_fishTraceHeader;

    private float m_timeInterval;

    private GameObject targetFish;

    private List<TracePoint> m_fishTracePoints;

    private Animator[] m_animators;

    private float m_fishWidth;

    private float m_limitWidth;

    private float m_limitHeight;

    private bool m_changeFishScene;

    private Vector3 currentTraceOffset = Vector3.zero;

    private int m_traceNumber;

    private Text m_debugText;

    private float m_debugTextDelayTime = 0;

    private Vector3 offsetFishZValue = Vector3.zero;

    int GroupId = 0;

    [HideInInspector] [System.NonSerialized] public int RotationIndexInterval = 4;
    [HideInInspector]  public int MoveIndexInterval = 1;

    [HideInInspector]
    [System.NonSerialized]
    public GameObject CachedGo;

    [HideInInspector]
    [System.NonSerialized]
    public Transform CachedTrans;


    [HideInInspector]
    [System.NonSerialized]
    public float ResolutionWidthHalf;

    [HideInInspector]
    [System.NonSerialized]
    public float ResolutionHeightHalf;

    [HideInInspector]
    public bool is3DFishRotation = false;

    [HideInInspector]
    public Transform childRotationPoint = null;

    bool isTilt = false;

    protected override void Awake()
    {
        CachedGo = gameObject;
        CachedTrans = transform;

        //Transform debugText = transform.Find("Debug");
        //if (debugText != null)
        //{
        //    debugText.gameObject.SetActive(true);
        //    m_debugText = debugText.GetComponent<Text>();
        //    m_debugText.text = "";
        //}
    }

    protected void OnTriggerEnter(Collider other)
    {
        if (onTriggerCallBack != null)
        {
            onTriggerCallBack(other);
        }
    }



    protected void Update()
    {
        if (onUpdate != null)
        {
            onUpdate();
        }
        
        if (m_objType == ObjType.Fish)
        {
            if (curFishStatus == FishStatus.Born)
            {
                m_delayBornTime -= Time.deltaTime;
                if (m_delayBornTime <= 0)
                {
                    m_delayBornTime = 0.0f;
                    CachedTrans.localPosition = m_fishTracePoints[m_fishPointIndex].pos + currentTraceOffset;
                    curFishStatus = FishStatus.Move;
                }
            }
            else if(curFishStatus == FishStatus.Move)
            {
                if (m_fishPointIndex >= m_fishTracePoints.Count)
                {
                    m_luaTable.Set<string, bool>("isCanDestroy", true);
                    return;
                }

                if (FishManager.m_Fish3D)
                    Fish3DMoving(Time.deltaTime);
                else
                    FishMoving(Time.deltaTime);

                //if (m_debugText != null)
                //{
                //    m_debugText.transform.localEulerAngles = new Vector3(0, 0, transform.localEulerAngles.z * -1);
                //}

                if (m_isFishSeen != CheckBoundValid())
                {
                    m_isFishSeen = !m_isFishSeen;

                    m_luaTable.Set<string, bool>("isCanSeen", m_isFishSeen);
                }
            }
        }
        else if (m_objType == ObjType.Bullet)
        {
            if (curFishStatus == FishStatus.Move)
            {
                BulletMoving();
            }
        }
    }


    public void OnPointerDown(PointerEventData eventData)
    {
        if (onPressCallBack != null)
        {
            onPressCallBack(true);
        }
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        if (onPressCallBack != null)
        {
            onPressCallBack(false);
        }
    }


    public Transform label;
    public void FishBeginMove(int traceNumber, float traceOffsetPosX, float traceOffsetPosY, float fishWidth, float fishHeight, int pointIndex = 0,int delayBornTime =0,int usGroupId=0,float fishZ=0)
    {
        
        m_fishWidth = fishWidth;
        offsetFishZValue.z = fishZ;
        m_delayBornTime = delayBornTime * 0.001f;
        m_debugTextDelayTime = m_delayBornTime;
        GroupId = usGroupId;
        curFishStatus = delayBornTime > 0 ? FishStatus.Born : FishStatus.Move;

        m_objType = ObjType.Fish;

        MoveIndexInterval = 1;

        ResolutionWidthHalf = FishManager.curResolutionWidth * 0.5f;

        ResolutionHeightHalf = FishManager.curResolutionHeight * 0.5f;

        m_limitWidth = ResolutionWidthHalf + m_fishWidth;

        m_limitHeight = ResolutionHeightHalf + fishHeight;

        m_animators = null;

        m_fishPointIndex = pointIndex;

        m_fishTracePoints = null;

        m_traceNumber = traceNumber;

        if (!FishManager.tracePointMap.TryGetValue(traceNumber, out m_fishTracePoints))
        {
            Log.Error("trace file is not  exit :" + traceNumber);
        }

        if (!FishManager.headerMap.TryGetValue(traceNumber, out m_fishTraceHeader))
        {
            Log.Error("trace file is not  exit :" + traceNumber);
        }


        Vector3 tempV = m_fishTracePoints[m_fishPointIndex].pos;
   
        currentTraceOffset = FishManager.RealPointToScreenPoint(tempV.x, tempV.y);
        currentTraceOffset.x = currentTraceOffset.x + traceOffsetPosX;
        currentTraceOffset.y = currentTraceOffset.y + traceOffsetPosY;
        currentTraceOffset = FishManager.ScreenPointToRealPoint(currentTraceOffset.x, currentTraceOffset.y);
        currentTraceOffset = currentTraceOffset - tempV;

        m_timeInterval = m_fishTraceHeader.timeInterval;
        if (Time.deltaTime > m_timeInterval)
        {
            int offset = ((int)(Time.deltaTime / m_timeInterval)) + 1;

            m_fishPointIndex += offset;

        }

        if (m_fishPointIndex < m_fishTracePoints.Count && m_fishPointIndex >= 0)
        {
            CachedTrans.localPosition = m_fishTracePoints[m_fishPointIndex].pos+currentTraceOffset;
        }
        else
        {
            CachedGo.SetActive(false);
            CachedTrans.localPosition = m_fishTracePoints[m_fishTracePoints.Count - 1].pos+currentTraceOffset;
        }

        if (curFishStatus == FishStatus.Born)
        {
            CachedTrans.localPosition = new Vector3(10000, 10000, 0);
        }

        //if (m_debugText != null)
        //{
        //    m_debugText.text = GroupId.ToString(); //(Time.realtimeSinceStartup - FishManager.gameElapseTime).ToString("f2") + "\n" + m_debugTextDelayTime.ToString("f2") + "\n" + m_traceNumber.ToString();
        //}
        SetFishMoveData();

        CachedTrans.rotation = Quaternion.FromToRotation(Vector3.right, m_orientation);

        m_isFishSeen = CheckBoundValid();

        m_luaTable.Set<string, bool>("isCanSeen", m_isFishSeen);

        m_isFishOutBounds = true;

    }

    
    public void SetFishMoveData()
    {
        if (m_fishTracePoints == null || m_fishTracePoints.Count == 0) return;

        if (m_fishPointIndex >= (m_fishTracePoints.Count - 1) || m_fishPointIndex < 0)
        {
            curFishStatus = FishStatus.Stop;
            m_luaTable.Set<string, bool>("isCanDestroy", true);

            return;
        }

        Vector3 newVector = Vector3.zero;

        if ((m_fishPointIndex + MoveIndexInterval) < m_fishTracePoints.Count)
        {
            newVector = (m_fishTracePoints[m_fishPointIndex + MoveIndexInterval].pos+ currentTraceOffset)+ offsetFishZValue - CachedTrans.localPosition;
        }
        else
        {
            newVector = (m_fishTracePoints[m_fishTracePoints.Count - 1].pos+ currentTraceOffset)+ offsetFishZValue - CachedTrans.localPosition;
        }

        if (m_fishTraceHeader.type == 0)
        {
            if ((m_fishPointIndex + RotationIndexInterval) < m_fishTracePoints.Count)
            {
                m_orientation = ((m_fishTracePoints[(m_fishPointIndex + RotationIndexInterval)].pos+ currentTraceOffset) + offsetFishZValue - CachedTrans.localPosition).normalized; 
            }
            else
            {
                m_orientation = ((m_fishTracePoints[m_fishTracePoints.Count - 1].pos+ currentTraceOffset) + offsetFishZValue - CachedTrans.localPosition).normalized; 
            }
            m_direction = newVector.normalized;

            m_moveSpeed = newVector.magnitude / m_timeInterval;
        }
        else
        {
            if ((((int)(m_fishTracePoints[m_fishPointIndex].oriented.x * 0.0001)) == 99999) && (((int)(m_fishTracePoints[m_fishPointIndex].oriented.y * 0.0001)) == 99999))
            {
               
                if ((m_fishPointIndex + RotationIndexInterval) < m_fishTracePoints.Count)
                {
                    m_orientation = ((m_fishTracePoints[(m_fishPointIndex + RotationIndexInterval)].pos+ currentTraceOffset) - CachedTrans.localPosition).normalized;
                }
                else
                {
                    m_orientation = ((m_fishTracePoints[m_fishTracePoints.Count - 1].pos+ currentTraceOffset) - CachedTrans.localPosition).normalized;
                }
                m_direction = newVector.normalized;
                m_moveSpeed = newVector.magnitude / m_timeInterval;
            }
            else
            {
                m_moveSpeed = newVector.magnitude / m_timeInterval;
                m_direction = newVector.normalized;
                m_orientation = (m_fishTracePoints[m_fishPointIndex].oriented - CachedTrans.localPosition).normalized;
            }
        }

        m_fishPointIndex += MoveIndexInterval;

        currentFishPointIndex = m_fishPointIndex + fishPointSmooth;

        m_fishTimeElapse = m_timeInterval;
        
    }

    public void AnimatorsEnableStatus()
    {
        for (int i = 0; i < m_animators.Length; ++i)
        {
            m_animators[i].enabled = !m_isFishOutBounds;
        }

    }

    public void FishMoving(float deltaTime)
    {

        if (m_fishTimeElapse >= deltaTime)
        {
            m_fishTimeElapse -= deltaTime;

            Vector3 currentMoveDirection = Vector3.Lerp(CachedTrans.TransformDirection(Vector3.right), m_orientation, deltaTime * Smooth);

            Vector3 orientaDirect = new Vector3(0.0f, 0.0f, GetFishRotateAngle(currentMoveDirection));

            CachedTrans.localEulerAngles = orientaDirect;

            CachedTrans.localPosition += m_direction * Time.deltaTime * m_moveSpeed;
        }
        else
        {
            Vector3 currentMoveDirection = Vector3.Lerp(CachedTrans.TransformDirection(Vector3.right), m_orientation, deltaTime * Smooth);

            Vector3 orientaDirect = new Vector3(0.0f, 0.0f, GetFishRotateAngle(currentMoveDirection));

            CachedTrans.localEulerAngles = orientaDirect;

            float timeTemp = m_fishTimeElapse;

            CachedTrans.localPosition += m_direction * Time.deltaTime * m_moveSpeed * timeTemp / deltaTime; 

            SetFishMoveData();

            CachedTrans.localPosition += m_direction * Time.deltaTime * m_moveSpeed * (deltaTime - timeTemp) / deltaTime;

            m_fishTimeElapse -= Math.Abs(deltaTime - timeTemp);

            return;
        }
    }

    public void Fish3DMoving(float deltaTime)
    {
        Vector3 tempV = Vector3.zero;
        if (m_fishTimeElapse >= deltaTime)
        {
            m_fishTimeElapse -= deltaTime;

            //if (currentFishPointIndex <= m_fishTracePoints.Count - 1)

            //    CachedTrans.forward = (m_fishTracePoints[currentFishPointIndex].pos + offsetFishZValue - CachedTrans.localPosition).normalized;
            //else
            //    CachedTrans.forward = (m_fishTracePoints[m_fishPointIndex].pos + offsetFishZValue - CachedTrans.localPosition).normalized;
            if(currentFishPointIndex <= m_fishTracePoints.Count - 1)
            {
                tempV = (m_fishTracePoints[currentFishPointIndex].pos + offsetFishZValue - CachedTrans.localPosition).normalized;
                CachedTrans.forward = new Vector3(tempV.x, tempV.y, 0);
            }
            else
            {
                tempV = (m_fishTracePoints[m_fishPointIndex].pos + offsetFishZValue - CachedTrans.localPosition).normalized;
                CachedTrans.forward = new Vector3(tempV.x, tempV.y, 0);
            }

            CachedTrans.localPosition += m_direction * Time.deltaTime * m_moveSpeed;
        }
        else
        {
            if (currentFishPointIndex <= m_fishTracePoints.Count - 1)
            {
                tempV = (m_fishTracePoints[currentFishPointIndex].pos + offsetFishZValue - CachedTrans.localPosition).normalized;
                CachedTrans.forward = new Vector3(tempV.x, tempV.y, 0);
            }
            else
            {
                tempV= (m_fishTracePoints[m_fishPointIndex].pos + offsetFishZValue - CachedTrans.localPosition).normalized;
                CachedTrans.forward = new Vector3(tempV.x, tempV.y, 0);
            }
               

            float timeTemp = m_fishTimeElapse;
           
            CachedTrans.localPosition += m_direction * Time.deltaTime * m_moveSpeed * timeTemp / deltaTime;

            SetFishMoveData();

            CachedTrans.localPosition += m_direction * Time.deltaTime * m_moveSpeed * (deltaTime - timeTemp) / deltaTime;

            m_fishTimeElapse -= Math.Abs(deltaTime - timeTemp);

            Set3DFishRotation();

            return;
        }
    }


    void Set3DFishRotation()
    {
        if (is3DFishRotation || isTilt)
        {
            if (CachedTrans.localEulerAngles.y >= 270 && CachedTrans.localEulerAngles.y<=360)
            {
                if (childRotationPoint != null)
                {
                    if(is3DFishRotation)
                        childRotationPoint.localEulerAngles = new Vector3(CachedTrans.localEulerAngles.x, 180, 0);
                    if(isTilt)
                       childRotationPoint.localEulerAngles = new Vector3(-45, childRotationPoint.localEulerAngles.y, childRotationPoint.localEulerAngles.z);
                }
            }
            else
            {
                if (childRotationPoint != null)
                {
                    if (is3DFishRotation)
                        childRotationPoint.localEulerAngles = new Vector3(-CachedTrans.localEulerAngles.x, 0, 0);
                    if (isTilt)
                        childRotationPoint.localEulerAngles = new Vector3(45, childRotationPoint.localEulerAngles.y, childRotationPoint.localEulerAngles.z);
                }
            }

        }
       
    }

    public void Set3DFishRotationState(bool isRotation,Transform targetTF)
    {
        is3DFishRotation = isRotation;
        childRotationPoint = targetTF;
        
    }


    public void Set45Tilt( bool isTilt, Transform targetTF)
    {
        this.isTilt = isTilt;
        childRotationPoint = targetTF;
    }



    public void FishQuickOutScene(int changInterval=10)
    {
        MoveIndexInterval = changInterval;
    }


    public float GetFishRotateAngle(Vector3 moveDirection)
    {
        float angle = Vector3.Angle(moveDirection, (Vector3.right));
        float diectAngle = Vector3.Angle(moveDirection, (Vector3.up));
        if (diectAngle > 90)
        {
            angle = -angle;
        }
        return angle;
    }

    public bool CheckBoundValid()
    {
        Vector3 pos = CachedTrans.localPosition;

        if (pos.x < -ResolutionWidthHalf || pos.x > ResolutionWidthHalf) return false;

        if (pos.y < -ResolutionHeightHalf || pos.y > ResolutionHeightHalf) return false;

        return true;
    }

    public bool OutOfBounds()
    {
        Vector3 pos = CachedTrans.localPosition;

        if (pos.x > m_limitWidth || pos.x < -m_limitWidth || pos.y > m_limitHeight || pos.y < -m_limitHeight) return true;

        return false;
    }

    public void SetPosition(float x, float y, float z)
    {
        if (CachedTrans != null)
        {
            CachedTrans.position = new Vector3(x, y, z);
        }
    }


    public void SetEulerAngles(float x, float y, float z)
    {
        if (CachedTrans != null)
        {
            CachedTrans.eulerAngles = new Vector3(x, y, z);
        }
    }

    public void SetLocalScale(float x, float y, float z)
    {
        if (CachedTrans != null)
        {
            CachedTrans.localScale = new Vector3(x, y, z);
        }
    }


    public static float AngleAroundAxis(Vector3 dirA, Vector3 dirB, Vector3 axis)
    {
        return Vector3.Angle(dirA, dirB) * (Vector3.Dot(axis, Vector3.Cross(dirA, dirB)) < 0 ? -1 : 1);
    }

    public void BulletBeginMove(float bulletSpeed)
    {
        m_objType = ObjType.Bullet;

        m_moveSpeed = bulletSpeed;

        ResolutionWidthHalf = FishManager.curResolutionWidth * 0.5f;

        ResolutionHeightHalf = FishManager.curResolutionHeight * 0.5f;

        curFishStatus = FishStatus.Move;
       
    }


    public void BulletMoving()
    {
       
        if (m_targetTrans != null)
        {
            Vector3 tempTargetFishPos = new Vector3(m_targetTrans.position.x, m_targetTrans.position.y, 0);
            Vector3 bulletPos = new Vector3(CachedTrans.position.x, CachedTrans.position.y, 0);
            Vector3 v1 = (tempTargetFishPos - bulletPos).normalized;
            CachedTrans.rotation = Quaternion.FromToRotation(Vector3.up, v1);
        }
        m_direction = CachedTrans.TransformDirection(Vector3.up);
        m_direction = m_direction.normalized;
        float tempMoveSpeed = m_moveSpeed * (FishManager.curResolutionWidth / 1280);
        Vector3 pos = CachedTrans.localPosition + m_direction * Time.deltaTime * tempMoveSpeed;

        if (pos.x > ResolutionWidthHalf)
        {
            Vector3 re = Vector3.Reflect(m_direction, -Vector3.right);
            CachedTrans.localEulerAngles = new Vector3(0, 0, AngleAroundAxis(Vector3.up, re, Vector3.forward));
            pos = new Vector3(ResolutionWidthHalf, CachedTrans.localPosition.y, CachedTrans.localPosition.z);
            m_direction = CachedTrans.TransformDirection(Vector3.up);
        }
        if (pos.x < -ResolutionWidthHalf)
        {
            Vector3 re = Vector3.Reflect(m_direction, Vector3.right);
            CachedTrans.localEulerAngles = new Vector3(0, 0, AngleAroundAxis(Vector3.up, re, Vector3.forward));
            pos = new Vector3(-ResolutionWidthHalf, transform.localPosition.y, transform.localPosition.z);
            m_direction = CachedTrans.TransformDirection(Vector3.up);
        }
        if (pos.y > ResolutionHeightHalf)
        {
            Vector3 re = Vector3.Reflect(m_direction, -Vector3.up);
            CachedTrans.localEulerAngles = new Vector3(0, 0, AngleAroundAxis(Vector3.up, re, Vector3.forward));
            pos = new Vector3(CachedTrans.localPosition.x, ResolutionHeightHalf, CachedTrans.localPosition.z);
            m_direction = CachedTrans.TransformDirection(Vector3.up);
        }
        if (pos.y < -ResolutionHeightHalf)
        {
            Vector3 re = Vector3.Reflect(m_direction, Vector3.up);
            CachedTrans.localEulerAngles = new Vector3(0, 0, AngleAroundAxis(Vector3.up, re, Vector3.forward));
            pos = new Vector3(CachedTrans.localPosition.x, -ResolutionHeightHalf, CachedTrans.localPosition.z);
            m_direction = CachedTrans.TransformDirection(Vector3.up);
        }

        CachedTrans.localPosition = pos;
    }


}
