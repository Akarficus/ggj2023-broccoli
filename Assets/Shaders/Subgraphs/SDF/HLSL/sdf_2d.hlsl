#ifndef SDF_2D_INCLUDED
#define SDF_2D_INCLUDED
#include "SDF_UTIL.hlsl";

// Circle - exact   (https://www.shadertoy.com/view/3ltSW2)
float sdCircle( float2 p, float r )
{
    return length(p) - r;
}

// Rounded Box - exact   (https://www.shadertoy.com/view/4llXD7 and https://www.youtube.com/watch?v=s5NGeUV2EyU)
float sdRoundedBox( in float2 p, in float2 b, in float4 r )
{
    r.xy = (p.x>0.0)?r.xy : r.zw;
    r.x  = (p.y>0.0)?r.x  : r.y;
    float2 q = abs(p)-b+r.x;
    return min(max(q.x,q.y),0.0) + length(max(q,0.0)) - r.x;
}

// Box - exact   (https://www.youtube.com/watch?v=62-pRVZuS5c)
float sdBox( in float2 p, in float2 b )
{
    float2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

// Oriented Box - exact
float sdOrientedBox( in float2 p, in float2 a, in float2 b, float th )
{
    float l = length(b-a);
    float2  d = (b-a)/l;
    float2  q = (p-(a+b)*0.5);
          q = float2x2(d.x,-d.y,d.y,d.x)*q;
          q = abs(q)-float2(l,th)*0.5;
    return length(max(q,0.0)) + min(max(q.x,q.y),0.0);    
}

// Segment - exact   (https://www.shadertoy.com/view/3tdSDj and https://www.youtube.com/watch?v=PMltMdi1Wzg)
float sdSegment( in float2 p, in float2 a, in float2 b )
{
    float2 pa = p-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    return length( pa - ba*h );
}

// Rhombus - exact   (https://www.shadertoy.com/view/XdXcRB)
float ndot(float2 a, float2 b ) { return a.x*b.x - a.y*b.y; }

float sdRhombus( in float2 p, in float2 b ) 
{
    p = abs(p);
    float h = clamp( ndot(b-2.0*p, b)/dot(b,b), -1.0, 1.0 );
    float d = length( p-0.5*b*float2(1.0-h,1.0+h) );
    return d * sign( p.x*b.y + p.y*b.x - b.x*b.y );
}

// Isosceles Trapezoid - exact   (https://www.shadertoy.com/view/MlycD3)
float sdTrapezoid( in float2 p, in float r1, float r2, float he )
{
    float2 k1 = float2(r2,he);
    float2 k2 = float2(r2-r1,2.0*he);
    p.x = abs(p.x);
    float2 ca = float2(p.x-min(p.x,(p.y<0.0)?r1:r2), abs(p.y)-he);
    float2 cb = p - k1 + k2*clamp( dot(k1-p,k2)/dot2(k2), 0.0, 1.0 );
    float s = (cb.x<0.0 && ca.y<0.0) ? -1.0 : 1.0;
    return s*sqrt( min(dot2(ca),dot2(cb)) );
}

// Parallelogram - exact   (https://www.shadertoy.com/view/7dlGRf)
float sdParallelogram( in float2 p, float wi, float he, float sk )
{
    float2 e = float2(sk,he);
    p = (p.y<0.0)?-p:p;
    float2  w = p - e; w.x -= clamp(w.x,-wi,wi);
    float2  d = float2(dot(w,w), -w.y);
    float s = p.x*e.y - p.y*e.x;
    p = (s<0.0)?-p:p;
    float2  v = p - float2(wi,0); v -= e*clamp(dot(v,e)/dot(e,e),-1.0,1.0);
    d = min( d, float2(dot(v,v), wi*he-abs(s)));
    return sqrt(d.x)*sign(-d.y);
}

// Equilateral Triangle - exact   (https://www.shadertoy.com/view/Xl2yDW)
float sdEquilateralTriangle( in float2 p )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x) - 1.0;
    p.y = p.y + 1.0/k;
    if( p.x+k*p.y>0.0 ) p = float2(p.x-k*p.y,-k*p.x-p.y)/2.0;
    p.x -= clamp( p.x, -2.0, 0.0 );
    return -length(p)*sign(p.y);
}

