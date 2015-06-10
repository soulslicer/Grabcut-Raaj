function data = getlabelarray(image, IDX, set_label)

s=size(image);
data = [];
for i = 1 : 1 : s(1)
    for j = 1 : 1 : s(2)
        idx = i*j;
        label = IDX(idx);
        if label == set_label,
            image_color = [image(i,j,1) image(i,j,2) image(i,j,3)];
            data = [data; image_color];
        end
    end
end 

end