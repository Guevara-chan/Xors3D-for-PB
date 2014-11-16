// This texture contains current scene rendered by xRenderWorld()
// without downsampling.
// Also you may use SCENECURRENT2X, SCENECURRENT4X and SCENECURRENT8X
// semantics to get downsampled scene texture (e.g. for bloom sample
// 800x600 backbuffer will be downsampled to 400x300, 200x150 and 100x75
// textures).
// And if you need to get previous frame texture you may use this semantics:
// SCENEPREVIOUS, SCENEPREVIOUS2X, SCENEPREVIOUS4X and SCENEPREVIOUS8X

const texture distortionTexture;
const texture sceneTexture : SCENECURRENT;
const float3 lightDir = float3(0.5f, 0.5f, 1.0f);

// Texture sampler to get access to texture pixels for shader
sampler sceneSample = sampler_state
{
	// Assing texture to sampler
	Texture   = <sceneTexture>;
	// We always need clamping for textures
	AddressU  = Clamp;
	AddressV  = Clamp;
	// Linear texture filtering, also you may use "Point" or "None"
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler distortionSample = sampler_state
{
	// Assing texture to sampler
	Texture   = <distortionTexture>;
	// We always need clamping for textures
	AddressU  = Clamp;
	AddressV  = Clamp;
	// Linear texture filtering, also you may use "Point" or "None"
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

// Pixel shader for uv-offset
float4 PSOffset(float2 texCoords : TEXCOORD0) : COLOR
{
	//float3 offset = (normalize(tex2D(distortionSample, texCoords)).rgb) - 0.32f;
	float2 offset = tex2D(distortionSample, texCoords);
	offset -=  0.5f;
	//float4 tint = pow(float4(offset.b, offset.b * 0.5f, offset.b * 0.25f, 1.0f) * 0.4f, 3);
    float4 color = float4(1.0f, 1.0f, 1.0f, 1.0f);
	// We getting pixel value from scene buffer
	color.rgb = tex2D(sceneSample, texCoords + offset * 0.25f).rgb;
	/*color.r = tex2D(sceneSample, texCoords + offset.xy).r;
	color.g = tex2D(sceneSample, texCoords + offset.xy * 1.5f).g;
	color.b = tex2D(sceneSample, texCoords + offset.xy * 2.0f).b;*/
	//float light = saturate((0.5f - saturate( dot (normalize (lightDir), normalize(float3(offset.rg + 0.5f, 0.0f))))) * 4.0f);
	float light = saturate( dot (normalize (lightDir), normalize(float3(offset - 0.5f, 0.5f)))) * 0.5f;
	//color.rgba = float4(light, light, light, 1.0f);
	return color + light /*+ tint*/;
}

// Shaders techniques. Shader must contain at least one technique.
technique MainTechnique
{
	// Sequence of technique passes. This passes will performs on stage.
	pass Offset
	{
		PixelShader	= compile ps_2_0 PSOffset();
	}
}