Shader "Unlit/Alpha Test"
{
    Properties
    {
        _MainTex ("MainTex",2D) = "white"{}
        _MainColor ("MainColor",Color) = (1,1,1,1)
        _SpecularColor ("SpecularColor",Color)=(1,1,1,1)
        _SpecularNum ("SpecularNum",Range(1,200))=20
        _AlphaScale ("AlphaScale",Range(0,1))=1
    }
    SubShader
    {
        Tags{"LightMode"="ForwardBase" "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
        Pass
        {
            ZWrite Off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float _SpecularNum;
            fixed _AlphaScale;
            struct a2v
            {
                float4 vertex:POSITION;
                float2 uv:TEXCOORD0;
                float3 normal:NORMAL;
            };
            struct v2f
            {
                float4 pos:SV_POSITION;
                float2 uv:TEXCOORD0;
                float3 wNormal:TEXCOORD1;
                float3 wPos:TEXCOORD2;
            };
            v2f vert(a2v v)
            {
                v2f data;
                data.pos=UnityObjectToClipPos(v.vertex);
                data.uv=TRANSFORM_TEX(v.uv,_MainTex);
                data.wNormal=UnityObjectToWorldNormal(v.normal);
                data.wPos=mul(unity_ObjectToWorld,v.vertex);
                return data;
            }
            fixed4 frag(v2f i):SV_Target
            {
                fixed4 texColor=tex2D(_MainTex,i.uv);
                fixed3 albedo=texColor.rgb * _MainColor.rgb;
                float3 lightDir=normalize(_WorldSpaceLightPos0.xyz);
                fixed3 lambertColor=_LightColor0.rgb*albedo*max(0,dot(i.wNormal,lightDir));
                float3 viewDir=normalize(_WorldSpaceCameraPos.xyz - i.wPos);
                float3 halfDir=normalize(lightDir+viewDir);
                fixed3 specularColor=_LightColor0.rgb*_SpecularColor.rgb*pow(max(0,dot(i.wNormal,halfDir)),_SpecularNum);
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.rgb*albedo;
                fixed4 finalColor;
                finalColor.rgb = ambient+lambertColor+specularColor;
                finalColor.a = texColor.a * _AlphaScale;
                return finalColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

