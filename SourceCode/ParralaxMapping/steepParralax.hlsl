float currentLayerDepth=0;
int count=0;
float2 currentTexCoords=UV;
float currentDepthMapValue=Tex.SampleGrad(TexSampler,currentTexCoords,InDDX, InDDY).r;

while(currentLayerDepth<currentDepthMapValue)
{
    // shift texture coordinates along direction of P
    currentTexCoords -= DeltaTexCoords;
    // get depthmap value at current texture coordinates
    currentDepthMapValue = Tex.SampleGrad (TexSampler,currentTexCoords,InDDX, InDDY).r;
    // get depth of next layer
    currentLayerDepth += StepSize;  
count++;
}
return float3(currentTexCoords,count);