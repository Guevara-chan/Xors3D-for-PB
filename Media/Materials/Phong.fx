//##########################################
//    mSL
//
// Phong
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
const float3 SpecClr;			// Specular Color
const half SpecInt;				// Specular Intensity
const half SpecDot;				// Specular Soft
const half SpecRng;				// Specular Range

// Positions
float3 PosLight;				// Light Position
float RngLight;					// Light Range
float3 PosCam;					// Camera Position

// Other
static float3 Color;
static float4 cD;

static float3 nSpec;



//##################  Textures  ##################
const texture tDiffuse;			// Diffuse Texture
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
	
	PosLight	= normalize(PosLight);
	PosCam		= normalize(PosCam-IN.pWorld);
	nSpec		= pow(saturate(dot(normalize(PosLight+PosCam),IN.Normal)),SpecRng);
	
	Color		= cD.rgb*AmbientClr+(cD.rgb*nSpec*SpecClr*SpecInt);
	
	return float4(Color,cD.a);
}
float4 psPoint( in sp_PW_N_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	
	PosLight	= normalize(PosLight-IN.pWorld);
	PosCam		= normalize(PosCam-IN.pWorld);
	nSpec		= pow(saturate(dot(normalize(PosLight+PosCam),IN.Normal)),SpecRng);
	
	Color		= cD.rgb*AmbientClr+(cD.rgb*nSpec*SpecClr*SpecInt);
	
	return float4(Color,cD.a);
}
float4 psPointDistance( in sp_PW_N_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	Color		= cD.rgb*AmbientClr;
	
	RngLight	= pow(saturate(1.0f-(distance(IN.pWorld,PosLight)/RngLight)),SpecDot);
	if (RngLight>0.0f) {
		PosLight	= normalize(PosLight-IN.pWorld);
		PosCam		= normalize(PosCam-IN.pWorld);
		nSpec		= pow(saturate(dot(normalize(PosLight+PosCam),IN.Normal)),SpecRng);
		
		Color		+=cD.rgb*nSpec*SpecClr*SpecInt*RngLight;
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
