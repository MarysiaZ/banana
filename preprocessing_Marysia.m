
%PREPROCESSING
clear all
nScans= [369 369];
dir='C:\Users\Dell\Desktop\BLIND1\'
subjects=[4]
nruns=2%no of runs per subject
runy={'RUN1.nii','RUN2.nii'}%functional images stored in 4D nifti files
runy2={'^RUN1.nii','^RUN2.nii'}
folders={'func','func1'}
%outputDir='C:\Users\Dell\Desktop\Czerwiec_Migbrain\Kasi\'
%runy={'RUN1.nii','RUN2.nii'}
%subjects= [16]
%smoothing in mm 
y=8
%for indRUN= 1:2
for subject = subjects
P1 = spm_select('ExtFPList', [dir num2str(subject)], ['^' runy{1}],1:nScans);
P2 = spm_select('ExtFPList', [dir num2str(subject)], ['^' runy{2}],1:nScans);
%realignement and reslice for each run separately, create rp file for each run
%spm_realign({P1 P2});
spm_reslice({P1 P2});
%coregistration whole experiment
matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'C:\Users\Dell\Desktop\matlab\spm12\tpm\TPM.nii,1'};
matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'C:\Users\Dell\Desktop\matlab\spm12\tpm\TPM.nii,2'};
matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'C:\Users\Dell\Desktop\matlab\spm12\tpm\TPM.nii,3'};
matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'C:\Users\Dell\Desktop\matlab\spm12\tpm\TPM.nii,4'};
matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'C:\Users\Dell\Desktop\matlab\spm12\tpm\TPM.nii,5'};
matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'C:\Users\Dell\Desktop\matlab\spm12\tpm\TPM.nii,6'};
matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
matlabbatch{1}.spm.spatial.preproc.warp.write = [0 1];

spm_jobman('run',matlabbatch);
Mean = spm_select('ExtFPList', [dir num2str(subject)], '\mean*.*');
t1 = spm_select('ExtFPList', [dir num2str(subject) '\T1'], '\s*.*');
jobs{1}.spatial{1}.coreg{1}.estimate.ref = cellstr(t1);


cd(outputDir);
spm('defaults', 'FMRI');
spm_jobman('run', jobs);  

%jobs{1}.spatial{1}.coreg{1}.estimate.source = cellstr(Mean);
%segmentation

%normalisation
%matlabbatch{1}.spm.spatial.preproc.channel.vols = {'C:\Users\Dell\Desktop\Czerwiec_Migbrain\Kasi\16\T1\s180523141015DST131221107523235454-0009-00001-000176-01.nii,1'};
nrun=1
jobfile = {'C:\Users\Dell\Desktop\matlab\CONN\data\seg_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

%smoothing
%jobs{1}.spatial.smooth.data = cellstr(P1);
%jobs{1}.spatial.smooth.fwhm = [8 8 8];
%jobs{1}.spatial.smooth.dtype = 0;
%jobs{1}.spatial.smooth.im = 0;
%jobs{1}.spatial.smooth.prefix = 's';


end
