
//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4 MatView;
const float4x4 MatWorldView;

// Depth
const half dRange;
const float dFar;

float far_clamp = 1;
float d_far = 1000;
float d_focus = 360;
float d_near = 80;
float4 ambient = float4(236.0/255,239.0/255,239.0/255, 1);
float4 diffuse = float4(214.0/255,220.0/255,227.0/255,1);
float4 specular = float4(255.0/255,244.0/255,171.0/255,1);
float n_specular = 7;
float Ka = 0.28;
float Ks = 0.22;
float Kd = 0.64;

float3 lightDir = float3(-0.4,-0.4,0.8);

//##################  Textures  ##################
const texture tDiffuse;
sampler TexDiffuse=sampler_state {
    Texture   = <tDiffuse>;
    AddressU = WRAP;
    AddressV = WRAP;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

const texture tEmissive;
sampler TexDown=sampler_state {
    Texture   = <tEmissive>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
    ADDRESSW  = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

const texture tBB;
sampler TexBB=sampler_state {
    Texture   = <tBB>;
    ADDRESSU  = CLAMP;
    ADDRESSV  = CLAMP;
    ADDRESSW  = CLAMP;
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

float ComputeDepthBlur (float depth)
{
   float f;

   if (depth < d_focus)
   {
      // scale depth value between near blur distance and focal distance to [-1, 0] range
      f = (depth - d_focus)/(d_focus - d_near);
   }
   else
   {
      // scale depth value between focal distance and far blur
      // distance to [0, 1] range
      f = (depth - d_focus)/(d_far - d_focus);

      // clamp the far blur to a maximum blurriness
      f = clamp (f, 0, far_clamp);
   }

   // scale and bias into [0, 1] range
   return f * 0.5f + 0.5f;
}


//###############  Input VS  ###############
struct vis 
{
   float4 inPos  : POSITION;
   float3 inNorm : NORMAL;
   float2 inTex  : TEXCOORD0;
};

//###############  Output VS  ##############
struct pis 
{
   float4 Pos    	: POSITION;
   float2 Tex	: TEXCOORD0;
   float3 View   	: TEXCOORD1;
   float3 Norm   	: TEXCOORD2;
   float  depth  	: TEXCOORD3;
};



//##################  VS  ##################
void vs( in vis IN, out pis Out ) {

   
   	// Output transformed position:
   	Out.Pos = mul(IN.inPos,MatWorldViewProj); 

   	// Compute position in view space:
   	float3 Pview = mul(IN.inPos, MatView); 

   	// Transform the input normal to view space:
   	Out.Norm = normalize( mul( IN.inNorm, MatWorldViewProj) );   
 
   	// Compute the view direction in view space:
   	Out.View = - normalize( Pview );

   	// Propagate texture coordinate for the object:
   	Out.Tex = IN.inTex;

   	Out.depth = Pview.z;
}



//##################  PS  ##################
//===============  Diffuse  ================
float4 psDiffuse( in pis IN ) : COLOR 
{

	float4 texDif = tex2D(TexDiffuse, IN.Tex);
   // Compute the reflection vector:
   float3 vReflect = normalize( 2 * dot( IN.Norm, -lightDir) * IN.Norm - -lightDir);       

   // Compute ambient term:
   float4 AmbientColor = ambient * Ka;

   // Compute diffuse term:
   float4 DiffuseColor = diffuse * Kd * max( 0, dot( IN.Norm, -lightDir));

   // Compute specular term:
   float4 SpecularColor = specular * Ks * pow( max( 0, dot(vReflect, IN.View)), n_specular );
   
   float4 FinalColor = (AmbientColor + DiffuseColor) * texDif + SpecularColor;
   
   FinalColor.a = ComputeDepthBlur (IN.depth);
   
   return FinalColor;
}


//==========================================

//###############  Input VS  ###############
struct visPP 
{
   float4 inPos  : POSITION;
   float2 inTex  : TEXCOORD0;
};

//###############  Output VS  ##############
struct pisPP 
{
   float4 Pos    	: POSITION;
   float2 Tex	: TEXCOORD0;
};


void vsDown( in visPP IN, out pisPP OUT ) 
{
	OUT.Pos		= mul(IN.inPos ,MatWorldViewProj);
	OUT.Tex		= IN.inTex;
}


float4 psDown( in pisPP IN ) : COLOR0
{
   float2 texCoordSample = 0;
   float4 cOut;
   
   float2 pixelSize = 1.0 / float2(800,600);

   // it would be more efficient if the texture coordinates
   // were computed in the vertex shader and passed down
   texCoordSample.x = IN.Tex.x - pixelSize.x;
   texCoordSample.y = IN.Tex.y + pixelSize.y;
   cOut = tex2D(TexDown, texCoordSample);
   
   texCoordSample.x = IN.Tex.x + pixelSize.x;
   texCoordSample.y = IN.Tex.y + pixelSize.y;
   cOut += tex2D(TexDown, texCoordSample);
   
   texCoordSample.x = IN.Tex.x + pixelSize.x;
   texCoordSample.y = IN.Tex.y - pixelSize.y;
   cOut += tex2D(TexDown, texCoordSample);
   
   texCoordSample.x = IN.Tex.x - pixelSize.x;
   texCoordSample.y = IN.Tex.y - pixelSize.y;
   cOut += tex2D(TexDown, texCoordSample);
      
   return cOut * 0.25;
}


float4 psGaus1( in pisPP IN ) : COLOR0
{
   float2 texCoordSample = 0;
   float4 cOut;
   
  float2 pixelSize = 4.0 / float2( 800.0, 600.0 );

   // using bilinear texture lookups, this could be implemented
   // with just 2 texture fetches
   
   cOut = 0.5 * tex2D(TexDown, IN.Tex);
   
   // ideally the vertex shader would compute the texture
   // coords and pas them down   
   texCoordSample.x = IN.Tex.x;
   texCoordSample.y = IN.Tex.y + pixelSize.y;
   cOut += 0.25 * tex2D(TexDown, texCoordSample);
   
   texCoordSample.y = IN.Tex.y - pixelSize.y;
   cOut += 0.25 * tex2D(TexDown, texCoordSample);
      
   return cOut;
}

float4 psGaus2( in pisPP IN ) : COLOR0
{
   float2 texCoordSample = 0;
   float4 cOut;
   
   float2 pixelSize = 4.0 / float2( 800, 600 );

   
   cOut = 0.5 * tex2D(TexDown, IN.Tex);
   
   texCoordSample.y = IN.Tex.y;
   texCoordSample.x = IN.Tex.x + pixelSize.x;
   cOut += 0.25 * tex2D(TexDown, texCoordSample);
   
   texCoordSample.x = IN.Tex.x - pixelSize.x;
   cOut += 0.25 * tex2D(TexDown, texCoordSample);
      
   return cOut;
}



float2 fInverseViewportDimensions = float2(1.0/800, 1.0/600);
#define NUM_TAPS 4

// maximum CoC radius and diameter in pixels
float2 vMaxCoC = float2(5.0,10.0);

// scale factor for maximum CoC size on low res. image
float radiusScale = 0.4;


// contains poisson-distributed positions on the unit circle
float2 poisson[8] = {  
  float2( 0.0,      0.0),
  float2( 0.527837,-0.085868),
  float2(-0.040088, 0.536087),
  float2(-0.670445,-0.179949),
  float2(-0.419418,-0.616039),
  float2( 0.440453,-0.639399),
  float2(-0.757088, 0.349334),
  float2( 0.574619, 0.685879)
};

float4 psDOF1( in pisPP IN ) : COLOR0
{
  float4 cOut;
  float discRadius, discRadiusLow, centerDepth;

  // pixel size of low resolution image
  float2 pixelSizeLow = 4.0 * fInverseViewportDimensions;

  cOut = tex2D(TexBB, IN.Tex);   // fetch center tap
  centerDepth = cOut.a;              // save its depth

  // convert depth into blur radius in pixels
  discRadius = abs(cOut.a * vMaxCoC.y - vMaxCoC.x);

  // compute disc radius on low-res image
  discRadiusLow = discRadius * radiusScale;
  
  // reuse cOut as an accumulator
  cOut = 0;

  for(int t = 0; t < NUM_TAPS; t++)
  {
    // fetch low-res tap
    float2 coordLow = IN.Tex + (pixelSizeLow * poisson[t] * discRadiusLow);
    float4 tapLow = tex2D(TexDown, coordLow);

    // fetch high-res tap
    float2 coordHigh = IN.Tex + (fInverseViewportDimensions * poisson[t] * discRadius);
    float4 tapHigh = tex2D(TexBB, coordHigh);

    // put tap blurriness into [0, 1] range
    float tapBlur = abs(tapHigh.a * 2.0 - 1.0);
    
    // mix low- and hi-res taps based on tap blurriness
    float4 tap = lerp(tapHigh, tapLow, tapBlur);

    // apply leaking reduction: lower weight for taps that are
    // closer than the center tap and in focus
    tap.a = (tap.a >= centerDepth) ? 1.0 : abs(tap.a * 2.0 - 1.0);

    // accumulate
    cOut.rgb += tap.rgb * tap.a;
    cOut.a += tap.a;
   }

  // normalize and return result
  return (cOut / cOut.a);
}



float4 psDOF2( in pisPP IN ) : COLOR0
{
  float4 cOut;
  float discRadius, discRadiusLow, centerDepth;

  // pixel size of low resolution image
  float2 pixelSizeLow = 4.0 * 1.0/600.0;

  cOut = tex2D(TexBB, IN.Tex);   // fetch center tap
  centerDepth = cOut.a;              // save its depth

  // convert depth into blur radius in pixels
  discRadius = abs(cOut.a * vMaxCoC.y - vMaxCoC.x);

  // compute disc radius on low-res image
  discRadiusLow = discRadius * radiusScale;
  
  // reuse cOut as an accumulator
  cOut = 0;

  for(int t = 4; t < 4+NUM_TAPS; t++)
  {
    // fetch low-res tap
    float2 coordLow = IN.Tex + (pixelSizeLow * poisson[t] *
                      discRadiusLow);
    float4 tapLow = tex2D(TexDown, coordLow);

    // fetch high-res tap
    float2 coordHigh = IN.Tex + (1.0/600.0* poisson[t] *
                       discRadius);
    float4 tapHigh = tex2D(TexBB, coordHigh);

    // put tap blurriness into [0, 1] range
    float tapBlur = abs(tapHigh.a * 2.0 - 1.0);
    
    // mix low- and hi-res taps based on tap blurriness
    float4 tap = lerp(tapHigh, tapLow, tapBlur);

    // apply leaking reduction: lower weight for taps that are
    // closer than the center tap and in focus
    tap.a = (tap.a >= centerDepth) ? 1.0 : abs(tap.a * 2.0 - 1.0);

    // accumulate
    cOut.rgb += tap.rgb * tap.a;
    cOut.a += tap.a;
  }

  // normalize and return result
  cOut = cOut / cOut.a;
  
  // alpha of 0.5 so that alpha blending averages results with
  // previous DoF 
  cOut.a = 0.5;
  
  return cOut;
}


//##############  Technique  ###############
//------------------------------------------
technique Diffuse {
	pass p0 {

		vertexshader	= compile vs_2_0 vs();
		pixelshader		= compile ps_2_0 psDiffuse();
	}
}

technique DownPass {
	pass p0 {
		vertexshader	= compile vs_2_0 vsDown();
		pixelshader		= compile ps_2_0 psDown();
	}
}

technique Gaus1 {
	pass p0 {
		vertexshader	= compile vs_2_0 vsDown();
		pixelshader		= compile ps_2_0 psGaus1();
	}
}

technique Gaus2 {
	pass p0 {
		vertexshader	= compile vs_2_0 vsDown();
		pixelshader		= compile ps_2_0 psGaus2();
	}
}

technique DOF1 {
	pass p0 {
		vertexshader	= compile vs_2_0 vsDown();
		pixelshader		= compile ps_2_0 psDOF1();
	}
}

technique DOF2 {
	pass p0 {
		BlendOp = 1;
		ALPHABLENDENABLE = 1;
		SrcBlend = SRCALPHA;
		DestBlend = INVSRCALPHA;
		vertexshader	= compile vs_2_0 vsDown();
		pixelshader		= compile ps_2_0 psDOF2();
	}
}