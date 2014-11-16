float4x4 matrixVP; // camera view-projection matrix
float4x4 matrixW;  // model world matrix

// color values
static float4 cD;
static float4 cN;

// ambient & deffuse colors
float4 diffuseColor;
float shininnes;
int entityFX;

// diffuse texture
const texture texDiffuse;
sampler samplerDiffuse = sampler_state
{
  Texture   = <texDiffuse>;
  ADDRESSU  = WRAP;
  ADDRESSV  = WRAP;
  ADDRESSW  = WRAP;
  MAGFILTER = ANISOTROPIC;
  MINFILTER = ANISOTROPIC;
  MIPFILTER = ANISOTROPIC;
  MAXANISOTROPY = 2;
};

// normal-map
const texture texNormal;
sampler samplerNormal = sampler_state
{
  Texture   = <texNormal>;
  ADDRESSU  = WRAP;
  ADDRESSV  = WRAP;
  ADDRESSW  = WRAP;
  MAGFILTER = ANISOTROPIC;
  MINFILTER = ANISOTROPIC;
  MIPFILTER = ANISOTROPIC;
  MAXANISOTROPY = 2;
};

// screen-space shadow-map
const texture texShadow;
sampler samplerShadow = sampler_state
{
  Texture   = <texShadow>;
  ADDRESSU  = WRAP;
  ADDRESSV  = WRAP;
  ADDRESSW  = WRAP;
  MAGFILTER = LINEAR;
  MINFILTER = LINEAR;
  MIPFILTER = LINEAR;
};

// VS input structure
struct VSInput
{
  float4 Position  : POSITION0;
  float3 Tangent   : TANGENT;
  float3 Binormal  : BINORMAL;
  float3 Normal    : NORMAL;
  float2 TexCoords : TEXCOORD0;
};

// VS output structure
struct VSOutput
{
  float4 Position  : POSITION0;
  float4 pWorld    : TEXCOORD0;
  float3 Tangent   : TEXCOORD1;
  float3 Binormal  : TEXCOORD2;
  float3 Normal    : TEXCOORD3;
  float2 TexCoords : TEXCOORD4;
  float4 Position2 : TEXCOORD5;
};

// VS output structure #2
struct VSOutput2
{
  float4 Position  : POSITION0;
  float2 TexCoords : TEXCOORD0;
};

// VS output structure #3
struct VSOutput3
{
  float4 Position  : POSITION0;
  float2 TexCoords : TEXCOORD0;
  float4 Position2 : TEXCOORD1;
};

// PS output structure
struct PSOutput
{
  float4 Color1: COLOR0;
  float4 Color2: COLOR1;
  float4 Color3: COLOR2;
};

// Vertex shader
void VSMain(in VSInput IN, out VSOutput OUT)
{
  // compute screen vertex position
  OUT.Position = mul(mul(IN.Position, matrixW), matrixVP);
  // compute world vertex position
  OUT.pWorld.rgba = mul(IN.Position, matrixW);
  // compute tangent vector in world space
  OUT.Tangent = normalize(mul(IN.Tangent, matrixW));
  // compute binormal vector in world space
  OUT.Binormal = normalize(mul(IN.Binormal, matrixW));
  // compute normal vector in world space
  OUT.Normal = normalize(mul(IN.Normal, matrixW));
  // write texture coords
  OUT.TexCoords	= IN.TexCoords;
  // copy vertex position for using in pixel shader
  OUT.Position2 = OUT.Position;
}

// Pixel shader
PSOutput PSMain(in VSOutput IN)
{
  PSOutput OUT;
  // getting diffuse color from texture
  cD = tex2D(samplerDiffuse, IN.TexCoords);
  clip(cD.a - 0.5f); // mask
  // getting normal vector from normal-map
  cN = normalize(tex2D(samplerNormal, IN.TexCoords) * 2.0f - 1.0f);
  // compute object-to-tangent space matrix
  float3x3 objToTangent;
  objToTangent[0] = IN.Tangent;
  objToTangent[1] = IN.Binormal;
  objToTangent[2] = IN.Normal;
  // transform normal to tangent space
  cN = float4(mul(cN.xyz, objToTangent), shininnes);
  // pack normal
  cN = float4(cN.xyz * 0.5f + 0.5f, shininnes);
  // compute shadow value
  IN.Position2.xy /=  IN.Position2.w * 2;
  IN.Position2.y   = -IN.Position2.y;
  IN.Position2.xy -=  0.5;
  float shadowValue = tex2D(samplerShadow, IN.Position2.xy);
  // compute result values
  if(entityFX != 1 && entityFX != 3)
  {
    OUT.Color1 = float4((cD * diffuseColor).xyz * shadowValue, entityFX / 255.0f);
    cN.a *= shadowValue;
  }
  else
  {
    OUT.Color1 = float4((cD * diffuseColor).xyz, entityFX / 255.0f);
  }
  OUT.Color2 = cN;
  OUT.Color3 = float4(IN.Position2.z / IN.Position2.w, 0.0f, 0.0f, 0.0f);
  return OUT;
}

// Vertex shader #2
void VSMain2(in VSInput IN, out VSOutput2 OUT)
{
  // compute screen vertex position
  OUT.Position = mul(mul(IN.Position, matrixW), matrixVP);
  // write texture coords
  OUT.TexCoords	= IN.TexCoords;
}

// Pixel shader #2
float4 PSMain2(in VSOutput2 IN) : COLOR0
{
  // getting diffuse color from texture
  cD = tex2D(samplerDiffuse, IN.TexCoords);
  clip(cD.a - 0.5f); // mask
  return float4((cD * diffuseColor).xyz, diffuseColor.a);
}

// Vertex shader #3
void VSMain3(in VSInput IN, out VSOutput3 OUT)
{
  // compute screen vertex position
  OUT.Position = mul(mul(IN.Position, matrixW), matrixVP);
  // write texture coords
  OUT.TexCoords	= IN.TexCoords;
  // copy vertex position for using in pixel shader
  OUT.Position2 = OUT.Position;
}

// Pixel shader #3
PSOutput PSMain3(in VSOutput3 IN)
{
  PSOutput OUT;
  // getting diffuse color from texture
  cD = tex2D(samplerDiffuse, IN.TexCoords);
  clip(cD.a - 0.5f); // mask
  cD = float4((cD * diffuseColor).xyz, diffuseColor.a);
  OUT.Color1 = cD;
  OUT.Color2 = float4(cD.xyz, 0.0f);
  OUT.Color3 = float4(IN.Position2.z / IN.Position2.w, 0.0f, 0.0f, 0.0f);
  return OUT;
}

// Rendering technique
technique DeferredMRTBase
{
  pass p0
  {
    AlphaBlendEnable = false;
    vertexshader     = compile vs_2_0 VSMain();
    pixelshader      = compile ps_2_0 PSMain();
  }
}

// Rendering technique for transparent objects
technique DeferredMRTBaseTrans
{
  pass p0
  {
    vertexshader = compile vs_2_0 VSMain2();
    pixelshader  = compile ps_2_0 PSMain2();
  }
}

technique DeferredMRTBaseTransFog
{
  pass p0
  {
    vertexshader = compile vs_2_0 VSMain3();
    pixelshader  = compile ps_2_0 PSMain3();
  }
}