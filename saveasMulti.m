function [] = saveasMulti(fig, fname, extensions)
    for k = 1:length(extensions)
        saveas(fig, fname, extensions{k});
    end
end