function outputNext = pruneOutputNext(outputNext, INPUT)

if ~isempty(outputNext)
    outputNext( [ outputNext.dvtot ]' > INPUT.tolDVmax) = [];
end

if ~isempty(outputNext)
    outputNext( [ outputNext.toftot ]' > INPUT.tofdmax ) = [];
end

dvtot    = cell2mat({outputNext.dvtot}');
toftot   = cell2mat({outputNext.toftot}');

matso      = sortrows( [dvtot toftot [1:1:length(dvtot)]'], [1, 2] );
outputNext = outputNext(matso(:,end));

end