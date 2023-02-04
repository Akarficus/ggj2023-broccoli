#ifndef SMOOTHSTEP_INTEGRAL_IQ
#define SMOOTHSTEP_INTEGRAL_IQ
// Smoothstep Integral
/*
If you use smoothstep for a velocity signal (say, you want to smoothly accelerate a
stationary object into constant velocity motion), you need to integrate smoothstep()
over time in order to get the actual position of value of the animation. The function
below is exactly that, the position of an object that accelerates with smoothstep.
Note it's derivative is never larger than 1, so no decelerations happen.
*/
float integralSmoothstep( float x, float T )
{
    if( x>T ) return x - T/2.0;
    return x*x*x*(1.0-x*0.5/T)/T/T;
}
#endif