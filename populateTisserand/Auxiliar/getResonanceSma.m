function sma = getResonanceSma(resonance,smaGA)
%% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%

    % Number of revolutions of the gravity-assist body
    N = resonance(:,1);

    % Number of revolutions of the spacecraft
    M = resonance(:,2);

    % Compute resonance semi-major axis
    sma = ((N./M).^(2/3)) * smaGA;

end