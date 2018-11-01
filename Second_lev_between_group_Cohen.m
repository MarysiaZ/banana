clear all; clc
clear SPM
clear subname
%%
spm('defaults','FMRI')
global defaults
global UFp; UFp = 0.001;

WinOrLin='Lin';

%% setting the subjects

path = '/home/maciek/DATA/ANOVA_try' % path to folder with subj

subjects = GetFolders(path);
control = strncmpi('K', subjects, 1);
experimental = ~control;
control = subjects(control)
experimental = subjects(experimental)

%%
asymmetry = 0
ngroups=2;
subname{1} = experimental;
subname{2} = control;

for i = 1:length(subname)
    nsub(i) = length(subname{i});
end
totsub = sum(nsub); %%% ????

%%
cont = [ 1 2 3 4 5 6 7 ];

CalcOnSmoothed=0;
SmoothContrasts=0;

ncon = length(cont);
nscan = ncon * totsub;
totcon = ncon * ngroups;

output_path = [ '/home/maciek/DATA/ANOVA_output'];
eval(['mkdir ' output_path]);
cd(output_path);

%% file names
P = {};
k = 0;

for con=1:ncon
    for group=1:ngroups
        for s=1:nsub(group)
            sub=subname{group}{s};
            k=k+1;
                        
            P{k}= [path '/' sub '/' sprintf('con_%04d.img', cont(con))]
                 
        end
    end
end

%% -Assemble SPM structure
%=======================================================================

SPM.nscan = nscan;
SPM.xY.P = P;

for i=1:SPM.nscan
    SPM.xY.VY(i) = spm_vol(SPM.xY.P{i});
end

cname = cell(totcon+totsub,1);
k=0;
for group=1:ngroups
    for c=1:ncon
        k=k+1;
        cname{k} = sprintf('con %d group %d',c,group);
    end
end
for group=1:ngroups
    for c=1:nsub(group)
        k=k+1;
        cname{k} = sprintf('sub %d group %d',c,group);
    end
end

%%%% define the subject part of the matrix
oc = ones(ncon,1);
subjectpart=kron(oc,eye(totsub));
subjectpart=subjectpart - repmat(mean(subjectpart),ncon*totsub,1);

%%% define the contrast part of the matrix
os = zeros(totsub,ngroups);
g=0;
for group=1:ngroups
  os((g+1):(g+nsub(group)),group)=1;
  g=g+nsub(group);
end
SPM.xX = struct(...
    'X',[kron(eye(ncon),os) subjectpart] ,... % change this
    'iH',1:totcon,'iC',zeros(1,0),...
    'iB',totcon+[1:totsub],...
    'iG',zeros(1,0),...
    'name',{cname},'I',[ones(nscan,1) kron([1:ncon]',os) kron(oc,[1:totsub]') ones(nscan,1)],...
    'sF',{{'repl'  'cond'  'subj'  ''}});

SPM.xC = [];

SPM.xGX = struct(...
    'iGXcalc',1,    'sGXcalc','omit',                               'rg',[],...
    'iGMsca',9,     'sGMsca','<no grand Mean scaling>',...
    'GM',0,         'gSF',ones(nscan,1),...
    'iGC',  12,     'sGC',  '(redundant: not doing AnCova)',        'gc',[],...
    'iGloNorm',9,   'sGloNorm','<no global normalisation>');


donotuseVI = 0;
if (donotuseVI)
    SPM.xVi = struct(...
        'iid',1, 'V',speye(ncon*totsub) );
else
    x=zeros(ncon);
    %x=zeros(totcon);
    s=eye(totsub);
    nv=0;
    for group=1:ngroups
        for i=1:ncon
            for j=i:ncon
                nv=nv+1;
                %v=x;
                %v(j,i)=1; v(i,j)=1;
                vitemp=zeros(ncon*totsub,ncon*totsub);
                deci = (i-1)*totsub;
                decj = (j-1)*totsub;
                for g2=1:group-1
                    deci =deci+nsub(g2);
                    decj =decj+nsub(g2);
                end
                for s=1:nsub(group)
                    vitemp(  deci+s,  decj+s)=1;
                    vitemp(  decj+s,  deci+s)=1;
                end
                vi{nv}=vitemp;
            end
        end
    end
    
%%% pour comprendre intuitivement ces matrices "vi":
% imagesc(SPM.xVi.Cy)  montre la corrélation observée entre les images à
% modéliser
% On cherche à modéliser cette matrice de corrélation afin de blanchir les données
% On la modéliser par une combinaison linéaire de vi, que l'on peut voir
% avec imagesc(vi{1}), etc...
% La meilleure combinaison linéaire des vi qui a été trouvée se voit avec imagesc(SPM.xVi.V)


    SPM.xVi = struct(...
        'iid',0, 'I',SPM.xX.I, 'sF','SPM.xX.sF',...
        'var',[0 1 0 0], 'dep',[0 1 0 0], 'Vi',{vi} );
end

%- With IMPLICIT masking
%=======================================================================
%     Mdes 	= struct(	'Analysis_threshold',	{'None (-Inf)'},...
%         'Implicit_masking',	{'Yes: NaNs treated as missing'},...
%         'Explicit_masking',	{'No'});
%     SPM.xM	= struct(	'T',-Inf,'TH',ones(nsub,1)*-Inf,...
%         'I',1,'VM',[],'xs',Mdes);

%- With EXPLICIT masking
%=======================================================================
Mdes 	= struct(	'Analysis_threshold',	{'None (-Inf)'},...
    'Implicit_masking',	{'No'},...
    'Explicit_masking',	{'Yes'});
SPM.xM	= struct(	'T',-Inf,'TH',ones(nscan,1)*-Inf,...
    'I',1,'VM',spm_vol('meanmask05.img'),'xs',Mdes);

Pdes    = {{sprintf('%d condition, +0 covariate, +0 block, +0 nuisance',totcon); sprintf('%d total, having %d degrees of freedom',totcon,totcon); sprintf('leaving %d degrees of freedom from %d images',nscan-totcon,nscan)}};

SPM.xsDes = struct(...
    'Design',               {'1-way ANOVA (within-subjects)'},...
    'Global_calculation',   {'omit'},...
    'Grand_mean_scaling',   {'<no grand Mean scaling>'},...
    'Global_normalisation', {'<no global normalisation>'},...
    'Parameters',           Pdes);

SPM.SPMid       = 'SPM2: spm_spm_ui (v2.49)';

save SPM SPM


%% Estimate parameters
% ===========================================================================
SPM = spm_spm(SPM);
%% set contrasts 
% make 1st one by hand. if the conman refuses to make a 't' contrast, make an 'F' contrast
names={};values={};types ={};

names={'cue_DEAF>HEAR'};

values={
    [1 -1 0 0 0 0 0 0 0 0 0 0 0 0]};

types = repmat({'T'}, 1, length(values));


load SPM

SPM.xCon=SPM.xCon(1);


%% pour ajouter des 0 pour les regresseurs "sujets"
for b=1:max(size(names,2))
  values{b}=[values{b},zeros(1,totsub)];
end

%% build matrix
for n=1:max(size(names))
 contrast = spm_FcUtil('Set',names{n}, types{n}, 'c', values{n}', SPM.xX.xKXs);
 SPM.xCon(n+1) = contrast; 
end 

save SPM SPM

%% 

spm_contrasts(SPM);
