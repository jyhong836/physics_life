%����Ԫ���Զ���version1.1
% v1.1.1
%   ��ʼ��ϸ������Ϊ128/4��ǽ������Ϊ128*4
% v1.1
%   ####��ϸ�������˶�������ϸ��֮�䣨������ǽ�ڣ���û����ײ�������󣬼�Ŀǰ��
%   ��֤����ϸ��������Ϊ��ײ��������������鿴updateBoxCell.m��####
%   Ϊ�˱�֤pos_code����ȷ�ԣ�Ҳ��updatecells.m�����޸ġ�
%   Ŀǰ�Ѿ���ӦcreateBoxCellinCA���������4x4ϸ��������������ߡ�
%   ÿ������ʱ���ڸýű��У�����boxcells���Ƿ����ٶȷ�0��boxcell��
%
%   ####����ϸ�������������Ӷ�������ԭ�أ�����ϸ���˶���####���Ľ�
%   updateBoxCell.m�е������Ϣ�ں���ĵ����п��ܻ����ã����Ա�����
%
%   �����ļ���
%   updatecells.m
%   updateBoxCell.m
%   createBoxCellinCA.m
%   -createBoxCell.m
%   updatecells_1_1.m
%   randDirection.m
%   setWalls_1_0.m
%
% v1.0
%   �����Ա߽�����HPPģ��
%   Ԫ���Զ�����updatecells_1_0.m

disp('===========================');
disp('            run            ');
disp('===========================');
n=0;
% ------------------��ʼ������--------------------
% �����趨
w=128; % x�᳤��
h=128; % y�᳤��
k=6;   % ���Ը���
walls_code=-128*4; % ǽ�ı���
density=0.4; % �����ʼ��HPP���ӵ��ܶ�

% ��ʼ��cells
cells=int32(rand(w,h,k)<density);%HPP�������඼Ϊ1

% ��ʼ��ѹ����
cells(20:60,20:60,:)=1;
cells(:,:,5:6)=0; % pos_code��0

% ����ǽ��
cells=setWalls(cells,w,h,k,1:w,[1 h],walls_code);
cells=setWalls(cells,w,h,k,[1 w],1:h,walls_code);

% ��ʼ��boxcells
boxcells=[]; % boxcells�б�
for i=[-5 5]
    %% ��ʼ��boxcells
    [cells dx dy]=createBoxCellinCA(cells,70,60+i*4,-128/4);% ϸ������Ϊ-128/4��һ����4��HPP�����γ�
    boxcells(end+1).x=70;
    boxcells(end).y=60+i*4;
    boxcells(end).w=dx;
    boxcells(end).h=dy;
    boxcells(end).dir.x=0;
    boxcells(end).dir.y=0;
end

cells=updatecells(cells,w,h,k);
% ------------------��ʼ������END--------------------

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

% ��ʼ����ͼ
img=cells(:,:,5).*(cells(:,:,5)>0);
spe=cells(:,:,5)<0;
imh = image(cat(3,1-img/4,1-img/4,1-img/4-spe));
set(imh, 'erasemode', 'none'); % �����趨
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
        
        %��� boxcells�б����Ƿ����˶���ϸ��
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
        
        % ��ͼ
        s=sum(cells(:,:,1:4),3);
%         img=cells(:,:,5).*(cells(:,:,5)>0);% HPP���
        img=s.*(cells(:,:,5)>0);% HPP���
        img=img/128*4;
        img=(img.*(~(img>1))).^(1/4);
        spe=cells(:,:,5)*(-1).*(cells(:,:,5)<0);% >0��ϸ��
        spe=spe/128;
        spe=(spe.*(~(spe>1))).^(1/3);
%         maxcolor=max(max(spe));
        set(imh,'cdata',cat(3,1-spe,1-img,1-img));
        
        % ������ʾ
        stepnumber = 1 + stepnumber;%str2num(get(number,'string'));   
        set(number,'string',num2str(stepnumber)); 
        
        if stepnumber>20
            for i=1:2
                boxcells(i).dir=randDirection();% �������
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

