
//##################  Varriables  ##################
const float4x4 MatWorldViewProj;
const float4x4 MatWorld;

float4 view_position;

float refractionScale = 1.0;
float rainbowScale = 0.2;
float rainbowSpread = 0.18;
float4 baseColor =float4(0.72, 0.7, 0.76, 1);
float ambient = 0.2;
float indexOfRefractionRatio = 1.14;
float reflectionScale = 1.0;
float4 FallOffCol;
float FallOffPow;

//##################  Textures  ##################
const texture tDiffuse;
sampler Environment=sampler_state {
    Texture   = <tDiffuse>;
    AddressU = WRAP;
    AddressV = WRAP;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

const texture tRainbow;
sampler Rainbow=sampler_state {
    Texture   = <tRainbow>;
    AddressU = WRAP;
    AddressV = WRAP;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};


//###############  Input VS  ###############
struct vis 
{
   float4 Pos:     POSITION;
   float3 normal:  NORMAL;
};

//###############  Output VS  ##############
struct pis 
{
   float4 Pos    	: POSITION;
   float3 normal 	: TEXCOORD0;
   float3 viewVec : TEXCOORD1;
};



//##################  VS  ##################
void vs( in vis IN, out pis Out ) 
{
   Out.Pos = mul(IN.Pos, MatWorldViewProj);
   Out.normal =  mul(IN.normal, MatWorld);
   Out.viewVec =  view_position - mul(IN.Pos, MatWorld);
}



//##################  PS  ##################
//===============  Diffuse  ================
float4 psDiffuse( in pis IN ) : COLOR 
{
   IN.normal = normalize(IN.normal);
   IN.viewVec = normalize(IN.viewVec);

   // Look up the reflection
   float3 reflVec = reflect(-IN.viewVec.xyz, IN.normal);
   float4 reflection = texCUBE(Environment, reflVec.xyz);

   // We'll use Snell's refraction law:
   // n  * sin(theta ) = n  * sin(theta )
   //  i            i     r            r

   // sin(theta )
   //          i
   float cosine = dot(IN.viewVec, IN.normal);
   float sine = sqrt(1 - cosine * cosine);

   // sin(theta )
   //          r
   float sine2 = saturate(indexOfRefractionRatio * sine);
   float cosine2 = sqrt(1 - sine2 * sine2);

   // Out of the sine and cosine of the angle between the
   // refraction vector and the normal we can construct the
   // refraction vector itself given two base vectors.
   // These two base vectors are the negative normal and
   // a tangent vector along the path of the incoming vector
   // relative to the surface.
   float3 x = -IN.normal;
   float3 y = normalize(cross(cross(IN.viewVec, IN.normal), IN.normal));

   // Refraction
   float3 refrVec = x * cosine2 + y * sine2;
   float4 refraction = texCUBE(Environment, refrVec.xyz);

   // Colors refract differently and the difference is more
   // visible the stronger the refraction. We'll fake this
   // effect by adding some rainbowish colors accordingly.
   //float4 rainbow = tex1D(Rainbow, pow(cosine, rainbowSpread));

   //float4 rain = rainbowScale * rainbow * baseColor;
   float4 refl = reflectionScale * reflection;
   float4 refr = refractionScale * refraction * baseColor;

	float FallOff = pow(1.0f-saturate(dot(IN.viewVec,IN.normal)),FallOffPow);
   // There is more light reflected at sharp angles and less
   // light refracted. There is more color separation of refracted
   // light at sharper angles
   return sine * refl + (1 - sine2) * refr + sine2 * FallOff*FallOffCol + ambient;
}



void vsSky( in vis IN, out pis Out ) 
{
   Out.Pos = mul(IN.Pos, MatWorldViewProj);
   Out.normal =  mul(IN.normal, MatWorldViewProj);
   Out.viewVec = IN.Pos.xyz;
}



//##################  PS  ##################
//===============  Diffuse  ================
float4 psSky( in pis IN ) : COLOR 
{
	return texCUBE(Environment, IN.viewVec);
}


//##############  Technique  ###############
//------------------------------------------

technique Diffuse 
{
	pass p0 
	{

		vertexshader	= compile vs_2_0 vs();
		pixelshader		= compile ps_2_0 psDiffuse();
	}
}

technique Sky 
{
	pass p0 
	{

		vertexshader	= compile vs_2_0 vsSky();
		pixelshader		= compile ps_2_0 psSky();
	}
}

