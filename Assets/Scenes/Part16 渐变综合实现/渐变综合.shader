Shader "Unlit/渐变综合"
{
    Properties
    {
        _MainTex("MainTex",2D) = "white"{}
        _MainColor("MainColor", Color) = (1,1,1,1)
        _NormalTex("BumpMap",2D) = "bump"{}
        _BumpScale("BumpScale", Float) = 1.0
        _RampTex("RampTex",2D) = "white"{}
        _SpecularColor("SpecularColor", Color) = (1,1,1,1)
        _SpecularNum("SpecularNum", Range(0,20)) = 10
    }
    SubShader
    {
        Tags { "LightMode"="ForwardBase" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 worldNormal : TEXCOORD2;
                float3 worldTangent : TEXCOORD3;
                float3 worldBinormal : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;

            sampler2D _NormalTex;
            float4 _NormalTex_ST;
            float _BumpScale;

            sampler2D _RampTex;
            float4 _RampTex_ST;

            fixed4 _SpecularColor;
            float _SpecularNum;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

                // 顶点阶段输出世界空间TBN
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                o.worldBinormal = cross(o.worldNormal, o.worldTangent) * v.tangent.w;
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                // 1.采样法线贴图，解压切线空间法线，缩放凹凸强度
                float3 normalTangent = UnpackNormal(tex2D(_NormalTex,i.uv));
                normalTangent.xy *= _BumpScale;
                normalTangent = normalize(normalTangent);

                // 2.切线空间法线转换到世界空间（世界空间TBN向量组合）
                float3 worldNormal = normalize(
                    i.worldTangent * normalTangent.x +
                    i.worldBinormal * normalTangent.y +
                    i.worldNormal * normalTangent.z
                );

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);

                // 固有色：贴图采样 * MainColor
                fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _MainColor.rgb;

                // Ramp渐变核心：漫反射点乘结果作为UV采样渐变贴图
                float diffDot = saturate(dot(worldNormal, lightDir));
                fixed3 rampDiff = tex2D(_RampTex, float2(diffDot,0.5)).rgb;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * rampDiff;
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow(max(0,dot(worldNormal,halfDir)),_SpecularNum);

                fixed3 finalColor = ambient + diffuse + specular;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

