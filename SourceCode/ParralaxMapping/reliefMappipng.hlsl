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
//float2 prevTexCoords = currentTexCoords + DeltaTexCoords;

// get depth after and before collision for linear interpolation
//float afterDepth  = currentDepthMapValue - currentLayerDepth;
//float beforeDepth = Tex.SampleGrad (TexSampler,prevTexCoords,InDDX, InDDY).r - currentLayerDepth + StepSize;
 
// interpolation of texture coordinates
//float weight = afterDepth / (afterDepth - beforeDepth);
//float2 finalTexCoords = lerp(currentTexCoords,prevTexCoords,weight);

///////////////////////////////////////////////////////////
// Start of Relief Parallax Mapping

// decrease shift and height of layer by half
//vec2 deltaTexCoord = DeltaTexCoords / 2;
DeltaTexCoords /= 2;
float deltaHeight = StepSize / 2;

// return to the mid point of previous layer
currentTexCoords += DeltaTexCoords;
currentLayerDepth -= deltaHeight;

// binary search to increase precision of Steep Paralax Mapping
//const int BinarySearchSteps = 5;
for(int i=0; i<BinarySearchSteps; i++)
{
  // decrease shift and height of layer by half
  DeltaTexCoords /= 2;
  deltaHeight /= 2;

  // new depth from heightmap
  currentDepthMapValue = Tex.SampleGrad (TexSampler,currentTexCoords,InDDX, InDDY).r;

  // shift along or agains vector V
  if(currentDepthMapValue > currentLayerDepth) // below the surface
  {
	 currentTexCoords -= DeltaTexCoords;
	 currentLayerDepth += deltaHeight;
  }
  else // above the surface
  {
	 currentTexCoords += DeltaTexCoords;
	 currentLayerDepth -= deltaHeight;
  }
  count++;
}

// return results
//return currentTexCoords;

return float3(currentTexCoords,count);