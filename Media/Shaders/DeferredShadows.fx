// matrices
const float4x4 matrixW; // entity world matrix
const float4x4 matrixLightVP; // light-space view-projection matrix
const float4x4 matrixVP; // camera view-projection matrix

// light data
float3 lightDirection;
float3 lightPosition;
float  lightRange;
float3 lightAngles;
float4 ambientLight;

// shadow data
float2 epsilon;

// textures
// surface diffuse texture (from layer 0, need for masks)
const texture textureDiffuse;
sampler2D samplerDiffuse = sampler_state
{
  Texture   = <textureDiffuse>;
  ADDRESSU  = WRAP;
  ADDRESSV  = WRAP;
  ADDRESSW  = WRAP;
  MAGFILTER = LINEAR;
  MINFILTER = LINEAR;
  MIPFILTER = LINEAR;
};

// shadow map
const texture textureShadowMap;
sampler2D samplerShadow = sampler_state
{
  Texture     = <textureShadowMap>;
  AddressU    = Border;
  AddressV    = Border;
  BorderColor = 0xFFFFFFFF;
  MAGFILTER   = POINT;
  MINFILTER   = POINT;
  MIPFILTER   = POINT;
};

// shadow map for point light
const texture textureShadowMapPoint;
samplerCUBE samplerShadowPoint = sampler_state
{
  Texture     = <textureShadowMapPoint>;
  AddressU    = Border;
  AddressV    = Border;
  BorderColor = 0xFFFFFFFF;
  MAGFILTER   = POINT;
  MINFILTER   = POINT;
  MIPFILTER   = POINT;
};

// =================== 
const texture textureResultShadow;
sampler2D samplerResultShadow = sampler_state
{
  Texture     = <textureResultShadow>;
  AddressU    = Border;
  AddressV    = Border;
  BorderColor = 0xFFFFFFFF;
  MAGFILTER   = POINT;
  MINFILTER   = POINT;
  MIPFILTER   = POINT;
};

const texture textureSrcShadow;
sampler2D samplerSrcShadow = sampler_state
{
  Texture     = <textureSrcShadow>;
  AddressU    = Border;
  AddressV    = Border;
  BorderColor = 0xFFFFFFFF;
  MAGFILTER   = POINT;
  MINFILTER   = POINT;
  MIPFILTER   = POINT;
};

// Vertex shader input structure
struct VSInput
{
  float4 Position  : POSITION0;
  float2 TexCoords : TEXCOORD0;
};

// Vertex shader input structure #2
struct VSInput2
{
  float4 Position  : POSITION0;
  float3 Normal    : NORMAL;
  float3 Tangent   : TANGENT;
  float3 Binormal  : BINORMAL;
  float2 TexCoords : TEXCOORD0;
};

// Vertex shader output structure
struct VSOutput
{
  float4 Position  : POSITION0;
  float4 Depth     : TEXCOORD1;
  float2 TexCoords : TEXCOORD0;
};

// Vertex shader output structure #2
struct VSOutput2
{
  float4 Position   : POSITION0;
  float2 TexCoords  : TEXCOORD0;
  float4 TexCoordsS : TEXCOORD1;
  float3 Normal     : TEXCOORD3;
  float4 Position2  : TEXCOORD4;
};

// Vertex shader for drawing object into shadow map (light type independent)
void VSMain(in VSInput IN, out VSOutput OUT) 
{
  // compute vertex position in light-view space
  OUT.Position  = mul(mul(IN.Position, matrixW), matrixLightVP);
  // write position in depth
  OUT.Depth     = OUT.Position;
  // rewrite texture coords
  OUT.TexCoords	= IN.TexCoords;
}

