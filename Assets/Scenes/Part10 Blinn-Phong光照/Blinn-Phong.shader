Shader "Unlit/Blinn-Phong"
{
    Properties
    {
        _MainColor("MainColor", Color) = (1,1,1,1)
        _SpecularColor("SpecularColor", Color) = (1,1,1,1)
        _SpecularNum("SpecularNum", Range(0, 20)) = 10
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
                fixed3 color : COLOR;
            };

            fixed4 _MainColor;
            fixed4 _SpecularColor;
            float _SpecularNum;

            v2f vert (appdata_base v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal = UnityObjectToWorldNormal(v.normal);
                normal = normalize(normal);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _MainColor.rgb;
                fixed3 diffuse = _LightColor0.rgb * _MainColor.rgb * max(0.0, dot(normal, lightDir));

                float3 halfDir = normalize(lightDir + viewDir);
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow( max(0.0, dot(normal,halfDir)), _SpecularNum);

                data.color = ambient + diffuse + specular;
                return data;
            }

            fixed4 frag (v2f i): SV_Target
            {
                return fixed4(i.color.rgb,1);
            }
            ENDCG
        }
    }
}
