if (LightVector.z < 0)
{
	return 0;
}

int count=0;

float currentDepthMapValue=Tex.SampleGrad(TexSampler,CurrentTexCoords,InDDX, InDDY).r;
float currentLayerDepth=currentDepthMapValue;

float layerDepth = 1.0 / MaxShadowSteps;
float P = LightVector.xy / LightVector.z * HeightScale;
float2 DeltaTexCoords = P / MaxShadowSteps;

while(currentLayerDepth<=currentDepthMapValue && currentLayerDepth>0)
{
    // shift texture coordinates along direction of P
    CurrentTexCoords += DeltaTexCoords;
    // get depthmap value at current texture coordinates
    currentDepthMapValue = Tex.SampleGrad (TexSampler,CurrentTexCoords,InDDX, InDDY).r;
    // get depth of next layer
    currentLayerDepth -= layerDepth ;  
count++;
}
float r = currentLayerDepth > currentDepthMapValue ? 1-ShadowStrength : 1;
return r;