// Isosceles Triangle - exact   (https://www.shadertoy.com/view/MldcD7)
float sdTriangleIsosceles( in float2 p, in float2 q )
{
    p.x = abs(p.x);
    float2 a = p - q*clamp( dot(p,q)/dot(q,q), 0.0, 1.0 );
    float2 b = p - q*float2( clamp( p.x/q.x, 0.0, 1.0 ), 1.0 );
    float s = -sign( q.y );
    float2 d = min( float2( dot(a,a), s*(p.x*q.y-p.y*q.x) ),
                  float2( dot(b,b), s*(p.y-q.y)  ));
    return -sqrt(d.x)*sign(d.y);
}

// Triangle - exact   (https://www.shadertoy.com/view/XsXSz4)
float sdTriangle( in float2 p, in float2 p0, in float2 p1, in float2 p2 )
{
    float2 e0 = p1-p0, e1 = p2-p1, e2 = p0-p2;
    float2 v0 = p -p0, v1 = p -p1, v2 = p -p2;
    float2 pq0 = v0 - e0*clamp( dot(v0,e0)/dot(e0,e0), 0.0, 1.0 );
    float2 pq1 = v1 - e1*clamp( dot(v1,e1)/dot(e1,e1), 0.0, 1.0 );
    float2 pq2 = v2 - e2*clamp( dot(v2,e2)/dot(e2,e2), 0.0, 1.0 );
    float s = sign( e0.x*e2.y - e0.y*e2.x );
    float2 d = min(min(float2(dot(pq0,pq0), s*(v0.x*e0.y-v0.y*e0.x)),
                     float2(dot(pq1,pq1), s*(v1.x*e1.y-v1.y*e1.x))),
                     float2(dot(pq2,pq2), s*(v2.x*e2.y-v2.y*e2.x)));
    return -sqrt(d.x)*sign(d.y);
}

// Uneven Capsule - exact   (https://www.shadertoy.com/view/4lcBWn)
float sdUnevenCapsule( float2 p, float r1, float r2, float h )
{
    p.x = abs(p.x);
    float b = (r1-r2)/h;
    float a = sqrt(1.0-b*b);
    float k = dot(p,float2(-b,a));
    if( k < 0.0 ) return length(p) - r1;
    if( k > a*h ) return length(p-float2(0.0,h)) - r2;
    return dot(p, float2(a,b) ) - r1;
}

// Regular Pentagon - exact   (https://www.shadertoy.com/view/llVyWW)
float sdPentagon( in float2 p, in float r )
{
    const float3 k = float3(0.809016994,0.587785252,0.726542528);
    p.x = abs(p.x);
    p -= 2.0*min(dot(float2(-k.x,k.y),p),0.0)*float2(-k.x,k.y);
    p -= 2.0*min(dot(float2( k.x,k.y),p),0.0)*float2( k.x,k.y);
    p -= float2(clamp(p.x,-r*k.z,r*k.z),r);    
    return length(p)*sign(p.y);
}

// Regular Hexagon - exact

float sdHexagon( in float2 p, in float r )
{
    const float3 k = float3(-0.866025404,0.5,0.577350269);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= float2(clamp(p.x, -k.z*r, k.z*r), r);
    return length(p)*sign(p.y);
}

// Regular Octogon - exact   (https://www.shadertoy.com/view/llGfDG)
float sdOctogon( in float2 p, in float r )
{
    const float3 k = float3(-0.9238795325, 0.3826834323, 0.4142135623 );
    p = abs(p);
    p -= 2.0*min(dot(float2( k.x,k.y),p),0.0)*float2( k.x,k.y);
    p -= 2.0*min(dot(float2(-k.x,k.y),p),0.0)*float2(-k.x,k.y);
    p -= float2(clamp(p.x, -k.z*r, k.z*r), r);
    return length(p)*sign(p.y);
}

