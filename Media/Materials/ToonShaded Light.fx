//##########################################
//    mSL
//
// Toon Shading
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
const float4 AmbientClr;		// Ambient Color
const float4 LightClr;			// Light Color
const float4 CountourClr;		// Contour Color
const half CountourWidth;		// Contour Width

// Positions
float4 PosLight;				// Light Position
float RngLight;					// Light Range
float4 PosCam;					// Camera Position

// Other
static float4 Color;
static float cTS;

static float nLight;
static float nCam;



//##################  Textures  ##################
const texture tToonGradient;		// Toon Gradient Texture
sampler1D TexToonGradient=sampler_state {
    Texture   = <tToonGradient>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};


//##################  Input VS  ##################
struct sv_N {
   float4 Position : POSITION0;
   float3 Normal : NORMAL;
};
//##################  Output VS  ##################
struct sp_PW_N {
	float4 Position : POSITION0;
	float4 pWorld : TEXCOORD0;
	float3 Normal : TEXCOORD1;
};


//##################  VS  ##################
void vs_PW_N( in sv_N IN, out sp_PW_N OUT ) {
	OUT.Position	= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld		= mul(IN.Position,MatWorld);
	OUT.Normal		= normalize(mul(IN.Normal,MatWorld));
}

//##################  PS  ##################
float4 psDirectional( in sp_PW_N IN ) : COLOR {
	PosLight	= normalize(PosLight);
	PosCam		= normalize(PosCam-IN.pWorld);
	
	nLight		= saturate(dot(PosLight,IN.Normal));
	nCam		= normalize(dot(PosCam,IN.Normal)-CountourWidth);
	
	cTS			= tex1D(TexToonGradient,nLight).r;
	
	Color		= (AmbientClr*(1.0f-cTS)+(cTS*LightClr))*nCam+((1.0f-nCam)*CountourClr);
	
	return float4(Color.rgb,1.0f);
}

float4 psPoint( in sp_PW_N IN ) : COLOR {
	PosLight	= normalize(PosLight-IN.pWorld);
	PosCam		= normalize(PosCam-IN.pWorld);
	
	nLight		= saturate(dot(PosLight,IN.Normal));
	nCam		= normalize(dot(PosCam,IN.Normal)-CountourWidth);
	
	cTS			= tex1D(TexToonGradient,nLight).r;
	
	Color		= (AmbientClr*(1.0f-cTS)+(cTS*LightClr))*nCam+((1.0f-nCam)*CountourClr);
	
	return float4(Color.rgb,1.0f);
}

float4 psPointDistance( in sp_PW_N IN ) : COLOR {
	RngLight	= saturate(1.0f-(distance(IN.pWorld,PosLight)/RngLight));
	if (RngLight>0.0f) {
		PosLight	= normalize(PosLight-IN.pWorld);
		
		nLight		= saturate(dot(PosLight,IN.Normal)*pow(RngLight,.1));
		
		cTS			= tex1D(TexToonGradient,nLight).r;
		
		Color		= AmbientClr*(1.0f-cTS)+(cTS*LightClr);
	} else {
		Color		= AmbientClr;
	}
	
	PosCam		= normalize(PosCam-IN.pWorld);
	nCam		= normalize(dot(PosCam,IN.Normal)-CountourWidth);
	
	Color		= Color*nCam+(1.0f-nCam)*CountourClr;
	
	return float4(Color.rgb,1.0f);
}


//##################  Technique  ##################
technique Directional {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N();
		pixelshader		= compile ps_2_0 psDirectional();
	}
}
technique Point {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N();
		pixelshader		= compile ps_2_0 psPoint();
	}
}
technique PointDistance {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N();
		pixelshader		= compile ps_2_0 psPointDistance();
	}
}
