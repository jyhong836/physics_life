function [ cellsout ] = setWalls( cells, w, h, k, xx, yy, code)
%��cells����ǽversion1.0
%   xx,yy����ǽ�Ŀ�ͳ��ķ�Χ
%   code��ǽ�ı��룬���ǽ����Ϊ-1
%   �������������������ǽ����������ռ�ݵ�
cellsout=cells;

cellsout(xx,yy,:)=0;
cellsout(xx,yy,5)=code;

end

