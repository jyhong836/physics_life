function [ dirout ] = randDirection(  )
%����һ������ķ���d��
%   version1.1
%   dirout:(1,0),(-1,0),(0,1),(0,0),(0,-1)
r=rand;
if r<1/5
    dirout.x=1;
    dirout.y=0;
elseif r<2/5
    dirout.x=-1;
    dirout.y=0;
elseif r<3/5
    dirout.x=0;
    dirout.y=0;
elseif r<4/5
    dirout.x=0;
    dirout.y=1;
else
    dirout.x=0;
    dirout.y=-1;
end

end

