function vB0 = velBeforeTILT_nonDim(raB0, rpB0, aB0, mu)

vcB0 = sqrt( (1 - mu)/aB0 );

if aB0 > 1
    vB0 = vcB0*sqrt( rpB0/raB0 );
elseif aB0 < 1
    vB0 = vcB0*sqrt( raB0/rpB0 );
end

end