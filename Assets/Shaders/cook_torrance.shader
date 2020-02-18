Shader "Study/Cook_Torrance"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Ambient ("Ambient", Range(0, 1)) = 0
        _SpecColor ("Specular Color", Color) = (0.872, 0.866, 0.370, 1.0)
        _Roughness ("Roughness", Range(0.000000001, 1)) = 0.5
        _FresnelEffect ("FresnelEffect", Float) = 20.0
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
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD;
                float3 worldNormal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _LightColor0;
            float _Ambient;
            float4 _SpecColor;
            float _Roughness;
            float _FresnelEffect;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;

                float3 worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldNormal = worldNormal;

                float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldPos = worldPos;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
                float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
                float3 halfDir = normalize(lightDir + viewDir);

                float NdotV = saturate(dot(normal, viewDir));
                float NdotH = saturate(dot(normal, halfDir));
                float VdotH = saturate(dot(viewDir, halfDir));
                float NdotL = saturate(dot(normal, lightDir));
                float LdotH = saturate(dot(lightDir, halfDir));

                float4 tex = tex2D(_MainTex, i.uv);

                // Diffuse Color
                float diffusePower = max(_Ambient, NdotL);
                float4 diffuse = diffusePower * tex * _LightColor0;

                // Beckmann
                float m = _Roughness * _Roughness;
                float r1 = 1.0 / (4.0 * m * pow(NdotH + 0.00001f, 4.0));
                float r2 = (NdotH * NdotH - 1.0) / (m * NdotH * NdotH + 0.00001f);
                float D = r1 * exp(r2);

                // Geometry Term
                float g1 = 2 * NdotH * NdotV / VdotH;
                float g2 = 2 * NdotH * NdotL / VdotH;
                float G = min(1.0, min(g1, g2));

                // Fresnel equations
                float n = _FresnelEffect;
                float g = sqrt(n * n + LdotH * LdotH - 1);
                float gpc = g + LdotH;
                float gnc = g - LdotH;
                float cgpc = LdotH * gpc - 1;
                float cgnc = LdotH * gnc + 1;
                float F = 0.5f * gnc * gnc * (1 + cgpc * cgpc / (cgnc * cgnc)) / (gpc * gpc);

                half BRDF = (F * D * G) / (NdotV * NdotL * 4.0 + 0.0001f);

                half3 finalValue = BRDF * _SpecColor * _LightColor0;

                fixed4 col = diffuse + float4(finalValue, 1.0);
                return col;
            }
            ENDCG
        }
    }
}