// Hexagram - exact   (https://www.shadertoy.com/view/tt23RR)
float sdHexagram( in float2 p, in float r )
{
    const float4 k = float4(-0.5,0.8660254038,0.5773502692,1.7320508076);
    p = abs(p);
    p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
    p -= 2.0*min(dot(k.yx,p),0.0)*k.yx;
    p -= float2(clamp(p.x,r*k.z,r*k.w),r);
    return length(p)*sign(p.y);
}

// Star 5 - exact   (https://www.shadertoy.com/view/3tSGDy)
float sdStar5(in float2 p, in float r, in float rf)
{
    const float2 k1 = float2(0.809016994375, -0.587785252292);
    const float2 k2 = float2(-k1.x,k1.y);
    p.x = abs(p.x);
    p -= 2.0*max(dot(k1,p),0.0)*k1;
    p -= 2.0*max(dot(k2,p),0.0)*k2;
    p.x = abs(p.x);
    p.y -= r;
    float2 ba = rf*float2(-k1.y,k1.x) - float2(0,1);
    float h = clamp( dot(p,ba)/dot(ba,ba), 0.0, r );
    return length(p-ba*h) * sign(p.y*ba.x-p.x*ba.y);
}


// Regular Star - exact   (https://www.shadertoy.com/view/3tSGDy)
float sdStar(in float2 p, in float r, in int n, in float m)
{
    // next 4 lines can be precomputed for a given shape
    float an = 3.141593/float(n);
    float en = 3.141593/m;  // m is between 2 and n
    float2  acs = float2(cos(an),sin(an));
    float2  ecs = float2(cos(en),sin(en)); // ecs=float2(0,1) for regular polygon

    float bn = atan(p.x, p.y) % (2.0*an) - an;
    p = length(p)*float2(cos(bn),abs(sin(bn)));
    p -= r*acs;
    p += ecs*clamp( -dot(p,ecs), 0.0, r*acs.y/ecs.y);
    return length(p)*sign(p.x);
}


// Pie - exact   (https://www.shadertoy.com/view/3l23RK)
float sdPie( in float2 p, in float2 c, in float r )
{
    p.x = abs(p.x);
    float l = length(p) - r;
    float m = length(p-c*clamp(dot(p,c),0.0,r)); // c=sin/cos of aperture
    return max(l,m*sign(c.y*p.x-c.x*p.y));
}


// Cut Disk - exact   (https://www.shadertoy.com/view/ftVXRc)
float sdCutDisk( in float2 p, in float r, in float h )
{
    float w = sqrt(r*r-h*h); // constant for any given shape
    p.x = abs(p.x);
    float s = max( (h-r)*p.x*p.x+w*w*(h+r-2.0*p.y), h*p.x-w*p.y );
    return (s<0.0) ? length(p)-r :
           (p.x<w) ? h - p.y     :
                     length(p-float2(w,h));
}

// Arc - exact   (https://www.shadertoy.com/view/wl23RK)
float sdArc( in float2 p, in float2 sc, in float ra, float rb )
{
    // sc is the sin/cos of the arc's aperture
    p.x = abs(p.x);
    return ((sc.y*p.x>sc.x*p.y) ? length(p-sc*ra) : 
                                  abs(length(p)-ra)) - rb;
}

// Horseshoe - exact   (https://www.shadertoy.com/view/WlSGW1)
float sdHorseshoe( in float2 p, in float2 c, in float r, in float2 w )
{
    p.x = abs(p.x);
    float l = length(p);
    p = float2x2(-c.x, c.y, c.y, c.x)*p;
    p = float2((p.y>0.0 || p.x>0.0)?p.x:l*sign(-c.x),
             (p.x>0.0)?p.y:l );
    p = float2(p.x,abs(p.y-r))-w;
    return length(max(p,0.0)) + min(0.0,max(p.x,p.y));
}

