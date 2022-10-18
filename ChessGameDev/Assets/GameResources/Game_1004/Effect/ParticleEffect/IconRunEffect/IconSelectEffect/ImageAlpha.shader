﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/ImageAlpha"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_AlphaLX("RangeAlphaLX",Float) = 0
		_AlphaRX("RangeAlphaRX",Float) = 1
		_AlphaTY("RangeAlphaTY",Float) = 1
		_AlphaBY("RangeAlphaBY",Float) = 0
		_AlphaPower("Power",Float) = 0 //透明度变化范围
		_YSpeed("YSpeed",Float) = 0
		_XSpeed("XSpeed",Float) = 0
	}
		SubShader
		{
			Tags { "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Back
			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				float _AlphaPower;
				float _YSpeed;
				float _XSpeed;
				sampler2D _AlphaTex;
				float _AlphaLX;
				float _AlphaRX;
				float _AlphaTY;
				float _AlphaBY;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}
				//此方法取自Unity默认Sprite的Shader
				fixed4 SampleSpriteTexture(float2 uv)
				{
					fixed2 UV = uv;
					//fixed xV = _XSpeed * _Time.x;
					fixed yV = _YSpeed*_Time.y;
					fixed xV = _XSpeed*_Time.y;
					UV -= fixed2(xV, yV);
					fixed4 col = tex2D(_MainTex, UV);
					return col;

				//	fixed4 color = tex2D(_MainTex, uv);

	//#if ETC1_EXTERNAL_ALPHA
	//				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
	//				color.a = tex2D(_AlphaTex, uv).r;
	//#endif //ETC1_EXTERNAL_ALPHA

					//return color;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					// sample the texture
					fixed4 col = SampleSpriteTexture(i.uv);
				//利用透明度阈值和uv坐标的差来计算透明的程度和是否控制其半透
				//四个方向只是对坐标的取值和正反方向不同，原理一致
				fixed alphalx = col.a * lerp(1,_AlphaPower,(_AlphaLX - i.uv.x));
				col.a = saturate(lerp(alphalx,col.a,step(_AlphaLX,i.uv.x)));

				fixed alpharx = col.a * lerp(1,_AlphaPower,(i.uv.x - _AlphaRX));
				col.a = saturate(lerp(col.a,alpharx,step(_AlphaRX,i.uv.x)));

				fixed alphaby = col.a * lerp(1,_AlphaPower,(_AlphaBY - i.uv.y));
				col.a = saturate(lerp(alphaby,col.a,step(_AlphaBY,i.uv.y)));

				fixed alphaty = col.a * lerp(1,_AlphaPower,(i.uv.y - _AlphaTY));
				col.a = saturate(lerp(col.a,alphaty,step(_AlphaTY,i.uv.y)));

				return col;
			}
			ENDCG
		}
		}
}