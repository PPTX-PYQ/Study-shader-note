Shader "Unlit/Phong(F)"
{
    Properties
    {
        _MainColor("MainColor", Color) = (1,1,1,1)
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

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            fixed4 _MainColor;

            v2f vert(appdata_base v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                data.worldNormal = UnityObjectToWorldNormal(v.normal);
                return data;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 worldNormal = normalize(i.worldNormal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _MainColor.rgb;
                fixed3 diffuse = _LightColor0.rgb * _MainColor.rgb * max(0, dot(worldNormal, lightDir));

                float3 reflectDir = reflect(-lightDir, worldNormal);
                fixed3 specular = _LightColor0.rgb * fixed3(1,1,1) * pow(max(0, dot(reflectDir, viewDir)), 10);

                fixed3 finalColor = ambient + diffuse + specular;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
    }
}
