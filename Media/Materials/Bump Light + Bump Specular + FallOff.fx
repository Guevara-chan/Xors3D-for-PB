//##########################################
//    mSL
//
// Bump Light + Specular + FallOff
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
const half LightDot;			// Light Soft
const float3 FallOffClr;		// FallOff Color
const half FallOffInt;			// FallOff Intensity
const float FallOffSoft;		// FallOff Soft
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
static float3 cN;
static float3 cS;

static float3 nLight;
static float3 nFallOff;
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

const texture tNormal;			// NormalMap Texture
sampler TexNormal=sampler_state {
    Texture   = <tNormal>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

const texture tSpecular;		// SpecularMap Texture
sampler TexSpecular=sampler_state {
    Texture   = <tSpecular>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};


//##################  Input VS  ##################
struct sv_TBN_TC {
	float4 Position		: POSITION0;
	float3 Tangent		: TANGENT;
	float3 Binormal		: BINORMAL;
	float3 Normal		: NORMAL;
	float2 TexCoords	: TEXCOORD0;
};
//##################  Output VS  ##################
struct sp_PW_TBN_TC {
	float4 Position		: POSITION0;
	float4 pWorld		: TEXCOORD0;
	float3 Tangent		: TEXCOORD1;
	float3 Binormal		: TEXCOORD2;
	float3 Normal		: TEXCOORD3;
	float2 TexCoords	: TEXCOORD4;
};


//##################  VS  ##################
void vs_PW_TBN_TC( in sv_TBN_TC IN, out sp_PW_TBN_TC OUT ) {
	OUT.Position	= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld		= mul(IN.Position,MatWorld);
	OUT.Tangent		= normalize(mul(IN.Tangent,MatWorld));
	OUT.Binormal	= normalize(mul(IN.Binormal,MatWorld));
	OUT.Normal		= normalize(mul(IN.Normal,MatWorld));
	OUT.TexCoords	= IN.TexCoords;
}

//##################  PS  ##################
float4 psDirectional( in sp_PW_TBN_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	cS			= tex2D(TexSpecular,IN.TexCoords);
	
	cN			= normalize(tex2D(TexNormal,IN.TexCoords)*2.0f-1.0f);
	
	PosLight	= normalize(PosLight);
	PosCam		= normalize(PosCam-IN.pWorld);
	
	nLight		= float3(dot(PosLight,IN.Tangent),
						dot(PosLight,IN.Binormal),dot(PosLight,IN.Normal));
	
	nFallOff	= pow(1.0f-saturate(dot(PosCam,IN.Normal)),FallOffSoft);
	
	nSpec		= normalize(PosLight+PosCam);
	nSpec		= float3(dot(nSpec,IN.Tangent),
						dot(nSpec,IN.Binormal),dot(nSpec,IN.Normal));
	
	nLight		= pow(max(dot(cN,nLight),0.0f),0.8f);
	nSpec		= pow(max(dot(cN,nSpec),0.0f),SpecRng);
	
	Color		= cD.rgb*AmbientClr + cD.rgb*nLight*LightClr*LightInt + cS*nSpec*SpecClr*SpecInt;
	
	Color		+= Color*cS*nFallOff*FallOffClr*FallOffInt;
	
	return float4(Color,cD.a);
}

float4 psPoint( in sp_PW_TBN_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	cS			= tex2D(TexSpecular,IN.TexCoords);
	
	cN			= normalize(tex2D(TexNormal,IN.TexCoords)*2.0f-1.0f);
	
	PosLight	= normalize(PosLight-IN.pWorld);
	PosCam		= normalize(PosCam-IN.pWorld);
	
	nLight		= float3(dot(PosLight,IN.Tangent),
						dot(PosLight,IN.Binormal),dot(PosLight,IN.Normal));
	
	nFallOff	= pow(1.0f-saturate(dot(PosCam,IN.Normal)),FallOffSoft);
	
	nSpec		= normalize(PosLight+PosCam);
	nSpec		= float3(dot(nSpec,IN.Tangent),
						dot(nSpec,IN.Binormal),dot(nSpec,IN.Normal));
	
	nLight		= pow(max(dot(cN,nLight),0.0f),0.8f);
	nSpec		= pow(max(dot(cN,nSpec),0.0f),SpecRng);
	
	Color		= cD.rgb*AmbientClr + cD.rgb*nLight*LightClr*LightInt + cS*nSpec*SpecClr*SpecInt;
	
	Color		+= Color*cS*nFallOff*FallOffClr*FallOffInt;
	
	return float4(Color,cD.a);
}

float4 psPointDistance( in sp_PW_TBN_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	cS			= tex2D(TexSpecular,IN.TexCoords);
	Color		= cD.rgb*AmbientClr;
	
	PosCam		= normalize(PosCam-IN.pWorld);
	nFallOff	= pow(1.0f-saturate(dot(PosCam,IN.Normal)),FallOffSoft);
	
	RngLight	= pow(saturate(1.0f-(distance(IN.pWorld,PosLight)/RngLight)),SpecDot);
	if (RngLight>0.0f) {
		cN			= normalize(tex2D(TexNormal,IN.TexCoords)*2.0f-1.0f);
		
		PosLight	= normalize(PosLight-IN.pWorld);
		nLight		= float3(dot(PosLight,IN.Tangent),
							dot(PosLight,IN.Binormal),dot(PosLight,IN.Normal));
		
		nSpec		= normalize(PosLight+PosCam);
		nSpec		= float3(dot(nSpec,IN.Tangent),
							dot(nSpec,IN.Binormal),dot(nSpec,IN.Normal));
		
		nLight		= pow(max(dot(cN,nLight),0.0f),0.8f);
		nSpec		= pow(max(dot(cN,nSpec),0.0f),SpecRng);
		
		Color		+= cD.rgb*nLight*LightClr*LightInt*RngLight + cS*nSpec*SpecClr*SpecInt*RngLight;
	}
	
	Color		+= Color*cS*nFallOff*FallOffClr*FallOffInt;
	
	return float4(Color,cD.a);
}


//##################  Technique  ##################
technique Directional {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_TBN_TC();
		pixelshader		= compile ps_2_0 psDirectional();
	}
}
technique Point {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_TBN_TC();
		pixelshader		= compile ps_2_0 psPoint();
	}
}
technique PointDistance {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_TBN_TC();
		pixelshader		= compile ps_2_0 psPointDistance();
	}
}
