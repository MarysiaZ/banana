% this is creating rois of equal numbers of voxels for all subjects in objects experiment
% tak an individual ROI for each subject and save to mat file

for nvox= 5:5:9

%PA group    
% subs={'dyslexia_102','dyslexia_103','dyslexia_104','dyslexia_105','dyslexia_106','dyslexia_107','dyslexia_108','dyslexia_109','dyslexia_110','dyslexia_111','dyslexia_112',	'dyslexia_113', 'dyslexia_114', 'dyslexia_116', 'dyslexia_117', 'dyslexia_118', 'dyslexia_202', 'dyslexia_204','dyslexia_205','dyslexia_207','dyslexia_209', 'dyslexia_210', 'dyslexia_211', 'dyslexia_212', 'dyslexia_213', 'dyslexia_215','dyslexia_216','dyslexia_218'};
  
    
% %PM group    
% subs={'dyslexia_102','dyslexia_104','dyslexia_105','dyslexia_106','dyslexia_110','dyslexia_111','dyslexia_112',	'dyslexia_113', 'dyslexia_115', 'dyslexia_116', 'dyslexia_117', 'dyslexia_118', 'dyslexia_119', 'dyslexia_201','dyslexia_202','dyslexia_204', 'dyslexia_205','dyslexia_207','dyslexia_208', 'dyslexia_209', 'dyslexia_210', 'dyslexia_211', 'dyslexia_212', 'dyslexia_213', 'dyslexia_215', 'dyslexia_216', 'dyslexia_217','dyslexia_218'};

 %final group
subs={'firstLev3','firstLev4','firstLev7','firstLev9','firstLev11','firstLev12','firstLev15','firstLev17','firstLev18','firstLev5'};
%nCont = length(strmatch('1',subs));
%nDys = length(strmatch('2',subs));
%xtable = cell(length(subs),3) ;

% this tells you how many voxels you want per subject
nvox = 400;

% here you turn on the masking
Masking = 0;


% here you define the limits within which you search set to large interval if you don't want to use this option (set xmin/max to +-100 if you want no lim here)
% some ROI coordinates:

                % ALL BRAIN
                 %ymin = -100; ymax = 100; 
                %xmin = -100; xmax = 100; 
                %zmin = -100; zmax = 100;
 
                % IPS:
%                 zmax = 65; zmin = 40; ymin = -78; ymax = -47;  % upper IPS
              
                % V1/V2
%                 zmax=3; zmin =-15; ymin = -100; ymax = -95; % V1/V2 center
%                 xmin=-20; xmax =0;  % Left
%                 xmin=0; xmax =25;   % Rmight
                
                % V3/V4
%                 zmax=-3; zmin =-15;  ymin = -90; ymax = -80; % V3/V4 center
%                 xmin=-40; xmax =-10; %Left
%                 xmin=10; xmax =40;  %Right
                              
                % VWFA
%                 zmax = -10; zmin =-25; ymin = -70; ymax = -40; 
%                 xmin=-60; xmax =-30; %Left
%                 xmin=30; xmax =60; %Right

%                 zmax = -10; zmin =-15; ymin = -65; ymax = -57; 
%                 xmin=-60; xmax =-30; %Left
%                 xmin=-41; xmax =-35; %Right

%                 zmax = -5; zmin =-15; ymin = -70; ymax = -50; 
%                 xmin=-45; xmax =-30; %Left
%                 xmin=-41; xmax =-35; %Right

                % MOG
                 %zmax =20; zmin =-5; ymin =-5; ymax = -45; 
                % xmin=-70; xmax =-50; %Left
               %  xmin=50; xmax =70; %Right
% 
%                      zmax =15; zmin =-8; ymin =-93; ymax = -84; 
%                      xmin=-38; xmax =-26; %Left
%                      xmin=10; xmax =20; %Right

%                 DMN nodes - right paracentral
%                 zmax =45,5; zmin =35,5; ymin =-33,5; ymax = -15,5; 
%                 xmin=18; xmax =35; 
                
                
%                 DMN nodes - left IFG
%                 zmax =30; zmin =10; ymin =-11,5; ymax = 10,5; 
%                 xmin=-67; xmax =-47; 

%                 DMN nodes - right frontal
%                 zmax =15; zmin =-10; ymin =49; ymax = 69; 
%                 xmin=5; xmax =25; %Left
%                 
%                 DMN nodes - left STS
%                 zmax =-7; zmin =-27; ymin =-10; ymax = 10; 
%                 xmin=-54; xmax =-34; %Right

%                 DMN nodes - right auditory
               zmax =25; zmin =2; ymin =-47; ymax = 5; 
               xmin=40; xmax =70;
              % xmin=-100; xmaz=100;%Left


% this is the mask, you have to choose one if you are masking
mask ='leftOTC.img';

% choose VOI name
VOIname='DMN5'; 
VOIcontrast ='from_PW'; index_img = 0001; 
VOI_File_Name='ROI_Marysi1';
% VOI_File_Name = [VOIname '_' VOIcontrast '_' mask '_' num2str(nvox)];
 %VOI_File_Name = [VOIname '_' VOIcontrast '_nomask_' num2str(nvox)];
WhereToSaveResults = 'C:\Users\Dell\Desktop\first';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% END OF PARAMETERS BELOW ONLY CODE (well, some params below, but I try...)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% now the loop begins
clear voxels MaxTVals xY;

