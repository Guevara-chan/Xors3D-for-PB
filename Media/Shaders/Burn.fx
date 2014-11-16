//##########################################
//    mSL
//
// Burn
//		with 2 Burn Source Types
//
// Open Source, for Free Using
// Author: MoKa (Maxim Miheyev)
// Mail: mokadwod@gmail.com
// Visit: RubuX.net
//##########################################


//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4 MatWorld;

// Burn
float BurnHeight;				// Burn Height
const float BurnHeightInt;		// Burn Height Intensity
const float3 BurnOClr;			// Burn Fire Color
const float3 BurnBClr;			// Burn Smouldering Color
const float BurnOWidth;			// Burn Fire Width
const float BurnBWidth;			// Burn Smouldering Width
const float BurnRWidth;			// Burn After Fire Width

// Positions
float4 SourcePos;				// Source Position
float SourceRng;				// Source Range

// Other
static float3 Color;
static float3 cD;
static float4 cF;
static float cA;

static float Temp1;
static float Temp2;



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

const texture tHeight;			// HeightMap Texture
sampler TexHeight=sampler_state {
    Texture   = <tHeight>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    ADDRESSW  = WRAP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

const texture tFire;			// Fire Diffuse Texture
sampler TexFire=sampler_state {
    Texture   = <tFire>;
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
struct sp_PW_TC {
	float4 Position : POSITION0;
	float4 pWorld : TEXCOORD0;
	float2 TexCoords : TEXCOORD1;
};


//##################  VS  ##################
void vs_PW_TC( in sv_N_TC IN, out sp_PW_TC OUT ) {
	OUT.Position	= mul(IN.Position,MatWorldViewProj);
	OUT.pWorld		= mul(IN.Position,MatWorld);
	OUT.TexCoords	= IN.TexCoords;
}

//##################  PS  ##################
float4 psNormal( in sp_PW_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords).rgb;
	
	Color		= cD;
	
	BurnHeight	= (1.0f-BurnHeight)-BurnHeight*(BurnOWidth+BurnBWidth+BurnRWidth);
	
	cA=1.0f;
	
	if(cA>BurnHeight) {
		cA			= 1.0f-tex2D(TexHeight,IN.TexCoords).r;
		cF			= tex2D(TexFire,IN.TexCoords+cD.rg);
		
		if(cA<BurnHeight+BurnOWidth) {
			Temp1		= saturate((cA-(BurnHeight))/BurnOWidth);
			Temp2		= 1.0f-abs(Temp1/2.0f-1.0f);
			Color		= Color*((1.0f-Temp2)+BurnOClr*Temp2-(Temp1*0.5f));
			cA			= 1.0f;
		} else if(cA<BurnHeight+BurnOWidth+BurnBWidth) {
			Temp1		= saturate((cA-(BurnHeight+BurnOWidth))/BurnBWidth);
			Temp2		= 1.0f-abs(Temp1*2.0f-1.0f);
			Color		= Color*BurnOClr*.5-(float3(1.0f,1.0f,1.0f)-BurnBClr)*Temp2+cF.rgb*(Temp1*0.5f);
			cA			= 1.0f;
		} else if(cA<BurnHeight+BurnOWidth+BurnBWidth+BurnRWidth) {
			Temp1		= saturate((cA-(BurnHeight+BurnOWidth+BurnBWidth))/BurnRWidth);
			Color		= cF.rgb;
			cA			= (1.0f-Temp1)-cF.a*Temp1;
		} else {
			cA			= 0.0f;
		}
	}
	
	return float4(Color.rgb,cA);
}

float4 psPointDistance( in sp_PW_TC IN ) : COLOR {
	cD			= tex2D(TexDiffuse,IN.TexCoords).rgb;
	
	Color		= cD;
	
	cA=1.0f;
	
	SourceRng	= saturate(1.0f-(distance(IN.pWorld,SourcePos)/SourceRng));
	if (SourceRng>0.0f) {
		BurnHeight	= 1.0f-SourceRng;
		BurnHeight	-=(1.0f-SourceRng)*(BurnOWidth+BurnBWidth+BurnRWidth);
		
		if(cA>BurnHeight) {
			cA			= SourceRng-tex2D(TexHeight,IN.TexCoords).r*BurnHeightInt*(1.0f-SourceRng);
			cF			= tex2D(TexFire,IN.TexCoords+cD.rg);
			
			if(cA<BurnHeight+BurnOWidth) {
				Temp1		= saturate((cA-(BurnHeight))/BurnOWidth);
				Temp2		= 1.0f-abs(Temp1/2.0f-1.0f);
				Color		= Color*((1.0f-Temp2)+BurnOClr*Temp2-(Temp1*0.5f));
				cA			= 1.0f;
			} else if(cA<BurnHeight+BurnOWidth+BurnBWidth) {
				Temp1		= saturate((cA-(BurnHeight+BurnOWidth))/BurnBWidth);
				Temp2		= 1.0f-abs(Temp1*2.0f-1.0f);
				Color		= Color*BurnOClr*.5-(float3(1.0f,1.0f,1.0f)-BurnBClr)*Temp2+cF.rgb*(Temp1*0.5f);
				cA			= 1.0f;
			} else if(cA<BurnHeight+BurnOWidth+BurnBWidth+BurnRWidth) {
				Temp1		= saturate((cA-(BurnHeight+BurnOWidth+BurnBWidth))/BurnRWidth);
				Color		= cF.rgb;
				cA			= (1.0f-Temp1)-cF.a*Temp1;
			} else {
				cA			= 0.0f;
			}
		}
	}
	
	return float4(Color.rgb,cA);
}

//##################  Technique  ##################
technique Normal {
	pass p0 {
		AlphaBlendEnable= true;
		vertexshader	= compile vs_2_0 vs_PW_TC();
		pixelshader		= compile ps_2_0 psNormal();
	}
}
technique PointDistance {
	pass p0 {
		AlphaBlendEnable= true;
		vertexshader	= compile vs_2_0 vs_PW_TC();
		pixelshader		= compile ps_2_0 psPointDistance();
	}
}
