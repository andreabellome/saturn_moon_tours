function [outputNext, LEGS, depNn, depNnU] = apply_MODP_outputNext(outputNext)

depNn         = cell2mat({outputNext.lastNode}');
[depNnU, IDC] = unique( depNn, 'rows', 'stable'  );

ind = 1;
for inddn = 1:size(depNnU,1)

    indxs = find( depNn(:,1) == depNnU(inddn,1) & ...
        depNn(:,2) == depNnU(inddn,2) & ...
        depNn(:,3) == depNnU(inddn,3));

    OUT    = outputNext(indxs);
    dvtot  = cell2mat({OUT.dvtot}');
    toftot = cell2mat({OUT.toftot}');

    pf = paretoFront_MODP( [ dvtot toftot ] );

    ltos = OUT(pf(:,end));
    outtosave(ind:ind-1+length(ltos)) = ltos;
    ind = ind + length(ltos);

end
outputNext = outtosave;

dvtot      = cell2mat({outputNext.dvtot}');
toftot     = cell2mat({outputNext.toftot}');
matso      = sortrows( [dvtot toftot [1:1:length(dvtot)]' ], [1 2] );
outputNext = outputNext(matso(:,end));

depNn         = cell2mat({outputNext.lastNode}');
[depNnU, IDC] = unique( depNn, 'rows', 'stable'  );
LEGS          = depNode2depRows(depNnU);

end
