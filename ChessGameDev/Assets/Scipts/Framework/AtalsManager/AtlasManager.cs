using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.U2D;

public class AtlasManager : Singleton<AtlasManager>
{
    public override void Init()
    {
        base.Init();
    }

   
    public void AddBindingSpriteAtlas(Action<string, Action<SpriteAtlas>> handle)
    {
        SpriteAtlasManager.atlasRequested += handle;
    }

    public void RemoveBindingSpriteAtlas(Action<string, Action<SpriteAtlas>> handle)
    {
        SpriteAtlasManager.atlasRequested -= handle;
    }

}
