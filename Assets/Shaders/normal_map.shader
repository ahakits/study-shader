Shader "Study/Normal_Map"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Ambient ("Ambient", Range(0,1)) = 0
        _NormalMap ("NormalMap", 2D) = "bump" {}
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD;
                float3 normalDir : TEXCOORD1;
                float3 tangentDir : TEXCOORD2;
                float3 binormalDir : TEXCOORD3;
            };

            sampler2D _MainTex;
            float _LightColor0;
            float _Ambient;
            sampler2D _NormalMap;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize(mul(unity_ObjectToWorld, v.tangent.xyz));
                o.binormalDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3x3 tangentTransform = float3x3(i.tangentDir, i.binormalDir, i.normalDir);
                float3 normalLocal = UnpackNormal(tex2D(_NormalMap, i.uv)).xyz;
                float3 normal = normalize(mul(normalLocal, tangentTransform));

                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float NdotL = dot(normal, lightDir);
                float diffuse = max(_Ambient, NdotL);

                fixed4 tex = tex2D(_MainTex, i.uv);

                fixed4 color = diffuse * tex * _LightColor0;
                return color;
            }
            ENDCG
        }
    }
}
