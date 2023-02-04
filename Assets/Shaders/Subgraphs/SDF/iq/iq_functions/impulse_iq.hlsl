#ifndef IMPULSE_IQ
#define IMPULSE_IQ
// Exponential Impulse
/*
Impulses are great for triggering behaviours or making envelopes for music or
animation. Baiscally, for anything that grows fast and then decays slowly. The following
is an exponential impulse function. Use k to control the stretching of the function. Its
maximum, which is 1, happens at exactly x = 1/k.
*/
float expImpulse( float x, float k )
{
    const float h = k*x;
    return h*exp(1.0-h);
}

// Polynomial Impulse
/*
Another impulse function that doesn't use exponentials can be designed by using
polynomials. Use k to control falloff of the function. For example, a quadratic can be
used, which peaks at x = sqrt(1/k).
*/
float quaImpulse( float k, float x )
{
    return 2.0*sqrt(k)*x/(1.0+k*x*x);
}

// You can easily generalize it to other powers to get different falloff shapes, where n
// is the degree of the polynomial:
float polyImpulse( float k, float n, float x )
{
    return (n/(n-1.0))*pow((n-1.0)*k,1.0/n)*x/(1.0+k*pow(x,n));
}
// These generalized impulses peak at x = [k(n-1)]-1/n.

// Sustained Impulse
/*
Similar to the previous, but it allows for control on the width of attack (through the
parameter "k") and the release (parameter "f") independently. Also, the impulse releases
at a value of 1 instead of 0.
*/
float expSustainedImpulse( float x, float f, float k )
{
    float s = max(x-f,0.0)
    return min( x*x/(f*f), 1+(2.0/f)*s*exp(-k*s));
}

#endif // IMPULSE_IQ