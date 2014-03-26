function [ cellsout ] = setWalls( cells, w, h, k, xx, yy, code)
%给cells设置墙version1.0
%   xx,yy给出墙的宽和长的范围
%   code是墙的编码，真的墙编码为-1
%   这个函数不仅可以设置墙，可以设置占据点
cellsout=cells;

cellsout(xx,yy,:)=0;
cellsout(xx,yy,5)=code;

end

