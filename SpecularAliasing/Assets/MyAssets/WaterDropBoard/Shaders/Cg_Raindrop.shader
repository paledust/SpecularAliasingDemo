Shader "FX/LeakingDrop" {
	Properties {
		_MaskClip("MaskClip", Range(0,1)) = 0
		_MaskTex("Area Mask", 2D) = "White" {}
		_Color("Tint", Color) = (1,1,1,1)
		[HDR]_Spec("Specular", Color) = (0,0,0,1)
		
		_FallingTogether("Noise", Range(0,2)) = 1
		_TileX("TileX", Float) = 1
		_TileY("TileY", Float) = 1
		_TileLayerStatic("Tile Layer Static", Float) = 1
		_TileLayer1("Tile Layer 1", Float) = 1
		_TileLayer2("Tile Layer 2", Float) = 1

		_DropTexture ("Drop Texture", 2D) = "white" {}
		_DistortionTex("Distortion Texture", 2D) = "black"{}
		_DistortionScale("Distortion Scale", Float) = 1
		_TrailZoom("Trail Zoom", Float) = 1
		_DropWobbleStrength("Wobble Curve Amount", Range(0,100)) = 1
		_WaterTrailScale("Water Trail Scale", Range(0,1)) = 1

		[Toggle(USE_TIME_OUTSIDE)]_UseTime("Use Time Setting Outside", Float) = 0
		_UpdateTime("Updated Time", Float) = 0

		_Angle("Rain Move Angle", Range(0,360)) = 0
		_Blend("Blend Amount", Range(0,1)) = 0
		_Distortion("Distortion Amount", Range(0,10)) = 1
		_Zoom("Zoom", Float) = 1
		_RainAmount("Rain Amount", Range(0,10)) = 1
		_Speed("Animation Speed", Float) = 1
		_TrailSpeed("Trail Speed", Float) = 1
		[Toggle(USE_2ND_MAP)]
		_UseSecMap("Use 2nd Texture Channel", Range(0,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "LightMode"="ForwardBase"}
		LOD 200


		GrabPass{
			"_GP"
		}

		Pass{
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature USE_2ND_MAP
			#pragma shader_feature USE_TIME_OUTSIDE
			#pragma shader_feature USE_TRANSPARENT

			#include "UnityCG.cginc"

			sampler2D _GP;
			sampler2D _MaskTex;
			sampler2D _DropTexture;
			sampler2D _DistortionTex;

			fixed4 _MaskTex_ST;
			fixed4 _GP_ST;
			fixed4 _Color;
			fixed4 _Spec;
			fixed _TileX;
			fixed _TileY;
			fixed _TileLayer1;
			fixed _TileLayer2;

			fixed _Angle;
			fixed _DropWobbleStrength;
			fixed _WaterTrailScale;
			fixed _Distortion;
			fixed _Zoom;
			fixed _RainAmount;
			fixed _RainAmountOffset;
			fixed _UpdateTime;
			fixed _Speed;
			fixed _Blend;
			fixed _MaskClip;
			fixed _TrailZoom;
			fixed _TrailSpeed;
			fixed _DistortionScale;
			fixed _TileLayerStatic;
			fixed _FallingNoise;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord2 : TEXCOORD1;
			};	
			
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 uvgrab : TEXCOORD1;
				float4 worldPos : TEXCOORD2;
				float4 color: COLOR;
				float4 pos : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
			#ifdef USE_2ND_MAP
				o.uv = v.texcoord2;
			#else
				o.uv = v.texcoord;
			#endif
				o.color = _Color;
				o.uvgrab = ComputeGrabScreenPos(o.pos);
				return o;
			}
			
			#define S(a, b, t) smoothstep(a, b, t)

			float3 N13(float p) {
				//  from DAVE HOSKINS
				float3 p3 = frac(float3(p, p, p) * float3(.1031, .11369, .13787));
				p3 += dot(p3, p3.yzx + 19.19);
				return frac(float3((p3.x + p3.y)*p3.z, (p3.x + p3.z)*p3.y, (p3.y + p3.z)*p3.x));
			}

			float4 N14(float t) {
				return frac(sin(t*float4(123., 1024., 1456., 264.))*float4(6547., 345., 8799., 1564.));
			}
			float N(float t) {
				return frac(sin(t*12345.564)*7658.76);
			}

			float Saw(float b, float t) {
				return S(0., b, t)*S(1., b, t);
			}

			float2 DropLayer2(float2 uv, float t) {
				float2 UV = uv;

				float angle = radians(_Angle);
				float2x2 rotMatrix = float2x2(cos(angle),-sin(angle),
											  sin(angle),cos(angle));
				uv += mul(rotMatrix, float2(0,t*.75));

				// uv.y += t*0.75;
				float2 a = float2(6., 1.);
				float2 grid = a*2.;
				float2 id = floor(uv*grid);

				float colShift = N(id.x);

				uv += mul(rotMatrix, float2(0,colShift));
				uv.y += colShift;

				id = floor(uv*grid);
				float3 n = N13(id.x*35.2 + id.y*2376.1);
				float2 st = frac(uv*grid) - float2(.5, 0);

				float x = n.x - .5;

				float y = UV.y*20.;
				float wiggle = sin(y + sin(y));
				x += wiggle*(.5 - abs(x))*(n.z - .5);
				x *= .7;
				float fallingNoise = N13(id.x*35.2 + id.y*2376.1 * _FallingNoise);
				float ti = frac(t + fallingNoise);
				y = (Saw(.85, ti) - .5)*.9 + .5;
				float2 p = float2(x, y);

				float d = length((st - p)*a.yx);

				float mainDrop = S(.4, .0, d);

				float r = sqrt(S(1., y, st.y));
				float cd = abs(st.x - x);
				float trail = S(.23*r, .15*r*r, cd);
				float trailFront = S(-.02, .02, st.y - y);
				trail *= trailFront*r*r;

				y = UV.y;
				float2 noiseUV = floor(UV*12);

				float trail2 = S(.2*r, .0, cd);
				float droplets = max(0., (sin(y*(1. - y)*120.) - st.y))*trail2*trailFront*n.z;
				y = frac(y*10.) + (st.y - .5);
				float dd = length(st - float2(x, y + N13(noiseUV.x*107.35+noiseUV.y*3543.654).x));
				droplets = S(.3, 0., dd);
				float m = mainDrop + droplets*r*trailFront;
				
				return float2(m, trail);
			}

			float StaticDrops(float2 uv, float t) {
				uv *= 40.;

				float2 id = floor(uv);
				uv = frac(uv) - .5;
				float3 n = N13(id.x*107.45 + id.y*3543.654);
				float2 p = (n.xy - .5)*.7;
				float d = length(uv - p);

				float fade = Saw(.025, frac(t + n.z));
				float c = S(.3, 0., d)*frac(n.z*10.)*fade;
				return c;
			}

			float2 Drops(float2 uv, float t, float l0, float l1, float l2) {
				float s = StaticDrops(uv*_TileLayerStatic, t)*l0;
				float2 m1 = DropLayer2(uv*_TileLayer1, t)*l1;
				float2 m2 = DropLayer2(uv*1.85*_TileLayer2, t)*l2;

				float c = m1 + m2 + s;
				c = S(.3, 1., c);

				return float2(c, max(m1.y*l0, m2.y*l1));
			}
			fixed3 BlendColor(fixed3 color, fixed blendAmount){
				fixed3 newColor = color * (1-blendAmount) + (color * (blendAmount) * _Blend + (blendAmount) * _Color * (1-_Blend));

				return newColor;
			}

			fixed4 frag(v2f i) : SV_Target{
				fixed2 tile = fixed2(_TileX, _TileY);
				fixed mask = tex2D(_MaskTex, i.uv*_MaskTex_ST.xy + _MaskTex_ST.zw).r;
				fixed time = 0;


				if(mask < _MaskClip){
					mask = 0;
				}

				fixed2 distortion = tex2D(_DistortionTex, (i.uv ) * _DistortionScale).rg;

				#ifdef USE_TIME_OUTSIDE
				time = _UpdateTime;
				#else
				time = _Time.y;
				#endif

				fixed4 drop = tex2D(_DropTexture, (i.uv * tile + fixed2(0,time * (_Speed * _TrailSpeed)/10) + distortion * _DropWobbleStrength/100)*_TrailZoom);
				fixed4 drop_2 = tex2D(_DropTexture, (i.uv * .9 * tile + fixed2(0, (.8*time+.5*sin(time)) * (_Speed * _TrailSpeed)/10 * .7) + distortion * _DropWobbleStrength/200) * _TrailZoom);
				fixed4 drop_3 = tex2D(_DropTexture, (i.uv * .6 * tile + fixed2(.3,.3) + fixed2(0, (.5*time+.3*sin(1.3*time)) * (_Speed * _TrailSpeed)/10 * .7) + distortion * _DropWobbleStrength/250) * _TrailZoom);

				fixed4 trailDistort = (drop + drop_2 * .4 + drop_3);
				trailDistort.a = max(max(drop.a, drop_2.a),drop_3.a);

				fixed2 uv = i.uv;
				uv.x *= 16.0/9.0;
				// for now
				fixed T = time * _Speed;
				fixed t = T*.2;

				fixed rainAmount = 0;

				rainAmount = _RainAmount * mask;			// the rain is where the heart is

				uv *= _Zoom;
				uv *= tile;

				t *= .25;

				fixed staticDrops = S(0, 1., rainAmount)*2.;
				fixed layer1 = S(.25, .75, rainAmount);
				fixed layer2 = S(.0, .5, rainAmount);

				trailDistort *= saturate(rainAmount) * _WaterTrailScale;

				fixed2 c = max(Drops(uv, t, staticDrops, layer1, layer2), trailDistort.a);
				fixed2 e = fixed2(.001, 0.);

				fixed cx = max(Drops(uv + e, t, staticDrops, layer1, layer2).x, trailDistort.a);
				fixed cy = max(Drops(uv + e.yx, t, staticDrops, layer1, layer2).x, trailDistort.a);

				fixed2 n = fixed2(cx - c.x, cy - c.x);		// expensive normals

				fixed4 texCoord = (fixed4(n.x,n.y, 0, 0) + fixed4(trailDistort.rg,0,0)*_WaterTrailScale) * _Distortion;

				fixed4 proj = tex2Dproj(_GP, i.uvgrab + texCoord);

				float3 normal = normalize(float3(n*10,1));
				normal = normal * 2 -1;
				float emission = saturate(dot(normal, UnityWorldSpaceLightDir(i.worldPos)));
				emission = saturate(pow(emission, 1)) * cx;
				

				fixed3 col = BlendColor(proj.rgb, max(cy, trailDistort.a)) + emission*_Spec;
				// return float4(emission.xxx,1);
				#ifdef USE_TRANSPARENT
				return fixed4(col,cx*_Color.a);
				#else
				return fixed4(col,1);
				#endif
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}