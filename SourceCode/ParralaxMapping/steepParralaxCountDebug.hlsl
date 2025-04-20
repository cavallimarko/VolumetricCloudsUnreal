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
// get texture coordinates before collision (reverse operations)
float2 prevTexCoords = currentTexCoords + DeltaTexCoords;

// get depth after and before collision for linear interpolation
float afterDepth  = currentDepthMapValue - currentLayerDepth;
float beforeDepth = Tex.SampleGrad (TexSampler,prevTexCoords,InDDX, InDDY).r - currentLayerDepth + StepSize;
 
// interpolation of texture coordinates
float weight = afterDepth / (afterDepth - beforeDepth);
float2 finalTexCoords = lerp(currentTexCoords,prevTexCoords,weight);


return float3(finalTexCoords,count);