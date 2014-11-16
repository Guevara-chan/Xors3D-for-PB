// SCENECURRENT semantics is the texture which contains the scene right after the rendering.
// Its size matches the size of the backbuffer.
const texture sceneTexture : SCENECURRENT;

// Texture sampler to get access to texture pixels for shader
sampler sceneSample = sampler_state
{
	// Assing texture to sampler
	Texture   = <sceneTexture>;
	// We always needs clamping for textures
	AddressU  = Clamp;
	AddressV  = Clamp;
	// Linear texture filtering, also you may use "Point" or "None"
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

// Pixel shader for uv-offset
float4 PSEffect(float2 texCoords : TEXCOORD0) : COLOR
{
	float3 color = tex2D(sceneSample, texCoords).rgb;
	color = 1.0f - color; // simple color invertion
	return float4(color, 1.0f);
}

// Shaders techniques. Shader must contain at least one technique.
technique MainTechnique
{
	// Sequence of technique passes. This passes will performs on stage.
	pass Invertion
	{
		PixelShader	= compile ps_2_0 PSEffect();
	}
}