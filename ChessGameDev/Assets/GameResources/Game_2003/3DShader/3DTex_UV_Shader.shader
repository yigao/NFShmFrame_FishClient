// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.35 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.35;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:1,rntp:1,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:3839,x:33303,y:32587,varname:node_3839,prsc:2|emission-3561-OUT;n:type:ShaderForge.SFN_Tex2d,id:106,x:32848,y:32535,ptovrint:False,ptlb:wenli,ptin:_wenli,varname:node_106,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:40d5fa7c7729a904997b0a524b70a255,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:2317,x:32666,y:32402,ptovrint:False,ptlb:Tex_UV_Color,ptin:_Tex_UV_Color,varname:node_2317,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:1,c2:0.8693712,c3:0.3235294,c4:1;n:type:ShaderForge.SFN_Multiply,id:8715,x:32774,y:32749,varname:node_8715,prsc:2|A-2317-RGB,B-3155-OUT;n:type:ShaderForge.SFN_Tex2d,id:6742,x:32432,y:32515,ptovrint:False,ptlb:node_6742,ptin:_node_6742,varname:node_6742,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:82d397571856bdd479e3d42297a0b331,ntxv:0,isnm:False|UVIN-1731-OUT;n:type:ShaderForge.SFN_TexCoord,id:9066,x:31985,y:32348,varname:node_9066,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:3561,x:33091,y:32672,varname:node_3561,prsc:2|A-106-RGB,B-7324-OUT;n:type:ShaderForge.SFN_Time,id:8695,x:31759,y:32400,varname:node_8695,prsc:2;n:type:ShaderForge.SFN_Append,id:7523,x:31829,y:32576,varname:node_7523,prsc:2|A-2423-OUT,B-5403-OUT;n:type:ShaderForge.SFN_Slider,id:5403,x:31454,y:32683,ptovrint:False,ptlb:V_speed,ptin:_V_speed,varname:node_5403,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_Slider,id:2423,x:31454,y:32561,ptovrint:False,ptlb:U_speed,ptin:_U_speed,varname:_V_speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:5;n:type:ShaderForge.SFN_Multiply,id:5734,x:31985,y:32503,varname:node_5734,prsc:2|A-8695-T,B-7523-OUT;n:type:ShaderForge.SFN_Add,id:1731,x:32214,y:32515,varname:node_1731,prsc:2|A-9066-UVOUT,B-5734-OUT;n:type:ShaderForge.SFN_Power,id:3155,x:32630,y:32766,varname:node_3155,prsc:2|VAL-6742-RGB,EXP-6363-OUT;n:type:ShaderForge.SFN_Slider,id:6363,x:32234,y:32854,ptovrint:False,ptlb:Power_Num,ptin:_Power_Num,varname:node_6363,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:2.465168,max:10;n:type:ShaderForge.SFN_Multiply,id:7324,x:32937,y:32749,varname:node_7324,prsc:2|A-8715-OUT,B-5377-OUT;n:type:ShaderForge.SFN_Slider,id:5377,x:32617,y:32962,ptovrint:False,ptlb:Light_qiangdu,ptin:_Light_qiangdu,varname:_Power_Num_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:1,cur:3.47552,max:10;proporder:106-2317-6742-5403-2423-6363-5377;pass:END;sub:END;*/

Shader "Custom/3DTex_UV_Shader" {
    Properties {
        _wenli ("wenli", 2D) = "white" {}
        _Tex_UV_Color ("Tex_UV_Color", Color) = (1,0.8693712,0.3235294,1)
        _node_6742 ("node_6742", 2D) = "white" {}
        _V_speed ("V_speed", Range(-5, 5)) = 0
        _U_speed ("U_speed", Range(-5, 5)) = 0
        _Power_Num ("Power_Num", Range(1, 10)) = 2.465168
        _Light_qiangdu ("Light_qiangdu", Range(0, 10)) = 3.47552
    }
    SubShader {
        Tags {
            "RenderType"="Opaque"
        }
        LOD 200
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
           // #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
         //   #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x xboxone ps4 psp2 n3ds wiiu 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _wenli; uniform float4 _wenli_ST;
            uniform float4 _Tex_UV_Color;
            uniform sampler2D _node_6742; uniform float4 _node_6742_ST;
            uniform float _V_speed;
            uniform float _U_speed;
            uniform float _Power_Num;
            uniform float _Light_qiangdu;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                UNITY_FOG_COORDS(1)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
////// Lighting:
////// Emissive:
                float4 _wenli_var = tex2D(_wenli,TRANSFORM_TEX(i.uv0, _wenli));
                float4 node_8695 = _Time + _TimeEditor;
                float2 node_1731 = (i.uv0+(node_8695.g*float2(_U_speed,_V_speed)));
                float4 _node_6742_var = tex2D(_node_6742,TRANSFORM_TEX(node_1731, _node_6742));
                float3 emissive = (_wenli_var.rgb+((_Tex_UV_Color.rgb*pow(_node_6742_var.rgb,_Power_Num))*_Light_qiangdu));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
