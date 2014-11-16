//##########################################
//    mSL
//
// Paint Light
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
const float4 CountourClr;		// Contour Color
const half CountourWidth;		// Contour Width
const float2 TexProjRnd;		// Texture Projective Random Value

// Positions
float4 PosLight;				// Light Position
float RngLight;					// Light Range
float4 PosCam;					// Camera Position

// Other
static float4 Color;
static float4 cD;

static float nLight;
static float nPaint;
static float nCam;



//##################  Textures  ##################
const texture tPaintDark;		// Dark Diffuse Texture
sampler TexPaintDark=sampler_state {
    Texture   = <tPaintDark>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tPaintMedium;		// Medium Diffuse Texture
sampler TexPaintMedium=sampler_state {
    Texture   = <tPaintMedium>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tPaintLight;		// Light Diffuse Texture
sampler TexPaintLight=sampler_state {
    Texture   = <tPaintLight>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};
const texture tPaintWhite;		// White Diffuse Texture
sampler TexPaintWhite=sampler_state {
    Texture   = <tPaintWhite>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
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
struct sp_PW_N_TP {
	float4 Position : POSITION0;
	float4 pWorld : TEXCOORD0;
	float3 Normal : TEXCOORD1;
	float3 TexProj : TEXCOORD2;
};


//##################  VS  ##################
void vs_PW_N_TP( in sv_N IN, out sp_PW_N_TP OUT ) {
	OUT.Position	= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld		= mul(IN.Position,MatWorld);
	OUT.Normal		= normalize(mul(IN.Normal,MatWorld));
	OUT.TexProj.x		= 0.5f*(OUT.Position.w+OUT.Position.x);
	OUT.TexProj.y		= 0.5f*(OUT.Position.w-OUT.Position.y);
	OUT.TexProj.z		= OUT.Position.w;
}

//##################  PS  ##################
float4 psDirectional( in sp_PW_N_TP IN ) : COLOR {
	IN.TexProj.xy	= (IN.TexProj.xy/IN.TexProj.z)+TexProjRnd;
	
	PosLight		= normalize(PosLight);
	PosCam			= normalize(PosCam-IN.pWorld);
	
	nLight			= saturate(dot(PosLight,IN.Normal))*3.0f;
	nCam			= saturate(normalize(dot(PosCam,IN.Normal)-CountourWidth));
	
	cD = tex2D(TexPaintDark,IN.TexProj.xy)*(1.0f-saturate(nLight));
	cD += tex2D(TexPaintMedium,IN.TexProj.xy)*(1.0f-saturate(abs(nLight-1.0f)));
	cD +=tex2D(TexPaintLight,IN.TexProj.xy)*(1.0f-saturate(abs(nLight-2.0f)));
	cD +=tex2D(TexPaintWhite,IN.TexProj.xy)*(saturate(nLight-2.0f));
	
	Color			= cD*nCam+((1.0f-nCam)*CountourClr);
	
	return float4(Color.rgb,1.0f);
}

float4 psPoint( in sp_PW_N_TP IN ) : COLOR {
	IN.TexProj.xy	= (IN.TexProj.xy/IN.TexProj.z)+TexProjRnd;
	
	PosLight		= normalize(PosLight-IN.pWorld);
	PosCam			= normalize(PosCam-IN.pWorld);
	
	nLight			= saturate(dot(PosLight,IN.Normal))*3.0f;
	nCam			= saturate(normalize(dot(PosCam,IN.Normal)-CountourWidth));
	
	cD = tex2D(TexPaintDark,IN.TexProj.xy)*(1.0f-saturate(nLight));
	cD += tex2D(TexPaintMedium,IN.TexProj.xy)*(1.0f-saturate(abs(nLight-1.0f)));
	cD +=tex2D(TexPaintLight,IN.TexProj.xy)*(1.0f-saturate(abs(nLight-2.0f)));
	cD +=tex2D(TexPaintWhite,IN.TexProj.xy)*(saturate(nLight-2.0f));
	
	Color			= cD*nCam+((1.0f-nCam)*CountourClr);
	
	return float4(Color.rgb,1.0f);
}

float4 psPointDistance( in sp_PW_N_TP IN ) : COLOR {
	IN.TexProj.xy	= (IN.TexProj.xy/IN.TexProj.z)+TexProjRnd;
	
	RngLight	= saturate(1.0f-(distance(IN.pWorld,PosLight)/RngLight));
	if (RngLight>0.0f) {
		PosLight		= normalize(PosLight-IN.pWorld);
		
		nLight			= saturate(dot(PosLight,IN.Normal)*RngLight)*3.0f;
		
		cD = tex2D(TexPaintDark,IN.TexProj.xy)*(1.0f-saturate(nLight));
		cD += tex2D(TexPaintMedium,IN.TexProj.xy)*(1.0f-saturate(abs(nLight-1.0f)));
		cD +=tex2D(TexPaintLight,IN.TexProj.xy)*(1.0f-saturate(abs(nLight-2.0f)));
		cD +=tex2D(TexPaintWhite,IN.TexProj.xy)*(saturate(nLight-2.0f));
	} else {
		cD = tex2D(TexPaintDark,IN.TexProj.xy);
	}
	
	PosCam			= normalize(PosCam-IN.pWorld);
	nCam			= saturate(normalize(dot(PosCam,IN.Normal)-CountourWidth));
	
	Color		= cD*nCam+(1.0f-nCam)*CountourClr;
	
	return float4(Color.rgb,1.0f);
}


//##################  Technique  ##################
technique Directional {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N_TP();
		pixelshader		= compile ps_2_0 psDirectional();
	}
}
technique Point {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N_TP();
		pixelshader		= compile ps_2_0 psPoint();
	}
}
technique PointDistance {
	pass p0 {
		AlphaBlendEnable= false;
		vertexshader	= compile vs_2_0 vs_PW_N_TP();
		pixelshader		= compile ps_2_0 psPointDistance();
	}
}
