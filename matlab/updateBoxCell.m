function [ cellsout newboxlist newpos_codelist ] = updateBoxCell( cells, box, dir, pos_code )
%���º�״��ϸ��version1.1.1
%   v1.1.02
%   �����ڲ�û�пռ��ˣ���ϸ�����з��ӷֽ⣬�ֽ⵽��ǰλ���ϡ�
%   �����ϸ����ǰ��֮��
%   1.�޸�pos_code��ϸ��������һ����HPP�����������
%   ��ͨ�Լ�⣺
%   2.�ٱ���һ�飬�ѶϿ��Ĳ��ַ����һ����ϸ����updateBoxcellSize.m
%   �Ѿ��Ƶ�runCA.m������
%   ���⣺�����һЩ���ƶ���ϸ�����ӣ���֪����Ϊʲô��
%   v1.1.01
%   ���ڲ��ų���HPP�����γ��µ����ӣ���һ���ļ��ʸ��ţ��������룬��
%   ��������ӵĴ�С���ֽ⣬���ź����box�ķ�Χ��
%   v1.1.0
%   ԭ�����뷨����������������ϸ���ĵ㣬��ֽ�ΪHPP���ӣ�����ϸ����
%   ��������ʣ���������Ϊ�������ˡ�
%   ʵ�ʣ����еķ�HPP��㣬�޷��ص����������pos_code��ͬ�ģ�ֱ��ֹͣ
%   ǰ����
%   box��Ӧ����һ���ṹ�壬����xx,yy���Ա��磺xx=x1:x2����ʾboxcell
%   ��cells�е���ʼ�ͽ���λ�á�
%   dir���ƶ��ķ�������������x,y����
%   ��k(6)��pos_code������ϸ���ں�ϸ���⣬ϸ�����Ϊ0��ͬʱ��ͬ��ϸ��
%   ��pos_code��ͬ��
%   @pos_code�����ֲ�ͬϸ�������߷�HPP��㣩��Ψһ��ʶ��

% 	####����ʾ����������
%   #####����ʾ������������Ǳ��봦������⣬��������keyboard
disp(cells(box.xx,box.yy,6));
[w h k]=size(cells);
newboxlist=[];
newpos_codelist=[];
newx=box.xx(1)+dir.x;
newy=box.yy(1)+dir.y;
newbox.xx=box.xx+dir.x;
newbox.yy=box.yy+dir.y;
if k<6
%     newx=box.xx(1);
%     newy=box.yy(1);
    cellsout=cells;
    newboxlist(1).xx=box.xx;
    newboxlist(1).yy=box.yy;
    newpos_codelist(1)=pos_code;
%     newbox=box;
    disp('cells size error:k<6');
    keyboard;
    return
end
cellsout=cells;
cellsout(box.xx,box.yy,:)=0;% clear
HPPlist=[];
HPPInside=[];
insideEmpty=0;% �ڲ��������ɵ�HPP������������λ�ã���ע�ⲻ��HPP�����,����k(5)
HPPOutside=[];
% pos_code=box.xx(1)+w*(box.yy(1)-1);
newpos_code=box.xx(1)+dir.x+w*(box.yy(1)-1+dir.y);
disp(['x    y     pos_code\n',num2str([box.xx(1) box.yy(1),pos_code])]);

for x=box.xx
    for y=box.yy
%         disp(x);
        if pos_code==cells(x,y,6)
            %% ��ǰ�����Ҫ�ƶ��ĸ��
%             disp('found');
%                 disp(num2str([x y dir.x dir.y]));
            if cells(x,y,5)>=0
                % ��¼���ڲ���HPP���
%                 disp('hpp inside');
                HPPInside(end+1).x=x+dir.x;
                HPPInside(end).y=y+dir.y;
%                 disp(num2str([x+dir.x y+dir.y]));
                insideEmpty=insideEmpty+4-sum(cells(x,y,1:4)>0);%cells(x,y,5);
