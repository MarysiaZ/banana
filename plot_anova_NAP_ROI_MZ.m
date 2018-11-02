% AFFICHAGE DU PROFIL DE REPONSE POUR UNE ANOVA DANS SPM
% Revue et corrig�e 05/01/2005
% avec possibilit� de moyenner dans un cube (LC sept 2007)
% change par marcin pour lancer a partir des autres contrastes
% et pour avoir des peaks individuels (Jun 2008)
% added option not to do cube but any set of n voxels given in a mat file
% (Dec 2010)

function [ymat]=plot_anova_profile();

ROILabel=2; % name to be used in excel 1-V1/V2 L, 2 V1/V2 R, 3-V4/V8 L, 4-V4/V8 R
cubesize=3; % taille impaire en voxels du cot� du cube dans lequel les valeurs sont moyenn�es autour du voxel s�lectionn�
cs=(cubesize-1)/2 ;
% this is the param that tells you if you go to another SPM mat for your vals (like
% plottting main from localizer) or if you take vals from the current SPM mat
DifferentSPM=1;
ManualValues=1; % put 0 if you want to get them from SPM, and Indiv to 0 too
IndivValues=1; % put 0 if you want one value for all subjects
Subjects=['1','2','3']';
NSubj=size(Subjects,1);
FigureWidth=0.21;
%XLSFile=('C:\Documents and Settings\Szwed\Mes documents\projects\NAP fMRI analysis\ROI\ROI_results.xls');
ROIMatFile=('ROI_Marysi1.mat');
PutExcel=1;

%% from below only code 

% load the file with voxels
clear voxels;
load (fullfile('C:\Users\Dell\Desktop\first\ROI_Marysi1.mat',ROIMatFile));

nvoxels=size(voxels{1},1);


if DifferentSPM==1
    % this is for a case where you start it from another contrast
    ModelMat='C:\Users\Dell\Desktop\fii\sec\SPM.mat';
%     ModelMat='C:\NAP_2008\anova_main\model_nosmooth_16SJ\SPM.mat';    
    load (ModelMat);
else    
    load('SPM.mat');
end

iM = SPM.xVol.iM ;
fprintf( '\n READ RAW DATA\n' ) ;

% VY is the coordinates of indivudual contrasts, so the size of vy is
% subjects*contrasts. note that the order is cont1(Subj1) cont1(Subj2) ... etc

VY = SPM.xY.VY; 
nconds = length(SPM.xX.iH);

% nsubj = 2; % for debug, let's see if it works
nsubj = length(VY)/nconds;

if size(voxels{1},2)>3
    for i = 1:nsubj
        voxels{i} (:,4)=[]; % remove the Z score values
    end
end


%% loop that assigns individual xyzvox to individual subjects
% loops on conditions; this is because  spm cannot take simple
% talaraich 3D coordinates but insists on use of a single index number

% xyzvox=zeros(3,length(VY),nvoxels);


for i = 0:1:(nconds-1)
    for j = 1:nsubj        
        for w = 1:nvoxels
