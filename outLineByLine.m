function outputNext = outLineByLine(output)

dvtot = cell2mat({output.dvtot}');
n     = length(dvtot);

ind        = 1;
outputNext = struct( 'LEGS', cell(1,n), ...
    'dvtot', cell(1,n), 'toftot', cell(1,n), ...
    'vinfa', cell(1,n), 'lastNode', cell(1,n), 'nfb', cell(1,n) );
for indou = 1:length(output)
    
    LEGS   = output(indou).LEGS;
    dvtot  = output(indou).dvtot;
    toftot = output(indou).toftot;
    vinfa  = output(indou).vinfa;
    for indl = 1:size(LEGS,1)
        
        outputNext(ind).LEGS     = LEGS(indl,:);
        outputNext(ind).dvtot    = dvtot(indl,:);
        outputNext(ind).toftot   = toftot(indl,:);
        outputNext(ind).vinfa    = vinfa(indl,:);
        outputNext(ind).depNode  = [ LEGS(indl,1) LEGS(indl,9:10) ];
        outputNext(ind).lastNode = [ LEGS(indl,end-11) LEGS(indl,end-3:end-2) ];
        outputNext(ind).nfb      = size(LEGS(indl,:),2);

        ind = ind + 1;

    end

end

end