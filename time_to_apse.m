function [dt, rr_out, vv_out] = time_to_apse(rr0, vv0, mu, apse, N)
% TIME_TO_APSE  Time from current state to the N-th periapsis or apoapsis.
%
%   [dt, rr_out, vv_out] = time_to_apse(rr0, vv0, mu, apse, N)
%
%   Inputs:
%     rr0   [1×3 or 3×1]  position vector  [any unit, consistent with mu]
%     vv0   [1×3 or 3×1]  velocity vector  [unit/s]
%     mu    [scalar]       gravitational parameter
%     apse  'peri' | 'apo' — which apse to target
%     N     [integer ≥ 0] — 0 = very next passage, 1 = one full orbit later, …
%
%   Outputs:
%     dt      [scalar]     time to target apse [s]
%     rr_out  [1×3]        position at target apse
%     vv_out  [1×3]        velocity at target apse
%
%   Notes:
%     - Works for any eccentricity 0 < e < 1 (elliptic only).
%     - N=0 always propagates *forward*: if already exactly at the target
%       apse (within tol), returns the passage one full orbit later.
%     - Apoapsis on a near-circular orbit (e < 1e-6) is ill-defined;
%       a warning is issued and dt = half-period is returned.

    %% ── Input parsing ────────────────────────────────────────────────────
    rr0 = rr0(:)';   vv0 = vv0(:)';
    apse = lower(apse);
    assert(ismember(apse, {'peri','apo'}), ...
        'apse must be ''peri'' or ''apo''');
    assert(N >= 0 && floor(N) == N, 'N must be a non-negative integer');

    %% ── Classical elements ───────────────────────────────────────────────
    kep = car2kep([rr0, vv0], mu);   % [a, e, i, OM, om, th]
    a   = kep(1);
    e   = kep(2);
    th0 = mod(kep(6), 2*pi);        % true anomaly ∈ [0, 2π)

    assert(e < 1, 'Orbit is not elliptic (e = %.6f)', e);

    if e < 1e-6 && strcmp(apse, 'apo')
        warning('time_to_apse: near-circular orbit (e=%.2e); apoapsis ill-defined.', e);
    end

    %% ── Target true & mean anomaly ───────────────────────────────────────
    switch apse
        case 'peri';  th_target = 0;
        case 'apo';   th_target = pi;
    end
    % Eccentric and mean anomaly at target are exact:
    %   peri → E=0,  M=0
    %   apo  → E=π,  M=π
    M_target = th_target;   % holds for both cases (E=th for these points)

    %% ── Current mean anomaly ─────────────────────────────────────────────
    E0 = 2*atan2( sqrt(1-e)*sin(th0/2), sqrt(1+e)*cos(th0/2) );
    M0 = mod(E0 - e*sin(E0), 2*pi);   % ∈ [0, 2π)

    %% ── Time difference ──────────────────────────────────────────────────
    n  = sqrt(mu / a^3);              % mean motion [rad/s]
    T  = 2*pi / n;                    % orbital period [s]

    % Forward mean anomaly difference to *first* passage
    dM = mod(M_target - M0, 2*pi);   % ∈ [0, 2π)

    % If already exactly at the apse (within numerical noise), skip to next
    if dM < 1e-10
        dM = 2*pi;
    end

    % Add N full orbits
    dt = (dM + N*2*pi) / n;

    %% ── State at target apse ─────────────────────────────────────────────
    car_out = kep2car( ...
        [a, e, kep(3), kep(4), kep(5), th_target], mu);
    rr_out = car_out(1:3);
    vv_out = car_out(4:6);
    
    rr_out = rr_out(:)';
    vv_out = vv_out(:)';
end