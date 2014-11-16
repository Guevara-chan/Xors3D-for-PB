//##########################################
//    mSL
//
// PerPixel Light
//		with 3 Light Source Types
//
// Open Source, for Free Using
// Author: MoKa (Maxim Miheyev)
// Mail: mokadwod@gmail.com
// Visit: RubuX.net
//##########################################


//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4 MatWorld;

// Light
const float3 AmbientClr;		// Ambient Color
const float3 LightClr;			// Light Color
const half LightInt;			// Light Intensity

// Positions
float3 PosLight;				// Light Position
float RngLight;					// Light Range
float DotLight;					// Light Soft

// Other
static float3 Color;
static float4 cD;

static float3 nLight;



//##################  Textures  ##################
const texture tDiffuse : TEXTURE_0;			// Diffuse Texture
sampler TexDiffuse=sampler_state {
    Texture   = <tDiffuse>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};


//##################  Input VS  ##################
struct sv_N_TC {
   float4 Position : POSITION0;
   float3 Normal : NORMAL;
   float2 TexCoords : TEXCOORD0;
};
//##################  Output VS  ##################
struct sp_PW_N_TC {
	float4 Position : POSITION0;
	float4 pWorld : TEXCOORD0;
	float3 Normal : TEXCOORD1;
	float2 TexCoords : TEXCOORD2;
};


//##################  VS  ##################
void vs_PW_N_TC( in sv_N_TC IN, out sp_PW_N_TC OUT ) {
	OUT.Position	= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld		= mul(IN.Position,MatWorld);
	OUT.Normal		= normalize(mul(IN.Normal,MatWorld));
	OUT.TexCoords	= IN.TexCoords;
}

//##################  PS  ##################
float4 psDirectional( in sp_PW_N_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	
	nLight		= saturate(dot(normalize(PosLight),IN.Normal));
	
	Color		= cD.rgb*AmbientClr+(cD.rgb*nLight*LightClr*LightInt);
	
	return float4(Color,cD.a);
}
float4 psPoint( in sp_PW_N_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	
	PosLight	= normalize(PosLight-IN.pWorld);
	nLight		= saturate(dot(PosLight,IN.Normal));
	
	Color		= cD.rgb*AmbientClr+(cD.rgb*nLight*LightClr*LightInt);
	
	return float4(Color,cD.a);
}
float4 psPointDistance( in sp_PW_N_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	Color		= cD.rgb*AmbientClr;
	
	RngLight	= pow(saturate(1.0f-(distance(IN.pWorld,PosLight)/RngLight)),DotLight);
	if (RngLight>0.0f) {
		PosLight	= normalize(PosLight-IN.pWorld);
		nLight		= saturate(dot(PosLight,IN.Normal));
		
		Color		+=cD.rgb*nLight*LightClr*LightInt*RngLight;
	}
	
	return float4(Color,cD.a);
}


//##################  Technique  ##################
technique Directional {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N_TC();
		pixelshader		= compile ps_2_0 psDirectional();
	}
}
technique Point {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N_TC();
		pixelshader		= compile ps_2_0 psPoint();
	}
}
technique PointDistance {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N_TC();
		pixelshader		= compile ps_2_0 psPointDistance();
	}
}
