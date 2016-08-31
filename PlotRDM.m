function rdm = PlotRDM(rdm)

ods = find(eye(size(rdm,1)));
rdm(ods) = NaN;
imagesc(rdm)
%pcolor(rdm')
axis('square')
colormap('jet')

hold on
matind = ones(size(rdm));
mind = find(matind == 1);
[mx my] = ind2sub(size(matind),mind);
for pos = 1:length(mx)
    h1 = rectangle('position',[my(pos)-.5 mx(pos)-.5 1 1 ]);
    set(h1,'EdgeColor',[0 0 0], 'linewidth',1.5);
end
axis('square')
set(gca,'xtick',[])
set(gca,'ytick',[])
colorbar

end