// Vesica - exact   (https://www.shadertoy.com/view/XtVfRW)
float sdVesica(float2 p, float r, float d)
{
    p = abs(p);
    float b = sqrt(r*r-d*d);
    return ((p.y-b)*d>p.x*b) ? length(p-float2(0.0,b))
                             : length(p-float2(-d,0.0))-r;
}

// Moon - exact   (https://www.shadertoy.com/view/WtdBRS)
float sdMoon(float2 p, float d, float ra, float rb )
{
    p.y = abs(p.y);
    float a = (ra*ra - rb*rb + d*d)/(2.0*d);
    float b = sqrt(max(ra*ra-a*a,0.0));
    if( d*(p.x*b-p.y*a) > d*d*max(b-p.y,0.0) )
          return length(p-float2(a,b));
    return max( (length(p          )-ra),
               -(length(p-float2(d,0))-rb));
}

// Circle Cross - exact   (https://www.shadertoy.com/view/NslXDM)
float sdRoundedCross( in float2 p, in float h )
{
    float k = 0.5*(h+1.0/h); // k should be const at modeling time
    p = abs(p);
    return ( p.x<1.0 && p.y<p.x*(k-h)+h ) ? 
             k-sqrt(dot2(p-float2(1,k)))  :
           sqrt(min(dot2(p-float2(0,h)),
                    dot2(p-float2(1,0))));
}

// Simple Egg - exact   (https://www.shadertoy.com/view/XtVfRW)
float sdEgg( in float2 p, in float ra, in float rb )
{
    const float k = sqrt(3.0);
    p.x = abs(p.x);
    float r = ra - rb;
    return ((p.y<0.0)       ? length(float2(p.x,  p.y    )) - r :
            (k*(p.x+r)<p.y) ? length(float2(p.x,  p.y-k*r)) :
                              length(float2(p.x+r,p.y    )) - 2.0*r) - rb;
}

// Heart - exact   (https://www.shadertoy.com/view/3tyBzV)
float sdHeart( in float2 p )
{
    p.x = abs(p.x);

    if( p.y+p.x>1.0 )
        return sqrt(dot2(p-float2(0.25,0.75))) - sqrt(2.0)/4.0;
    return sqrt(min(dot2(p-float2(0.00,1.00)),
                    dot2(p-0.5*max(p.x+p.y,0.0)))) * sign(p.x-p.y);
}

// Cross - exact exterior, bound interior   (https://www.shadertoy.com/view/XtGfzw)
float sdCross( in float2 p, in float2 b, float r ) 
{
    p = abs(p); p = (p.y>p.x) ? p.yx : p.xy;
    float2  q = p - b;
    float k = max(q.y,q.x);
    float2  w = (k>0.0) ? q : float2(b.y-p.x,-k);
    return sign(k)*length(max(w,0.0)) + r;
}

// Rounded X - exact   (https://www.shadertoy.com/view/3dKSDc)
float sdRoundedX( in float2 p, in float w, in float r )
{
    p = abs(p);
    return length(p-min(p.x+p.y,w)*0.5) - r;
}

// Polygon - exact   (https://www.shadertoy.com/view/wdBXRW)
float sdPolygon( in float2[N] v, in float2 p )
{
    float d = dot(p-v[0],p-v[0]);
    float s = 1.0;
    for( int i=0, j=N-1; i<N; j=i, i++ )
    {
        float2 e = v[j] - v[i];
        float2 w =    p - v[i];
        float2 b = w - e*clamp( dot(w,e)/dot(e,e), 0.0, 1.0 );
        d = min( d, dot(b,b) );
        bool3x3 c = bool3x3(p.y>=v[i].y,p.y<v[j].y,e.x*w.y>e.y*w.x);
        if( all(c) || all(!(c)) ) s*=-1.0;  
    }

    return s*sqrt(d);
}


