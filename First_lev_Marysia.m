
%%% Change here to adjust the sctipt: 
dir= 'C:\Users\Dell\Desktop\Czerwiec_Migbrain\Kasi'
nruns=2%no of runs per subject
runy={'RUN1.nii','RUN1.nii'}%functional images stored in 4D nifti files
runy2={'^RUN1.nii','^RUN1.nii'}
nScans= [455 455];%slices per run
subjects= [16 17]%list of subjects, put folders names here
rp={'rp_RUN1.txt', 'rp_RUN1.txt'}%rp 

%spmDir = 'C:\Users\Dell\Desktop\Czerwiec_Migbrain\Kasi\spm'
ESTIMATE_GLM = 1;%set 1 if you want to estimate your models
multiCond = {'cond1.mat','cond1.mat'}%names of multiple conditions mat files
rpFile='C:\Users\Dell\Desktop\Czerwiec_Migbrain\Kasi\16\rp_RUN1.txt'
for subject=subjects 
    TR=2.19;
    outputDir= [dir '\' num2str(subject) '\']
    jobs{1}.stats{1}.fmri_spec.dir = cellstr(outputDir);
    jobs{1}.stats{1}.fmri_spec.timing.units = 'secs';
    jobs{1}.stats{1}.fmri_spec.timing.RT = TR;
    jobs{1}.stats{1}.fmri_spec.timing.fmri_t = 16;
    jobs{1}.stats{1}.fmri_spec.timing.fmri_t0 = 1;
   
    for runIdx = 1:nruns
        files = spm_select('ExtFPList', [dir '\' num2str(subject) '\'], [runy2{runIdx}] ,1:nScans);
        mc= [dir '\'  multiCond{runIdx}]
        jobs{1}.stats{1}.fmri_spec.sess(runIdx).scans = cellstr(files);
        jobs{1}.stats{1}.fmri_spec.sess(runIdx).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}),'orth', {};
        jobs{1}.stats{1}.fmri_spec.sess(runIdx).multi = cellstr(mc);
        jobs{1}.stats{1}.fmri_spec.sess(runIdx).regress = struct('name', {}, 'val', {});
        jobs{1}.stats{1}.fmri_spec.sess(runIdx).multi_reg = cellstr(rpFile);
        jobs{1}.stats{1}.fmri_spec.sess(runIdx).hpf = 128;                 
    end
    
    %movefile('C:\Users\Dell\Desktop\matlab\bin\multi_cond_blinds.mat', outputDir)
    jobs{1}.stats{1}.fmri_spec.fact = struct('name', {}, 'levels', {});
    jobs{1}.stats{1}.fmri_spec.bases.hrf = struct('derivs', [0 0]);
    jobs{1}.stats{1}.fmri_spec.volt = 1;
    jobs{1}.stats{1}.fmri_spec.global = 'None';
    jobs{1}.stats{1}.fmri_spec.mask = {''};
    jobs{1}.stats{1}.fmri_spec.cvi = 'AR(1)';
    
    %Navigate to output directory, specify and estimate GLM
    cd(outputDir);
    spm('defaults', 'FMRI');
    spm_jobman('run', jobs);
    %spm_jobman('run', jobs)
    
    if ESTIMATE_GLM == 1
        load SPM;
        spm_spm(SPM);
    end
end