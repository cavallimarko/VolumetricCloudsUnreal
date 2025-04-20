// this escapes from the current HLSL function and allows us to write our own functions
	return 1;
}
#define EPSILON 0.0001
float3 pallete( float t, float3 a, float3 b, float3 c, float3 d )
{
    return a + b*cos( 6.28318*(c*t+d) );
}
float3 blueWhiteRed( float t)
{
    return pallete( t, float3(0.660, 0.560, 0.680),float3(0.718, 0.438, 0.720),float3(0.520, 0.800, 0.520),float3(-0.430, -0.397, -0.083) );
}
float3 complexityPallete( float t)
{
    return pallete( t, float3(0.500, 0.500, 0.500),float3(1.000, 1.000, 1.000),float3(0.870, 0.870, 0.870),float3(-0.622, -0.288, 0.045) );
}
float boxSDF( float3 pos, float3 boxDimensions) {
	float3 q = abs(pos) - boxDimensions;
	return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}
float boxSDFUniform( float3 pos, float boxSize) {
	float3 q = abs(pos) - float3(boxSize, boxSize, boxSize);
	return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}
float sphereSDF( float3 pos, float radius) {
	return length(pos) - radius;
}
float sdVerticalCapsule( float3 p, float h, float r )
{
  p.y -= clamp( p.y, 0.0, h );
  return length( p ) - r;
}
float mandelbulbSDF( float3 p, float power ) {
	float3 w = p;
    float m = dot(w,w);
	float dz = 1.0;

	for( int i=0; i<3; i++ )
    {
        dz = power*pow(sqrt(m), power - 1.0 )*dz + 1.0;

        float r = length(w);
        float b = power*acos( w.y/r);
        float a = power*atan2( w.x, w.z );
        w = p + pow(r,power) * float3( sin(b)*sin(a), cos(b), sin(b)*cos(a) );

        m = dot(w,w);
		if( m > 256.0 )
            break;
    }

    return 0.25*log(m)*sqrt(m)/dz;
}
float animatedSin(float Amplitude, float Speed){
	float sinNorm=sin(View.GameTime*Speed);
	return sinNorm*Amplitude;
}
float animatedCos(float Amplitude, float Speed){
	float sinNorm=cos(View.GameTime*Speed);
	return sinNorm*Amplitude;
}
float animatedAbsSin(float Amplitude, float Speed){
	float sinNorm=0.5+sin(View.GameTime*Speed)/2;
	return sinNorm*Amplitude;
}
float animatedAbsCos(float Amplitude, float Speed){
	float sinNorm=0.5+cos(View.GameTime*Speed)/2;
	return sinNorm*Amplitude;
}
float opUnion( float d1, float d2 ) { return min(d1,d2); }

float opSubtraction( float d1, float d2 ) { return max(-d1,d2); }

float opIntersection( float d1, float d2 ) { return max(d1,d2); }

float smin( float a, float b, float k )
{
    float h = max( k-abs(a-b), 0.0 )/k;
    return min( a, b ) - h*h*k*(1.0/4.0);
}

float opRepLim( float3 pos, float repetitionPeriod, float3 dimensions, float radius )
{
    float3 q = pos-repetitionPeriod*clamp(round(pos/repetitionPeriod),-dimensions,dimensions);
    return length(q) - radius;
}
float randomHalf (float3 pos) {
    return 2*frac(sin(dot(pos,float3(12.9898,78.233,102.9898)))*43758.5453123)-1;
}
float3 randomBlob (float3 pos,float count) {
	float dist=sphereSDF(pos,20);
	for( int i=0; i<count; i++ )
    {	float3 randomDirection=float3(randomHalf(i),randomHalf(i*i),randomHalf(i*i*i));
		float dist1=sphereSDF(pos+12*randomDirection+randomDirection*animatedSin(3+i/count,i/count+0.5),3+(i/count)*5);
        dist=smin(dist,dist1,5);
    }
	return dist;
    
}
float displacement(float3 pos,float scale )
{
    return  sin(scale*pos.x)*sin(scale*pos.y)*sin(scale*pos.z);
}

float opDisplace( float distanceToPrimitive, float3 pos )
{
    float d1 = distanceToPrimitive;
    float d2 = displacement(pos,0.2);
    return d1+d2;
}

float sceneSDF( float3 pos ) {
  float sphere = sphereSDF(pos, 40.0);
  float box = boxSDFUniform(pos, 20.0);
  float capsule = sdVerticalCapsule(pos, 40.0, 10.0);
  //return sphere;
  //return box;
  //return capsule;

  //return lerp(sphere,box,0.5+sin(View.GameTime)/2);
  //return lerp(sphere,capsule,0.5+sin(View.GameTime)/2);
  //return lerp(box,capsule,0.5+sin(View.GameTime)/2);
  
  //return opUnion(box,sphere);
  //return opSubtraction(box,sphere);
  //return opIntersection(box,capsule);
  
  //float3 offset=float3(40,0,0);
  //float sphere1 = sphereSDF(pos, 30.0);
  //float sphere2 = sphereSDF(pos-offset+float3(animatedAbsSin(80,1),0,0), 15.0);
  //float sphere3 = sphereSDF(pos+float3(animatedSin(40,1),animatedCos(40,1),animatedSin(40,2)), 12.0);
  //return smin(box,sphere2,5);
  
  //return mandelbulbSDF(pos/30,5)*30;//scaling by 30
  
  //return opRepLim(pos, 10, float3(4,4,4), 4);
  
  //return randomBlob(pos,50);
  return opDisplace(sphere,pos);
  

 }
float3 estimateNormals(float3 pos) {
  return normalize( float3(
  	sceneSDF(float3( pos.x + EPSILON, pos.yz ) )
    - sceneSDF(float3( pos.x - EPSILON, pos.yz) ),
    sceneSDF( float3( pos.x, pos.y + EPSILON, pos.z) )
    - sceneSDF( float3( pos.x, pos.y - EPSILON, pos.z ) ),
    sceneSDF( float3(pos.xy, pos.z + EPSILON) )
    - sceneSDF( float3( pos.xy, pos.z - EPSILON ) )
  ));
