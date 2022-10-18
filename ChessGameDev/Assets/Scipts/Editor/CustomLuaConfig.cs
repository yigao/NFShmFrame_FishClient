using Spine.Unity;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.U2D;
using UnityEngine.UI;
using XLua;
using DG.Tweening;
using static UnityEngine.UI.Button;
using static UnityEngine.UI.InputField;

public static class CustomLuaConfig  {


    [LuaCallCSharp]
    public static List<Type> LuaCallCSharp = new List<Type>() {
        //Unity
        typeof(GameObject),
       // typeof(WWW),
        typeof(WaitForEndOfFrame),
        typeof(WaitForFixedUpdate),
        typeof(WaitForSeconds),
        typeof(MonoBehaviour),
        typeof(Behaviour),
        typeof(Component),
        typeof(Transform),
        typeof(Vector2),
        typeof(Vector3),
        typeof(Quaternion),
        typeof(Animation),
        typeof(AnimationClip),
        typeof(AnimationCurve),
        typeof(Animator),
        typeof(Ray),
        typeof(Time),
        typeof(Renderer),
        typeof(Color),
        typeof(MeshRenderer),
        typeof(SkinnedMeshRenderer),
        typeof(Collider),
        typeof(BoxCollider),
        typeof(CapsuleCollider),
        typeof(SphereCollider),
        typeof(SpriteRenderer),
        typeof(Screen),
        typeof(UnityEvent),
        typeof(UnityAction),
        typeof(Mathf),
        typeof(PlayerPrefs),
        typeof(Time),
        typeof(AudioSource),
        typeof(AudioClip),
        typeof(UnityEngine.Random),
        typeof(Camera),
        typeof(Color),
        typeof(AnimationCurve),
        typeof(Keyframe),
        typeof(TextAnchor),
        typeof(ParticleSystem),
        typeof(ParticleSystemRenderer),
        typeof(PlayerPrefs),
        typeof(Texture2D),
        typeof(Font),
       

        //CS
        typeof(List<int>),
        typeof(List<string>),
        typeof(List<object>),
        typeof(List<DG.Tweening.Tween>),
        typeof(Dictionary<string, int>),
        typeof(System.Action),
        typeof(EventHandle_Unit),
        typeof(TcpLcClient),
        typeof(TcpLcStateNotifyCallBack),
        typeof(System.DateTime),
       

        //UGUI
        typeof(CanvasScaler),
        typeof(Button),
        typeof(ButtonClickedEvent),
        typeof(SpriteAtlas),
        typeof(Text),
        typeof(Slider),
        typeof(Slider.SliderEvent),
        typeof(Toggle),
        typeof(ScrollRect),
        typeof(Canvas),
        typeof(RawImage),
        typeof(Image),
        typeof(RectTransform),
        typeof(InputField),
        typeof(CanvasGroup),
        typeof(HorizontalLayoutGroup),
        typeof(OnChangeEvent),

        //Curstom
        typeof(EventID),
        typeof(LuaManager),
        typeof(NetworkManager),
        typeof(TcpLcClient.NetworkStatus),
        typeof(ResourceManager),
        typeof(CorotineManager),
        typeof(ResourceBase),
        typeof(FishManager),
        typeof(FishLuaBehaviour),
        typeof(FishLuaBehaviour.FishStatus),
        typeof(EventManager),
        typeof(UIManager),
        typeof(UIEventScript),
        typeof(UIMiniEventScript),
        typeof(UITimerScript),
        typeof(UIFormScript),
        typeof(TimerManager),
        typeof(AtlasManager),
        typeof(FileManager),
        typeof(PoissonDiskSample),
        typeof(AnimationCurveConfig),
        typeof(UpdateManager),
        typeof(UpdateManager.UpdateItem),
        typeof(RenderConfig),
        typeof(UIListScript),
        typeof(UIListElementScript),
        typeof(GlobalConfigManager),
        typeof(StartUpSystem),
        typeof(VersionUpdateManager),
        typeof(GameResVersionInfo),
        typeof(GameVersionStatus),
        typeof(ShakeCamera),

        //Spine
        typeof(SkeletonAnimation),
        typeof(Spine.AnimationState),
        typeof(Spine.TrackEntry),
        typeof(SkeletonGraphic),

        //DoTween
        typeof(DG.Tweening.AutoPlay),
        typeof(DG.Tweening.AxisConstraint),
        typeof(DG.Tweening.Ease),
        typeof(DG.Tweening.LogBehaviour),
        typeof(DG.Tweening.LoopType),
        typeof(DG.Tweening.PathMode),
        typeof(DG.Tweening.PathType),
        typeof(DG.Tweening.RotateMode),
        typeof(DG.Tweening.ScrambleMode),
        typeof(DG.Tweening.TweenType),
        typeof(DG.Tweening.UpdateType),

        typeof(DG.Tweening.DOTween),
        typeof(DG.Tweening.DOVirtual),
        typeof(DG.Tweening.EaseFactory),
        typeof(DG.Tweening.Tweener),
        typeof(DG.Tweening.Tween),
        typeof(DG.Tweening.Sequence),
        typeof(DG.Tweening.TweenParams),
        typeof(DG.Tweening.Core.ABSSequentiable),

        typeof(DG.Tweening.Core.TweenerCore<Vector3, Vector3, DG.Tweening.Plugins.Options.VectorOptions>),

        typeof(DG.Tweening.TweenCallback),
        typeof(DG.Tweening.TweenExtensions),
        typeof(DG.Tweening.TweenSettingsExtensions),
        typeof(DG.Tweening.ShortcutExtensions),

    };