%             else
% %                 disp(cells(x,y,5));
            end
            x1=x+dir.x;
            y1=y+dir.y;
            if pos_code==cells(x1,y1,6)
                %% ǰ��pos_code��ͬ
                cellsout(x1,y1,:)=cells(x,y,:);% ��ʹ��һ�༴�����������Ҳ��Ϊ��������
                cellsout(x1,y1,6)=newpos_code;
                disp(['ǰ��pos_code��ͬ��',num2str([x,y])]);%####
            else
                %% ǰ��pos_code��ͬ
                if cells(x1,y1,5)<0
                    disp('can not go forward!');
%                     newx=box.xx(1);
%                     newy=box.yy(1); 
                    cellsout=cells;
                    newboxlist(1).xx=box.xx;
                    newboxlist(1).yy=box.yy;
                    newpos_codelist(1)=pos_code;
%                     newbox=box;
                    return
                elseif cells(x1,y1,5)==0
                    cellsout(x1,y1,:)=cells(x,y,:);
                    cellsout(x1,y1,6)=newpos_code;
                    disp(['ǰ��pos_code��ͬ������û��HPP���ӣ�',num2str([x,y]),' pose_code: ',num2str([cells(x,y,6),cells(x1,y1,6)])]);%####
                else
                    % ���ǰǰ��
                    x2=x1+dir.x;
                    y2=y1+dir.y;
                    if pos_code==cells(x2,y2,6) || cells(x2,y2,5)==0
                        cellsout(x2,y2,:)=cells(x1,y1,:);
                        cellsout(x1,y1,:)=cells(x,y,:);
                        cellsout(x1,y1,6)=newpos_code;
                        disp(['ǰ��pos_code��ͬ��ǰǰ��Ϊ�ջ�pos_code��ͬ��',num2str([x,y]),' pose_code: ',num2str([cells(x,y,6),cells(x1,y1,6)])]);%####
                    elseif cells(x2,y2,5)>0
                        for i=1:4
                            if cells(x1,y1,i)>0
                                if cells(x2,y2,i)==0
                                    cellsout(x2,y2,i)=cells(x1,y1,i);
                                else
                                    HPPlist(end+1)=cells(x1,y1,i);
                                end
                            end
                        end
                        cellsout(x1,y1,:)=cells(x,y,:);
                        cellsout(x1,y1,6)=newpos_code;
                        disp(['ǰ��pos_code��ͬ�����ɹ���ǰǰ��ת���ˣ�',num2str([x,y]),' pose_code: ',num2str([cells(x,y,6),cells(x1,y1,6)])]);%####
                    else % cells(x2,y2,5)<0 && poscode not equal
                        % ǰǰ��������HPP����
                        for i=1:4
                            if cells(x1,y1,i)>0
                                HPPlist(end+1)=cells(x1,y1,i);
                            end
                        end
                        cellsout(x1,y1,:)=cells(x,y,:);
                        cellsout(x1,y1,6)=newpos_code;
                        disp('ǰ��pos_code��ͬ������ǰǰ��������HPP���ӣ�׼����HPP���Ӻ���');
                    end
                end
            end % pos_code~=cells(x1,y1,6)
        else % pos_code~=cells(x,y,6)
            % ���ƶ����
%             disp('# ��boxcell��Χ�ڷ��ַ�ϸ����� #');####
            if cellsout(x,y,5)==0
                cellsout(x,y,:)=cells(x,y,:);
            end
        end % if pos_code==cells(x,y,6)
    end
end
% ����ʣ���HPP����
type=0;

for x=box.xx
    for y=box.yy
        if cellsout(x,y,5)==0&&cellsout(x,y,6)==0
%             disp(['output position: ',num2str([x y])]);
            HPPOutside(end+1).x=x;
            HPPOutside(end).y=y;
        elseif cellsout(x,y,5)~=0
            type=cellsout(x,y,5);
        end
    end
