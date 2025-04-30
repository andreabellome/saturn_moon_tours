function [dvv, dv, vv1, vv2, tof1, tof2, rr_apsis, vv2post, vv2pre] = obj_function_full_vilt( xx, pl1, t1, t2, rrga1, rrga2, idcentral, dv_apsis )

muCentral = constants(idcentral, pl1);

r_apsis = xx(1);
theta   = xx(2);
alpha   = xx(3);
tof     = ( t2 - t1 );

tof1    = tof*alpha*86400;
tof2    = tof*(1 - alpha)*86400;

% --> vector of rotation
nn = cross(rrga1, rrga2);
nn = nn / norm(nn);  % normalize
if nn(3) < 0
    nn = cross(rrga2, rrga1);
    nn = nn / norm(nn);  % normalize    
end

vector = rrga1./norm( rrga1 );              % --> vector to rotate
v1     = eulerAxisAngle(vector, nn, theta); % --> rotated vector

% --> where you place the manoeuvre
rr_apsis = r_apsis.*v1';

[vv1, vv2pre]  = lambertMR_MEXIFY_mex(rrga1, rr_apsis, tof1, muCentral, 0, 0);
[vv2post, vv2] = lambertMR_MEXIFY_mex(rr_apsis, rrga2, tof2, muCentral, 0, 0);

[~,~,~,~,vv1, vv2pre] = lambertMR_CER(rrga1, rr_apsis, tof1, muCentral, 0, 0, 0);


dvv = vv2post - vv2pre;
dv  = norm(dvv);

end
