using UnityEngine;
using UnityEngine.Video;
using UnityEngine.SceneManagement;

[GameState]
public class LaunchState : BaseState
{
    public const string Video_Path = "Video/VideoPlayer";

    private GameObject m_videoObj;

    public override void OnStateEnter()
    {
        //Singleton<ResourceLoader>.GetInstance().LoadScene("SplashScene", new ResourceLoader.LoadCompletedDelegate(this.OnSplashLoadCompleted));
        CheckContionToNextState();
    }

    private void OnSplashLoadCompleted()
    {
        //ResourceBase resourceBase = MonoSingleton<ResourceManager>.GetInstance().GetResource(Video_Path, typeof(GameObject));
        //if (resourceBase != null)
        //{
        //    m_videoObj = GameObject.Instantiate(resourceBase.content) as GameObject;
        //    VideoPlayer videoPlayer = m_videoObj.transform.Find("VideoClip").GetComponent<VideoPlayer>();
        //    if (videoPlayer.clip != null)
        //    {
        //        videoPlayer.loopPointReached += OnVedioPlayComplete;
        //        GameObject.DontDestroyOnLoad(m_videoObj);
        //        return;
        //    }
        //}
        OnSplashPlayComplete();
    }

    private void OnVedioPlayComplete(VideoPlayer source)
    {
        OnSplashPlayComplete();
    }

    private void OnSplashPlayComplete()
    { 
        CheckContionToNextState();
    }


    private void CheckContionToNextState()
    {
        //GameObject.DestroyImmediate(m_videoObj);
        //m_videoObj = null;
        Singleton<GameStateCtrl>.GetInstance().GotoState("ResState");
    }
}