for s = 1:length(subs)
	anadir = fullfile('C:\Users\Dell\Desktop\matlab\Blinds_wyniki\firsLEV', subs{s},'\');
    
    % this loads the individual T contrast
	cd(anadir);
	Timg = sprintf('spmT_0003.nii',index_img);
	Vt = spm_vol(Timg);
	[Yt,XYZt] = spm_read_vols(Vt);
    % Yt is the actual data (t values or whatever in the img) in x*y*z, XYZt are the
    % mm coords for each voxel (3x n) arranged in the matlab convention
   % maskdir = ['D:\kids_dyslexia_fmri\data\kids_dartel_all\STATS\localizer\PA_subcortical\masks\'];
   
        
    if Masking==1 
        cd(maskdir);
        % this loads the mask
        Mimg = mask;
        Vm = spm_vol(Mimg);
        % loads the contrast map
        [Ym,XYZm] = spm_read_vols(Vm);
        outmask = find(Ym==0); % find where the mask is 0
        Ymt = Yt;
        Ymt(outmask) = 0; % set to 0 all areas that do not fall within the mask
    else
        Ymt = Yt; % no masking, take whole image
    end
    % Ymt is the actual data AFTER MASKING (t values or whatever in the img) in x*y*z, XYZt are the
    % mm coords for each voxel (3x n) arranged in the matlab convention    
    % find all coordinates within a certain range
    coords_to_include = find( XYZt(1,:) > xmin & XYZt(1,:) < xmax & ...
    XYZt(2,:) < ymax & XYZt(2,:) > ymin & XYZt(3,:) > zmin & XYZt(3,:) < zmax);
    dat_to_include = Ymt(coords_to_include);
    % sort acording to t-value
    [sorted,ind] = sort(dat_to_include);
    % get coordinate with max t-value
%     XYZmm = XYZt(:,coords_to_include(ind(length(ind))));
    xY.XYZmm = XYZt(:,coords_to_include(ind(length(ind)-(nvox-1):length(ind))));
    xY.XYZmm
    % and the t-value itself
    % store in a column the size of nulmber of subcts
    for i=1:nvox
        MaxTVals(i) = Ymt(coords_to_include(ind(length(ind)-(i-1))));
    end
    
    % store the coordinates too
    voxels{s}=xY.XYZmm';     
    % this just appends thresholds as a 4th col and displays the voxels
    voxels{s}(:,4)=MaxTVals;
%     disp(subs(s)); 
%     display(sprintf('y filter %.1f %.1f',ymin,ymax));
%     display(sprintf('model: %s contrast no %.0f',ana,index_img));
%     display('xyzmm = [...');
    disp([subs{s} ' ' VOIname ' ' VOIcontrast ' ' num2str(voxels{s}(nvox,4)) '  '... 
        num2str(voxels{s}(1,1),2) ' ' num2str(voxels{s}(1,2),2) ' ' num2str(voxels{s}(1,3),2)]); % output last 

   %%% make table 
   xtable(s,:)=[subs(s), voxels{s}(nvox,4), [num2str(voxels{s}(1,1),2),num2str(voxels{s}(1,2),2),num2str(voxels{s}(1,3),2)]];

    
end


cd(WhereToSaveResults);


clear OutMat;
    OutMat(1,1:7)= {'Group','SubNum','VOIname','from_Contrast','mask','peak','coordinates'};
    OutMat(2:(nCont+1),1)={'Ctrl'};
    OutMat(nCont+2:(length(subs)+1),1)={'Dys'};
    OutMat(2:(length(subs)+1),2)=xtable(:,1);
    OutMat(2:(length(subs)+1),3)={VOIname};
    OutMat(2:(length(subs)+1),4)={VOIcontrast};
    OutMat(2:(length(subs)+1),5)={mask};
    OutMat(2:(length(subs)+1),6)=xtable(:,2);
    OutMat(2:(length(subs)+1),7)=xtable(:,3);
    
    xlsfilename = ['peak_' VOI_File_Name];
 
%     javaaddpath('C:\Program Files\MATLAB\R2011a\java\poi_library\poi-3.8-20120326.jar');
%     javaaddpath('C:\Program Files\MATLAB\R2011a\java\poi_library\poi-ooxml-3.8-20120326.jar');
%     javaaddpath('C:\Program Files\MATLAB\R2011a\java\poi_library\poi-ooxml-schemas-3.8-20120326.jar');
%     javaaddpath('C:\Program Files\MATLAB\R2011a\java\poi_library\xmlbeans-2.3.0.jar');
%     javaaddpath('C:\Program Files\MATLAB\R2011a\java\poi_library\dom4j-1.6.1.jar');
%     javaaddpath('C:\Program Files\MATLAB\R2011a\java\poi_library\stax-api-1.0.1.jar');
    
xlswrite(xlsfilename,OutMat);
xY
%save (fullfile(WhereToSaveResults,[VOI_File_Name  '.mat']),'xY'); %saves coordinates
save (fullfile(WhereToSaveResults,[VOI_File_Name '.mat']),'voxels'); %saves vovexls
%% launch automatically ROI plot
%save blabla1.mat xY
plot_anova_ROI_from_loc(ROI_Marysi1)
plot_anova_ROI_from_loc(VOI_File_Name);

end  % for nvox
