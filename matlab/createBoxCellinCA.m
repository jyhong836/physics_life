function [ cellsout dx dy ] = createBoxCellinCA( cells, x, y, type )
%��CA������һ��Boxϸ��
%   x,yӦ������Boxϸ����x,y����Сֵ
%   �����ļ�:createBoxCell.m
%   ����ֵ��dx,dy��ʾboxcell��size

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
% rubi=cells(x:(x+dx-1),y:(y+dy-1),:); % #### ��ɾ������HPP���ӣ���ʱû���ã��Ժ���Կ���ɾȥ�� 
cellsout(x:(x+dx-1),y:(y+dy-1),:)=boxcell;

end

