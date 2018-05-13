// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'

Shader "Custom/VideoProjector" {
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
        _Intensity ("Intensity", Float) = 1.0
        _VideoTex ("Video", 2D) = "" {}
        _ShapeMaskTex ("Shape Mask", 2D) = "" {}
        _FalloffTex ("FallOff", 2D) = "" {}
    }
    
    Subshader {
        Tags {"Queue"="Transparent"}
        Pass {
            ZWrite Off
            ColorMask RGB
            Blend DstColor One
            Offset -1, -1
    
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"
            
            struct v2f {
                float4 uvShadow : TEXCOORD0;
                float4 uvFalloff : TEXCOORD1;
                UNITY_FOG_COORDS(2)
                float4 pos : SV_POSITION;
            };
            
            float4x4 unity_Projector;
            float4x4 unity_ProjectorClip;
            
            v2f vert (float4 vertex : POSITION)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uvShadow = mul (unity_Projector, vertex);
                o.uvFalloff = mul (unity_ProjectorClip, vertex);
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            
            fixed4 _Color;
            float _Intensity;
            sampler2D _VideoTex;
            sampler2D _ShapeMaskTex;
            sampler2D _FalloffTex;
            
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 videoTex = tex2Dproj (_VideoTex, UNITY_PROJ_COORD(i.uvShadow));
                fixed4 shapeTex = tex2Dproj (_ShapeMaskTex, UNITY_PROJ_COORD(i.uvShadow));
                videoTex.rgb *= _Intensity;
                videoTex.rgb *= shapeTex.rgb;
                videoTex.rgb *= _Color.rgb;
                videoTex.a = 1.0 - videoTex.a;
    
                fixed4 falloffTex = tex2Dproj (_FalloffTex, UNITY_PROJ_COORD(i.uvFalloff));
                fixed4 res = videoTex * falloffTex.a;

                UNITY_APPLY_FOG_COLOR(i.fogCoord, res, fixed4(0,0,0,0));
                return res;
            }
            ENDCG
        }
    }
}