end
disp('length(HPPlist)  length(HPPInside) insideEmpty');%####
disp([length(HPPlist),length(HPPInside),insideEmpty]);%####
if ~isempty(HPPlist)
    if ~isempty(HPPInside)
        if length(HPPlist)>insideEmpty
            % û���㹻�Ŀ�����λ
            i=length(HPPlist)-insideEmpty; % ��Ҫ�滻��HPP������
            disp(['��Ҫ���ڲ���',num2str(i),'��HPP�����Ƴ�']);
            h=0;
            HPPOutputList=[];
            %% ���ڲ���HPP�����滻���ⲿ�ģ����������
            t=length(HPPInside);
            while i>0||(mod(h,4)~=0&&~isempty(HPPlist))
                if t<1%t>length(HPPInside)
                    disp(['index<0:unknown error occured in updateBoxCell']);
                    keyboard;
%                     newx=box.xx(1);
%                     newy=box.yy(1);
                    cellsout=cells;
                    newboxlist(1).xx=box.xx;
                    newboxlist(1).yy=box.yy;
                    newpos_codelist(1)=pos_code;
%                     newbox=box;
                    return;
                end
%                 disp(['t ',num2str([t length(HPPlist) HPPInside(t).x HPPInside(t).y])]);
                if sum(cellsout(HPPInside(t).x,HPPInside(t).y,1:4)>0)>0
                    for j=1:4
                        if cellsout(HPPInside(t).x,HPPInside(t).y,j)>0
                            h=h+1;
%                             disp(h);
                            HPPOutputList(end+1)=cellsout(HPPInside(t).x,HPPInside(t).y,j);
                            cellsout(HPPInside(t).x,HPPInside(t).y,j)=HPPlist(end);
                            HPPlist(end)=[];
                            i=i-1;
                            if isempty(HPPlist)
                                disp(['HPPlist is empty ,i= ',num2str(i)]);
                                break;
                            end
                        end
                    end
                end
                t=t-1;
            end
            while h>0
                %% ���˶����������ϸ�����
                newtype=0;
                for i=1:4
                    newtype=newtype-HPPOutputList(end);
                    HPPOutputList(end)=[];
                    if isempty(HPPOutputList)
                        % HPP����������4��
                        break;
                    end
                end
                r=rand;
                xtmp=HPPOutside(end).x;
                ytmp=HPPOutside(end).y;
                if r<0.5 % ####������ϸ�����ӵļ�����0.4
                    %% ������ϸ�����ӣ����ţ�
                    cellsout(xtmp,ytmp,5)=newtype;
                    cellsout(xtmp,ytmp,6)=newpos_code;
                    % ��չboxcell�ı߽�
                    if ytmp>newbox.yy(end)
                        newbox.yy=[newbox.yy ytmp];
                    elseif xtmp>newbox.xx(end)
                        newbox.xx=[newbox.xx xtmp];
                    else
                        pos_code_tmp=0;
                        if ytmp<newbox.yy(1)
                            newbox.yy=[ytmp newbox.yy];
                            newy=ytmp;
                            pos_code_tmp=newx+w*(newy-1);
                        elseif xtmp<newbox.xx(1)
                            newbox.xx=[xtmp newbox.xx];
                            newx=xtmp;
                            pos_code_tmp=newx+w*(newy-1);
                        end
                        if pos_code_tmp~=0&&pos_code_tmp~=newpos_code
                           % pos_code �б仯
                            cellsout(newbox.xx,newbox.yy,6)=cellsout(newbox.xx,newbox.yy,6).*...
                                (cellsout(newbox.xx,newbox.yy,6)~=newpos_code)+...
                                (cellsout(newbox.xx,newbox.yy,6)==newpos_code)*pos_code_tmp;
                            newpos_code=pos_code_tmp;
                        end
                    end
                else
                    if newtype>128/4
                        % ��ԭ�ӣ��ֽ�Ϊ4������
                        part=floor(-newtype/4);%<0
                        cellsout(xtmp,ytmp,1:4)=part;
                        cellsout(xtmp,ytmp,ceil(rand*4))=-newtype-3*part;
                        cellsout(xtmp,ytmp,5)=1;
                        cellsout(xtmp,ytmp,6)=0;
                    else
                        % Сԭ�Ӳ��ֽ�
                        cellsout(xtmp,ytmp,ceil(rand*4))=-newtype;
                        cellsout(xtmp,ytmp,5)=1;
                        cellsout(xtmp,ytmp,6)=0;
                    end
                end
                HPPOutside(end)=[];%####���ܳ���HPPOutside=[]�����
                h=h-4; % ÿ������4�����ӣ��������һ��
            end
        end
        %% ���ڲ����HPP����
        disp('���ڲ����HPP����');
        disp('length(HPPlist)  length(HPPInside) insideEmpty');
        disp([length(HPPlist),length(HPPInside),insideEmpty]);
        while ~isempty(HPPlist)
