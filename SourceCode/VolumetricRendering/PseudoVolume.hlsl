// this escapes from the current HLSL function and allows us to write our own functions
	return 1;
}
//converts an input 1d to 2d position. Useful for locating z frames that have been laid out in a 2d grid like a flipbook.
float2 Convert1dto2d(float XSize, float idx)
{
	float2 xyidx = 0;
	xyidx.x =  fmod( idx,  XSize );
	xyidx.y = floor( idx / XSize );

	return xyidx;
}


// return a pseudovolume textuer sample. treats 2d layout of frames a 3d texture and performs bilinear filtering by blending with an offset Z frame.
// @param Tex       = Input Texture Object storing Volume Data
// @param inPos     = Input float3 for Position, 0-1
// @param xsize     = Input float for num frames in x,y directions
// @param numFrames = Input float for num total frames
float4 PseudoVolumeTextureCustom(Texture2D Tex, SamplerState TexSampler, float3 inPos, float xsize, float numframes)
{
	float zframe = ceil( inPos.z * numframes );
	float zphase = frac( inPos.z * numframes );

	float2 uv = frac(inPos.xy) / xsize;

	float2 curframe = Convert1dto2d(xsize, zframe) / xsize;
	float2 nextframe = Convert1dto2d(xsize, zframe + 1) / xsize;

	float4 sampleA = Tex.SampleLevel(TexSampler, uv + curframe, 0);
	float4 sampleB = Tex.SampleLevel(TexSampler, uv + nextframe, 0);
	return lerp( sampleA, sampleB, zphase );
}
// return a pseudovolume textuer sample. treats 2d layout of frames a 3d texture and performs bilinear filtering by blending with an offset Z frame.
// @param Tex       = Input Texture Object storing Volume Data
// @param inPos     = Input float3 for Position, 0-1
// @param xsize     = Input float for num frames in x,y directions
// @param numFrames = Input float for num total frames
float4 PseudoVolumeTextureSingle(Texture2D Tex, SamplerState TexSampler, float3 inPos, float xsize, float numframes)
{
	float zframe = ceil( inPos.z * numframes );
	float2 uv = frac(inPos.xy) / xsize;

	float2 curframe = Convert1dto2d(xsize, zframe) / xsize;
	float4 sampleA = Tex.SampleLevel(TexSampler, uv + curframe, 0);
	
	return sampleA;
