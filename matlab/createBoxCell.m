function [ boxcell ] = createBoxCell( k, type, pos_code )
%createBoxCell����һ��ϸ������СΪ4*4,�ڲ�Ϊ2*2�Ŀո�version1.1
%   v1.1
%   type:ϸ�����ͣ�Ҳ���Ǳ�����k(5)�е���ֵ��
%   Ҫ�����ڲ���HPP���ӵ�k(6)ҲҪ�����ϸ��ͬ������Ϣ(poscode)
%   pos_code�����ֲ�ͬϸ����Ψһ��ʶ��
boxcell=zeros(4,4,k);
if type>=-1 || k<6
    return
end
boxcell(:,:,5)=type;
boxcell(2:3,2:3,5)=0;
boxcell(:,:,6)=pos_code;

end