%             disp(['##' num2str(cellsout(HPPInside(end).x,HPPInside(end).y,5))]);
            if sum(cellsout(HPPInside(end).x,HPPInside(end).y,1:4)>0)<4
                for j=1:4
                    if cellsout(HPPInside(end).x,HPPInside(end).y,j)==0
%                         [HPPInside(end).x,HPPInside(end).y,j,HPPlist(end)]
                        cellsout(HPPInside(end).x,HPPInside(end).y,j)=HPPlist(end);
                        HPPlist(end)=[];
                        disp(length(HPPlist));%####
                        if isempty(HPPlist)
                            disp('break');
                            break;
                        end
                    end
                end
            end
            HPPInside(end)=[];
%             disp(['length of HPPInside: ',num2str(length(HPPInside))]);
            if ~isempty(HPPlist) && isempty(HPPInside)
                % ��HPPlist�ǿգ���HPPInside�ѿյ�ʱ��˵���ڲ���λ����������
                disp('there is no ENOUGH space inside cell��������������̫��');
                keyboard;% ���뱻���������#####
%                 newx=box.xx(1);
%                 newy=box.yy(1);
                cellsout=cells;
                newboxlist(1).xx=box.xx;
                newboxlist(1).yy=box.yy;
                newpos_codelist(1)=pos_code;
%                 newbox=box;
                return;
            end
        end
    else % HPPInside is empty
        disp('there is NO space inside cell');
        disp('+ HPPInside is empty��there must be something wrong,or there is no HPP site inside cell');
%         keyboard;% ���뱻���������#####
%         newx=box.xx(1);
%         newy=box.yy(1);
        cellsout=cells;
        r=ceil(rand*4);
        cellsout(box.xx,box.yy,r)=cellsout(box.xx,box.yy,r)+cellsout(box.xx,box.yy,5).*...
            (-(cellsout(box.xx,box.yy,6)==pos_code)&(cellsout(box.xx,box.yy,5)<0));
        cellsout(box.xx,box.yy,6)=cellsout(box.xx,box.yy,6).*...
            (cellsout(box.xx,box.yy,6)~=pos_code);
        cellsout=cells;
        newboxlist=[];
        newpos_codelist=[];
%         newboxlist(1).xx=box.xx;
%         newboxlist(1).yy=box.yy;
%         newpos_codelist(1)=pos_code;
%         newbox=box;
        return;
    end
end
% newpos_codelist=[];

newpos_codelist(1)=newpos_code;
newboxlist(1).xx=newbox.xx;
newboxlist(1).yy=newbox.yy;
% [ cellsout newpos_codelist newboxlist ] = updateBoxcellSize( cellsout, newpos_code, newbox, w, h );


% cellsout(box.xx+dir.x,box.yy+dir.y,:)=cells(box.xx,box.y,:);
% Temp=cellsout(newbox.xx,newbox.yy,6);%##############��һ���ֱ��������ˣ�û���ƶ�
disp('===move success===');
% disp(cellsout(box.xx,box.yy,6));

end

