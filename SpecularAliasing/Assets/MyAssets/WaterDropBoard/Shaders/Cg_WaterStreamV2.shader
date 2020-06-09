// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "FX/WaterStreamV2"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Spec("Spec", Range( 0 , 1)) = 0
		[HDR]_SpecColor("SpecColor", Color) = (0,0,0,0)
		_SpecColor("Specular Color",Color)=(1,1,1,1)
		_NormalSharpness("NormalSharpness", Float) = 0
		_NormalStrength("NormalStrength", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_DistortionMap("DistortionMap", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_FoamStrength("FoamStrength", Float) = 0
		_DistortionAmount("DistortionAmount", Float) = 1
		_CutOff("CutOff", Range( 0 , 1)) = 0
		_BlendAlpha("BlendAlpha", Range( 0 , 1)) = 1
		_Speed("Speed", Float) = 3
		[Toggle(_USE_REFLECTION_ON)] _USE_REFLECTION("Use Reflection", Float) = 0
		_RefIntensity("RefIntensity", Float) = 0
		[HideInInspector]_ReflectionTex("ReflectionTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature _USE_REFLECTION_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _MainTex;
		uniform sampler2D _DistortionMap;
		uniform float _Speed;
		uniform float4 _DistortionMap_ST;
		uniform float _DistortionAmount;
		uniform float4 _MainTex_ST;
		uniform float _NormalSharpness;
		uniform float _NormalStrength;
		uniform float4 _Color;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _FoamStrength;
		uniform sampler2D _ReflectionTex;
		uniform float _RefIntensity;
		uniform float _Spec;
		uniform float _CutOff;
		uniform sampler2D _Mask;
		uniform float _BlendAlpha;

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_27_0 = ( _Speed * _Time.x );
			float2 appendResult28 = (float2(0.0 , temp_output_27_0));
			float2 uv0_DistortionMap = i.uv_texcoord * _DistortionMap_ST.xy + _DistortionMap_ST.zw;
			float2 uvdist59 = ( ( ( (tex2D( _DistortionMap, ( appendResult28 + uv0_DistortionMap ) )).rg * float2( 2,2 ) ) - float2( 1,1 ) ) * _DistortionAmount );
			float2 temp_output_67_0 = ( uvdist59 * 0.001 );
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 appendResult29 = (float2(0.0 , ( temp_output_27_0 * 2.5 )));
			float2 temp_output_34_0 = ( uv0_MainTex + appendResult29 );
			float2 temp_output_2_0_g9 = ( temp_output_67_0 + temp_output_34_0 );
			float2 break6_g9 = temp_output_2_0_g9;
			float temp_output_25_0_g9 = ( pow( _NormalSharpness , 3.0 ) * 0.1 );
			float2 appendResult8_g9 = (float2(( break6_g9.x + temp_output_25_0_g9 ) , break6_g9.y));
			float4 tex2DNode14_g9 = tex2D( _MainTex, temp_output_2_0_g9 );
			float temp_output_4_0_g9 = _NormalStrength;
			float3 appendResult13_g9 = (float3(1.0 , 0.0 , ( ( tex2D( _MainTex, appendResult8_g9 ).r - tex2DNode14_g9.r ) * temp_output_4_0_g9 )));
			float2 appendResult9_g9 = (float2(break6_g9.x , ( break6_g9.y + temp_output_25_0_g9 )));
			float3 appendResult16_g9 = (float3(0.0 , 1.0 , ( ( tex2D( _MainTex, appendResult9_g9 ).r - tex2DNode14_g9.r ) * temp_output_4_0_g9 )));
			float3 normalizeResult22_g9 = normalize( cross( appendResult13_g9 , appendResult16_g9 ) );
			float2 temp_output_36_0 = ( uv0_MainTex + appendResult28 );
			float2 temp_output_2_0_g10 = ( temp_output_67_0 + temp_output_36_0 );
			float2 break6_g10 = temp_output_2_0_g10;
			float temp_output_25_0_g10 = ( pow( _NormalSharpness , 3.0 ) * 0.1 );
			float2 appendResult8_g10 = (float2(( break6_g10.x + temp_output_25_0_g10 ) , break6_g10.y));
			float4 tex2DNode14_g10 = tex2D( _MainTex, temp_output_2_0_g10 );
			float temp_output_4_0_g10 = _NormalStrength;
			float3 appendResult13_g10 = (float3(1.0 , 0.0 , ( ( tex2D( _MainTex, appendResult8_g10 ).r - tex2DNode14_g10.r ) * temp_output_4_0_g10 )));
			float2 appendResult9_g10 = (float2(break6_g10.x , ( break6_g10.y + temp_output_25_0_g10 )));
			float3 appendResult16_g10 = (float3(0.0 , 1.0 , ( ( tex2D( _MainTex, appendResult9_g10 ).r - tex2DNode14_g10.r ) * temp_output_4_0_g10 )));
			float3 normalizeResult22_g10 = normalize( cross( appendResult13_g10 , appendResult16_g10 ) );
			float3 normal71 = BlendNormals( normalizeResult22_g9 , normalizeResult22_g10 );
			o.Normal = normal71;
			float4 color39 = _Color;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 unityObjectToClipPos14 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeGrabScreenPos12 = ComputeGrabScreenPos( unityObjectToClipPos14 );
			float4 screenColor15 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float4( ( uvdist59 * 0.02 ), 0.0 , 0.0 ) + computeGrabScreenPos12 ).xy/( float4( ( uvdist59 * 0.02 ), 0.0 , 0.0 ) + computeGrabScreenPos12 ).w);
			float4 Foam43 = ( ( tex2D( _MainTex, temp_output_34_0 ) + tex2D( _MainTex, temp_output_36_0 ) ) * color39 * _FoamStrength );
			float4 temp_output_74_0 = ( ( color39 * screenColor15 ) + Foam43 );
			o.Albedo = temp_output_74_0.rgb;
			float4 unityObjectToClipPos91 = UnityObjectToClipPos( ase_vertex3Pos );
			float4 computeScreenPos95 = ComputeScreenPos( unityObjectToClipPos91 );
			computeScreenPos95 = computeScreenPos95 / computeScreenPos95.w;
			computeScreenPos95.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? computeScreenPos95.z : computeScreenPos95.z* 0.5 + 0.5;
			float4 Reflection103 = ( tex2D( _ReflectionTex, ( ( (computeScreenPos95).xy + ( uvdist59 * 0.1 ) ) / (computeScreenPos95).w ) ) * _RefIntensity );
			#ifdef _USE_REFLECTION_ON
				float4 staticSwitch25 = ( temp_output_74_0 * Reflection103 );
			#else
				float4 staticSwitch25 = float4( 0,0,0,0 );
			#endif
			o.Emission = staticSwitch25.rgb;
			o.Specular = _Spec;
			o.Gloss = 1.0;
			float temp_output_45_0 = ( tex2D( _Mask, i.uv_texcoord ).r * pow( _BlendAlpha , 2.0 ) );
			float alpha81 = ( step( _CutOff , temp_output_45_0 ) * temp_output_45_0 );
			o.Alpha = alpha81;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf BlinnPhong alpha:fade keepalpha fullforwardshadows nometa noforwardadd 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17800
-1459;102;1237;824;2662.23;-1357.133;1.3;True;False
Node;AmplifyShaderEditor.RangedFloatNode;21;-2295.556,548.4811;Inherit;False;Property;_Speed;Speed;14;0;Create;True;0;0;False;0;3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;26;-2348.437,640.4539;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2152.437,584.4539;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1942.512,822.8613;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-1997.173,1172.674;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-1740.311,1062.754;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1594.981,1034.175;Inherit;True;Property;_DistortionMap;DistortionMap;6;0;Create;True;0;0;False;0;-1;None;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;56;-1309.315,1034.515;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1106.315,1038.515;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;2,2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1031.932,1151.114;Inherit;False;Property;_DistortionAmount;DistortionAmount;11;0;Create;True;0;0;False;0;1;32.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;89;-1855.103,-1787.028;Inherit;False;2221.743;858.0756;Comment;14;103;104;24;23;100;98;99;97;110;105;95;109;91;90;Reflection;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;58;-974.3149,1037.515;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;-808.5734,1038.527;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;90;-1776.927,-1353.22;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-654.1876,1030.757;Inherit;False;uvdist;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-1990.734,267.3057;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;91;-1589.547,-1352.236;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;105;-1111.436,-1344.9;Inherit;False;59;uvdist;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-1908.85,516.3738;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-1855.734,263.3057;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1036.803,-1234.671;Inherit;False;Constant;_Float3;Float 3;18;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;95;-1386.814,-1354.404;Inherit;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1603.63,727.3255;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-862.603,-1285.371;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;97;-1148.73,-1428.441;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;6;-3218.677,-619.0596;Inherit;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;1,1,1,1;1,0.9952829,0.9952829,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;13;-1557.45,-594.0984;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1992.078,-278.6262;Inherit;True;Property;_MainTex;MainTex;5;0;Create;True;0;0;False;0;57713af7e82cc3d4587c9c04e7ff1b7e;3d7a81a2f2fe5fb4da76977baa4f9987;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1668.957,228.0297;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;98;-1159.897,-1152.425;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-1095.112,-856.8833;Inherit;False;59;uvdist;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;14;-1320.977,-591.4106;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;-2975.468,-617.5145;Inherit;False;color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;35;-1383.208,535.6098;Inherit;True;Property;_TextureSample4;Texture Sample 4;13;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;99;-771.9868,-1424.325;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;33;-1366.41,317.384;Inherit;True;Property;_TextureSample3;Texture Sample 3;13;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-1094.465,-740.738;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-2400.599,1814.33;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;66;-1882.36,-46.34466;Inherit;False;59;uvdist;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2243.67,2085.785;Inherit;False;Property;_BlendAlpha;BlendAlpha;13;0;Create;True;0;0;False;0;1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeGrabScreenPosHlpNode;12;-1067.14,-591.5256;Inherit;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1898.06,53.6149;Inherit;False;Constant;_Float2;Float 2;14;0;Create;True;0;0;False;0;0.001;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-906.9778,-809.1859;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1024.837,718.9946;Inherit;False;Property;_FoamStrength;FoamStrength;10;0;Create;True;0;0;False;0;0;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-1045.16,422.0799;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-1037.08,635.1017;Inherit;False;39;color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;100;-629.324,-1168.801;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1694.226,1.35272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-777.3168,538.2394;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;23;-469.1769,-1441.969;Inherit;True;Property;_ReflectionTex;ReflectionTex;17;1;[HideInInspector];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-772.3121,-611.1237;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;22;-2140.448,1796.787;Inherit;True;Property;_Mask;Mask;7;0;Create;True;0;0;False;0;-1;c10208ed108e7f74f9359225f20b299b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-320.355,-1203.387;Inherit;False;Property;_RefIntensity;RefIntensity;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;115;-1931.63,2091.633;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1372.083,117.6114;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-119.3894,-1308.591;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-1418.554,-161.4497;Inherit;False;Property;_NormalStrength;NormalStrength;4;0;Create;True;0;0;False;0;0;23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;68;-1462.439,-41.20425;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-623.866,-753.0118;Inherit;False;39;color;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-1792.772,1898.358;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1922.122,1681.923;Inherit;False;Property;_CutOff;CutOff;12;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-1369.554,-246.4497;Inherit;False;Property;_NormalSharpness;NormalSharpness;3;0;Create;True;0;0;False;0;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;43;-624.8699,533.7167;Inherit;False;Foam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;15;-629.8831,-609.7849;Inherit;False;Global;_GrabScreen0;Grab Screen 0;3;0;Create;True;0;0;False;0;Object;-1;False;True;1;0;FLOAT4;0,0,0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-407.6972,-699.6016;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-346.3848,-458.8659;Inherit;False;43;Foam;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;44;-1132.182,-315.9353;Inherit;True;NormalCreate;8;;9;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;55.99439,-1409.254;Float;False;Reflection;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;4;-1129.509,-24.38832;Inherit;True;NormalCreate;8;;10;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;48;-1634.672,1770.645;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-218.6189,-317.5927;Inherit;False;103;Reflection;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;70;-825.6501,-128.499;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;74;-132.9638,-696.9613;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-1012.855,1774.566;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;81;-793.017,1777.86;Inherit;False;alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;40.4534,-457.4893;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-556.1423,-135.1163;Inherit;False;normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;85;488.9344,-529.5615;Inherit;False;Property;_Spec;Spec;1;0;Create;True;0;0;False;0;0;0.959;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;598.6044,-306.2635;Inherit;False;81;alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;587.2045,-418.5988;Inherit;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;72;537.9146,-634.8068;Inherit;False;71;normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;114;380.2291,-201.6099;Inherit;False;Property;_SpecColor;SpecColor;2;1;[HDR];Fetch;True;0;0;True;0;0,0,0,0;1.292038,1.492826,1.601825,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;25;195.2841,-595.9601;Inherit;False;Property;_USE_REFLECTION;Use Reflection;15;0;Create;False;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;794.3071,-715.5553;Float;False;True;-1;2;ASEMaterialInspector;0;0;BlinnPhong;FX/WaterStreamV2;False;False;False;False;False;False;False;False;False;False;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;2;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;21;0
WireConnection;27;1;26;1
WireConnection;28;1;27;0
WireConnection;55;0;28;0
WireConnection;55;1;54;0
WireConnection;2;1;55;0
WireConnection;56;0;2;0
WireConnection;57;0;56;0
WireConnection;58;0;57;0
WireConnection;107;0;58;0
WireConnection;107;1;18;0
WireConnection;59;0;107;0
WireConnection;30;0;27;0
WireConnection;91;0;90;0
WireConnection;29;1;30;0
WireConnection;95;0;91;0
WireConnection;36;0;32;0
WireConnection;36;1;28;0
WireConnection;110;0;105;0
WireConnection;110;1;109;0
WireConnection;97;0;95;0
WireConnection;34;0;32;0
WireConnection;34;1;29;0
WireConnection;98;0;95;0
WireConnection;14;0;13;0
WireConnection;39;0;6;0
WireConnection;35;0;3;0
WireConnection;35;1;36;0
WireConnection;99;0;97;0
WireConnection;99;1;110;0
WireConnection;33;0;3;0
WireConnection;33;1;34;0
WireConnection;12;0;14;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;37;0;33;0
WireConnection;37;1;35;0
WireConnection;100;0;99;0
WireConnection;100;1;98;0
WireConnection;67;0;66;0
WireConnection;67;1;64;0
WireConnection;41;0;37;0
WireConnection;41;1;42;0
WireConnection;41;2;19;0
WireConnection;23;1;100;0
WireConnection;63;0;61;0
WireConnection;63;1;12;0
WireConnection;22;1;31;0
WireConnection;115;0;20;0
WireConnection;69;0;67;0
WireConnection;69;1;36;0
WireConnection;104;0;23;0
WireConnection;104;1;24;0
WireConnection;68;0;67;0
WireConnection;68;1;34;0
WireConnection;45;0;22;1
WireConnection;45;1;115;0
WireConnection;43;0;41;0
WireConnection;15;0;63;0
WireConnection;16;0;40;0
WireConnection;16;1;15;0
WireConnection;44;1;3;0
WireConnection;44;2;68;0
WireConnection;44;3;87;0
WireConnection;44;4;88;0
WireConnection;103;0;104;0
WireConnection;4;1;3;0
WireConnection;4;2;69;0
WireConnection;4;3;87;0
WireConnection;4;4;88;0
WireConnection;48;0;17;0
WireConnection;48;1;45;0
WireConnection;70;0;44;0
WireConnection;70;1;4;0
WireConnection;74;0;16;0
WireConnection;74;1;73;0
WireConnection;49;0;48;0
WireConnection;49;1;45;0
WireConnection;81;0;49;0
WireConnection;113;0;74;0
WireConnection;113;1;108;0
WireConnection;71;0;70;0
WireConnection;25;0;113;0
WireConnection;0;0;74;0
WireConnection;0;1;72;0
WireConnection;0;2;25;0
WireConnection;0;3;85;0
WireConnection;0;4;5;0
WireConnection;0;9;82;0
ASEEND*/
//CHKSM=BAB705E1F370A7A44FA4EE82DDA5B89FCCB6FA9B