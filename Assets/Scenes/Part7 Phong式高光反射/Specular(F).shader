Shader "Unlit/Specular(F)"
{
    Properties
    {
        _SpecularColor("SpecularColor", Color) = (1,1,1,1)
        _SpecularNum("SpecularNum", Range(0, 20)) = 0.5
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

            fixed4 _SpecularColor;
            float _SpecularNum;

            v2f vert (appdata_base v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                data.worldNormal = UnityObjectToWorldNormal(v.normal);
                return data;
            }

            fixed4 frag (v2f i): SV_Target
            {
                float3 worldNormal = normalize(i.worldNormal);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 reflectDir = reflect(-lightDir, worldNormal);
                fixed3 specular = _LightColor0.rgb * _SpecularColor.rgb * pow( max(0.0, dot(viewDir,reflectDir)), _SpecularNum);
                return fixed4(specular,1);
            }
            ENDCG
        }
    }
}
