// Based on https://iquilezles.org/www/articles/distfunctions/distfunctions.htm
/*
In this index below, each primitives, modifier and operator function in this page you'll find a "exact" or "bound" note. This refers to the properties of the SDF that is 
generated or returned by the function.
• An "exact" SDF is one that retains all the qualities of a true SDF in Euclidean space - it really measures a distance exactly, meaning and its gradient always has length one.
• A "bound" SDF is no longer a true SDF (being pedantic) and only returns a lower bound to the real SDF, which can still be useful in certain scenarios.
SDFs that are "exact" are generally desired over the "bound" ones because they work better with a bigger number of algorithms and techniques, and produce higher quality results.
However some primitives (like the ellipsoid) or operators (like the smooth minimum here) cannot be "exact" because the very mathematics that describe them prevent it.
In those cases, I propose a "bound" version and mark it so to prevent confusion.
If a primitive that has an "exact" implementation can also be approximated by a "bound" version and sometimes I sometimes document that one too, but not too often because while
locally faster than their "exact" counterpart they often backfire in the form of a global performance hit (ironically) due to their poorer quality in measuring distances.
*/

#ifndef SDF_3D_INCLUDED
#define SDF_3D_INCLUDED
#include "SDF_UTIL.hlsl";


    //    Sphere - exact   (https://www.shadertoy.com/view/Xds3zN)
    float sdSphere_float( float3 p, float s, out float Out )
    {
        return Out = length(p)-s;
    }

    // Box - exact   (Youtube Tutorial with derivation: https://www.youtube.com/watch?v=62-pRVZuS5c)
    float sdBox_float( float3 p, float3 b, out float Out )
    {
        float3 q = abs(p) - b;
        return Out = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
    }

    // Round Box - exact
    float sdRoundBox_float( float3 p, float3 b, float r, out float Out )
    {
        float3 q = abs(p) - b;
        return Out = length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0) - r;
    }

    // Box Frame - exact   (https://www.shadertoy.com/view/3ljcRh)
    float sdBoxFrame_float( float3 p, float3 b, float e, out float Out )
    {
        p = abs(p)-b;
        float3 q = abs(p+e)-e;
        return Out = min
                    (
                        min
                        (
                            length(max(float3(p.x,q.y,q.z),0.0))+min(max(p.x,max(q.y,q.z)),0.0),
                            length(max(float3(q.x,p.y,q.z),0.0))+min(max(q.x,max(p.y,q.z)),0.0)
                        ),
                        length(max(float3(q.x,q.y,p.z),0.0))+min(max(q.x,max(q.y,p.z)),0.0)
                    );
    }

    // Torus - exact
    float sdTorus_float( float3 p, float2 t, out float Out )
    {
        float2 q = float2(length(p.xz)-t.x,p.y);
        return Out = length(q)-t.y;
    }

    // Capped Torus - exact   (https://www.shadertoy.com/view/tl23RK)
    float sdCappedTorus_float(in float3 p, in float2 sc, in float ra, in float rb, out float Out )
    {
        p.x = abs(p.x);
        float k = (sc.y*p.x>sc.x*p.y) ? dot(p.xy,sc) : length(p.xy);
        return Out = sqrt( dot(p,p) + ra*ra - 2.0*ra*k ) - rb;
    }

    //  Link - exact   (https://www.shadertoy.com/view/wlXSD7)
    float sdLink_float( float3 p, float le, float r1, float r2, out float Out )
    {
        float3 q = float3( p.x, max(abs(p.y)-le,0.0), p.z );
        return Out = length(float2(length(q.xy)-r1,q.z)) - r2;
    }

    // Infinite Cylinder - exact
    float sdCylinder_float( float3 p, float3 c, out float Out )
    {
        return Out = length(p.xz-c.xy)-c.z;
    }

    // Cone - exact
    float sdCone_float( in float3 p, in float2 c, float h, out float Out )
    {
        // c is the sin/cos of the angle, h is height
        // Alternatively pass q instead of (c,h),
        // which is the point at the base in 2D
        float2 q = h*float2(c.x/c.y,-1.0);
        
        float2 w = float2( length(p.xz), p.y );
        float2 a = w - q*clamp( dot(w,q)/dot(q,q), 0.0, 1.0 );
        float2 b = w - q*float2( clamp( w.x/q.x, 0.0, 1.0 ), 1.0 );
        float k = sign( q.y );
        float d = min(dot( a, a ),dot(b, b));
        float s = max( k*(w.x*q.y-w.y*q.x),k*(w.y-q.y)  );
        return Out = sqrt(d)*sign(s);
    }

    // Cone - bound (not exact!)
    float sdBoundCone( float3 p, float2 c, float h, out float Out )
    {
        float q = length(p.xz);
        return Out = max(dot(c.xy,float2(q,p.y)),-h-p.y);
    }

    // Infinite Cone - exact
    float sdInfiniteCone_float( float3 p, float2 c, out float Out )
    {
        // c is the sin/cos of the angle
        float2 q = float2( length(p.xz), -p.y );
        float d = length(q-c*max(dot(q,c), 0.0));
        return Out = d * ((q.x*c.y-q.y*c.x<0.0)?-1.0:1.0);
    }

    // Plane - exact
    float sdPlane_float( float3 p, float3 n, float h, out float Out )
    {
        // n must be normalized
        return Out = dot(p,n) + h;
    }

    // Hexagonal Prism - exact
    float sdHexPrism_float( float3 p, float2 h, out float Out )
    {
        const float3 k = float3(-0.8660254, 0.5, 0.57735);
        p = abs(p);
        p.xy -= 2.0*min(dot(k.xy, p.xy), 0.0)*k.xy;
        float2 d = float2(
        length(p.xy-float2(clamp(p.x,-k.z*h.x,k.z*h.x), h.x))*sign(p.y-h.x),
        p.z-h.y );
        return Out = min(max(d.x,d.y),0.0) + length(max(d,0.0));
    }

    // Triangular Prism - bound
    float sdTriPrism_float( float3 p, float2 h, out float Out )
    {
        float3 q = abs(p);
        return Out =  max(q.z-h.y,max(q.x*0.866025+p.y*0.5,-p.y)-h.x*0.5);
    }

    // Capsule / Line - exact
    float sdCapsule_float( float3 p, float3 a, float3 b, float r, out float Out )
    {
        float3 pa = p - a, ba = b - a;
        float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
        return Out = length( pa - ba*h ) - r;
    }

    // Capsule / Line - exact
    float sdVerticalCapsule_float( float3 p, float h, float r, out float Out )
    {
        p.y -= clamp( p.y, 0.0, h );
        return Out = length( p ) - r;
    }

    // Capped Cylinder - exact
    float sdCappedCylinder_float( float3 p, float h, float r, out float Out )
    {
        float2 d = abs(float2(length(p.xz),p.y)) - float2(h,r);
        return Out = min(max(d.x,d.y),0.0) + length(max(d,0.0));
    }

    // Capped Cylinder - exact   (https://www.shadertoy.com/view/wdXGDr)
    float sdCappedCylinder2_float(float3 p, float3 a, float3 b, float r, out float Out)
    {
        float3  ba = b - a;
        float3  pa = p - a;
        float baba = dot(ba,ba);
        float paba = dot(pa,ba);
        float x = length(pa*baba-ba*paba) - r*baba;
        float y = abs(paba-baba*0.5)-baba*0.5;
        float x2 = x*x;
        float y2 = y*y*baba;
        float d = (max(x,y)<0.0)?-min(x2,y2):(((x>0.0)?x2:0.0)+((y>0.0)?y2:0.0));
        return Out = sign(d)*sqrt(abs(d))/baba;
    }

    // Rounded Cylinder - exact
    float sdRoundedCylinder_float( float3 p, float ra, float rb, float h, out float Out )
    {
        float2 d = float2( length(p.xz)-2.0*ra+rb, abs(p.y) - h );
        return Out = min(max(d.x,d.y),0.0) + length(max(d,0.0)) - rb;
    }

    // Capped Cone - exact
    float sdCappedCone_float( float3 p, float h, float r1, float r2, out float Out )
    {
        float2 q = float2( length(p.xz), p.y );
        float2 k1 = float2(r2,h);
        float2 k2 = float2(r2-r1,2.0*h);
        float2 ca = float2(q.x-min(q.x,(q.y<0.0)?r1:r2), abs(q.y)-h);
        float2 cb = q - k1 + k2*clamp( dot(k1-q,k2)/dot2(k2), 0.0, 1.0 );
        float s = (cb.x<0.0 && ca.y<0.0) ? -1.0 : 1.0;
        return Out = s*sqrt( min(dot2(ca),dot2(cb)) );
    }

    // Capped Cone - exact   (https://www.shadertoy.com/view/tsSXzK)
    float sdCappedCone_float(float3 p, float3 a, float3 b, float ra, float rb, out float Out)
    {
        float rba  = rb-ra;
        float baba = dot(b-a,b-a);
        float papa = dot(p-a,p-a);
        float paba = dot(p-a,b-a)/baba;
        float x = sqrt( papa - paba*paba*baba );
        float cax = max(0.0,x-((paba<0.5)?ra:rb));
        float cay = abs(paba-0.5)-0.5;
        float k = rba*rba + baba;
        float f = clamp( (rba*(x-ra)+paba*baba)/k, 0.0, 1.0 );
        float cbx = x-ra - f*rba;
        float cby = paba - f;
        float s = (cbx < 0.0 && cay < 0.0) ? -1.0 : 1.0;
        return Out = s*sqrt( min(cax*cax + cay*cay*baba, cbx*cbx + cby*cby*baba) );
    }

    // Solid Angle - exact   (https://www.shadertoy.com/view/wtjSDW)
    float sdSolidAngle_float(float3 p, float2 c, float ra, out float Out)
    {
        // c is the sin/cos of the angle
        float2 q = float2( length(p.xz), p.y );
        float l = length(q) - ra;
        float m = length(q - c*clamp(dot(q,c),0.0,ra) );
        return Out = max(l,m*sign(c.y*q.x-c.x*q.y));
    }

    // Round cone - exact
    float sdRoundCone_float( float3 p, float r1, float r2, float h, out float Out )
    {
        float2 q = float2( length(p.xz), p.y );
        
        float b = (r1-r2)/h;
        float a = sqrt(1.0-b*b);
        float k = dot(q,float2(-b,a));
        
        if( k < 0.0 ) return length(q) - r1;
        if( k > a*h ) return length(q-float2(0.0,h)) - r2;
        
        return Out = dot(q, float2(a,b) ) - r1;
    }

    // Round Cone - exact   (https://www.shadertoy.com/view/tdXGWr)
    float sdRoundCone_float(float3 p, float3 a, float3 b, float r1, float r2, out float Out)
    {
        // sampling independent computations (only depend on shape)
        float3  ba = b - a;
        float l2 = dot(ba,ba);
        float rr = r1 - r2;
        float a2 = l2 - rr*rr;
        float il2 = 1.0/l2;
        
        // sampling dependant computations
        float3 pa = p - a;
        float y = dot(pa,ba);
        float z = y - l2;
        float x2 = dot2( pa*l2 - ba*y );
        float y2 = y*y*l2;
        float z2 = z*z*l2;

        // single square root!
        float k = sign(rr)*rr*rr*x2;
        if( sign(z)*a2*z2 > k ) return  sqrt(x2 + z2)        *il2 - r2;
        if( sign(y)*a2*y2 < k ) return  sqrt(x2 + y2)        *il2 - r1;
        return Out = (sqrt(x2*a2*il2)+y*rr)*il2 - r1;
    }

    // Ellipsoid - bound (not exact!)   (https://www.shadertoy.com/view/tdS3DG)
    float sdEllipsoid_float( float3 p, float3 r, out float Out )
    {
        float k0 = length(p/r);
        float k1 = length(p/(r*r));
        return Out = k0*(k0-1.0)/k1;
    }

    // Rhombus - exact   (https://www.shadertoy.com/view/tlVGDc)
    float sdRhombus_float(float3 p, float la, float lb, float h, float ra, out float Out )
    {
        p = abs(p);
        float2 b = float2(la,lb);
        float f = clamp( (ndot(b,b-2.0*p.xz))/dot(b,b), -1.0, 1.0 );
        float2 q = float2(length(p.xz-0.5*b*float2(1.0-f,1.0+f))*sign(p.x*b.y+p.z*b.x-b.x*b.y)-ra, p.y-h);
        return Out = min(max(q.x,q.y),0.0) + length(max(q,0.0));
    }

    // Octahedron - exact   (https://www.shadertoy.com/view/wsSGDG)
    float sdOctahedronExact_float( float3 p, float s, out float Out)
    {
        p = abs(p);
        float m = p.x+p.y+p.z-s;
        float3 q;
        if( 3.0*p.x < m ) q = p.xyz;
        else if( 3.0*p.y < m ) q = p.yzx;
        else if( 3.0*p.z < m ) q = p.zxy;
        else return m*0.57735027;
        
        float k = clamp(0.5*(q.z-q.y+s),0.0,s); 
        return Out = length(float3(q.x,q.y-s+k,q.z-k)); 
    }

    // Octahedron - bound (not exact)
    float sdOctahedron_float( float3 p, float s, out float Out)
    {
        p = abs(p);
        return Out = (p.x+p.y+p.z-s)*0.57735027;
    }

    // Pyramid - exact   (https://www.shadertoy.com/view/Ws3SDl)
    float sdPyramid_float( float3 p, float h, out float Out)
    {
        float m2 = h*h + 0.25;
        
        p.xz = abs(p.xz);
        p.xz = (p.z>p.x) ? p.zx : p.xz;
        p.xz -= 0.5;

        float3 q = float3( p.z, h*p.y - 0.5*p.x, h*p.x + 0.5*p.y);
        
        float s = max(-q.x,0.0);
        float t = clamp( (q.y-0.5*p.z)/(m2+0.25), 0.0, 1.0 );
        
        float a = m2*(q.x+s)*(q.x+s) + q.y*q.y;
        float b = m2*(q.x+0.5*t)*(q.x+0.5*t) + (q.y-m2*t)*(q.y-m2*t);
        
        float d2 = min(q.y,-q.x*m2-q.y*0.5) > 0.0 ? 0.0 : min(a,b);
        
        return Out = sqrt( (d2+q.z*q.z)/m2 ) * sign(max(q.z,-p.y));
    }

    // Triangle - exact   (https://www.shadertoy.com/view/4sXXRN)
    float udTriangle_float( float3 p, float3 a, float3 b, float3 c, out float Out )
    {
        float3 ba = b - a; float3 pa = p - a;
        float3 cb = c - b; float3 pb = p - b;
        float3 ac = a - c; float3 pc = p - c;
        float3 nor = cross( ba, ac );

        return Out = sqrt(
        (sign(dot(cross(ba,nor),pa)) +
        sign(dot(cross(cb,nor),pb)) +
        sign(dot(cross(ac,nor),pc))<2.0)
        ?
        min( min(
        dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
        dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
        dot2(ac*clamp(dot(ac,pc)/dot2(ac),0.0,1.0)-pc) )
        :
        dot(nor,pa)*dot(nor,pa)/dot2(nor) );
    }

    // Quad - exact   (https://www.shadertoy.com/view/Md2BWW)
    float udQuad_float( float3 p, float3 a, float3 b, float3 c, float3 d, out float Out )
    {
        float3 ba = b - a; float3 pa = p - a;
        float3 cb = c - b; float3 pb = p - b;
        float3 dc = d - c; float3 pc = p - c;
        float3 ad = a - d; float3 pd = p - d;
        float3 nor = cross( ba, ad );

        return Out = sqrt(
        (sign(dot(cross(ba,nor),pa)) +
        sign(dot(cross(cb,nor),pb)) +
        sign(dot(cross(dc,nor),pc)) +
        sign(dot(cross(ad,nor),pd))<3.0)
        ?
        min( min( min(
        dot2(ba*clamp(dot(ba,pa)/dot2(ba),0.0,1.0)-pa),
        dot2(cb*clamp(dot(cb,pb)/dot2(cb),0.0,1.0)-pb) ),
        dot2(dc*clamp(dot(dc,pc)/dot2(dc),0.0,1.0)-pc) ),
        dot2(ad*clamp(dot(ad,pd)/dot2(ad),0.0,1.0)-pd) )
        :
        dot(nor,pa)*dot(nor,pa)/dot2(nor) );
    }

#endif