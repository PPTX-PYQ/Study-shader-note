Shader "Unlit/Specular"
{
     Properties
    {
       _SpecularColor("SpecularColor",Color) =(1,1,1,1)
       _SpecularNum("SpecularNum", Range(0, 20)) = 0.5
    }
    SubShader
    {
        Tags {  "LightMode"="ForwardBase" }
       

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
         

            struct v2f
            {
                float4 pos:SV_POSITION;
                fixed3 color:COLOR;
            
            };
                 fixed4 _SpecularColor;
                 float _SpecularNum;

             v2f vert (appdata_base v)
            {
                v2f data;
                //顶点坐标转换到裁剪空间
                data.pos = UnityObjectToClipPos(v.vertex);

                float3 worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
                float3 viewDir = _WorldSpaceCameraPos.xyz - worldPos;

                viewDir = normalize(viewDir);

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 normal = UnityObjectToWorldNormal(v.normal);
                float3 reflectDir = reflect(-lightDir, normal);

                fixed3 color = _LightColor0.rgb * _SpecularColor.rgb * pow( max(0.0, dot(viewDir,reflectDir)), _SpecularNum);

                data.color = color;

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