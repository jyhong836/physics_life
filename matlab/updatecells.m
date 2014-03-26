function [ cellsout ] = updatecells( cells, w, h, k )
%����Ԫ���Զ���version1.1.02
%   v1.1.02
%   HPP������ײϸ�����ӻ���һ���ļ��ʴ���һ��ԭ�ӣ������Ա߽�㴦�������
%   ���ʵ��� strikeCoef*[��ײ��������/��ײ��ϸ����������]������������Խ�󣬴������ӵ�
%   ������Խ��
%   v1.1.0
%   �����ƶ���ռ�ݷ���
%   k(6):����Ĳ����Ƿ��򣬶���ϸ�����Ͻ�λ�ã����뷽ʽ:=x+w*(y-1);���뷽
%   ʽ��y=floor(double(code)/w))+1,x=code-w*(y-1);����һ���ò������롣
%   ����λ�õļ���ʹ��mean(x)��mean(y)�õ�����ͬһϸ���ڵ�ϸ������HPP��
%   �㶼��k(6)���Ϊ��ͬ��pos_code��
%   
%   v1.0
%   k:=6
%   1~4:�ĸ����������HPP���ӽ��룬���ʾHPP���ӵı��룬���ҽ���Ϊ0ʱ
%   ��ʾ�÷���û������
%   5:����ø�㱻��HPP����ռ�ݣ��򱣴�ռ�����ӵı��루Ϊ��������û�е�
%   ��Ϊ0��û�з�HPPռ�ݵ��������¼HPP���ӵ������������4����
%   6:��5��Ϊ0������£�����ռ�����ӵ���Ϣ��Ŀǰ�������Ƿ������Ϊ0��
%   ʾ���ƶ���
%   
%   �Ѿ������߽磬�߽�ֻ���ڸ����ռ�ݵ��ʱ��Ž��м��
%   �Ѿ�����ռ�ݸ���HPP���ӵķ�����

walls_code=-128*4;
strikeCoef=0.1;

if k<6
    disp('error:k<6');
    return
end
cellsout=zeros(w,h,k);
% x=2:w-1;
% y=2:h-1;
for x=2:w-1
    for y=2:h-1
        %% �����HPP����ո��
        if cells(x,y,5)>=0
            %% ��������
            if cells(x,y,1)>0 && cells(x,y,3)>0 && cells(x,y,2)==0 && cells(x,y,4)==0
                cellsout(x,y+1,4)=cells(x,y,1);
                cellsout(x,y-1,2)=cells(x,y,3);
                cellsout(x,y,5)=2;
                cellsout(x,y,6)=cells(x,y,6);
                continue
            end
            %% ��������
            if cells(x,y,2)>0 && cells(x,y,4)>0 && cells(x,y,1)==0 && cells(x,y,3)==0
                cellsout(x+1,y,1)=cells(x,y,2);
                cellsout(x-1,y,3)=cells(x,y,4);
                cellsout(x,y,5)=2;
                cellsout(x,y,6)=cells(x,y,6);
                continue
            end
            %% ����ǰ��
            for i=1:4
                if cells(x,y,i)>0
                    if mod(i,2)==0 % 2 or 4
                        cellsout(x,y-3+i,i)=cells(x,y,i);
                    else % 1 or 3
                        cellsout(x+2-i,y,i)=cells(x,y,i);
                    end
                    cellsout(x,y,5)=cellsout(x,y,5)+1;
                end
            end
            cellsout(x,y,6)=cells(x,y,6);
        else
            %% ϸ�����
            % ���ƶ�
            cellsout(x,y,5:6)=cells(x,y,5:6);
            if cells(x,y,1)>0
                if rand<strikeCoef*cells(x,y,1)/-cells(x,y,5)
                    cellsout(x,y,5)=cellsout(x,y,5)+1;
                    cellsout(x-1,y,3)=cells(x,y,1)+1;
                else
                    cellsout(x-1,y,3)=cells(x,y,1);
                end
            end
            if cells(x,y,2)>0
                if cellsout(x,y,5)<0 && rand<strikeCoef*cells(x,y,2)/-cells(x,y,5)
                    cellsout(x,y,5)=cellsout(x,y,5)+1;
                    cellsout(x,y+1,4)=cells(x,y,2)+1;
                else
                    cellsout(x,y+1,4)=cells(x,y,2);
                end
            end
            if cells(x,y,3)>0
                if cellsout(x,y,5)<0 && rand<strikeCoef*cells(x,y,3)/-cells(x,y,5)
                    cellsout(x,y,5)=cellsout(x,y,5)+1;
                    cellsout(x+1,y,1)=cells(x,y,3)+1;
                else
                    cellsout(x+1,y,1)=cells(x,y,3);
                end
            end
            if cells(x,y,4)>0
                if cellsout(x,y,5)<0 && rand<strikeCoef*cells(x,y,3)/-cells(x,y,5)
                    cellsout(x,y,5)=cellsout(x,y,5)+1;
                    cellsout(x,y-1,2)=cells(x,y,4)+1;
                else
                    cellsout(x,y-1,2)=cells(x,y,4);
                end
            end
            if cellsout(x,y,5)==0
                cellsout(x,y,6)=0;
            end
        end
    end
end

%% ���ұ߽�
for x=[1 w]
    for y=1:h
        if cells(x,y,5)<0
            %% ռ�ݸ��
            if cells(x,y,1)>0
                cellsout(x-1,y,3)=cells(x,y,1);
            end
            if cells(x,y,2)>0
                cellsout(x,y+1,4)=cells(x,y,2);
            end
            if cells(x,y,3)>0
                cellsout(x+1,y,1)=cells(x,y,3);
            end
            if cells(x,y,4)>0
                cellsout(x,y-1,2)=cells(x,y,4);
            end
            cellsout(x,y,5:6)=cells(x,y,5:6);
        end
    end
end

%% ���±߽�
for x=1:w
    for y=[1 h]
        if cells(x,y,5)<0
            %% ռ�ݸ��
            if cells(x,y,1)>0
                cellsout(x-1,y,3)=cells(x,y,1);
            end
            if cells(x,y,2)>0
                cellsout(x,y+1,4)=cells(x,y,2);
            end
            if cells(x,y,3)>0
                cellsout(x+1,y,1)=cells(x,y,3);
            end
            if cells(x,y,4)>0
                cellsout(x,y-1,2)=cells(x,y,4);
            end
            cellsout(x,y,5:6)=cells(x,y,5:6);
        end
    end
end
end
