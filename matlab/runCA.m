%运行元胞自动机version1.1.01
% v1.1.02
%   设置不同pos_code的细胞颜色不同
%   updateBoxcellSize.m完成集团的划分
% v1.1.01
%   初始的细胞种类为128/4，墙的种类为128*4
%   从内部排出的HPP粒子形成新的粒子，有一定的几率附着，否则脱离，脱
%   离后，视粒子的大小而分解，附着后更新box的范围。见updateBoxCell.m
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
clear;
n=0;
% ------------------初始化工作--------------------
% 参数设定
w=128; % x轴长度
h=128; % y轴长度
k=6;   % 属性个数
walls_code=-128*4; % 墙的编码
density=0.5; % 随机初始化HPP粒子的密度

% 初始化cells
cells=int32(rand(w,h,k)<density);%HPP粒子种类都为1

% 初始化压缩波
% cells(20:60,20:60,:)=1;
cells(:,:,5:6)=0; % pos_code置0

% 设置墙壁
cells=setWalls(cells,w,h,k,1:w,[1 h],walls_code);
cells=setWalls(cells,w,h,k,[1 w],1:h,walls_code);

% 初始化boxcells
boxcells=[]; % boxcells列表
for i=[-5 5]
    %% 初始化boxcells
    x=70;
    y=60+i*4;
    % 这里的x,y事细胞左上角的点的位置
    [cells dx dy]=createBoxCellinCA(cells,x,y,-128/4);% 细胞种类为-128/4，一般由4个HPP粒子形成
%     boxcells(end+1).x=x;
%     boxcells(end).y=y;
    boxcells(end+1).pos_code=x+w*(y-1);
    boxcells(end).box.xx=x:(x+dx-1);
    boxcells(end).box.yy=y:(y+dy-1);
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

% 锟斤拷始锟斤拷锟斤拷图
img=cells(:,:,5).*(cells(:,:,5)>0);
spe=cells(:,:,5)<0;
imh = image(cat(3,1-img/4,1-img/4,1-img/4-spe));
% set(imh, 'erasemode', 'none'); % 数据设定
% ---------------------锟斤拷图-------------------------
        s=sum(cells(:,:,1:4),3);
%         img=cells(:,:,5).*(cells(:,:,5)>0);% HPP锟斤拷锟?
        img=s.*(cells(:,:,5)>0);% HPP锟斤拷锟?
        img=img/128*4;
        img=(img.*(~(img>1))).^(1/4);
        spe=cells(:,:,5)*(-1).*(cells(:,:,5)<0);% >0锟斤拷细锟斤拷
        spe=spe/128;
        spe=(spe.*(~(spe>1))).^(1/3);
        
        img=img';
        spe=spe';
%         maxcolor=max(max(spe));
        set(imh,'cdata',cat(3,1-spe,1-img,1-img));
        
        % 锟斤拷锟斤拷锟斤拷示
        stepnumber = 1 ;%+ stepnumber;%str2num(get(number,'string'));   
        set(number,'string',num2str(stepnumber));
        % ---------------------锟斤拷图END-------------------------
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
            disp(['boxcells: ',num2str(i)]);
            if boxcells(i).dir.x~=0||boxcells(i).dir.y~=0
%                 box.xx=boxcells(i).x:(boxcells(i).x+boxcells(i).w-1);
%                 box.yy=boxcells(i).y:(boxcells(i).y+boxcells(i).h-1);
                [ cells newboxlist newpos_codelist ]=updateBoxCell(cells,...
                    boxcells(i).box, boxcells(i).dir, boxcells(i).pos_code);
%                 boxcells(i).w=box.xx(end)-box.xx(1)+1;
%                 boxcells(i).h=box.yy(end)-box.yy(1)+1;
                if ~isempty(newboxlist)&&~isempty(newpos_codelist)
                    [ cells newpos_codelist newboxlist ] = updateBoxcellSize(cells, newpos_codelist(1), newboxlist(1), w, h);
                end
%                 disp(cells(boxcells(1).box.xx,boxcells(1).box.yy,6));
                if length(newboxlist)>=1
                    boxcells(i).box=newboxlist(1);
                    boxcells(i).pos_code=newpos_codelist(1);
                    boxcells(i).dir.x=0;
                    boxcells(i).dir.y=0;
                    for l=2:(length(newboxlist))
                        boxcells(end+1).box=newboxlist(l);
                        boxcells(end).pos_code=newpos_codelist(l);
                        boxcells(end).dir.x=0;
                        boxcells(end).dir.y=0;
                    end
                else % 返回为空，则清除数据
                    disp(['清除',num2str(i),'th boxcell for newboxlist is empty']);
                    boxcells(i)=[];
                end
            end
            i=i-1;
        end
        
        
        cells=updatecells(cells,w,h,k);%####
%         disp(cells(boxcells(1).box.xx,boxcells(1).box.yy,6));
        
        % ---------------------绘图-------------------------
        s=sum(cells(:,:,1:4),3);
%         img=cells(:,:,5).*(cells(:,:,5)>0);% HPP格点
        img=s.*(cells(:,:,5)>0);% HPP格点
        img=img/128*4;
        img=(img.*(~(img>1))).^(1/4);
        spe=cells(:,:,5)*(-1).*(cells(:,:,5)<0);% >0，细胞
        spe=spe/128;
        spe=(spe.*(~(spe>1))).^(1/3);
        pos_color=cells(:,:,6)'/(w+w*(h-1));
        
        img=img';
        spe=spe';
%         maxcolor=max(max(spe));
        set(imh,'cdata',cat(3,1-spe,1-pos_color,1-img));
        
        % 参数显示
        stepnumber = 1 + stepnumber;%str2num(get(number,'string'));   
        set(number,'string',num2str(stepnumber));
        % ---------------------绘图END-------------------------
        
            for i=1:length(boxcells)
                boxcells(i).dir=randDirection();% 锟斤拷锟斤拷锟斤拷锟?
            end
%         if length(boxcells)>=1
%             boxcells(1).dir.y=1;
%         end
    else
        keyboard;
    end
    
    if (freeze==1) 
        run = 0; 
        freeze = 0; 
    end
    drawnow
    pause(pausetime);
end

