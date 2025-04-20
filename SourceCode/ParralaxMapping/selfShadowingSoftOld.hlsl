if (LightVector.z < 0)
{
	return 0;
}
float shadowMultiplier = 0;
int count=1;
float numSamplesUnderSurface = 0;
float currentDepthMapValue=Tex.SampleGrad(TexSampler,CurrentTexCoords,InDDX, InDDY).r;
float currentLayerDepth=currentDepthMapValue;

float layerDepth = 1.0 / MaxShadowSteps;
float P = LightVector.xy / LightVector.z * HeightScale;
float2 DeltaTexCoords = P / MaxShadowSteps;

while(currentLayerDepth>0)
{
	// if point is under the surface
	 if(currentDepthMapValue > currentLayerDepth)
	 {
		// calculate partial shadowing factor
		numSamplesUnderSurface += 1;
		float newShadowMultiplier = (currentDepthMapValue - currentLayerDepth) *
										 (1.0 - (count / MaxShadowSteps));
		shadowMultiplier = max(shadowMultiplier, newShadowMultiplier);
	 }
	 
	 // offset to the next layer
    // shift texture coordinates along direction of P
    CurrentTexCoords += DeltaTexCoords;
    // get depthmap value at current texture coordinates
    currentDepthMapValue = Tex.SampleGrad (TexSampler,CurrentTexCoords,InDDX, InDDY).r;
    // get depth of next layer
    currentLayerDepth -= layerDepth ;  
	count++;
}
// Shadowing factor should be 1 if there were no points under the surface
if(numSamplesUnderSurface < 1)
{
 shadowMultiplier = 1;
}
else
{
 shadowMultiplier = 1.0 - shadowMultiplier*ShadowStrength;
}

return shadowMultiplier;