// Ellipse - exact   (https://www.shadertoy.com/view/4sS3zz)
float sdEllipse( in float2 p, in float2 ab )
{
    p = abs(p); if( p.x > p.y ) {p=p.yx;ab=ab.yx;}

    float l = ab.y*ab.y - ab.x*ab.x;
    float m = ab.x*p.x/l;      float m2 = m*m; 
    float n = ab.y*p.y/l;      float n2 = n*n; 
    float c = (m2+n2-1.0)/3.0; float c3 = c*c*c;
    float q = c3 + m2*n2*2.0;
    float d = c3 + m2*n2;
    float g = m + m*n2;
    float co;
    if( d<0.0 )
    {
        float h = acos(q/c3)/3.0;
        float s = cos(h);
        float t = sin(h)*sqrt(3.0);
        float rx = sqrt( -c*(s + t + 2.0) + m2 );
        float ry = sqrt( -c*(s - t + 2.0) + m2 );
        co = (ry+sign(l)*rx+abs(g)/(rx*ry)- m)/2.0;
    }

    else
    {
        float h = 2.0*m*n*sqrt( d );
        float s = sign(q+h)*pow(abs(q+h), 1.0/3.0);
        float u = sign(q-h)*pow(abs(q-h), 1.0/3.0);
        float rx = -s - u - c*4.0 + 2.0*m2;
        float ry = (s - u)*sqrt(3.0);
        float rm = sqrt( rx*rx + ry*ry );
        co = (ry/sqrt(rm-rx)+2.0*g/rm-m)/2.0;
    }

    float2 r = ab * float2(co, sqrt(1.0-co*co));
    return length(r-p) * sign(p.y-r.y);
}


// Parabola - exact   (https://www.shadertoy.com/view/ws3GD7)
float sdParabola( in float2 pos, in float k )
{
    pos.x = abs(pos.x);
    float ik = 1.0/k;
    float p = ik*(pos.y - 0.5*ik)/3.0;
    float q = 0.25*ik*ik*pos.x;
    float h = q*q - p*p*p;
    float r = sqrt(abs(h));
    float x = (h>0.0) ? 
        pow(q+r,1.0/3.0) - pow(abs(q-r),1.0/3.0)*sign(r-q) :
        2.0*cos(atan(r/q)/3.0)*sqrt(p);
    return length(pos-float2(x,k*x*x)) * sign(pos.x-x);
}


// Parabola Segment - exact   (https://www.shadertoy.com/view/3lSczz)
float sdParabola( in float2 pos, in float wi, in float he )
{
    pos.x = abs(pos.x);
    float ik = wi*wi/he;
    float p = ik*(he-pos.y-0.5*ik)/3.0;
    float q = pos.x*ik*ik*0.25;
    float h = q*q - p*p*p;
    float r = sqrt(abs(h));
    float x = (h>0.0) ? 
        pow(q+r,1.0/3.0) - pow(abs(q-r),1.0/3.0)*sign(r-q) :
        2.0*cos(atan(r/q)/3.0)*sqrt(p);
    x = min(x,wi);
    return length(pos-float2(x,he-x*x/ik)) * 
           sign(ik*(pos.y-he)+pos.x*pos.x);
}


// Quadratic Bezier - exact   (https://www.shadertoy.com/view/MlKcDD)
float sdBezier( in float2 pos, in float2 A, in float2 B, in float2 C )
{    
    float2 a = B - A;
    float2 b = A - 2.0*B + C;
    float2 c = a * 2.0;
    float2 d = A - pos;
    float kk = 1.0/dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);      
    float res = 0.0;
    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx-3.0*ky) + kz;
    float h = q*q + 4.0*p3;
    if( h >= 0.0) 
    { 
        h = sqrt(h);
        float2 x = (float2(h,-h)-q)/2.0;
        float2 uv = sign(x)*pow(abs(x), float2(1.0/3.0));
        float t = clamp( uv.x+uv.y-kx, 0.0, 1.0 );
        res = dot2(d + (c + b*t)*t);
    }

    else
    {
        float z = sqrt(-p);
        float v = acos( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        float3  t = clamp(float3(m+m,-n-m,n-m)*z-kx,0.0,1.0);
        res = min( dot2(d+(c+b*t.x)*t.x),
                   dot2(d+(c+b*t.y)*t.y) );
        // the third root cannot be the closest
        // res = min(res,dot2(d+(c+b*t.z)*t.z));
    }

    return sqrt( res );
}


