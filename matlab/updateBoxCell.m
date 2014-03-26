function [ cellsout newboxlist newpos_codelist ] = updateBoxCell( cells, box, dir, pos_code )
%更新盒状的细胞version1.1.1
%   v1.1.02
%   发现内部没有空间了，则细胞所有分子分解，分解到当前位置上。
%   在完成细胞的前进之后：
%   1.修改pos_code：细胞内任意一个非HPP格点的坐标编码
%   连通性检测：
%   2.再遍历一遍，把断开的部分分离出一个新细胞。updateBoxcellSize.m
%   已经移到runCA.m里面了
%   问题：会产生一些不移动的细胞粒子，不知道是为什么。
%   v1.1.01
%   从内部排出的HPP粒子形成新的粒子，有一定的几率附着，否则脱离，脱
%   离后，视粒子的大小而分解，附着后更新box的范围。
%   v1.1.0
%   原来的想法：如果格点上有其他细胞的点，则分解为HPP粒子，两个细胞各
%   出两个，剩余的粒子认为被吸收了。
%   实际：所有的非HPP格点，无法重叠，如果遇到pos_code不同的，直接停止
%   前进。
%   box：应当是一个结构体，包括xx,yy属性比如：xx=x1:x2，表示boxcell
%   在cells中的起始和结束位置。
%   dir：移动的方向向量，包含x,y属性
%   用k(6)的pos_code来区分细胞内和细胞外，细胞外的为0；同时不同的细胞
%   的pos_code不同。
%   @pos_code是区分不同细胞（或者非HPP格点）的唯一标识。

% 	####：表示保留的问题
%   #####：表示如果发生，则是必须处理的问题，这里设有keyboard
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
insideEmpty=0;% 内部可以容纳的HPP粒子数（进入位置），注意不是HPP格点数,不是k(5)
HPPOutside=[];
% pos_code=box.xx(1)+w*(box.yy(1)-1);
newpos_code=box.xx(1)+dir.x+w*(box.yy(1)-1+dir.y);
disp(['x    y     pos_code\n',num2str([box.xx(1) box.yy(1),pos_code])]);

for x=box.xx
    for y=box.yy
%         disp(x);
        if pos_code==cells(x,y,6)
            %% 当前格点是要移动的格点
%             disp('found');
%                 disp(num2str([x y dir.x dir.y]));
            if cells(x,y,5)>=0
                % 记录下内部的HPP格点
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
                %% 前方pos_code相同
                cellsout(x1,y1,:)=cells(x,y,:);% 即使是一侧即将进入的粒子也认为被连带走
                cellsout(x1,y1,6)=newpos_code;
                disp(['前方pos_code相同，',num2str([x,y])]);%####
            else
                %% 前方pos_code不同
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
                    disp(['前方pos_code不同，但是没有HPP粒子，',num2str([x,y]),' pose_code: ',num2str([cells(x,y,6),cells(x1,y1,6)])]);%####
                else
                    % 检查前前方
                    x2=x1+dir.x;
                    y2=y1+dir.y;
                    if pos_code==cells(x2,y2,6) || cells(x2,y2,5)==0
                        cellsout(x2,y2,:)=cells(x1,y1,:);
                        cellsout(x1,y1,:)=cells(x,y,:);
                        cellsout(x1,y1,6)=newpos_code;
                        disp(['前方pos_code不同，前前方为空或pos_code相同，',num2str([x,y]),' pose_code: ',num2str([cells(x,y,6),cells(x1,y1,6)])]);%####
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
                        disp(['前方pos_code不同，但成功向前前方转移了，',num2str([x,y]),' pose_code: ',num2str([cells(x,y,6),cells(x1,y1,6)])]);%####
                    else % cells(x2,y2,5)<0 && poscode not equal
                        % 前前方碰到非HPP粒子
                        for i=1:4
                            if cells(x1,y1,i)>0
                                HPPlist(end+1)=cells(x1,y1,i);
                            end
                        end
                        cellsout(x1,y1,:)=cells(x,y,:);
                        cellsout(x1,y1,6)=newpos_code;
                        disp('前方pos_code不同，而且前前方碰到非HPP粒子，准备把HPP粒子后移');
                    end
                end
            end % pos_code~=cells(x1,y1,6)
        else % pos_code~=cells(x,y,6)
            % 非移动格点
%             disp('# 在boxcell范围内发现非细胞格点 #');####
            if cellsout(x,y,5)==0
                cellsout(x,y,:)=cells(x,y,:);
            end
        end % if pos_code==cells(x,y,6)
    end
end
% 处理剩余的HPP粒子
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
            % 没有足够的空粒子位
            i=length(HPPlist)-insideEmpty; % 需要替换的HPP粒子数
            disp(['需要将内部的',num2str(i),'个HPP粒子移出']);
            h=0;
            HPPOutputList=[];
            %% 把内部的HPP粒子替换成外部的，并向后延伸
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
                %% 向运动方向后方延伸细胞格点
                newtype=0;
                for i=1:4
                    newtype=newtype-HPPOutputList(end);
                    HPPOutputList(end)=[];
                    if isempty(HPPOutputList)
                        % HPP粒子数不足4个
                        break;
                    end
                end
                r=rand;
                xtmp=HPPOutside(end).x;
                ytmp=HPPOutside(end).y;
                if r<0.5 % ####产生新细胞粒子的几率是0.4
                    %% 产生新细胞粒子（附着）
                    cellsout(xtmp,ytmp,5)=newtype;
                    cellsout(xtmp,ytmp,6)=newpos_code;
                    % 扩展boxcell的边界
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
                           % pos_code 有变化
                            cellsout(newbox.xx,newbox.yy,6)=cellsout(newbox.xx,newbox.yy,6).*...
                                (cellsout(newbox.xx,newbox.yy,6)~=newpos_code)+...
                                (cellsout(newbox.xx,newbox.yy,6)==newpos_code)*pos_code_tmp;
                            newpos_code=pos_code_tmp;
                        end
                    end
                else
                    if newtype>128/4
                        % 大原子，分解为4个部分
                        part=floor(-newtype/4);%<0
                        cellsout(xtmp,ytmp,1:4)=part;
                        cellsout(xtmp,ytmp,ceil(rand*4))=-newtype-3*part;
                        cellsout(xtmp,ytmp,5)=1;
                        cellsout(xtmp,ytmp,6)=0;
                    else
                        % 小原子不分解
                        cellsout(xtmp,ytmp,ceil(rand*4))=-newtype;
                        cellsout(xtmp,ytmp,5)=1;
                        cellsout(xtmp,ytmp,6)=0;
                    end
                end
                HPPOutside(end)=[];%####可能出现HPPOutside=[]的情况
                h=h-4; % 每次消耗4个粒子，除了最后一次
            end
        end
        %% 向内部填充HPP粒子
        disp('向内部填充HPP粒子');
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
                % 当HPPlist非空，而HPPInside已空的时候，说明内部空位数量不够了
                disp('there is no ENOUGH space inside cell，进来的粒子数太多');
                keyboard;% 必须被处理的问题#####
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
        disp('+ HPPInside is empty，there must be something wrong,or there is no HPP site inside cell');
%         keyboard;% 必须被处理的问题#####
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
% Temp=cellsout(newbox.xx,newbox.yy,6);%##############有一部分被留下来了，没有移动
disp('===move success===');
% disp(cellsout(box.xx,box.yy,6));

end

