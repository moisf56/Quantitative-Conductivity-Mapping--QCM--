%% qcm_setup.m
% Creates the complete project directory structure

fprintf('Setting up QCM project directory structure...\n');

% Create main directories
dirs = {'data', 'src', 'src/utils', 'results', 'results/conductivity_maps', ...
        'results/validation_plots', 'docs', 'tests'};

for i = 1:length(dirs)
    if ~exist(dirs{i}, 'dir')
        mkdir(dirs{i});
        fprintf('Created directory: %s\n', dirs{i});
    end
end

% Create placeholder files
placeholder_files = {
    'data/README.md',
    'results/README.md', 
    'docs/algorithm_comparison.md',
    'docs/clinical_applications.md'
};

for i = 1:length(placeholder_files)
    if ~exist(placeholder_files{i}, 'file')
        fid = fopen(placeholder_files{i}, 'w');
        fprintf(fid, '# %s\n\nPlaceholder file for project organization.\n', ...
                placeholder_files{i});
        fclose(fid);
        fprintf('Created placeholder: %s\n', placeholder_files{i});
    end
end

fprintf('Project structure setup complete!\n');