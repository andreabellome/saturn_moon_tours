function PATHph = dividePathPhases_tiss(path, INPUT)

% --> divide the path by phases
ids = unique( path(:,1), 'stable' );

PATHph = struct( 'path', cell(1,length(ids)), 'dvPhase', cell(1,length(ids)),...
    'tofPhase', cell(1,length(ids)), 'dvOI', cell(1,length(ids)) );
for indsol = 1:length(ids)
    indxs     = find(path(:,1) == ids(indsol));
    if indsol == length(ids)
        pathPhase = [ path(indxs,:) ];
    else
        pathPhase = [ path(indxs,:); path(indxs(end)+1,:) ];
    end
    dvPhase                 = sum( pathPhase(2:end,end-1) );
    tofPhase                = sum( pathPhase(2:end,end) );
    PATHph(indsol).path     = pathPhase;
    PATHph(indsol).dvPhase  = dvPhase;
    PATHph(indsol).tofPhase = tofPhase;
end

if nargin == 1
    PATHph(end).dvOI = 0;
else
    pl   = PATHph(end).path(end,1);
    vinf = PATHph(end).path(end,10);

    PATHph(end).dvOI = orbitInsertion(INPUT.idcentral, pl, vinf, INPUT.h);
end

end