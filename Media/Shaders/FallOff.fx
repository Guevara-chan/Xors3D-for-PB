//##########################################
//    mSL
//
// FallOff
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
const float3 FallOffClr;		// FallOff Color
const half FallOffInt;			// FallOff Intensity
const float FallOffSoft;		// FallOff Soft

// Positions
float4 PosCam;					// Camera Position

// Other
static float3 Color;
static float4 cD;

static float3 nFallOff;



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
float4 psNormal( in sp_PW_N_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords);
	
	PosCam		= normalize(PosCam-IN.pWorld);
	nFallOff	= pow(1.0f-saturate(dot(PosCam,IN.Normal)),FallOffSoft);
	
	Color		= cD.rgb+(nFallOff*FallOffClr*FallOffInt);
	
	return float4(Color,cD.a);
}


//##################  Technique  ##################
technique Normal {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N_TC();
		pixelshader		= compile ps_2_0 psNormal();
	}
}
