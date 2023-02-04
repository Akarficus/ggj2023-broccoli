#ifndef GAIN_IQ
#define GAIN_IQ
// Gain
/*
Remapping the unit interval into the unit interval by expanding the sides and
compressing the center, and keeping 1/2 mapped to 1/2, that can be done with the
gain() function. This was a common function in RSL tutorials (the Renderman Shading
Language). k=1 is the identity curve, k<1 produces the classic gain() shape, and k>1
produces "s" shaped curces. The curves are symmetric (and inverse) for k=a and k=1/a.
*/
float gain(float x, float k) 
{
    const float a = 0.5*pow(2.0*((x<0.5)?x:1.0-x), k);
    return (x<0.5)?a:1.0-a;
}
#endif // GAIN_IQ