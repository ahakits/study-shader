Shader "Study/Cube_Map"
{
    Properties
    {
        [NoScaleOffset] _CubeTex("Cube", Cube) = "" {}
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD1;
                float3 normal : TEXCOORD2;
            };

            samplerCUBE _CubeTex;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 viewDir = _WorldSpaceCameraPos - i.worldPos;
                half3 reflDir = reflect(-1 * viewDir, i.normal);
                half4 refColor = texCUBE(_CubeTex, reflDir);

                return refColor;
            }
            ENDCG
        }
    }
}
