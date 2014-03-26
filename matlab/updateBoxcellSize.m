function [ cellsout newpos_codelist newboxlist ] = updateBoxcellSize( cells, newpos_code, newbox, w, h )
%更新boxcell的pos_code，范围，集团的分割
%   v1.1.02
%   更新boxcell的pos_code，范围，集团的分割
%   代码是在updateBoxCell.m里面写了复制过来的，所以变量名字可能有些不合理
cellsout=cells;
newpos_codelist=[];
newboxlist=[];

sameCode=[];
cellsout(newbox.xx,newbox.yy,6)=cellsout(newbox.xx,newbox.yy,6).*...
    (cellsout(newbox.xx,newbox.yy,6)~=newpos_code)...
    -(cellsout(newbox.xx,newbox.yy,6)==newpos_code);
% disp(cellsout(newbox.xx,newbox.yy,6));%####
% 因为boxcell不可能接触到墙，所以不必处理边界问题
for x=newbox.xx
    for y=newbox.yy
        %% 遍历细胞
        if cellsout(x,y,6)==-1
            if cellsout(x-1,y,6)<-1
                cellsout(x,y,6)=cellsout(x-1,y,6);
                if cellsout(x,y-1,6)<-1 && cellsout(x-1,y,6)~=cellsout(x,y-1,6)
                    cellsout(x,y,6)=max(cellsout(x-1,y,6),cellsout(x,y-1,6));
                    sameCode(end+1).max=cellsout(x,y,6);
                    sameCode(end).min=min(cellsout(x-1,y,6),cellsout(x,y-1,6));% 将要被替换掉的部分
                end
            else
                if cellsout(x,y-1,6)<-1
                    cellsout(x,y,6)=cellsout(x,y-1,6);
                else
                    cellsout(x,y,6)=-x-w*(y-1);
                    newpos_codelist(end+1)=-x-w*(y-1);
                end
            end
        end
    end
end
disp('len of sameCode');
disp(length(sameCode));% same code 里面有重复项
for i=1:length(sameCode)
    %% 清理掉重复的pos_code
    disp([sameCode(i).max sameCode(i).min]);
    cellsout(newbox.xx,newbox.yy,6)=...
        (cellsout(newbox.xx,newbox.yy,6)==sameCode(i).min)...
        .*sameCode(i).max...
        +cellsout(newbox.xx,newbox.yy,6).*...
        (cellsout(newbox.xx,newbox.yy,6)~=sameCode(i).min);
    newpos_codelist(find(newpos_codelist==sameCode(i).min))=[];
end
if isempty(newpos_codelist)
    disp('没找到对应pos_code，可能该细胞已经消失');
    newpos_codelist=[];
    newboxlist=[];
    cellsout=cells;
end
for codetmp=newpos_codelist
    %% 更新各个细胞的范围
    [xlist ylist]=find(cellsout(:,:,6)==codetmp);
    xmin=min(xlist);
    xmax=max(xlist);
    ymin=min(ylist);
    ymax=max(ylist);
    newboxlist(end+1).xx=xmin:xmax;
    newboxlist(end).yy=ymin:ymax;
end
disp(['len of newboxlist:',num2str([length(newboxlist)])]);
% if isempty(newboxlist)
%     keyboard;
% end
cellsout(newbox.xx,newbox.yy,6)=(-(cellsout(newbox.xx,newbox.yy,6)<0)).*cellsout(newbox.xx,newbox.yy,6)+...
    (cellsout(newbox.xx,newbox.yy,6)>=0).*cellsout(newbox.xx,newbox.yy,6);
% disp(cellsout(newbox.xx,newbox.yy,6));
newpos_codelist=-newpos_codelist;


end

