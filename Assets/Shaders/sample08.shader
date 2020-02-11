Shader "Sample/Sample08"
{
    Properties
    {
        _FloatValue ("Float Value", Range(0, 1)) = 1
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv: TEXCOORD;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv: TEXCOORD;
            };

            float _FloatValue;
            fixed4 _GlobalColorValue;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = fixed4(_FloatValue, _FloatValue, _FloatValue, 1);
                color *= _GlobalColorValue;
                return color;
            }
            ENDCG
        }
    }
}
