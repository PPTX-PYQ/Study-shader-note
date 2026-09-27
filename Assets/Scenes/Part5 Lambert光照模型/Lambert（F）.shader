Shader "Unlit/Lambert（F）"
{
      Properties
    {
       _MainColor("MainColor", Color )= (1,1,1,1)
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
            fixed4 _MainColor;
         
            struct v2f
            {
                float4 pos:SV_POSITION;
                float3 normal:NORMAL ;
            };

            v2f vert (appdata_base v )
            {
                v2f v2fData;

                v2fData.pos = UnityObjectToClipPos(v.vertex);

                v2fData.normal = UnityObjectToWorldNormal (v.normal );
              
        

               return v2fData;

            }

            fixed4 frag (v2f i) : SV_Target
            {
               float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
               fixed3 color = _LightColor0.rgb * _MainColor.rgb * max(0,dot(i.normal, lightDir));
               color = UNITY_LIGHTMODEL_AMBIENT.rgb + color;

               return fixed4(color.rgb, 1);

            }
            ENDCG
        }
    }
}