// Bobbly Cross - exact   (https://www.shadertoy.com/view/NssXWM)
float sdBlobbyCross( in float2 pos, float he )
{
    pos = abs(pos);
    pos = float2(abs(pos.x-pos.y),1.0-pos.x-pos.y)/sqrt(2.0);

    float p = (he-pos.y-0.25/he)/(6.0*he);
    float q = pos.x/(he*he*16.0);
    float h = q*q - p*p*p;
    
    float x;
    if( h>0.0 ) { float r = sqrt(h); x = pow(q+r,1.0/3.0)-pow(abs(q-r),1.0/3.0)*sign(r-q); }

    else        { float r = sqrt(p); x = 2.0*r*cos(acos(q/(p*r))/3.0); }

    x = min(x,sqrt(2.0)/2.0);
    
    float2 z = float2(x,he*(1.0-2.0*x*x)) - pos;
    return length(z) * sign(z.y);
}


// Tunnel - exact   (https://www.shadertoy.com/view/flSSDy)
float sdTunnel( in float2 p, in float2 wh )
{
    p.x = abs(p.x); p.y = -p.y;
    float2 q = p - wh;

    float d1 = dot2(float2(max(q.x,0.0),q.y));
    q.x = (p.y>0.0) ? q.x : length(p)-wh.x;
    float d2 = dot2(float2(q.x,max(q.y,0.0)));
    float d = sqrt( min(d1,d2) );
    
    return (max(q.x,q.y)<0.0) ? -d : d;
}


// Stairs - exact   (https://www.shadertoy.com/view/7tKSWt)
float sdStairs( in float2 p, in float2 wh, in float n )
{
    float2 ba = wh*n;
    float d = min(dot2(p-float2(clamp(p.x,0.0,ba.x),0.0)), 
                  dot2(p-float2(ba.x,clamp(p.y,0.0,ba.y))) );
    float s = sign(max(-p.y,p.x-ba.x) );

    float dia = length(wh);
    p = float2x2(wh.x,-wh.y, wh.y,wh.x)*p/dia;
    float id = clamp(round(p.x/dia),0.0,n-1.0);
    p.x = p.x - id*dia;
    p = float2x2(wh.x, wh.y,-wh.y,wh.x)*p/dia;

    float hh = wh.y/2.0;
    p.y -= hh;
    if( p.y>hh*sign(p.x) ) s=1.0;
    p = (id<0.5 || p.x>0.0) ? p : -p;
    d = min( d, dot2(p-float2(0.0,clamp(p.y,-hh,hh))) );
    d = min( d, dot2(p-float2(clamp(p.x,0.0,wh.x),hh)) );
    
    return sqrt(d)*s;
}

// Making shapes rounded

// All the shapes above can be converted into rounded shapes by subtracting a constant from their distance function.
// That, effectivelly moves the isosurface (isopetimeter I guess) from the level zero to one of the outter rings, which
// naturally are rounded, as it can be seen in the yellow areas in all the images above. So, basically, for any shape
// defined by d(x,y) = sdf(x,y), one can make it sounded by computing d(x,y) = sdf(x,y) - r.
// You can learn more about this in this Youtube video: https://www.youtube.com/watch?v=s5NGeUV2EyU

float opRound( in float2 p, in float r )
{
    return sdShape(p) - r;
}

// These are a few examples: rounded line, rounded triangle, rounded box and a rounded pentagon.

// Making shapes annular

// Similarly, shapes can be made annular (like a ring or the layers of an onion), but taking their absolute value
// and then subtracting a constant from their field.
// So, for any shape defined by d(x,y) = sdf(x,y) compute d(x,y) = |sdf(x,y)| - r:

float opOnion( in float2 p, in float r )
{
    return abs(sdShape(p)) - r;
}

// These are a few examples: annular rounded line, an annular triangle, an annular box and a annular pentagon.

#endif