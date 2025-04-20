float currentDepth = 100;//nearClippingPlane
float maxDepth =10000; //farClippingPlane
float epsilon=0.0001;
for(int i=0;i<100;i++){
	float3 rayPosition=CameraPosition+(normalize(LocalPosition-CameraPosition))*currentDepth;
	float distanceToClosestSDF = length(rayPosition)-SphereRadius;
	if(distanceToClosestSDF<=epsilon){
		return currentDepth;
	}
	currentDepth+=distanceToClosestSDF;
	if(currentDepth>maxDepth){
		break;
	}
}
return maxDepth;