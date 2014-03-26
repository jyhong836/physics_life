%运行元胞自动机version1.1
% v1.1.1
%   初始的细胞种类为128/4，墙的种类为128*4
% v1.1
%   ####让细胞可以运动，但是细胞之间（包括和墙壁），没有碰撞破碎现象，即目前的
%   保证所有细胞不会因为碰撞而死亡，具体请查看updateBoxCell.m。####
%   为了保证pos_code的正确性，也在updatecells.m做了修改。
%   目前已经适应createBoxCellinCA添加了两个4x4细胞，让其随机行走。
%   每次运行时（在该脚本中）会检查boxcells中是否有速度非0的boxcell。
%
%   ####所以细胞产生的新粒子都保留在原地，不随细胞运动。####待改进
%   updateBoxCell.m中的输出信息在后面的调试中可能还有用，所以保留。
%
%   依赖文件：
%   updatecells.m
%   updateBoxCell.m
%   createBoxCellinCA.m
%   -createBoxCell.m
%   updatecells_1_1.m
%   randDirection.m
%   setWalls_1_0.m
%
% v1.0
%   周期性边界条件HPP模型
%   元胞自动机见updatecells_1_0.m

disp('===========================');
disp('            run            ');
disp('===========================');
n=0;
% ------------------初始化工作--------------------
% 参数设定
w=128; % x轴长度
h=128; % y轴长度
k=6;   % 属性个数
walls_code=-128*4; % 墙的编码
density=0.4; % 随机初始化HPP粒子的密度

% 初始化cells
cells=int32(rand(w,h,k)<density);%HPP粒子种类都为1

% 初始化压缩波
cells(20:60,20:60,:)=1;
cells(:,:,5:6)=0; % pos_code置0

% 设置墙壁
cells=setWalls(cells,w,h,k,1:w,[1 h],walls_code);
cells=setWalls(cells,w,h,k,[1 w],1:h,walls_code);

% 初始化boxcells
boxcells=[]; % boxcells列表
for i=[-5 5]
    %% 初始化boxcells
    [cells dx dy]=createBoxCellinCA(cells,70,60+i*4,-128/4);% 细胞种类为-128/4，一般由4个HPP粒子形成
    boxcells(end+1).x=70;
    boxcells(end).y=60+i*4;
    boxcells(end).w=dx;
    boxcells(end).h=dy;
    boxcells(end).dir.x=0;
    boxcells(end).dir.y=0;
end

cells=updatecells(cells,w,h,k);
% ------------------初始化工作END--------------------

%-----------------build the GUI --------------------
%define the plot button 
plotbutton=uicontrol('style','pushbutton',... 
'string','Run', ... 
'fontsize',12, ... 
'position',[100,400,50,20], ... 
'callback', 'run=1;'); 
%define the stop button 
erasebutton=uicontrol('style','pushbutton',... 
'string','Stop', ... 
'fontsize',12, ... 
'position',[200,400,50,20], ... 
'callback','freeze=1;'); 
%define the Quit button 
quitbutton=uicontrol('style','pushbutton',... 
'string','Quit', ... 
'fontsize',12, ... 
'position',[300,400,50,20], ... 
'callback','stop=1;close;'); 
number = uicontrol('style','text', ... 
'string','1', ... 
'fontsize',12, ... 
'position',[20,400,50,20]); 

% 初始化绘图
img=cells(:,:,5).*(cells(:,:,5)>0);
spe=cells(:,:,5)<0;
imh = image(cat(3,1-img/4,1-img/4,1-img/4-spe));
set(imh, 'erasemode', 'none'); % 数据设定
%-----------------------------------------

axis equal 
axis tight 

stop= 0; %wait for a quit button push 
run = 0; %wait for a draw  
freeze = 0; %wait for a freeze 

stepnumber=1;
fps=60;
pausetime=1/fps;
while stop==0
    if run==1
        disp(['===============',num2str(stepnumber),'================']);
        
        %检查 boxcells列表，看是否有运动的细胞
        i=length(boxcells);
        while i>0
            if boxcells(i).dir.x~=0||boxcells(i).dir.y~=0
                box.xx=boxcells(i).x:(boxcells(i).x+boxcells(i).w-1);
                box.yy=boxcells(i).y:(boxcells(i).y+boxcells(i).h-1);
                [cells boxcells(i).x boxcells(i).y box]=updateBoxCell(cells,box,boxcells(i).dir);
                boxcells(i).w=box.xx(end)-box.xx(1)+1;
                boxcells(i).w=box.xx(end)-box.yy(1)+1;
                boxcells(i).dir.x=0;
                boxcells(i).dir.y=0;
            end
            i=i-1;
        end
        
        cells=updatecells(cells,w,h,k);%####
%         disp(cells(box.xx,box.yy,6));
        
        % 绘图
        s=sum(cells(:,:,1:4),3);
%         img=cells(:,:,5).*(cells(:,:,5)>0);% HPP格点
        img=s.*(cells(:,:,5)>0);% HPP格点
        img=img/128*4;
        img=(img.*(~(img>1))).^(1/4);
        spe=cells(:,:,5)*(-1).*(cells(:,:,5)<0);% >0，细胞
        spe=spe/128;
        spe=(spe.*(~(spe>1))).^(1/3);
%         maxcolor=max(max(spe));
        set(imh,'cdata',cat(3,1-spe,1-img,1-img));
        
        % 参数显示
        stepnumber = 1 + stepnumber;%str2num(get(number,'string'));   
        set(number,'string',num2str(stepnumber)); 
        
        if stepnumber>20
            for i=1:2
                boxcells(i).dir=randDirection();% 随机行走
            end
        end
    end
    
    if (freeze==1) 
        run = 0; 
        freeze = 0; 
    end
    drawnow
    pause(pausetime);
end

