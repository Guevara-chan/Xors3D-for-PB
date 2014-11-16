float4x4 matrixInvVP; // inversed camera view-projection matrix

// colors values
static float4 cD;
static float4 cP;
half4 cN;

// camera position
float3 cameraPosition;
float3 fogData;
float4 fogColor;

//light data
float3 lightPosition;
float3 lightDirection;
float4 lightColor;
float3 lightAngles;
float  lightRange;
int numLights;

// ambient & deffuse colors
float4 ambientLight;

// diffuse map
const texture texDiffuse;
sampler samplerDiffuse = sampler_state
{
  Texture   = <texDiffuse>;
  ADDRESSU  = WRAP;
  ADDRESSV  = WRAP;
  ADDRESSW  = WRAP;
  MAGFILTER = LINEAR;
  MINFILTER = LINEAR;
  MIPFILTER = LINEAR;
};

// normal map
const texture texNormal;
sampler samplerNormal = sampler_state
{
  Texture   = <texNormal>;
  ADDRESSU  = WRAP;
  ADDRESSV  = WRAP;
  ADDRESSW  = WRAP;
  MAGFILTER = LINEAR;
  MINFILTER = LINEAR;
  MIPFILTER = LINEAR;
};

// depth map
const texture texDepth;
sampler samplerDepth = sampler_state
{
  Texture   = <texDepth>;
  ADDRESSU  = WRAP;
  ADDRESSV  = WRAP;
  ADDRESSW  = WRAP;
  MAGFILTER = LINEAR;
  MINFILTER = LINEAR;
  MIPFILTER = LINEAR;
};

// Pixel shader (point light)
float4 PSMain(float4 TexCoords : TEXCOORD0) : COLOR0
{
  // getting diffuse color from diffuse map
  cD = tex2D(samplerDiffuse, TexCoords);
  // getting normal vector from normal map
  cN = tex2D(samplerNormal, TexCoords);
  cN.xyz = normalize(2 * cN.xyz - 1.0f);
  // getting depth balue from depth map
  float depthVal = tex2D(samplerDepth, TexCoords);
  // restore real position from depth
  float4 position;
  position.x = TexCoords.x * 2.0f - 1.0f;
  position.y = -(TexCoords.y * 2.0f - 1.0f);
  position.z = depthVal;
  position.w = 1.0f;
  position = mul(position, matrixInvVP);
  position /= position.w;
  // compute result color
  float res   = saturate(1.0f - distance(position.xyz, lightPosition) / lightRange);
  half3 nspec = normalize((cameraPosition - position.xyz) + (lightPosition - position.xyz));
  half  spec  = cN.a * pow(dot(nspec, cN), 100);
  int entityFX = cD.a * 255.0f;
  float4 cDf = cD / numLights;
  int lightDisable = (entityFX == 1 || entityFX == 3);
  cD = cD * dot(cN, normalize(lightPosition - position.xyz));
  cD = (spec + cD) * res * lightColor;
  cD = (cD * (1 - lightDisable)) + (cDf * lightDisable);
  return cD;
}

// Pixel shader #2 (no light without fog)
float4 PSMainAmbient(float4 TexCoords : TEXCOORD0) : COLOR0
{
  // just return diffuse color from diffuse map
  cD = tex2D(samplerDiffuse, TexCoords);
  int entityFX = cD.a * 255.0f;
  if(entityFX == 1 || entityFX == 3) return 0.0f;
  return (cD * ambientLight) / 3;
}

// Pixel shader #2 (no light without fog)
float4 PSMain2(float4 TexCoords : TEXCOORD0) : COLOR0
{
  // just return diffuse color from diffuse map
  cD = tex2D(samplerDiffuse, TexCoords);
  int entityFX = cD.a * 255.0f;
  if(entityFX == 1 || entityFX == 3) return cD;
  return cD * ambientLight;
}

// Pixel shader (directional light)
float4 PSMain3(float4 TexCoords : TEXCOORD0) : COLOR0
{
  // getting diffuse color from diffuse map
  cD = tex2D(samplerDiffuse, TexCoords);
  // getting normal vector from normal map
  cN = tex2D(samplerNormal, TexCoords);
  cN.xyz = normalize(2 * cN.xyz - 1.0f);
  // getting depth balue from depth map
  float depthVal = tex2D(samplerDepth, TexCoords);
  // restore real position from depth
  float4 position;
  position.x = TexCoords.x * 2.0f - 1.0f;
  position.y = -(TexCoords.y * 2.0f - 1.0f);
  position.z = depthVal;
  position.w = 1.0f;
  position = mul(position, matrixInvVP);
  position /= position.w;
  // compute result color
  int entityFX = cD.a * 255.0f;
  float4 cDf = cD / numLights;
  int lightDisable = (entityFX == 1 || entityFX == 3);
  half  spec  = cN.a * pow(dot(normalize(cameraPosition - position.xyz), cN), 200);
  cD  = cD * saturate(dot(cN, lightDirection));
  cD += cD * ambientLight;
  cD  = (spec + saturate(cD)) * float4(lightColor.xyz, 1.0f);
  cD  = (cD * (1 - lightDisable)) + (cDf * lightDisable);
  return cD;
}