// Pixel shader for drawing object into shadow map (spot light)
float4 PSMain(VSOutput IN): COLOR0
{
  // return depth
  float depth = IN.Depth.z / IN.Depth.w;
  return float4(depth, depth, depth, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// Pixel shader for drawing object into shadow map (directional light)
float4 PSMain6(VSOutput IN): COLOR0
{
  // return depth
  float depth = IN.Depth.z;
  return float4(depth, depth, depth, tex2D(samplerDiffuse, IN.TexCoords).a);
}

void VSMain3(in VSInput IN, out VSOutput OUT) 
{
  // compute vertex position in light-view space
  OUT.Position  = mul(IN.Position, matrixW);
  OUT.Depth     = OUT.Position;
  // write position in depth
  OUT.Position  = mul(OUT.Position, matrixLightVP);
  // rewrite texture coords
  OUT.TexCoords	= IN.TexCoords;
}

// Pixel shader for drawing object into shadow map (point light)
float4 PSMain4(VSOutput IN): COLOR0
{
  // return depth
  float depth = distance(lightPosition, IN.Depth.xyz) / lightRange;
  return float4(depth, depth, depth, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// Vertex shader for drawing screen-space shadows
void VSMain2(in VSInput2 IN, out VSOutput2 OUT) 
{
  // compute vertex position in wolrd space
  OUT.Position   = mul(IN.Position, matrixW);
  OUT.Position2  = OUT.Position;
  // rewrite texture coords
  OUT.TexCoords  = IN.TexCoords;
  // compute shadow map coords
  OUT.TexCoordsS = mul(OUT.Position, matrixLightVP);
  // compute vertex position in view space
  OUT.Position	 = mul(OUT.Position, matrixVP);
  // transform normal in world space
  OUT.Normal     = normalize(mul(IN.Normal, matrixW));
}

// pixel shader for drawing sceen-space shadows (spot light)
float4 PSMain2(VSOutput2 IN) : COLOR 
{
  // compute invert light direction
  float3 lightAng      = normalize(-lightDirection);
  // pixel lighting factor
  float lightingFactor = 1.0f;
  // cosine of angle between light axis and pixel normal
  float nLight         = dot(lightAng, IN.Normal);
  // if angle not euql to zero - compute lighting factor
  if(nLight > epsilon[1])
  {
    // compute attenuation
    float3 toLight = lightPosition - IN.Position2.xyz;
    float cosAngle = dot(lightDirection, -normalize(float4(toLight, 1.0f)));
    float spotAttenuation = clamp((cosAngle - lightAngles.x) / lightAngles.z, 0.8f, 1.0f) - 0.8f;
    float halfRange = lightRange * 0.5f;
    float distAttenuation = saturate(((length(toLight) * cosAngle) - halfRange) / halfRange);
    // project coordinates
    IN.TexCoordsS.xyz /=  IN.TexCoordsS.w;
    lightingFactor     = (tex2D(samplerShadow, IN.TexCoordsS).r > IN.TexCoordsS.z - epsilon[0] ? 1.0f : 0.3f + 3.5f * spotAttenuation);
    lightingFactor     = saturate(lightingFactor + distAttenuation);
  };
  // compute result color
  float3 color = lightingFactor;
  // return it
  return float4(color, tex2D(samplerDiffuse, IN.TexCoords).a);
}

int splitPlane;

// pixel shader for drawing sceen-space shadows (directional light)
float4 PSMain5(VSOutput2 IN) : COLOR 
{
  // compute invert light direction
  float3 lightAng      = normalize(-lightDirection);
  // pixel lighting factor
  float lightingFactor = 1.0f;//ambientLight;
  // cosine of angle between light axis and pixel normal
  float nLight         = dot(lightAng, IN.Normal);
  // if angle not euql to zero - compute lighting factor
  if(nLight > epsilon[1])
  {
    // project coordinates
    IN.TexCoordsS.xy /=  IN.TexCoordsS.w;
    lightingFactor    = (tex2D(samplerShadow, IN.TexCoordsS).r > IN.TexCoordsS.z - epsilon[0] * splitPlane ? 1.0f : ambientLight);
  };
  // compute result color
  float3 color = lightingFactor;
  // return it
  return float4(color, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// pixel shader for drawing sceen-space shadows (point light)
float4 PSMain3(VSOutput2 IN) : COLOR
{
  // compute pixel to light direction
  float3 lightAng      = normalize(lightPosition - IN.Position2);
  // pixel lighting factor
  float lightingFactor = 1.0f;
  float nLight         = dot(lightAng, IN.Normal);
  // if angle not euqal to zero - compute lighting factor
  if(nLight > epsilon[1])
  {
    float depth    = distance(lightPosition, IN.Position2) / lightRange;
    float atten    = clamp((depth - 0.5f) / 2.0f, 0.0f, 0.7f);
    lightingFactor = texCUBE(samplerShadowPoint, -lightAng).r + epsilon[0];
    lightingFactor = (lightingFactor > depth ? 1.0f : 0.3f + atten);
  }
  // compute result color
  float3 color = lightingFactor;
  // return it
  return float4(color, tex2D(samplerDiffuse, IN.TexCoords).a);
}

float4 PSMainMix(float2 TexCoords : TEXCOORD0) : COLOR
{
  float4 src  = tex2D(samplerSrcShadow, TexCoords);
  float4 dest = tex2D(samplerResultShadow, TexCoords);
  return dest * src;
}

// Technique for rendering object into shadow map (directional & spot lights)
technique RenderShadowMapSpot
{
  pass p0 
  {
    AlphaBlendEnable = 0;
    AlphaTestEnable  = 1;
    AlphaRef         = 60;
    AlphaFunc        = 5;
    CullMode         = NONE;
    VertexShader     = compile vs_2_0 VSMain();
    PixelShader      = compile ps_2_0 PSMain();
  }
}

technique RenderShadowMapDirectional
{
  pass p0 
  {
    AlphaBlendEnable = 0;
    AlphaTestEnable  = 1;
    AlphaRef         = 60;
    AlphaFunc        = 5;
    CullMode         = NONE;
    VertexShader     = compile vs_2_0 VSMain();
    PixelShader      = compile ps_2_0 PSMain6();
  }
}

technique RenderShadowMapPoint
{
  pass p0 
  {
    AlphaBlendEnable = 0;
    AlphaTestEnable  = 1;
    AlphaRef         = 60;
    AlphaFunc        = 5;
    CullMode         = NONE;
    VertexShader     = compile vs_2_0 VSMain3();
    PixelShader      = compile ps_2_0 PSMain4();
  }
}

// Technique for rendering screen-space shadow map (spot lights)
technique ShadowedSpot
{
  pass p0
  {
    AlphaTestEnable  = 1;
    AlphaRef         = 60;
    AlphaFunc        = 5;
    AlphaBlendEnable = 0;
    CullMode         = CCW;
    VertexShader     = compile vs_2_0 VSMain2();
    PixelShader      = compile ps_2_0 PSMain2();
  }
}


// Technique for rendering screen-space shadow map (directional lights)
technique ShadowedDirectional
{
  pass p0
  {
    AlphaTestEnable  = 1;
    AlphaRef         = 60;
    AlphaFunc        = 5;
    AlphaBlendEnable = 0;
    CullMode         = CCW;
    VertexShader     = compile vs_2_0 VSMain2();
    PixelShader      = compile ps_2_0 PSMain5();
  }
}

// Technique for rendering screen-space shadow map (point lights)
technique ShadowedPoint
{
  pass p0
  {
    AlphaTestEnable  = 1;
    AlphaRef         = 60;
    AlphaFunc        = 5;
    AlphaBlendEnable = 0;
    CullMode         = CCW;
    VertexShader     = compile vs_2_0 VSMain2();
    PixelShader      = compile ps_2_0 PSMain3();
  }
}

// =============================
technique MixShadows
{
  pass p0
  {
    AlphaTestEnable  = 0;
    AlphaBlendEnable = 0;
    PixelShader      = compile ps_2_0 PSMainMix();
  }
}