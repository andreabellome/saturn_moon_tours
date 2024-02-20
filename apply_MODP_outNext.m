function [LEGS, outputNext] = apply_MODP_outNext(outputNext)

outputNext = apply_MODP_outputNext(outputNext);

LEGS = zeros( length(outputNext), 12 );
for indou = 1:length(outputNext)

    dv = outputNext(indou).dvtot;
    dt = outputNext(indou).toftot;
    
    LEGS(indou,:) = outputNext(indou).LEGS(:,end-11:end);
    LEGS(indou,11:12) = [ dv dt ];

end

end