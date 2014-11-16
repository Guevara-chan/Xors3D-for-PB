//##########################################
//    mSL
//
// Refraction
//
// Open Source, for Free Using
// Author: MoKa (Maxim Miheyev)
// Mail: mokadwod@gmail.com
// Visit: RubuX.net
//##########################################


//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4 MatWorld;

// FallOff
const float3 FallOffClr;		// FallOff Color
const half FallOffInt;			// FallOff Intensity
const float FallOffSoft;		// FallOff Soft

// Refract
const float Refract;			// Refraction Intensity

// Positions
float3 PosCamera;				// Camera Position

// Other
static float3 Color;
static float3 cN;
static float3 cS;
static float cFO;

static float3 nCamera;


//##################  Textures  ##################
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
const texture tScreen;			// Screen Texture
sampler TexScreen=sampler_state {
    Texture   = <tScreen>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
    ADDRESSW  = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};


//###############  Input VS  ###############
struct sv_N_TC {
    float4 Position	: POSITION0;
	float3 Normal : NORMAL;
	float2 TexCoords : TEXCOORD0;
};
struct sv_TBN_TC {
    float4 Position	: POSITION0;
	float3 Tangent : TANGENT;
	float3 Binormal : BINORMAL;
	float3 Normal : NORMAL;
	float2 TexCoords : TEXCOORD0;
};
//###############  Output VS  ##############
struct sp_PW_N_TC_TP {
    float4 Position	: POSITION0;
	float4 pWorld : TEXCOORD0;
	float3 Normal : TEXCOORD1;
	float2 TexCoords : TEXCOORD2;
	float3 TexProj : TEXCOORD3;
};
struct sp_PW_TBN_TC_TP {
    float4 Position	: POSITION0;
	float4 pWorld : TEXCOORD0;
	float3 Tangent : TEXCOORD1;
	float3 Binormal : TEXCOORD2;
	float3 Normal : TEXCOORD3;
	float2 TexCoords : TEXCOORD4;
	float3 TexProj : TEXCOORD5;
};


//##################  VS  ##################
void vs_PW_N_TC_TP( in sv_N_TC IN, out sp_PW_N_TC_TP OUT ) {
	OUT.Position		= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld			= mul(IN.Position,MatWorld);
	OUT.Normal			= normalize(mul(IN.Normal,MatWorld));
	OUT.TexCoords		= IN.TexCoords;
	OUT.TexProj.x		= 0.5f*(OUT.Position.w+OUT.Position.x);
	OUT.TexProj.y		= 0.5f*(OUT.Position.w-OUT.Position.y);
	OUT.TexProj.z		= OUT.Position.w;
}
void vs_PV_TBN_TC_TP( in sv_TBN_TC IN, out sp_PW_TBN_TC_TP OUT ) {
	OUT.Position		= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld			= mul(IN.Position,MatWorld);
	OUT.Normal			= normalize(mul(IN.Normal,MatWorld));
	OUT.Tangent			= normalize(mul(IN.Tangent,MatWorld));
	OUT.Binormal		= normalize(mul(IN.Binormal,MatWorld));
	OUT.TexCoords		= IN.TexCoords;
	OUT.TexProj.x		= 0.5f*(OUT.Position.w+OUT.Position.x);
	OUT.TexProj.y		= 0.5f*(OUT.Position.w-OUT.Position.y);
	OUT.TexProj.z		= OUT.Position.w;
}


//##################  PS  ##################
float4 psRefraction( in sp_PW_N_TC_TP IN ) : COLOR {
	PosCamera	= normalize(PosCamera-IN.pWorld);
	
	cS			= tex2D(TexScreen,(IN.TexProj.xy/IN.TexProj.z)+(refract(PosCamera,IN.Normal,0.5f)*Refract));
	cFO			= pow((1.0f-max(dot(PosCamera,IN.Normal),0.0f)),FallOffSoft)*FallOffInt;
	
	Color		= cS*(1.0f-cFO)+cFO*FallOffClr;
	return float4(Color,1.0f);
}
float4 psRefractionNM( in sp_PW_TBN_TC_TP IN ) : COLOR {
	cN			= normalize(tex2D(TexNormal,IN.TexCoords)*2.0f-1.0f);
	
	PosCamera	= normalize(PosCamera-IN.pWorld);
	
	cS			= tex2D(TexScreen,(IN.TexProj.xy/IN.TexProj.z)+cN.xy*Refract);
	
	nCamera		= normalize(float3(dot(PosCamera,IN.Tangent),
						dot(PosCamera,IN.Binormal),dot(PosCamera,IN.Normal)));
	
	cFO			= pow((1.0f-max(dot(cN,nCamera),0.0f)),FallOffSoft)*FallOffInt;
	
	Color		= cS*(1.0f-cFO)+cFO*FallOffClr;
	return float4(Color,1.0f);
}


//##############  Technique  ###############
technique Refraction {		// Simple Refraction
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_3_0 vs_PW_N_TC_TP();
		pixelshader		= compile ps_3_0 psRefraction();
	}
}
technique RefractionNM {	// Refraction with Normal Mapping
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_3_0 vs_PV_TBN_TC_TP();
		pixelshader		= compile ps_3_0 psRefractionNM();
	}
}
