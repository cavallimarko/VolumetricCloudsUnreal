float currentDepth = 1;//nearClippingPlane
float maxDepth =10000; //farClippingPlane
float epsilon=0.0001;
for(int i=0;i<100;i++){
	float3 rayPosition=CameraPosition+(normalize(LocalPosition-CameraPosition))*currentDepth;
	float3 q = abs(rayPosition) - BoxDimensions;
	float distanceToClosestSDF = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
	if(distanceToClosestSDF<=epsilon){
		return currentDepth;
	}
	currentDepth+=distanceToClosestSDF;
	if(currentDepth>maxDepth){
		break;
	}
}
return maxDepth;