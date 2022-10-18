using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;


[CSharpCallLua]
public delegate Vector2 Vector2Getter();
[CSharpCallLua]
public delegate void Vector2Setter(Vector2 ve2);


[CSharpCallLua]
public delegate Color Color2Getter();
[CSharpCallLua]
public delegate void Color2Setter(Color color);

