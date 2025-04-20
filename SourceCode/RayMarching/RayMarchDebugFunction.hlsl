float currentDepth = 1;//nearClippingPlane
float maxDepth =10000; //farClippingPlane
float epsilon=0.001;
for(int i=0;i<MaxSteps;i++){
	float3 rayPosition=CameraPosition+(RayDirection)*currentDepth;
	float distanceToClosestSDF = sceneSDF(rayPosition);
	if(distanceToClosestSDF<=epsilon*currentDepth){
		return float2(currentDepth,i);
	}
	currentDepth+=distanceToClosestSDF;
	if(currentDepth>maxDepth){
		break;
	}
}
return float2(maxDepth,i);