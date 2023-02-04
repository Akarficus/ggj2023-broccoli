#ifndef EXP_STEP_IQ
#define EXP_STEP_IQ
// Exponential Step
/*
A natural attenuation is an exponential of a linearly decaying quantity: yellow curve, exp(-x).
A gaussian, is an exponential of a quadratically decaying quantity: light green curve, exp(-x2).
You can generalize and keep increasing powers, and get a sharper and sharper s-shaped curves.
For really high values of n you can approximate a perfect step(). If you want such step to
transition at x=a, like in the graphs to the right, you can set k = a-n⋅ln 2.
*/
float expStep( float x, float k, float n )
{
    return exp( -k*pow(x,n) );
}
#endif // EXP_STEP_IQ