    //C#静态调用Lua的配置（包括事件的原型），仅可以配delegate，interface
    [CSharpCallLua]
    public static List<Type> CSharpCallLua = new List<Type>() {
                typeof(Action),
                typeof(Action<bool>),
                typeof(Func<double, double, double>),
                typeof(Action<int>),
                typeof(Action<string>),
                typeof(Action<float>),
                typeof(Action<double>),
                typeof(Action<Collider>),
                typeof(Action<GameObject>),
                //typeof(Action<EventUnit>),
                typeof(UnityEngine.Events.UnityAction),
                typeof(System.Collections.IEnumerator),
                typeof(EventHandle_Unit),
                typeof(Timer.OnTimeUpHandler),
                typeof(TcpLcStateNotifyCallBack),
                typeof(Action<string, Action<SpriteAtlas>>),
                typeof(Action<ResourceBase,float>),
                typeof(DG.Tweening.TweenCallback),
                typeof(DG.Tweening.ShortcutExtensions),
                typeof(Vector2Getter),
                typeof(Action<GameResVersionInfo>),
               // typeof(Vector2Getter(UnityEngine.Vector2)),
            };

    //黑名单
    [BlackList]
    public static List<List<string>> BlackList = new List<List<string>>()  {
                new List<string>(){"System.Xml.XmlNodeList", "ItemOf"},
                new List<string>(){"UnityEngine.WWW", "movie"},
    #if UNITY_WEBGL
                new List<string>(){"UnityEngine.WWW", "threadPriority"},
    #endif
                new List<string>(){"UnityEngine.Texture2D", "alphaIsTransparency"},
                new List<string>(){"UnityEngine.Security", "GetChainOfTrustValue"},
                new List<string>(){"UnityEngine.CanvasRenderer", "onRequestRebuild"},
                new List<string>(){"UnityEngine.Light", "areaSize"},
                new List<string>(){"UnityEngine.Light", "lightmapBakeType"},
                new List<string>(){"UnityEngine.WWW", "MovieTexture"},
                new List<string>(){"UnityEngine.WWW", "GetMovieTexture"},
                new List<string>(){"UnityEngine.AnimatorOverrideController", "PerformOverrideClipListCleanup"},
    #if !UNITY_WEBPLAYER
                new List<string>(){"UnityEngine.Application", "ExternalEval"},
    #endif
                new List<string>(){"UnityEngine.GameObject", "networkView"}, //4.6.2 not support
                new List<string>(){"UnityEngine.Component", "networkView"},  //4.6.2 not support
                new List<string>(){"System.IO.FileInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
                new List<string>(){"System.IO.FileInfo", "SetAccessControl", "System.Security.AccessControl.FileSecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "GetAccessControl", "System.Security.AccessControl.AccessControlSections"},
                new List<string>(){"System.IO.DirectoryInfo", "SetAccessControl", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "CreateSubdirectory", "System.String", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"System.IO.DirectoryInfo", "Create", "System.Security.AccessControl.DirectorySecurity"},
                new List<string>(){"UnityEngine.MonoBehaviour", "runInEditMode"},

                new List<string>(){ "UnityEngine.MeshRenderer", "receiveGI"},
                new List<string>(){ "UnityEngine.UI.Text", "OnRebuildRequested"},
                new List<string>(){ "UnityEngine.MeshRenderer", "scaleInLightmap"},
                new List<string>(){ "UnityEngine.MeshRenderer", "stitchLightmapSeams"},
                new List<string>(){ "UnityEngine.ParticleSystemRenderer", "supportsMeshInstancing"},
                


            };

#if UNITY_2018_1_OR_NEWER
    [BlackList]
    public static Func<MemberInfo, bool> MethodFilter = (memberInfo) =>
    {
        if (memberInfo.DeclaringType.IsGenericType && memberInfo.DeclaringType.GetGenericTypeDefinition() == typeof(Dictionary<,>))
        {
            if (memberInfo.MemberType == MemberTypes.Constructor)
            {
                ConstructorInfo constructorInfo = memberInfo as ConstructorInfo;
                var parameterInfos = constructorInfo.GetParameters();
                if (parameterInfos.Length > 0)
                {
                    if (typeof(System.Collections.IEnumerable).IsAssignableFrom(parameterInfos[0].ParameterType))
                    {
                        return true;
                    }
                }
            }
            else if (memberInfo.MemberType == MemberTypes.Method)
            {
                var methodInfo = memberInfo as MethodInfo;
                if (methodInfo.Name == "TryAdd" || methodInfo.Name == "Remove" && methodInfo.GetParameters().Length == 2)
                {
                    return true;
                }
            }
        }
        return false;
    };
#endif


}
