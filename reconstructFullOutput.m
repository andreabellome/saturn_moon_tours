function outputFor = reconstructFullOutput(outputNext, output2, INPUT)

outputNext2 = outLineByLine(output2);

depNode     = cell2mat({outputNext2.depNode}');
lastNode    = cell2mat({outputNext.lastNode}');

ind = 1;
% n   = size(depNode,1) * size(lastNode,1); 
n   = 300e3;
outputFor = struct( 'LEGS', cell(1,n), 'dvtot', cell(1,n), 'toftot', cell(1,n), ...
    'vinfa', cell(1,n), 'lastNode', cell(1,n), 'nfb', cell(1,n), 'depNode', cell(1,n) );
for indd = 1:size(depNode,1)

    indd/size(depNode,1)*100;

    dnode = depNode(indd,:);

    indxs = find( lastNode(:,1) == dnode(:,1) & lastNode(:,2) == dnode(:,2) & lastNode(:,3) == dnode(:,3) );
    
    for inds = 1:length(indxs)
    
        legsPrev         = outputNext(indxs(inds)).LEGS;
        legsNext         = outputNext2(indd).LEGS;
        legsNext(:,1:12) = [];

        legsNew = [ legsPrev legsNext ];
        [dvtot, toftot, vinfa] = costFunctionTiss(legsNew);

        if dvtot <= INPUT.tolDVmax && toftot <= INPUT.tofdmax

            outputFor(ind).LEGS     = legsNew;
            outputFor(ind).dvtot    = dvtot;
            outputFor(ind).toftot   = toftot;
            outputFor(ind).vinfa    = vinfa;
            outputFor(ind).lastNode = [ legsNew(1,end-11) legsNew(1,end-3:end-2) ];
            outputFor(ind).nfb      = size(legsNew,2);
            outputFor(ind).depNode  = [ legsNew(1,1) legsNew(1,9:10) ];

        end

        ind = ind + 1;

    end

end

emptyIndex            = find(arrayfun(@(outputFor) isempty(outputFor.LEGS),outputFor));
outputFor(emptyIndex) = [];

dvtot     = cell2mat({outputFor.dvtot}');
toftot    = cell2mat({outputFor.toftot}');
matso     = sortrows( [dvtot toftot [1:1:length(dvtot)]' ], [1 2] );
outputFor = outputFor(matso(:,end));

end
