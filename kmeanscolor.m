function [IDX,C,imageNew] = kmeanscolor(image,N,flag)

s=size(image);

if flag == 1,
    r = [];
    g = [];
    b = [];
    for i = 1 : 1 : s(1)
     for j = 1 : 1 : s(2)
       color = image(i,j,:);
       if color(1) ~= 0 && color(2) ~= 0 && color(3) ~= 0,
           r = [r ;color(1)];
           g = [g ;color(2)];
           b = [b ;color(3)];
       else

       end
     end
    end
    imagek = [r g b];
    imagek(:,1) = r; 
    imagek(:,2) = g;
    imagek(:,3) = b;
else
    r = image(:,:,1);
    g = image(:,:,2);
    b = image(:,:,3);
    imagek(:,1) = r(:); 
    imagek(:,2) = g(:);
    imagek(:,3) = b(:);
end

imagek = double(imagek);
[IDX, C] = kmeans(imagek, N, 'EmptyAction', 'singleton');
IDX= uint8(IDX);
C2=round(C);
imageNew = zeros(s(1),s(2),3);

if flag == 0,
    temp = reshape(IDX, [s(1) s(2)]);
    for i = 1 : 1 : s(1)
     for j = 1 : 1 : s(2)
       imageNew(i,j,:) = C2(temp(i,j),:);
     end
    end
    imageNew=uint8(imageNew);
end
    
end