%             xyzvox{i*nconds+j}(:,w)  = iM( 1:3, : ) * [ voxels{j}(w,:)' ; 1 ]; 
            xyzvox{i*nsubj+j}(:,w)  = iM( 1:3, : ) * [ voxels{j}(w,:)' ; 1 ]; 

        end
    end           
end    

%% now the data reading starts

y = zeros( nconds*nsubj,1) ;
h = waitbar( 0, 'Raw data reading...' ) ;
      waitbar( i/length(VY), h ) ;
      % VY is the coordinates of indivudual contrasts, so the size of vy is
      % subjects*contrasts. note that the order is cont1(Subj1) cont1(Subj2) ... etc      
for i = 1:1:length(VY)
      waitbar( i/length(VY), h ) ;
              for w=1:nvoxels
%                     y(i) = y(i) + spm_sample_vol(VY(i), xyzvox(1,i,w), xyzvox(2,i,w), xyzvox(3,i,w), 0 ) ;
                    y(i) = y(i) + spm_sample_vol(VY(i), xyzvox{i}(1,w), xyzvox{i}(2,w), xyzvox{i}(3,w), 0 ) ;

              end
       y(i) = y(i)/nvoxels; 
end    

close(h) ;

fprintf( '\n AVERAGING \n\n' ) ;

%% make new fig
figure(30)
clf;
Lstr ='Response';
annotation('textbox',[0.05 0.97 0.4 0.04],'string',Lstr,'LineStyle','none','FontSize',10);

% matrix ymat of values : all cond x subj
ymat=reshape(y,nsubj,nconds);
% computation of mean and error for ymat
meanactiv = mean(ymat);  
meanbysubj = mean(ymat');
withinsubj = ymat-repmat(meanbysubj',1,nconds); %%%% mean activation after subtraction of the subject's mean
sterror = std(withinsubj)/sqrt(nsubj);

%% matrix ymat1 of values 
% words controls objects controls
nconds1=4;
word=mean(ymat(:,[9:12]),2);
word_control=mean(ymat(:,[13:16]),2);
pict=mean(ymat(:,[1:6]),2);
pict_control=mean(ymat(:,[7:8]),2);
ymat1=[word,word_control,pict,pict_control];
% computation of mean and error for ymat1
meanactiv1 = mean(ymat1);  
meanbysubj1 = mean(ymat1');
withinsubj1 = ymat1-repmat(meanbysubj1',1,nconds1); %%%% mean activation after subtraction of the subject's mean
sterror1 = std(withinsubj1)/sqrt(nsubj);
% figure for ymat2
subplot(2,3,1)
titlestring='rel to baseline';
barweb(reshape(mean(ymat1),2,2)',reshape(sterror1,2,2)',0.75,['Real Ctrl'],[],[],[],bone);
pozycja=get(gca,'Position'); pozycja(3)=FigureWidth;
set(gca,'Position',pozycja,'FontSize',9);
title(titlestring,'FontSize',10);
xlabel( '  words       objects', 'FontSize', 10 )
ylabel( 'Response', 'FontSize', 10 )

%% matrix ymat2 of values 
% words - controls / objects - controls

nconds2=2;
condNames2={'Words','Objects'}';
word_vs_ctrl=word-word_control;
pict_vs_ctrl=pict-pict_control;
ymat2=[word_vs_ctrl,pict_vs_ctrl];
% computation of mean and error for ymat2
meanactiv2 = mean(ymat2);  
meanbysubj2 = mean(ymat2');
withinsubj2 = ymat2-repmat(meanbysubj2',1,nconds2); %%%% mean activation after subtraction of the subject's mean
sterror2 = std(withinsubj2)/sqrt(nsubj*2);
% figure for ymat2
subplot(2,3,2)
titlestring='rel to control';
barweb(mean(ymat2),sterror2,0.5,['words      objects'],[],[],[],gray);
pozycja=get(gca,'Position'); pozycja(3)=FigureWidth;
set(gca,'Position',pozycja,'FontSize',9);
title(titlestring,'FontSize',10);



%%  matrix ymat3 of values 
% words55 words35 gestalts noises objects controls
nconds3=7;
word_55=mean(ymat(:,[9:10]),2);
word_35=mean(ymat(:,[11:12]),2);
word_gestalt=mean(ymat(:,[13:14]),2);
word_noise=mean(ymat(:,[15:16]),2);
samezera(1:16)=0;
ymat3=[word_55,word_35,word_gestalt,word_noise,samezera',pict,pict_control];
% computation of mean and error for ymat1
meanactiv3 = mean(ymat3);  
meanbysubj3 = mean(ymat3');
withinsubj3 = ymat3-repmat(meanbysubj3',1,nconds3); %%%% mean activation after subtraction of the subject's mean
sterror3 = std(withinsubj3)/sqrt(nsubj);
sterror3(5)=0; % this is to have no errbarr at the blank
% figure for ymat3
subplot(2,3,3)
titlestring='detailed comparison';
handles=barweb(mean(ymat3),sterror3,0.75,['55% 35% Gest Noiz  Real Noiz'],[titlestring],[],[],gray);
set(handles.title,'FontSize',10);
pozycja=get(gca,'Position'); pozycja(3)=(FigureWidth+0.05);
set(gca,'Position',pozycja,'FontSize',8);
xlabel( '    words    objects', 'FontSize',10)



%% matrix ymat4 of values 
% comparison for words + objects
% matrix ymat4: to display all word conditions
nconds4=8;
ymat4=[ymat(:,[10,9,12,11]),mean(ymat(:,[14 16]),2),mean(ymat(:,[13 15]),2),ymat(:,[16,15])];
% computation of mean and error for ymat4

meanactiv4 = mean(ymat4);  
meanbysubj4 = mean(ymat4');
withinsubj4 = ymat4-repmat(meanbysubj4',1,nconds4); %%%% mean activation after subtraction of the subject's mean
sterror4 = std(withinsubj4)/sqrt(nsubj);

% figure for ymat4
subplot(2,3,4);
titlestring='words vs ctrls';
handles=barweb(reshape(mean(ymat4),2,4)',reshape(sterror4,2,4)',[],['v  ms'],[titlestring],[],[],gray);
set(handles.title,'FontSize',10);
pozycja=get(gca,'Position'); pozycja(3:4)=[FigureWidth 0.3];
set(gca,'Position',pozycja,'FontSize',9);
xlabel( '55   35 controls noises', 'FontSize', 10 )
ylabel( 'Response', 'FontSize', 10)

%% matrix ymat5: words and objects in one graph

ymat5=[ymat(:,[10,9,12,11]),mean(ymat(:,[2 4 6]),2),mean(ymat(:,[1 3 5]),2)];
nconds5=6;
meanactiv5 = mean(ymat5);  
meanbysubj5 = mean(ymat5');
withinsubj5 = ymat5-repmat(meanbysubj5',1,nconds5); %%%% mean activation after subtraction of the subject's mean
sterror5 = std(withinsubj5)/sqrt(nsubj);
% figure for ymat4
subplot(2,3,5);
titlestring='v>ms in words&objects';
handles=barweb(reshape(mean(ymat5),2,3)',reshape(sterror5,2,3)',[],['v  ms'],[titlestring],[],[],gray);
set(handles.title,'FontSize',10);
pozycja=get(gca,'Position'); pozycja(3:4)=[FigureWidth 0.3];
set(gca,'Position',pozycja,'FontSize',9);
xlabel( '55      35     objects', 'FontSize', 10 )

%% matrix ymat6: to display all picture conditions 
ymat6=ymat(:,[4,3,2,1,6,5,8,7]);
nconds6=8;
% computation of mean and error for ymat4
sterror6 = sterror(1,[4,3,2,1,6,5,8,7]);
% figure for ymat5
subplot(2,3,6);
handles=barweb(reshape(mean(ymat6),2,4)',reshape(sterror6,2,4)',[],['v ms'],['objects detailed'],[],[],gray);
set(handles.title,'FontSize',10);
pozycja=get(gca,'Position'); pozycja(3:4)=[FigureWidth 0.3];
set(gca,'Position',pozycja,'FontSize',9);
xlabel( 'm>v   m=<v   m<<v   noise', 'FontSize', 9 )


% pour grouper une s�rie s en g groupes de n barres
% bar(reshape(s,n,g)')

% ******************************************************
% *     END OF PLOTTING PART
% *     NOW ONLY THE EXCEL WRITING FOR ANOVA
% ******************************************************

%% write ymat to excel
if PutExcel
    SaveButton = questdlg('remember to close the xls file! save values into excel?','close the xls!');
    if strcmp(SaveButton,'Yes')
%% some pre-fabricated values for Excel
    Real(1:NSubj,:)={'real'};
    Control(1:NSubj,:)={'ctrl'};
    Vertex(1:NSubj,:)={'vertex'};
    Mdsg(1:NSubj,:)={'mdsg'};
    Object(1:NSubj,:)={'object'};
    Word(1:NSubj,:)={'word'};
 
%% now the first matrix of results
% verify the current sizes of the data in the workbook
    sajz1=size(xlsread(XLSFile,'word-pict','A:A'),1);
    clear OutMat;
    condNames1={'WordReal','WordCtrl','ObjReal','ObjCtrl'}';    
    OutMat(1:(NSubj*nconds1),1)=ROILabel;
    OutMat(1:(NSubj*nconds1),2)=vertcat(Subjects,Subjects,Subjects,Subjects);
    OutMat(1:(NSubj*nconds1),3)=reshape(ymat1,(NSubj*nconds1),1);
    WriteInCell=sprintf('A%d',(sajz1+3));
    OutMat=num2cell(OutMat);
    OutMat(1:(NSubj*nconds1),6)=vertcat(Word,Word,Object,Object);
    OutMat(1:(NSubj*nconds1),7)=vertcat(Real,Control,Real,Control);
    for i=0:(nconds1-1)
        for j=1:NSubj
            if IndivValues==1
                OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]',mean(voxels{j}(:,1)),mean(voxels{j}(:,2)),mean(voxels{j}(:,3)));
            end
        OutMat{i*NSubj+j,5}=condNames1{i+1};        
        end
    end    
    fprintf( '\n WRITING EXCEL....\n\n' ) ;
     xlswrite(XLSFile,OutMat,'word-pict',WriteInCell);       
     
%% the 2nd matrix of results
    clear OutMat;
    % get the pointer where to write in xls
    sajz2=size(xlsread(XLSFile,'word-pict','H:H'),1);
    OutMat(1:(NSubj*nconds2),1)=ROILabel;
    % here you have to adust manually for every matrix size
    OutMat(1:(NSubj*nconds2),2)=vertcat(Subjects,Subjects);
    OutMat(1:(NSubj*nconds2),3)=reshape(ymat2,(NSubj*nconds2),1);
    WriteInCell=sprintf('H%d',(sajz2+3));
    OutMat=num2cell(OutMat);
    for i=0:(nconds2-1)
        for j=1:NSubj
          if IndivValues==1
                OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', mean(voxels{j}(:,1)),mean(voxels{j}(:,2)),mean(voxels{j}(:,3)));
            end
        OutMat{i*NSubj+j,5}=condNames2{i+1};
        end
    end    
     xlswrite(XLSFile,OutMat,'word-pict',WriteInCell);       
%% the 3rd matrix of results 
    clear OutMat;
    % verify the current sizes of the data in the workbook
    sajz3=size(xlsread(XLSFile,'word-pict','M:M'),1);
    condNames3={'word-55','word-35','word-gestalt','word-noize','objt','objt-noize'};
    if size(ymat3,2)>6
        ymat3(:,5)=[]; nconds3=6; % delete the row of 0's that was there for cosmetic reasons
    end
    OutMat(1:(NSubj*nconds3),1)=ROILabel;
    OutMat(1:(NSubj*nconds3),2)=vertcat(Subjects,Subjects,Subjects,Subjects,Subjects,Subjects);
    OutMat(1:(NSubj*nconds3),3)=reshape(ymat3,(NSubj*nconds3),1);
    WriteInCell=sprintf('M%d',(sajz3+3));
    OutMat=num2cell(OutMat);
    OutMat(1:(NSubj*nconds3),6)=vertcat(Word,Word,Word,Word,Object,Object);
    OutMat(1:(NSubj*nconds3),7)=vertcat(Real,Real,Control,Control,Real,Control);
    for i=0:(nconds3-1)
        for j=1:NSubj
          if IndivValues==1
                OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', mean(voxels{j}(:,1)),mean(voxels{j}(:,2)),mean(voxels{j}(:,3)));
            end
        OutMat{i*NSubj+j,5}=condNames3{i+1};
        end
    end    
     xlswrite(XLSFile,OutMat,'word-pict',WriteInCell);       
    
% %% the 4th matrix of results: Vertex/Midsegment in Words
%     clear OutMat;
%     condNames4={'word-55-vert','word-55-mdsg','word-35-vert','word-35-mdsg','ctrl-55-vert','ctrl-55-mdsg','noiz-55-vert','noiz-55-mdsg'};
%     % verify the current sizes of the data in the workbook
%     sajz4=size(xlsread(XLSFile,'vert-mdsg','A:A'),1);
%     OutMat(1:(NSubj*nconds4),1)=ROILabel;
%     OutMat(1:(NSubj*nconds4),2)=vertcat(Subjects,Subjects,Subjects,Subjects...
%         ,Subjects,Subjects,Subjects,Subjects);
%     OutMat(1:(NSubj*nconds4),3)=reshape(ymat4,(NSubj*nconds4),1);
%     WriteInCell=sprintf('A%d',(sajz4+3));
%     OutMat=num2cell(OutMat);
%     OutMat(1:(NSubj*nconds4),6)=vertcat(Real,Real,Real,Real,Control,Control,Control,Control);
%     OutMat(1:(NSubj*nconds4),7)=vertcat(Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg);
%     for i=0:(nconds4-1)
%         for j=1:NSubj
%           if IndivValues==1
%                 OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', mean(voxels{j}(:,1)),mean(voxels{j}(:,2)),mean(voxels{j}(:,3)));
%             end
%         OutMat{i*NSubj+j,5}=condNames4{i+1};
%         end
%     end    
%     
%       xlswrite(XLSFile,OutMat,'vert-mdsg',WriteInCell);       
% %% the 5th matrix: same but with noises only
% 
%     clear OutMat;
%     condNames5={'word-55-vert','word-55-mdsg','word-35-vert','word-35-mdsg','obj-vert','obj-mdsg'};
%     % verify the current sizes of the data in the workbook
%     sajz5=size(xlsread(XLSFile,'vert-mdsg','H:H'),1);
%     OutMat(1:(NSubj*nconds5),1)=ROILabel;
%     OutMat(1:(NSubj*nconds5),2)=vertcat(Subjects,Subjects,Subjects,Subjects...
%         ,Subjects,Subjects);
%     OutMat(1:(NSubj*nconds5),3)=reshape(ymat5,(NSubj*nconds5),1);
%     WriteInCell=sprintf('H%d',(sajz5+3));
%     OutMat=num2cell(OutMat);
%     OutMat(1:(NSubj*nconds5),6)=vertcat(Word,Word,Word,Word,Real,Real);
%     OutMat(1:(NSubj*nconds5),7)=vertcat(Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg);
%     for i=0:(nconds5-1)
%         for j=1:NSubj
%           if IndivValues==1
%                 OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', mean(voxels{j}(:,1)),mean(voxels{j}(:,2)),mean(voxels{j}(:,3)));
%             end
%         OutMat{i*NSubj+j,5}=condNames5{i+1};
%         end
%     end    
%     
%       xlswrite(XLSFile,OutMat,'vert-mdsg',WriteInCell);       
% %% the 6th matrix: objects
% 
%     clear OutMat;
%     condNames6={'Pict45MdsgVertex','Pict45MdsgMdseg','Pict45IntermVertex','Pict45IntermMdseg','Pict45VrtxyVertex','Pict45VrtxyMdseg',...
%    'PictFeatNoizVertex','PictFeatNoizMdseg'};
%     % verify the current sizes of the data in the workbook
%     sajz6=size(xlsread(XLSFile,'vert-mdsg','O:O'),1);
%     OutMat(1:(NSubj*nconds6),1)=ROILabel;
%     OutMat(1:(NSubj*nconds6),2)=vertcat(Subjects,Subjects,Subjects,Subjects...
%         ,Subjects,Subjects,Subjects,Subjects);
%     OutMat(1:(NSubj*nconds6),3)=reshape(ymat6,(NSubj*nconds6),1);
%     WriteInCell=sprintf('O%d',(sajz6+3));
%     OutMat=num2cell(OutMat);
%     OutMat(1:(NSubj*nconds6),6)=vertcat(Real,Real,Real,Real,Real,Real,Control,Control);
%     OutMat(1:(NSubj*nconds6),7)=vertcat(Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg);
%     for i=0:(nconds6-1)
%         for j=1:NSubj
%           if IndivValues==1
%                 OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', mean(voxels{j}(:,1)),mean(voxels{j}(:,2)),mean(voxels{j}(:,3)));
%             else
%                 OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', xyzmm(1),xyzmm(2),xyzmm(3));
%             end
%         OutMat{i*NSubj+j,5}=condNames6{i+1};
%         end
%     end    
%     
%       xlswrite(XLSFile,OutMat,'vert-mdsg',WriteInCell);       
%       
%       
%% %%     this is for the raw results of all 16 conditions
%     clear OutMat;
%     % verify the current sizes of the data in the workbook    
%     sajz7=size(xlsread(XLSFile,'raw','A:A'),1);    
%     condNames7={'Pict45IntermMdseg','Pict45IntermVertex','Pict45MdsgMdseg','Pict45MdsgVertex',...
%         'Pict45VrtxyMdseg','Pict45VrtxyVertex','PictFeatNoizMdseg',...
%    'PictFeatNoizVertex','Word45Mdseg','Word45Vertex','Word65Mdseg','Word65Vertex',...
%    'GestaltsMdseg','GestaltsVertex','WordFeatNoizMdseg','WordFeatNoizVertex'};
%     nconds7=16; % delete the row of 0's that was there for cosmetic reasons
%     OutMat(1:(NSubj*nconds7),1)=ROILabel;
%     OutMat(1:(NSubj*nconds7),2)=vertcat(Subjects,Subjects,Subjects,Subjects,Subjects,Subjects,...
%         Subjects,Subjects,Subjects,Subjects,Subjects,Subjects,Subjects,Subjects,Subjects,Subjects);
%     OutMat(1:(NSubj*nconds7),3)=reshape(ymat,(NSubj*nconds7),1);
%     WriteInCell=sprintf('A%d',(sajz7+3));
%     OutMat=num2cell(OutMat);
%     OutMat(1:(NSubj*nconds7),6)=vertcat(Real,Real,Real,Real,Real,Real,Control,Control,Real,Real,Real,Real,Control,Control,Control,Control);
%     OutMat(1:(NSubj*nconds7),7)=vertcat(Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex,Mdsg,Vertex);
%     OutMat(1:(NSubj*nconds7),8)=vertcat(Object,Object,Object,Object,Object,Object,Object,Object,Word,Word,Word,Word,Word,Word,Word,Word);    
%     for i=0:(nconds7-1)
%         for j=1:NSubj
%           if IndivValues==1
%                 OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', mean(voxels{j}(:,1)),mean(voxels{j}(:,2)),mean(voxels{j}(:,3)));
%             else
%                 OutMat{i*NSubj+j,4}=sprintf( '[%g, %g, %g]', xyzmm(1),xyzmm(2),xyzmm(3));
%             end
%         OutMat{i*NSubj+j,5}=condNames7{i+1};
%         end
%     end    
%      xlswrite(XLSFile,OutMat,'raw',WriteInCell);       
% % 
%% end of PutExcel loop
    end   
end
fprintf( 'DONE! \n' ) ;
% ymat1    
clear ROILabel

