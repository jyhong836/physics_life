function [ cellsout newpos_codelist newboxlist ] = updateBoxcellSize( cells, newpos_code, newbox, w, h )
%����boxcell��pos_code����Χ�����ŵķָ�
%   v1.1.02
%   ����boxcell��pos_code����Χ�����ŵķָ�
%   ��������updateBoxCell.m����д�˸��ƹ����ģ����Ա������ֿ�����Щ������
cellsout=cells;% boxcell��չһ�α߽������
newpos_codelist=[];
newboxlist=[];

sameCode=[];
cellsout(newbox.xx,newbox.yy,6)=cellsout(newbox.xx,newbox.yy,6).*...
    (cellsout(newbox.xx,newbox.yy,6)~=newpos_code)...
    -(cellsout(newbox.xx,newbox.yy,6)==newpos_code);
% ��Ϊboxcell�����ܽӴ���ǽ�����Բ��ش���߽�����
for x=newbox.xx
    for y=newbox.yy
        if cellsout(x,y,6)==-1
            if cellsout(x-1,y,6)<-1
                cellsout(x,y,6)=cellsout(x-1,y,6);
                if cellsout(x,y-1,6)<-1 && cellsout(x-1,y,6)~=cellsout(x,y-1,6)
                    cellsout(x,y,6)=max(cellsout(x-1,y,6),cellsout(x,y-1,6));
                    sameCode(end+1).max=cellsout(x,y,6);
                    sameCode(end).min=min(cellsout(x-1,y,6),cellsout(x,y-1,6));% ��Ҫ���滻���Ĳ���
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
disp(cellsout(newbox.xx,newbox.yy,6));%####
disp('len of sameCode');
disp(length(sameCode));% same code �������ظ���
for i=1:length(sameCode)
    disp([sameCode(i).max sameCode(i).min]);
    cellsout(newbox.xx,newbox.yy,6)=...
        (cellsout(newbox.xx,newbox.yy,6)==sameCode(i).min)...
        .*sameCode(i).max...
        +cellsout(newbox.xx,newbox.yy,6).*...
        (cellsout(newbox.xx,newbox.yy,6)~=sameCode(i).min);
    newpos_codelist(find(newpos_codelist==sameCode(i).min))=[];
end
for codetmp=newpos_codelist
    [xlist ylist]=find(cellsout(:,:,6)==codetmp);
    xmin=min(xlist);
    xmax=max(xlist);
    ymin=min(ylist);
    ymax=max(ylist);
    newboxlist(end+1).xx=xmin:xmax;
    newboxlist(end).yy=ymin:ymax;
end
disp(['len of newboxlist:',num2str([length(newboxlist)])]);
disp(cellsout(newbox.xx,newbox.yy,6));
cellsout(newbox.xx,newbox.yy,6)=(-(cellsout(newbox.xx,newbox.yy,6)<0)).*cellsout(newbox.xx,newbox.yy,6)+...
    (cellsout(newbox.xx,newbox.yy,6)>=0).*cellsout(newbox.xx,newbox.yy,6);
newpos_codelist=-newpos_codelist;


end

