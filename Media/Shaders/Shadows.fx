//================================================================
//=                                                              =
//=                 Xors3D Engine sapmles shaders                =
//=                                                              =
//= shadows rendering shader. See 'Forest sample'                =
//=                                                              =
//================================================================

// matrices
const float4x4 matrixW[60]; // entity bones matrices array
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

// PSSM data
int splitPlane  = 0;
float texelSize = 1.0 / 1024.0;

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

// Vertex shader input structure for static depth rendering
struct VSInput
{
	float4 Position  : POSITION0;
	float2 TexCoords : TEXCOORD0;
};

// Vertex shader input structure for static shadows rendering
struct VSInput2
{
	float4 Position  : POSITION0;
	float3 Normal    : NORMAL;
	float2 TexCoords : TEXCOORD0;
};

// Vertex shader input structure for animated depth rendering
struct VSInput3
{
	float4 Position     : POSITION0;
	float2 TexCoords    : TEXCOORD0;
	float4 BlendWeights : BLENDWEIGHT;
	float4 BlendIndices : BLENDINDICES;
};

// Vertex shader input structure for animated shadows rendering
struct VSInput4
{
	float4 Position     : POSITION0;
	float3 Normal       : NORMAL;
	float2 TexCoords    : TEXCOORD0;
	float4 BlendWeights : BLENDWEIGHT;
	float4 BlendIndices : BLENDINDICES;
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

// Vertex shader for drawing object into shadow map (directional & spot lights)
void VSDepthDirectionalSpot(in VSInput IN, out VSOutput OUT) 
{
	// compute vertex position in light-view space
	OUT.Position  = mul(mul(IN.Position, matrixW[0]), matrixLightVP);
	// write position in depth
	OUT.Depth     = OUT.Position;
	// rewrite texture coords
	OUT.TexCoords	= IN.TexCoords;
}

// Vertex shader for drawing object into shadow map (directional & spot lights) for skinned objects
void VSDepthDirectionalSpotAnimated(in VSInput3 IN, out VSOutput OUT) 
{
	int    indexArray[4]        = (int[4])D3DCOLORtoUBYTE4(IN.BlendIndices);
	float  blendWeightsArray[4] = (float[4])IN.BlendWeights;
	float  lastWeight           = 0.0f;
	OUT.Position                = float4(0.0f, 0.0f, 0.0f, 0.0f);
	[unroll] for(int i = 0; i < 3; i++)
	{
		lastWeight    = lastWeight + blendWeightsArray[i];
		OUT.Position += mul(IN.Position, matrixW[indexArray[i]]) * blendWeightsArray[i];
	}
	lastWeight    = 1.0f - lastWeight;
	OUT.Position += mul(IN.Position, matrixW[indexArray[3]]) * lastWeight;
	OUT.Position  = mul(OUT.Position, matrixLightVP);
	// write position in depth
	OUT.Depth     = OUT.Position;
	// rewrite texture coords
	OUT.TexCoords = IN.TexCoords;
}

// Vertex shader for drawing object into shadow map (point lights)
void VSDepthPoint(in VSInput IN, out VSOutput OUT) 
{
	// compute vertex position in light-view space
	OUT.Position  = mul(IN.Position, matrixW[0]);
	OUT.Depth     = OUT.Position;
	// write position in depth
	OUT.Position  = mul(OUT.Position, matrixLightVP);
	// rewrite texture coords
	OUT.TexCoords = IN.TexCoords;
}

// Vertex shader for drawing object into shadow map (point lights) for skinned objects
void VSDepthPointAnimated(in VSInput3 IN, out VSOutput OUT) 
{
	int    indexArray[4]        = (int[4])D3DCOLORtoUBYTE4(IN.BlendIndices);
	float  blendWeightsArray[4] = (float[4])IN.BlendWeights;
	float  lastWeight           = 0.0f;
	OUT.Position                = float4(0.0f, 0.0f, 0.0f, 0.0f);
	[unroll] for(int i = 0; i < 3; i++)
	{
		lastWeight    = lastWeight + blendWeightsArray[i];
		OUT.Position += mul(IN.Position, matrixW[indexArray[i]]) * blendWeightsArray[i];
	}
	lastWeight    = 1.0f - lastWeight;
	OUT.Position += mul(IN.Position, matrixW[indexArray[3]]) * lastWeight;
	OUT.Depth     = OUT.Position;
	OUT.Position  = mul(OUT.Position, matrixLightVP);
	// rewrite texture coords
	OUT.TexCoords = IN.TexCoords;
}

// Pixel shader for drawing object into shadow map (spot light)
float4 PSDepthSpot(VSOutput IN): COLOR0
{
	// return depth
	float depth = IN.Depth.z / IN.Depth.w;
	return float4(depth, depth, depth, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// Pixel shader for drawing object into shadow map (directional light)
float4 PSDepthDirectional(VSOutput IN): COLOR0
{
	// return depth
	float depth = IN.Depth.z;
	return float4(depth, depth, depth, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// Pixel shader for drawing object into shadow map (point light)
float4 PSDepthPoint(VSOutput IN): COLOR0
{
	// return depth
	float depth = distance(lightPosition, IN.Depth.xyz) / lightRange;
	return float4(depth, depth, depth, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// Vertex shader for drawing screen-space shadows (light type independent)
void VSShadows(in VSInput2 IN, out VSOutput2 OUT) 
{
	// compute vertex position in wolrd space
	OUT.Position   = mul(IN.Position, matrixW[0]);
	OUT.Position2  = OUT.Position;
	// rewrite texture coords
	OUT.TexCoords  = IN.TexCoords;
	// compute shadow map coords
	OUT.TexCoordsS = mul(OUT.Position, matrixLightVP);
	// compute vertex position in view space
	OUT.Position	 = mul(OUT.Position, matrixVP);
	// transform normal in world space
	OUT.Normal     = normalize(mul(IN.Normal, matrixW[0]));
}

// Vertex shader for drawing screen-space shadows (light type independent) for skinned objects
void VSShadowsAnimated(in VSInput4 IN, out VSOutput2 OUT) 
{
	// compute vertex position in wolrd space
	int    indexArray[4]        = (int[4])D3DCOLORtoUBYTE4(IN.BlendIndices);
	float  blendWeightsArray[4] = (float[4])IN.BlendWeights;
	float  lastWeight           = 0.0f;
	OUT.Position                = float4(0.0f, 0.0f, 0.0f, 0.0f);
	OUT.Normal                  = float4(0.0f, 0.0f, 0.0f, 0.0f);
	[unroll] for(int i = 0; i < 3; i++)
	{
		lastWeight    = lastWeight + blendWeightsArray[i];
		OUT.Position += mul(IN.Position, matrixW[indexArray[i]]) * blendWeightsArray[i];
		OUT.Normal   += mul(IN.Normal,   matrixW[indexArray[i]]) * blendWeightsArray[i];
	}
	lastWeight     = 1.0f - lastWeight;
	OUT.Position  += mul(IN.Position, matrixW[indexArray[3]]) * lastWeight;
	OUT.Normal    += mul(IN.Normal,   matrixW[indexArray[3]]) * lastWeight;
	OUT.Position2  = OUT.Position;
	// rewrite texture coords
	OUT.TexCoords  = IN.TexCoords;
	// compute shadow map coords
	OUT.TexCoordsS = mul(OUT.Position, matrixLightVP);
	// compute vertex position in view space
	OUT.Position   = mul(OUT.Position, matrixVP);
	// transform normal in world space
	OUT.Normal     = normalize(OUT.Normal);
}

// pixel shader for drawing sceen-space shadows (spot light)
float4 PSShadowsSpot(VSOutput2 IN) : COLOR 
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
		float3 toLight        = lightPosition - IN.Position2.xyz;
		float cosAngle        = dot(lightDirection, -normalize(float4(toLight, 1.0f)));
		float spotAttenuation = clamp((cosAngle - lightAngles.x) / lightAngles.z, 0.8f, 1.0f) - 0.8f;
		float halfRange       = lightRange * 0.5f;
		float distAttenuation = saturate(((length(toLight) * cosAngle) - halfRange) / halfRange);
		// project coordinates
		IN.TexCoordsS.xyz /=  IN.TexCoordsS.w;
		lightingFactor     = (tex2D(samplerShadow, IN.TexCoordsS).r > IN.TexCoordsS.z - epsilon[0] ? 1.0f : 0.3f + 3.5f * spotAttenuation);
		lightingFactor     = saturate(lightingFactor + distAttenuation);
	};
	// return it
	return float4(lightingFactor, lightingFactor, lightingFactor, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// pixel shader for drawing sceen-space shadows (directional light)
float4 PSShadowsDirectional(VSOutput2 IN) : COLOR 
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
		// project coordinates
		IN.TexCoordsS.xy /=  IN.TexCoordsS.w;
		float4 shadowValue;
		shadowValue.r   = tex2D(samplerShadow, IN.TexCoordsS.xy).r;
		shadowValue.g   = tex2D(samplerShadow, IN.TexCoordsS.xy + float2(texelSize, 0.0)).r;
		shadowValue.b   = tex2D(samplerShadow, IN.TexCoordsS.xy + float2(0.0,       texelSize)).r;
		shadowValue.a   = tex2D(samplerShadow, IN.TexCoordsS.xy + float2(texelSize, texelSize)).r;
		float4 inLight  = (IN.TexCoordsS.z - epsilon[0] * splitPlane < shadowValue);
		lightingFactor  = dot(inLight, float4(0.25, 0.25, 0.25, 0.25));
		lightingFactor += ambientLight;
	};
	// return it
	return float4(lightingFactor, lightingFactor, lightingFactor, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// pixel shader for drawing sceen-space shadows (point light)
float4 PSShadowsPoint(VSOutput2 IN) : COLOR
{
	float lightSize = 0.2f;
	// compute pixel to light direction
	float3 lightAng      = normalize(lightPosition - IN.Position2);
	// pixel lighting factor
	float lightingFactor = 1.0f;
	float nLight         = dot(lightAng, IN.Normal);
	// if angle not euqal to zero - compute lighting factor
	if(nLight > epsilon[1])
	{
		float depth     = distance(lightPosition, IN.Position2) / lightRange;
		//float atten     = clamp(log(depth / 0.70f), 0.0f, 1.0f);
		float atten     = clamp(depth / 3.0f, 0.0f, 1.0f);
		lightingFactor  = texCUBE(samplerShadowPoint, -lightAng).r + epsilon[0];
		lightingFactor  = lightingFactor < depth ? atten : 1.0f;
		lightingFactor += ambientLight;
	}
	// return it
	return float4(lightingFactor, lightingFactor, lightingFactor, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// Vertex shader for drawing non-receivers
void VSNotReceiver(in VSInput2 IN, out VSOutput2 OUT) 
{
	// compute vertex position in wolrd space
	OUT.Position  = mul(IN.Position, matrixW[0]);
	// rewrite texture coords
	OUT.TexCoords = IN.TexCoords;
	// compute vertex position in view space
	OUT.Position  = mul(OUT.Position, matrixVP);
}

// Vertex shader for drawing skinned non-receivers
void VSNotReceiverAnimated(in VSInput4 IN, out VSOutput2 OUT) 
{
	// compute vertex position in wolrd space
	int    indexArray[4]        = (int[4])D3DCOLORtoUBYTE4(IN.BlendIndices);
	float  blendWeightsArray[4] = (float[4])IN.BlendWeights;
	float  lastWeight           = 0.0f;
	OUT.Position                = float4(0.0f, 0.0f, 0.0f, 0.0f);
	[unroll] for(int i = 0; i < 3; i++)
	{
		lastWeight    = lastWeight + blendWeightsArray[i];
		OUT.Position += mul(IN.Position, matrixW[indexArray[i]]) * blendWeightsArray[i];
	}
	lastWeight     = 1.0f - lastWeight;
	OUT.Position  += mul(IN.Position, matrixW[indexArray[3]]) * lastWeight;
	// rewrite texture coords
	OUT.TexCoords  = IN.TexCoords;
	// compute vertex position in view space
	OUT.Position   = mul(OUT.Position, matrixVP);
}

// pixel shader for drawing non-receivers
float4 PSNotReceiver(VSOutput2 IN) : COLOR
{
	return float4(1.0f, 1.0f, 1.0f, tex2D(samplerDiffuse, IN.TexCoords).a);
}

// Pixel shader for shadows mixing
float4 PSMixShadows(float2 TexCoords : TEXCOORD0) : COLOR
{
	float4 src  = tex2D(samplerSrcShadow, TexCoords);
	float4 dest = tex2D(samplerResultShadow, TexCoords);
	return dest * src;
}

// Technique for rendering object into shadow map (spot lights)
technique RenderShadowMapSpot
{
	pass p0 
	{
		AlphaBlendEnable = 0;
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSDepthDirectionalSpot();
		PixelShader      = compile ps_2_0 PSDepthSpot();
	}
}

// Technique for rendering object into shadow map (directional lights)
technique RenderShadowMapDirectional
{
	pass p0 
	{
		AlphaBlendEnable = 0;
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSDepthDirectionalSpot();
		PixelShader      = compile ps_2_0 PSDepthDirectional();
	}
}

// Technique for rendering object into shadow map (point lights)
technique RenderShadowMapPoint
{
	pass p0 
	{
		AlphaBlendEnable = 0;
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSDepthPoint();
		PixelShader      = compile ps_2_0 PSDepthPoint();
	}
}

// Technique for rendering object into shadow map (spot lights) for skinned objects
technique RenderShadowMapSpotAnimated
{
	pass p0 
	{
		AlphaBlendEnable = 0;
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSDepthDirectionalSpotAnimated();
		PixelShader      = compile ps_2_0 PSDepthSpot();
	}
}

// Technique for rendering object into shadow map (directional lights) for skinned objects
technique RenderShadowMapDirectionalAnimated
{
	pass p0 
	{
		AlphaBlendEnable = 0;
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSDepthDirectionalSpotAnimated();
		PixelShader      = compile ps_2_0 PSDepthDirectional();
	}
}

// Technique for rendering object into shadow map (point lights) for skinned objects
technique RenderShadowMapPointAnimated
{
	pass p0 
	{
		AlphaBlendEnable = 0;
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSDepthPointAnimated();
		PixelShader      = compile ps_2_0 PSDepthPoint();
	}
}

// Technique for rendering screen-space shadow map (spot lights)
technique ShadowedSpot
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSShadows();
		PixelShader      = compile ps_2_0 PSShadowsSpot();
	}
}


// Technique for rendering screen-space shadow map (directional lights)
technique ShadowedDirectional
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSShadows();
		PixelShader      = compile ps_2_0 PSShadowsDirectional();
	}
}

// Technique for rendering screen-space shadow map (point lights)
technique ShadowedPoint
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSShadows();
		PixelShader      = compile ps_2_0 PSShadowsPoint();
	}
}

// Technique for rendering screen-space shadow map (spot lights) for skinned objects
technique ShadowedSpotAnimated
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSShadowsAnimated();
		PixelShader      = compile ps_2_0 PSShadowsSpot();
	}
}


// Technique for rendering screen-space shadow map (directional lights) for skinned objects
technique ShadowedDirectionalAnimated
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSShadowsAnimated();
		PixelShader      = compile ps_2_0 PSShadowsDirectional();
	}
}

// Technique for rendering screen-space shadow map (point lights) for skinned objects
technique ShadowedPointAnimated
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSShadowsAnimated();
		PixelShader      = compile ps_2_0 PSShadowsPoint();
	}
}

// Technique for rendering non shadows revievers objects in screen-space shadow map
technique NotReceiver
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSNotReceiver();
		PixelShader      = compile ps_2_0 PSNotReceiver();
	}
}

// Technique for rendering non shadows revievers skinned objects in screen-space shadow map
technique NotReceiverAnimated
{
	pass p0
	{
		AlphaTestEnable  = 1;
		AlphaRef         = 0;
		AlphaFunc        = 5;
		AlphaBlendEnable = 0;
		CullMode         = NONE;
		VertexShader     = compile vs_2_0 VSNotReceiverAnimated();
		PixelShader      = compile ps_2_0 PSNotReceiver();
	}
}

// Technique for mixing shadows from all light sources
technique MixShadows
{
	pass p0
	{
		AlphaTestEnable  = 0;
		AlphaBlendEnable = 0;
		PixelShader      = compile ps_2_0 PSMixShadows();
	}
}