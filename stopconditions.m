function [value, isterminal, direction] = stopconditions(times, states)

% stop if its inside the sun
value      = states(2);
isterminal = 1;   % Stop the integration
direction  = 0;

end
