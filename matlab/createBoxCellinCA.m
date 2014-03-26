function [ cellsout dx dy ] = createBoxCellinCA( cells, x, y, type )
%在CA中生成一个Box细胞
%   x,y应当代表Box细胞中x,y的最小值
%   依赖文件:createBoxCell.m
%   返回值中dx,dy表示boxcell的size

[w h k]=size(cells);
pos_code=x+w*(y-1);
disp(['create Box cell ',num2str([x y pos_code])]);
boxcell=createBoxCell(k, type, pos_code);
[dx dy k1]=size(boxcell);
cellsout=cells;
if k1~=k
    disp('error in createBoxCellinCA:k not match');
end
if ~isempty(find(cells(x:(x+dx-1),y:(y+dy-1),5)<0, 1))
    disp('error in createBoxCellinCA:create boxcell fail, there have exist some box cells');
    return
end
% rubi=cells(x:(x+dx-1),y:(y+dy-1),:); % #### 被删除掉的HPP粒子，暂时没有用，以后可以考虑删去。 
cellsout(x:(x+dx-1),y:(y+dy-1),:)=boxcell;

end

