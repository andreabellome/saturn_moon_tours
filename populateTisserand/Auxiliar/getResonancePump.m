function resPumpAngle = getResonancePump(N,M,vInf,rEnc,vFB,muCB)
% Compute the pump angle associated to the specified resonance. This
% function is based on the work of Strange:
%
% Analytical Methods for Gravity-Assist Tour Design. Nathan Strange. 2016.
% PhD Thesis pg.42, Purdue University.
%
% However, it corrects an erratum in the equation in the text and extends
% the formulation to also consider also non-circular orbits of the
% gravity-assist body.
%
% If the resonance can't be achieved with the provided value of v-infinity,
% the function returns a NaN value for the pump angle.
%
% Input:
% - N: number of revolutions of the gravity-assist body [-]
% - M: number of revolutions of the spacecraft [-]
% - vInf: vInf velocity of the flyby [m/s]
% - rEnc: radius of encounter [m] (distance from the central body to the
%         flyby body)
% - vFB: velocity of the gravity-assist body [m/s]
% - muCB: gravitational parameter of the central body [m^3/s^2]
%
% Output:
% - resPumpAngle: pump angle corresponding to the specified resonance [rad]
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Compute local circular velocity
    vc = circularVelocity(muCB,rEnc);

    % Compute the ratio between the gravity-assist body and the spacecraft
    % orbits semi-major axes
    aP_aSC = (M/N)^(2/3);

    % Compute the velocity the spacecraft must have to have the energy
    % required to be in the specified resonance
    vSC2 = 2*(1 - aP_aSC)*vc^2 + vFB^2 * aP_aSC;

    % Compute the pump angle corresponding to N:M resonance
    num = vSC2 - vInf^2 - vFB^2;
    den = 2*vInf*vFB;
    if abs(num) < den % Check if the resonance can be achieved
        resPumpAngle = acos(num/den);
    else
        resPumpAngle = NaN;
    end

end