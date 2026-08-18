function interRes = findIntermediateResonance(Res1,Res2,maxRev)
% Find the resonance in between two other resonances with the lowest
% possible value for N (revolutions of the gravity-assist body). If several
% resonances with equal value of N are located in between the two provided
% resonance, the function returns the one located closer to the 1:1
% resonance. The number of allowed revolution around the central body can
% be limited through the maxRev parameter.
%
% Remark: N ---> Number of revolutions of the gravity-assist body
%         M ---> Number of spacecraft revolutions
%
% Input:
% - Res1: resonance number 1 [-]. 1x2 matrix of integer values [N M].
%
% - Res2: resonance number 2 [-]. 1x2 matrix of integer values [N M].
%
% - maxRev: maximum value allowed for N and M [-].
%
% - muCB: gravitational parameter of the central body [m^3/s^2]
%
% Output:
% - interRes: resonance in between resonance 1 and 2 with lowest number of
%             gravity-assist body revolutions[-].
%
% Copyright Airbus Defence and Space SAS (c), 2025. All rights reserved.
% Authors:
% - Yago CASTILLA
% - Slim LOCOCHE
%%
    % Extract N and M values
    N1 = Res1(1); M1 = Res1(2);
    N2 = Res2(1); M2 = Res2(2);

    % Compute ratios
    R1 = N1/M1;
    R2 = N2/M2;

    % Check that both resonances are different
    if R1 == R2
        error('Resonances must have different ratios.')
    end

    % Check the resonance with lower ratio
    if R1 < R2
        RLow = R1;
        RHigh = R2;
    else
        RLow = R2;
        RHigh = R1;
    end

    % Check relative position with respect to the 1:1 resonance
    if RLow == 1
        above11 = 1;
    elseif RHigh == 1
        above11 = 0;
    else
        if RHigh < 1
            above11 = 0;
        elseif RLow > 1
            above11 = 1;
        else
            % The 1:1 resonance is in between both resonances
            interRes = [1 1];
            return
        end
    end

    % Split into the cases above or below the 1:1 resonance
    if above11
        % Start the iterations on N
        for N = 2:maxRev

            % Loop in the values of M
            for M = N-1:-1:1

                % Compute the ratio of current resonance
                ratio = N/M;

                % Check if it is above the lower resonance
                if ratio >= RHigh
                    break
                elseif ratio > RLow
                    % Intermidiate resonance found
                    interRes = [N M];
                    return
                end

            end

        end

    else
        % Start the iterations on N
        for N = 1:maxRev

            % Loop in the values of M
            for M = N+1:maxRev

                % Compute the ratio of current resonance
                ratio = N/M;

                % Check if it is above the lower resonance
                if ratio <= RLow
                    break
                elseif ratio < RHigh
                    % Intermidiate resonance found
                    interRes = [N M];
                    return
                end

            end

        end

    end

    % No solution found for the allowed number of revoltions
    interRes = [NaN NaN];

end

