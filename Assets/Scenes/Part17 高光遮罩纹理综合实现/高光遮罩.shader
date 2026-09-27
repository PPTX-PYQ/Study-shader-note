Shader "Unlit/高光遮罩"
{
    Properties
    {
        _MainTex("MainTex",2D) = "white"{}
        _MainColor("MainColor", Color) = (1,1,1,1)
        _NormalTex("BumpMap",2D) = "bump"{}
        _BumpScale("BumpScale", Float) = 1.0
        _SpecularMask("SpecularMask",2D) = "white"{}
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
                float3 TtoW0 : TEXCOORD2;
                float3 TtoW1 : TEXCOORD3;
                float3 TtoW2 : TEXCOORD4;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _MainColor;

            sampler2D _NormalTex;
            float4 _NormalTex_ST;
            float _BumpScale;

            sampler2D _SpecularMask;
            float4 _SpecularMask_ST;

            fixed4 _SpecularColor;
            float _SpecularNum;

            v2f vert (appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv,_MainTex);
                o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 worldBinormal = cross(worldNormal, worldTangent) * v.tangent.w;

                // 切线空间转世界空间矩阵
                o.TtoW0 = float3(worldTangent.x, worldBinormal.x, worldNormal.x);
                o.TtoW1 = float3(worldTangent.y, worldBinormal.y, worldNormal.y);
                o.TtoW2 = float3(worldTangent.z, worldBinormal.z, worldNormal.z);
                return o;
            }

            fixed4 frag(v2f i):SV_Target
            {
                // 采样法线贴图
                float3 tangentNormal = UnpackNormal(tex2D(_NormalTex,i.uv));
                tangentNormal.xy *= _BumpScale;
                tangentNormal = normalize(tangentNormal);

                float3 worldNormal = normalize(float3(
                    dot(i.TtoW0,tangentNormal),
                    dot(i.TtoW1,tangentNormal),
                    dot(i.TtoW2,tangentNormal)
                ));

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                float3 halfDir = normalize(lightDir + viewDir);

                fixed3 albedo = tex2D(_MainTex,i.uv).rgb * _MainColor.rgb;
                fixed specularMask = tex2D(_SpecularMask,i.uv).r;

          
                float dotNL = dot(worldNormal,lightDir);
                float diffuseFactor = dotNL * 0.5 + 0.5;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * albedo;
                fixed3 diffuse = _LightColor0.rgb * albedo * diffuseFactor;
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * specularMask * pow(max(0,dot(worldNormal,halfDir)),_SpecularNum);

                fixed3 finalColor = ambient + diffuse + specular;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}

