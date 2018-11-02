% AFFICHAGE DU PROFIL DE REPONSE POUR UNE ANOVA DANS SPM
% Revue et corrig�e 05/01/2005
% avec possibilit� de moyenner dans un cube (LC sept 2007)
% change par marcin pour lancer a partir des autres contrastes
% et pour avoir des peaks individuels (Jun 2008)
% added option not to do cube but any set of n voxels given in a mat file
% (Dec 2010)
% modified by Marysia Z to calculate functional ind roi
function [ymat]=plot_anova_profile();

ROILabel=2; % name to be used in excel 1-V1/V2 L, 2 V1/V2 R, 3-V4/V8 L, 4-V4/V8 R
cubesize=6; % taille impaire en voxels du cot� du cube dans lequel les valeurs sont moyenn�es autour du voxel s�lectionn�
cs=(cubesize-1)/2 ;
cs
% this is the param that tells you if you go to another SPM mat for your vals (like
% plottting main from localizer) or if you take vals from the current SPM mat
DifferentSPM=1; %
ManualValues=0; % put 0 if you want to get them from SPM, and Indiv to 0 too
IndivValues=0; % put 0 if you want one value for all subjects
Subjects={'firstLev3','firstLev4','firstLev7','firstLev9','firstLev11','firstLev12','firstLev15','firstLev17','firstLev18','firstLev5'};

NSubj=size(Subjects,1);

FigureWidth=0.21;
%XLSFile=('C:\Documents and Settings\Szwed\Mes documents\projects\NAP fMRI analysis\ROI\ROI_results.xls');
ROIMatFile=('ROI_Marysi1.mat');
PutExcel=1;

%% from below only code 

% load the file with voxels
clear voxels;
load (fullfile('C:\Users\Dell\Desktop\blindd\first\ROI_Marysi1.mat'));

nvoxels=size(voxels{1},10);
nvoxels

if DifferentSPM==1
    % this is for a case where you start it from another contrast
    ModelMat='C:\Users\Dell\Desktop\matlab\Blinds_wyniki\2le\SPM.mat';
%     ModelMat='C:\NAP_2008\anova_main\model_nosmooth_16SJ\SPM.mat';    
    load (ModelMat);
else    
    load('SPM.mat');
end

iM = SPM.xVol.iM ;
fprintf( '\n READ RAW DATA\n' ) ;

% VY is the coordinates of indivudual contrasts, so the size of vy is
% subjects*contrasts. note that the order is cont1(Subj1) cont1(Subj2) ... etc
% 

VY = SPM.xY.VY; 
VY
nconds = length(SPM.xX.iH);
nconds
% nsubj = 2; % for debug, let's see if it works
nsubj = length(VY)/nconds;

nsubj
voxels



if size(voxels{1},2)>3
    for i = 1:nsubj
        voxels{i} (:,4)=[]; % remove the Z score values
    end
end

voxels{1}(1,3)
%% loop that assigns individual xyzvox to individual subjects
% loops on conditions; this is because  spm cannot take simple
% talaraich 3D coordinates but insists on use of a single index number

%xyzvox=zeros(3,length(VY),nvoxels);


for i = 0:1:(nconds-1)
    for j = 1:nsubj        
        for w = 1:nvoxels
             %xyzvox{i*nconds+j}(:,w)  = iM( 1:3, : ) * [ voxels{j}(w,:)' ; 1 ]; 
            xyzvox{i*nsubj+j}(:,w)  = iM( 1:3, : ) * [ voxels{j}(w,:)' ; 1 ]; 

        end
    end           
end    
xyzvox
%% now the data reading starts

y = zeros( nconds*nsubj,1) ;
y
h = waitbar( 0, 'Raw data reading...' ) ;
      waitbar( i/length(VY), h ) ;
      % VY is the coordinates of indivudual contrasts, so the size of vy is
      % subjects*contrasts. note that the order is cont1(Subj1) cont1(Subj2) ... etc  



for i = 1:1:length(VY)
      waitbar( i/length(VY), h ) ;
              for w=1:nvoxels
                    
                   % y(i) = y(i) + spm_sample_vol(VY(i), xyzvox(1,i,w), xyzvox(2,i,w), xyzvox(3,i,w), 0 ) ;
                    
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
meanactiv
%%%% meand by subject:
meanbysubj = mean(ymat');
%%%% mean activation after subtraction of the subject's mean
withinsubj = ymat-repmat(meanbysubj',1,nconds); 
%%%% standard deviation
sterror = std(withinsubj)/sqrt(nsubj);

%numbers=[1,2,3,4,5,6,7,8,9,10]
%t= table(numbers,ymat(1:10),ymat(11:20),'VariableNames',{'species','meas1','meas2'});
%t

%rm = fitrm(t,'meas1-meas2~species')
%% matrix ymat1 of values 
% words controls objects controls
nconds1=2;


%%% indexing on ymat you can choose for which contrasts/subjects you
%%% calculate mean value
rytm=mean(ymat(1:6));
control=mean(ymat(7:12));
%ymat1=[rytm,control];
% computation of mean and error for ymat1
meanactiv1 = mean(ymat);  
meanbysubj = mean(ymat')
meanbysubj
withinsubj1 = ymat-repmat(meanbysubj',1,nconds1); %%%% mean activation after subtraction of the subject's mean
withinsubj1
sterror1 = std(ymat)/sqrt(nsubj);
sterror1
% figure for ymat2

x=ymat(1:6)
y=ymat(7:12)
x
y

[h,p]=ttest(x,y)
h
p
fprintf( '\n DISPLAY RESULTS\n\n' ) ;
figure(31);clf;
hold on

bar(1:nconds,mean(ymat));
errorbar(1:nconds,mean(ymat),sterror,'.k');
xlabel( 'Conditions', 'FontSize', 12 )
YLstr = sprintf( 'Response at [%g, %g, %g]', 10 ) ;
title( YLstr, 'FontSize', 12 )

   
% % 
%% end of PutExcel loop
  

clear ROILabel

