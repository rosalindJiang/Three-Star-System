from vpython import *
#Web VPython 3.2

G = 6.7e-11

s1 = sphere(pos=vec(-1e11,0,0), radius=2e10, color=color.red, make_trail=True)
s1.mass = 2e30
s1.p = vec(0,0,-1.2e4) * s1.mass
#-1.2e4

s2 = sphere(pos=vec(1.5e11,0,0), radius=2e10, color=color.yellow, make_trail=True)
s2.mass = 1e30
s2.p = -s1.p
#1.2e4

s3 = sphere(pos=vec(6e11,0,0), radius=1e10, color=color.green, make_trail=True)
s3.mass = 1e28
s3.p = vec(0,0,1e4) * s3.mass

#dt = 1e5
dt=1e5
t=0

r12 = s2.pos - s1.pos
r13 = s3.pos - s1.pos
r23 = s3.pos - s2.pos

KEcurve=gcurve(color=color.blue, dot = True)
KE3curve=gcurve(color=color.cyan, dot = True)
PEcurve=gcurve(color=color.yellow, dot = True)
Emechcurve=gcurve(color=color.green, dot = True)
#escapecurve=gcurve(color=color.red, dot = True)
e3=-0.1
#while t < 1e15: 
while e3<0:
    rate(500)
    r12 = s2.pos - s1.pos
    r13 = s3.pos - s1.pos
    r23 = s3.pos - s2.pos

    k1 = 0.5*s1.mass*mag(s1.p/s1.mass)**2
    u1 = -(G*s1.mass*s2.mass/mag(r12))-(G*s1.mass*s3.mass/mag(r13))
    e1 = k1 + u1
    
    k2 = 0.5*s2.mass*mag(s2.p/s2.mass)**2
    u2 = -(G*s1.mass*s2.mass/mag(r12))-(G*s2.mass*s3.mass/mag(r23))
    e2 = k2 + u2
    
    k3 = 0.5*s3.mass*mag(s3.p/s3.mass)**2
    u3 = -(G*s1.mass*s3.mass/mag(r13))-(G*s2.mass*s3.mass/mag(r23))
    e3 = k3 + u3
    
    kt = k1 + k2 + k3
    ut = (-G*s1.mass*s2.mass/mag(r12))+(-G*s1.mass*s3.mass/mag(r13))+(-G*s2.mass*s3.mass/mag(r23))
    ut2 = -G*((s1.mass*s2.mass/mag(r12))+(s2.mass*s3.mass/mag(r23))+(s1.mass*s3.mass/mag(r13)))
    et = kt + ut2
    
    force12 = G * s1.mass * s2.mass * r12.hat / mag(r12)**2
    force13 = G * s1.mass * s3.mass * r13.hat / mag(r13)**2
    force23 = G * s2.mass * s3.mass * r23.hat / mag(r23)**2
    
    s1.p = s1.p + (force12+force13)*dt
    s2.p = s2.p - (force12-force23)*dt
    s3.p = s3.p - (force13+force23)*dt
    
    s1.pos = s1.pos + (s1.p/s1.mass) * dt
    s2.pos = s2.pos + (s2.p/s2.mass) * dt
    s3.pos = s3.pos + (s3.p/s3.mass) * dt
    
#     escapecurve.plot( ( pos=(t,e3) ) )
    KEcurve.plot( ( pos=(t,kt) ) )
    PEcurve.plot( ( pos=(t,ut2) ) )
    Emechcurve.plot( ( pos=(t,et) ) )

    if e3>0:
        print(t)
        break
    t = t+dt
    
