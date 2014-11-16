//##########################################
//    mSL
//
// Bump Light
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
static float3 cN;

static float3 nLight;



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


//##################  Input VS  ##################
struct sv_TBN_TC {
    float4 Position	: POSITION0;
	float3 Normal : NORMAL;
	float3 Tangent : TANGENT;
	float3 Binormal : BINORMAL;
	float2 TexCoords : TEXCOORD0;
};
//##################  Output VS  ##################
struct sp_PW_TBN_TC {
    float4 Position	: POSITION0;
	float4 pWorld : TEXCOORD0;
	float2 TexCoords : TEXCOORD1;
	float3 Normal : TEXCOORD2;
	float3 Tangent : TEXCOORD3;
	float3 Binormal : TEXCOORD4;
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
	cN			= normalize(tex2D(TexNormal,IN.TexCoords)*2.0f-1.0f);
	
	PosLight	= normalize(PosLight);
	nLight		= float3(dot(PosLight,IN.Tangent),
						dot(PosLight,IN.Binormal),dot(PosLight,IN.Normal));
	
	nLight		= pow(max(dot(cN,nLight),0.0f),0.8f);
	
	Color		= cD.rgb*AmbientClr+(cD*nLight*LightClr*LightInt);
	
	return float4(Color,cD.a);
}
float4 psPoint( in sp_PW_TBN_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	cN			= normalize(tex2D(TexNormal,IN.TexCoords)*2.0f-1.0f);
	
	PosLight	= normalize(PosLight-IN.pWorld);
	nLight		= float3(dot(PosLight,IN.Tangent),
						dot(PosLight,IN.Binormal),dot(PosLight,IN.Normal));
	
	nLight		= pow(max(dot(cN,nLight),0.0f),0.8f);
	
	Color		= cD.rgb*AmbientClr+(cD*nLight*LightClr*LightInt);
	
	return float4(Color,cD.a);
}
float4 psPointDistance( in sp_PW_TBN_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	Color		= cD.rgb*AmbientClr;
	
	RngLight	= pow(saturate(1.0f-(distance(IN.pWorld,PosLight)/RngLight)),DotLight);
	if (RngLight>0.0f) {
		cN			= normalize(tex2D(TexNormal,IN.TexCoords)*2.0f-1.0f);
		
		PosLight	= normalize(PosLight-IN.pWorld);
		nLight		= float3(dot(PosLight,IN.Tangent),
							dot(PosLight,IN.Binormal),dot(PosLight,IN.Normal));
		
		nLight		= pow(max(dot(cN,nLight),0.0f),0.8f);
		Color		+=cD.rgb*nLight*LightClr*LightInt*RngLight;
	}
	
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
