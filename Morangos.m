pkg load image

clear all
close all

[fileName, pathName] = uigetfile({'*.png'; '*.jpg'}, 'Texto da janela');
original = uint8(imread(strcat(pathName, fileName)));

##figure("Name", "Original");
##imshow(original);

#pre-processamento:
imAux01 = original;
for i=1:size(imAux01,1)
  for j=1:size(imAux01,2)
    if(imAux01(i,j,1) < imAux01(i, j, 3) && imAux01(i,j,2) < imAux01(i, j, 3) && imAux01(i,j,3) > 50)
      imAux01(i,j,1) = 0;
      imAux01(i,j,2) = 0;
      imAux01(i,j,3) = 0;
    endif
  endfor 
endfor

imAux02 = original;
for i=1:size(imAux02,1)
  for j=1:size(imAux02,2)
      if(imAux02(i,j,2) < imAux02(i, j, 1))
      imAux02(i,j,1) = 0;
      imAux02(i,j,2) = 0;
      imAux02(i,j,3) = 0;
    endif
  endfor 
endfor

imFinal = imAux01 - imAux02;

##figure("Name", "imAux01");
##imshow(imAux01);

##figure("Name", "imAux02");
##imshow(imAux02);

##figure("Name", "imFinal");
##imshow(imFinal);

##SEGMENTAÇÃO
imFinalR = imFinal(:,:,1);
imFinalG = imFinal(:,:,2);
imFinalB = imFinal(:,:,3);

##figure("Name", "imFinalR");
##imshow(imFinalR);

##figure("Name", "imFinalG");
##imshow(imFinalG);

##figure("Name", "imFinalB");
##imshow(imFinalB);

imFinalGLim = im2bw(imFinalG);

##figure("Name", "CanalG Limiarizado");
##imshow(imFinalGLim);

imFinalGray = rgb2gray(imFinal);

##figure("Name", "imNovaGray");
##imshow(imFinalGray);

imFinal2BW = zeros(size(imFinalGray,1), size(imFinalGray,2)); 

for i=1:size(imFinal2BW,1)
  for j=1:size(imFinal2BW,2)
    if(imFinalGray(i,j) > 0)
      imFinal2BW(i,j) = 1;
    endif
  endfor 
endfor

#figure("Name", "imFinal2BW");
#imshow(imFinal2BW);

imMascaraVermelhos = imFinal2BW - imFinalGLim;

#figure("Name", "imMascaraVermelhos");
#imshow(imMascaraVermelhos);

prop = regionprops(im2bw(imFinal2BW), 'BoundingBox', 'Area');

media = (sum(sum(imFinal2BW))./size(prop,1))*0.3;
cont = 1;
for i=1:size(prop,1)
    if(prop(i).Area > media)
        prop2(cont) = prop(i);
        cont = cont+1;
    end
end

figure('name', 'Final');
imshow(original);

for i=1:size(prop2,2)
    hold on
    if i==1
        rectangle('Position',[prop2(i).BoundingBox(1),prop2(i).BoundingBox(2),prop2(i).BoundingBox(3),prop2(i).BoundingBox(4)],...
            'EdgeColor','g','LineWidth',2 );
        text(prop2(i).BoundingBox(1)+prop2(i).BoundingBox(3)/4, prop2(i).BoundingBox(2)+prop2(i).BoundingBox(4)/4, ...
            'Metrica');
        
        pixelMetrica = (prop2(i).BoundingBox(3) + prop2(i).BoundingBox(4))/2;
    
    else
        rectangle('Position',[prop2(i).BoundingBox(1),prop2(i).BoundingBox(2),prop2(i).BoundingBox(3),prop2(i).BoundingBox(4)],...
            'EdgeColor','r','LineWidth',2 );
        text(prop2(i).BoundingBox(1)+prop2(i).BoundingBox(3)/4, prop2(i).BoundingBox(2)+prop2(i).BoundingBox(4)/4, ...
            sprintf('Morango: %d', i-1));
            
        morango.index = i-1;
        morango.altura = (prop2(i).BoundingBox(4) * 5)/pixelMetrica;
        morango.largura = (prop2(i).BoundingBox(3) * 5)/pixelMetrica;
        morango
        
    end
    hold off   
end





