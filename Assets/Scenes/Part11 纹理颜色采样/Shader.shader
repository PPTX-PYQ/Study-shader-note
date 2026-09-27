Shader "Unlit/Shader"
{
    Properties
    {
        _MainTex("MainTex",2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
       
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
          
            #include "UnityCG.cginc"
         
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f data;
                data.pos = UnityObjectToClipPos(v.vertex);
                data.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return data;
            }

            fixed4 frag (v2f i): SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv);
                return texColor;
            }
            ENDCG
        }
    }
}

