// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fire"
{
	Properties
	{
		_EdgeLength ( "Edge length", Range( 2, 50 ) ) = 15
		_Color0("Color 0", Color) = (1,0.4028269,0,0)
		_Exp("Exp", Float) = 0.84
		_Scale("Scale", Float) = 7
		_Vector0("Vector 0", Vector) = (0,1,0,0)
		_SpeedFire("Speed Fire", Float) = 0.1
		_SpeedAngleUV("Speed Angle UV", Float) = 1
		_Ola("Ola", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Scale;
		uniform float _SpeedAngleUV;
		uniform float2 _Vector0;
		uniform float _SpeedFire;
		uniform float _Exp;
		uniform float _Ola;
		uniform float4 _Color0;
		uniform float _EdgeLength;


		float2 voronoihash1( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi1( float2 v, float time, inout float2 id, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mr = 0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash1( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = g - f + o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F2 - F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, _EdgeLength);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float time1 = ( _Time.y * _SpeedAngleUV );
			float mulTime15 = _Time.y * _SpeedFire;
			float2 uv_TexCoord2 = v.texcoord.xy + ( _Vector0 * mulTime15 );
			float2 coords1 = uv_TexCoord2 * _Scale;
			float2 id1 = 0;
			float fade1 = 0.5;
			float voroi1 = 0;
			float rest1 = 0;
			for( int it1 = 0; it1 <2; it1++ ){
			voroi1 += fade1 * voronoi1( coords1, time1, id1,0 );
			rest1 += fade1;
			coords1 *= 2;
			fade1 *= 0.5;
			}//Voronoi1
			voroi1 /= rest1;
			float temp_output_6_0 = pow( voroi1 , _Exp );
			float3 appendResult23 = (float3(0.0 , ( temp_output_6_0 * _Ola ) , 0.0));
			v.vertex.xyz += appendResult23;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float time1 = ( _Time.y * _SpeedAngleUV );
			float mulTime15 = _Time.y * _SpeedFire;
			float2 uv_TexCoord2 = i.uv_texcoord + ( _Vector0 * mulTime15 );
			float2 coords1 = uv_TexCoord2 * _Scale;
			float2 id1 = 0;
			float fade1 = 0.5;
			float voroi1 = 0;
			float rest1 = 0;
			for( int it1 = 0; it1 <2; it1++ ){
			voroi1 += fade1 * voronoi1( coords1, time1, id1,0 );
			rest1 += fade1;
			coords1 *= 2;
			fade1 *= 0.5;
			}//Voronoi1
			voroi1 /= rest1;
			float temp_output_6_0 = pow( voroi1 , _Exp );
			float4 temp_cast_0 = (temp_output_6_0).xxxx;
			o.Emission = ( _Color0 - temp_cast_0 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
790;73;825;599;2886.818;622.653;1.927534;True;False
Node;AmplifyShaderEditor.RangedFloatNode;18;-2262.419,-12.46875;Inherit;False;Property;_SpeedFire;Speed Fire;4;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-2072.088,-12.04724;Inherit;False;1;0;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;13;-2011.312,-232.0462;Inherit;False;Property;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;False;0,1;0,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;3;-2053.692,178.5936;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-1819.276,-92.85168;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2040.942,401.9576;Inherit;False;Property;_SpeedAngleUV;Speed Angle UV;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1627.251,-208.8821;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1532.97,619.3412;Inherit;False;Property;_Scale;Scale;2;0;Create;True;0;0;False;0;False;7;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1587.726,346.7833;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-958.6598,441.9285;Inherit;False;Property;_Exp;Exp;1;0;Create;True;0;0;False;0;False;0.84;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;1;-1210.634,130.632;Inherit;True;0;0;1;2;2;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;7;False;3;FLOAT;0;False;2;FLOAT;0;FLOAT2;1
Node;AmplifyShaderEditor.PowerNode;6;-807.5803,141.3625;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;0.84;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-702.4756,493.5389;Inherit;False;Property;_Ola;Ola;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-538.4283,306.5705;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-794.6144,-177.8153;Inherit;False;Property;_Color0;Color 0;0;0;Create;True;0;0;False;0;False;1,0.4028269,0,0;1,0.4028269,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;22;-988.6899,-152.2397;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;12;-374.6448,35.30415;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-373.7936,262.012;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;Fire;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;15;0;18;0
WireConnection;14;0;13;0
WireConnection;14;1;15;0
WireConnection;2;1;14;0
WireConnection;5;0;3;0
WireConnection;5;1;19;0
WireConnection;1;0;2;0
WireConnection;1;1;5;0
WireConnection;1;2;17;0
WireConnection;6;0;1;0
WireConnection;6;1;16;0
WireConnection;24;0;6;0
WireConnection;24;1;25;0
WireConnection;22;0;1;0
WireConnection;12;0;7;0
WireConnection;12;1;6;0
WireConnection;23;1;24;0
WireConnection;0;2;12;0
WireConnection;0;11;23;0
ASEEND*/
//CHKSM=7C4F6DFB912F7CE6A56157B0E5D7152F65E49700