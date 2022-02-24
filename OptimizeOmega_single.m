function [R]=OptimizeOmega_single(C,A,ub,lb,sense,ct,b,vt)

[R,c,e,extra] = glpk(C,A,b,lb,ub,ct,vt,sense);
