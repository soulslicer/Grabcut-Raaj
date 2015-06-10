function m = visualizeGaussian(GMModel, Array, K, fignum)
    figure(fignum);
    
    % Visualize
    for i=1:K,
        h1 = plot_gaussian_ellipsoid(GMModel.mu(i,:),GMModel.Sigma(:,:,i));
        set(h1,'facealpha',0.3);
        axis([-255 255 255 inf]);
        view(129,36); set(gca,'proj','perspective'); grid on; 
        grid on; axis equal; axis tight;
    end

    rejector = 2;
    rejectcount = 0;
    for i=1:size(Array,1),
        rejectcount = rejectcount+1;
        if rejectcount<rejector,
            continue
        end
        if rejectcount==rejector,
            rejectcount = 0;
        end

        color = Array(i,2:4);
        plot3(color(1),color(2),color(3),'Marker','.','MarkerEdgeColor',color/255);
    end

end