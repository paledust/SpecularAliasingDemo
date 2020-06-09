Shader "FX/MirrorTest"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color("Mirror Color", Color) = (1,1,1,1)
		[HideInInspector] _ReflectionTex ("", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "Queue"="Transparent+100" "RenderType"="Transparent"}
		// Pass{
		// 	ZWrite Off
		// 	Blend Zero One

		// 	CGPROGRAM
		// 	#pragma vertex vert
		// 	#pragma fragment frag
		// 	#include "UnityCG.cginc"
		// 	struct v2f
		// 	{
		// 		float2 uv : TEXCOORD0;
		// 		float4 pos : SV_POSITION;
		// 	};
		// 	sampler2D _MainTex;
		// 	float4 _MainTex_ST;

		// 	v2f vert(float4 pos : POSITION, float2 uv : TEXCOORD0)
		// 	{
		// 		v2f o;
		// 		o.pos = UnityObjectToClipPos (pos);
		// 		o.uv = TRANSFORM_TEX(uv, _MainTex);
		// 		return o;
		// 	}
		// 	fixed4 frag(v2f i) : SV_Target
		// 	{
		// 		fixed4 tex = tex2D(_MainTex, i.uv);
		// 		return tex;
		// 	}
		// 	ENDCG
		// }

		//Improved Order Independent Transparent Shader
		CGINCLUDE
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;	

			uniform half4 _MainTex_TexelSize;
			uniform half4 _Parameter;
			uniform half4 _MainTex_ST;	

		ENDCG
		
		Pass{
			ColorMask A
			Blend Zero One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag 

			float4 vert(float4 vertex : POSITION) : SV_POSITION{
				return UnityObjectToClipPos(vertex);
			}

			fixed4 frag() : COLOR{
				return (1,1,1,0);
			}

			ENDCG
		}
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 refl : TEXCOORD1;
				half2 offs : TEXCOORD2;
				float4 pos : SV_POSITION;
			};

			float4 _Color;

			v2f vert(float4 pos : POSITION, float2 uv : TEXCOORD0)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (pos);
				o.uv = TRANSFORM_TEX(uv, _MainTex);
				o.refl = ComputeScreenPos (o.pos);
				o.offs = _MainTex_TexelSize.xy * half2(1.0, 1.0) * _Parameter.x;
				return o;
			}

			sampler2D _ReflectionTex;
			uniform half4 _ReflectionTex_TexelSize;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 tex = tex2D(_MainTex, i.uv);
				fixed4 projUV = UNITY_PROJ_COORD(i.refl);
				
				half2 uv = i.uv; 

				fixed4 refl = tex2Dproj(_ReflectionTex, projUV);

				//My Change
				refl = tex2Dproj(_ReflectionTex, i.refl);

				return tex * refl * _Color;
			}
			ENDCG
	    }
	}
}