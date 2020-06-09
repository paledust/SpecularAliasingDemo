// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "FX/LeakWaterShader"
{
	Properties
	{
		_CutOff("Alpha CutOff Value", Range(0,1)) = .5
		_DistortionMap("Distortion Map", 2D) = "black"{}
		_DistortionAmount("Distortion Amount", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_TopColor("Top Color", Color) = (1,1,1,1)
		_EndColor("End Color", Color) = (1,1,1,1)
		_ShadeColor("Shade Color", Color) = (1,1,1,1)
		_FoamStrength("Foam Strength",Range(0,2)) = 0.0
		_Fading("Fading Minimal Height", Range(0,1)) = 0.0
		_Mask ("Mask", 2D) = "white" {}
		_BlendAlpha("Alpha", Range(0,1)) = 1.0
		_Speed("Speed", float) = 1.0
		[Toggle(USE_REFLECTION)]_USE_REFLECTION ("Use Reflection", Float) = 0
		_RefIntensity("Reflection Intensity", Float) = 0
		[HideInInspector] _ReflectionTex ("", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "LightMode"="ForwardBase"}
		LOD 100

		GrabPass{}
		
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			CGPROGRAM
			#pragma shader_feature USE_REFLECTION
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
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1; 
				float4 color: COLOR;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;

				#ifdef USE_REFLECTION
				float4 refl : TEXCOORD2;
				#endif
			};

			sampler2D _Mask;
			sampler2D _MainTex;
			sampler2D _DistortionMap;
			sampler2D _GrabTexture;
			sampler2D _ReflectionTex;
			float4 _DistortionMap_ST;
			float4 _Mask_ST;
			float4 _GrabTexture_ST;

			uniform fixed4 _ReflectionTex_TexelSize;
			fixed4 _TopColor;
			fixed4 _EndColor;
			fixed4 _ShadeColor;
			fixed _Fading;
			fixed _Speed;
			fixed _FoamStrength;
			fixed _BlendAlpha;
			fixed _CutOff;
			fixed _DistortionAmount;

			#ifdef USE_REFLECTION
			fixed _RefIntensity;
			#endif

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				float f = clamp((v.vertex.y - _Fading + 1), 0, 1);
				o.color = lerp(_EndColor,_TopColor,f);
				o.uv = TRANSFORM_TEX(v.uv, _Mask);
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				#ifdef USE_REFLECTION
				o.refl = ComputeScreenPos(o.vertex);
				#endif
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float4 finalColor;
				// sample the texture
				fixed4 mask = tex2D(_Mask, i.uv );

				fixed4 col = tex2D(_MainTex, i.uv * _DistortionMap_ST.xy + float2(0,_Time.x * _Speed));
				fixed4 col_2 = tex2D(_MainTex, i.uv * 1.3 + float2(0, 2.5*_Time.x * _Speed));

				finalColor.a = mask.r * _BlendAlpha;

				
				if(finalColor.a <= _CutOff){
					discard;
				}
				else{
					finalColor.a = clamp(1 - pow(finalColor.a - 1,2),0,1);
				}

				fixed2 distortion = tex2D(_DistortionMap, i.uv * _DistortionMap_ST.xy + float2(0, _Time.x * _Speed));
				distortion = tex2D(_DistortionMap, i.uv + distortion.xy);
				fixed4 main_distort = tex2Dproj(_GrabTexture, i.uvgrab + float4(distortion.x * 2 - 1, distortion.y * 2 - 1,0,0) * finalColor.a * .04 * _DistortionAmount);

				finalColor.rgb = _ShadeColor.rgb * (col.rgb + col_2.rgb) * _FoamStrength + i.color*.5 + main_distort.rgb;

				#ifdef USE_REFLECTION
				fixed4 projUV = UNITY_PROJ_COORD(i.refl);
				fixed4 refl = tex2Dproj(_ReflectionTex, i.refl + float4(distortion.x * 2 - 1, distortion.y * 2 - 1,0,0)*_DistortionAmount) * _RefIntensity;

				finalColor *= refl;
				#endif

				return finalColor;
			}
			ENDCG
		}
	}
}
