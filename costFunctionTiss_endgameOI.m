function [dvtot, toftot, vinfa, dvs, tofs, alpha] = costFunctionTiss_endgameOI(LEGSnext, idcentral, pl, h)

dvs    = LEGSnext(:,11:12:end-1);
tofs   = LEGSnext(:,12:12:end);
dvtot  = sum(dvs,2);
toftot = sum(tofs,2);
vinfa  = LEGSnext(:,end-2);
alpha  = LEGSnext(:,end-3);

dv     = orbitInsertion(idcentral, pl, vinfa, h);

dvtot  = dvtot + dv;

end
