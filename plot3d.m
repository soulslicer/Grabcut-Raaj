function m = plot3d(image,C,IDX)
s=size(image);

% Plot clusters
hold on;
grid on;
figure(3);
axis([ 0 255 0 255 0 255])
colors = [[0.2 0.4 0.6];[0.3 0.7 0.2];[0.1 0.8 0.9];[0.7 0.2 0.5];[0.4 0.8 0.1];[0.4 0.6 0.6];[0.4 0.6 0.6]];

% Plot centroid
for i = 1:size(C,1),
    plot3(C(i,1),C(i,2),C(i,3),'Marker','*','MarkerEdgeColor',colors(i,:),'markersize', 35);
end

% Plot pixels around
rejector = 50;
rejectcount = 0;
for i = 1 : 1 : s(1)
 for j = 1 : 1 : s(2)
    rejectcount = rejectcount+1;
    if rejectcount<rejector,
        continue
    end
    if rejectcount==rejector,
        rejectcount = 0;
    end
    
    index = i*j;
    label = IDX(index);
    
    plot3(image(i,j,1),image(i,j,2),image(i,j,3),'Marker','.','MarkerEdgeColor',colors(label,:));
 end
end
hold off;
end