// Pixel shader (spot light)
float4 PSMain4(float4 TexCoords : TEXCOORD0) : COLOR0
{
  // getting diffuse color from diffuse map
  cD = tex2D(samplerDiffuse, TexCoords);
  // getting normal vector from normal map
  cN = tex2D(samplerNormal, TexCoords);
  cN.xyz = normalize(2 * cN.xyz - 1.0f);
  // getting depth balue from depth map
  float depthVal = tex2D(samplerDepth, TexCoords);
  // restore real position from depth
  float4 position;
  position.x = TexCoords.x * 2.0f - 1.0f;
  position.y = -(TexCoords.y * 2.0f - 1.0f);
  position.z = depthVal;
  position.w = 1.0f;
  position = mul(position, matrixInvVP);
  position /= position.w;
  // compute result color
  // direction to light, in .w stored 1 / distance-to-light
  float3 toLight = lightPosition - position.xyz;
  float4 vLight  = normalize(float4(toLight, 1.0f));
  // specular light
  half3 nspec = normalize((cameraPosition - position.xyz) + toLight);
  half  spec  = cN.a * pow(dot(nspec, cN), 100);
  // material info
  int entityFX = cD.a * 255.0f;
  float4 cDf = cD / numLights;
  int lightDisable = (entityFX == 1 || entityFX == 3);
  // compute final color without lighting
  cD = cD * lightColor;
  // compute attenuation
  float cosAngle = dot(-lightDirection, -vLight.xyz);
  // ... by distance
  float halfRange = lightRange * 0.5f;
  float distAttenuation = 1.0f - saturate(((length(toLight) * cosAngle) - halfRange) / halfRange);
  // spotlight attenuation
  // in lightAngles.z stored light_outer - light_inner value
  float spotAttenuation = 1.0f - saturate((cosAngle - lightAngles.x) / lightAngles.z);
  // compute result color
  cD = cD * dot(lightDirection, cN.xyz);
  cD = cD * spotAttenuation + (spec * spotAttenuation);
  cD = cD * distAttenuation;
  // apply material
  cD = (cD * (1 - lightDisable)) + (cDf * lightDisable);
  return cD;
}

float4 PSMainFog(float4 TexCoords : TEXCOORD0) : COLOR0
{
  // getting diffuse color from diffuse map
  cD = tex2D(samplerDiffuse, TexCoords);
  // getting depth value from depth map
  float depthVal = tex2D(samplerDepth, TexCoords);
  // restore real position from depth
  float4 position;
  position.x = TexCoords.x * 2.0f - 1.0f;
  position.y = -(TexCoords.y * 2.0f - 1.0f);
  position.z = depthVal;
  position.w = 1.0f;
  position = mul(position, matrixInvVP);
  position /= position.w;
  // getting entity material
  int entityFX = cD.a * 255.0f;
  if(entityFX > 1) return float4(0.0f, 0.0f, 0.0f, 0.0f);
  // compute fog color
  float d = length(cameraPosition - position.xyz);
  d = clamp((d - fogData.x) / fogData.y, 0.0f, 1.0f);
  return float4(fogColor.xyz, d);
}

// Technique for adding fog to scene
technique DeferredFinalFog
{
  pass p0
  {
    AlphaBlendEnable = true;
    SrcBlend         = SrcAlpha;
    DestBlend        = InvSrcAlpha;
    PixelShader	     = compile ps_2_0 PSMainFog();
  }
}

// Render technique for point lights
technique DeferredFinalPoint
{
  pass p0
  {
    AlphaBlendEnable = true;
    SrcBlend         = One;
    DestBlend        = One;
    PixelShader	     = compile ps_2_0 PSMain();
  }
}

// Render technique for point lights
technique DeferredFinalDirectional
{
  pass p0
  {
    AlphaBlendEnable = true;
    SrcBlend         = One;
    DestBlend        = One;
    PixelShader	     = compile ps_2_0 PSMain3();
  }
}

// Render technique for point lights
technique DeferredFinalSpot
{
  pass p0
  {
    AlphaBlendEnable = true;
    SrcBlend         = One;
    DestBlend        = One;
    PixelShader	     = compile ps_2_0 PSMain4();
  }
}

// Render technique for scene without light lights
technique DeferredFinalNoLight
{
  pass p0
  {
    AlphaBlendEnable = true;
    SrcBlend         = One;
    DestBlend        = One;
    PixelShader	     = compile ps_2_0 PSMain2();
  }
}

// 
technique DeferredFinalAmbient
{
  pass p0
  {
    AlphaBlendEnable = true;
    SrcBlend         = One;
    DestBlend        = One;
    PixelShader	     = compile ps_2_0 PSMainAmbient();
  }
}