float currentDepth = 1;//nearClippingPlane
float maxDepth =10000; //farClippingPlane
float epsilon=0.0001;
float maxSteps=100;
for(int i=0;i<maxSteps;i++){
	float3 rayPosition=CameraPosition+(RayDirection)*currentDepth;
	float distanceToClosestSDF = sceneSDF(rayPosition);
	if(distanceToClosestSDF<=epsilon){
		return currentDepth;
	}
	currentDepth+=distanceToClosestSDF;
	if(currentDepth>maxDepth){
		break;
	}
}
return maxDepth;