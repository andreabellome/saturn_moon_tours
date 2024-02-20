function plotFullPath_tiss(PATHph, INPUT)

% --> plot Tisserand trajectory
for indph = 1:length(PATHph)
    if size(PATHph(indph).path,1) > 1
        plotPath_tiss(PATHph(indph).path, INPUT);
    end
end

end