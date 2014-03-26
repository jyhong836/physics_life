function [ boxcell ] = createBoxCell( k, type, pos_code )
%createBoxCell生成一个细胞，大小为4*4,内部为2*2的空格version1.1
%   v1.1
%   type:细胞类型，也就是保存在k(5)中的数值。
%   要求在内部的HPP粒子的k(6)也要保存和细胞同样的信息(poscode)
%   pos_code是区分不同细胞的唯一标识。
boxcell=zeros(4,4,k);
if type>=-1 || k<6
    return
end
boxcell(:,:,5)=type;
boxcell(2:3,2:3,5)=0;
boxcell(:,:,6)=pos_code;

end

