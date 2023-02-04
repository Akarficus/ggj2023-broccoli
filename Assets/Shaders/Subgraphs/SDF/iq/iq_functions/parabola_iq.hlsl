#ifndef PARABOLA_IQ
#define PARABOLA_IQ
// Parabola
/*
A nice choice to remap the 0..1 interval into 0..1, such that the corners are mapped to 0
and the center to 1. You can then rise the parabolar to a power k to control its shape.
*/
float parabola( float x, float k )
{
    return pow( 4.0*x*(1.0-x), k );
}

// Power curve
/*
This is a generalziation of the Parabola() above. It also maps the 0..1 interval into 0..1 by
keeping the corners mapped to 0. But in this generalziation you can control the shape
one either side of the curve, which comes handy when creating leaves, eyes, and many
other interesting shapes.
*/
float pcurve( float x, float a, float b )
{
    const float k = pow(a+b,a+b)/(pow(a,a)*pow(b,b));
    return k*pow(x,a)*pow(1.0-x,b);
}
#endif // PARABOLA_IQ