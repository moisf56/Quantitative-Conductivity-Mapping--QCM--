%% Quantitative Conductivity Mapping (QCM) - Main Analysis
% EEE 473/573 Medical Imaging Project
% Authors: Mohammed Abed, Elif Yali
% Date: January 2025

clear all; close all; clc;

%% Configuration Parameters
config = struct();
config.w = 2*pi*128e6;                    % Larmor frequency (rad/s)
config.mu0 = 4*pi*1e-7;                   % Permeability of vacuum (H/m)
config.spatial_res = [0.001, 0.001, 0.001]; % Spatial resolution (m)
config.kernel_size = [5, 5, 5];           % Kernel dimensions
config.quality_threshold = 0.30;          % Magnitude quality gate
config.poly_degree = 2;                   % Polynomial fitting degree

%% Data Loading
fprintf('Loading MRI phantom data...\n');
try
    data_struct = load('4anomaly_3D.mat');
    phase_data = angle(data_struct.data);
    mag_data = abs(data_struct.data);
    fprintf('Data loaded successfully: %dx%dx%d voxels\n', size(phase_data));
catch ME
    error('Failed to load data: %s', ME.message);
end

%% Method 1: Direct Laplacian
fprintf('\n=== Running Direct Laplacian Method ===\n');
tic;
conductivity_direct = direct_laplacian_method(phase_data, config);
time_direct = toc;
fprintf('Direct method completed in %.2f seconds\n', time_direct);

%% Method 2: Kernel-based Laplacian  
fprintf('\n=== Running Kernel-based Laplacian Method ===\n');
tic;
conductivity_kernel = kernel_laplacian_method(phase_data, mag_data, config);
time_kernel = toc;
fprintf('Kernel method completed in %.2f seconds\n', time_kernel);

%% Method 3: Surface Integral
fprintf('\n=== Running Surface Integral Method ===\n');
tic;
conductivity_integral = surface_integral_method(phase_data, mag_data, config);
time_integral = toc;
fprintf('Surface integral method completed in %.2f seconds\n', time_integral);

%% Results Visualization
fprintf('\n=== Generating Results Visualization ===\n');
visualize_results(mag_data, phase_data, conductivity_direct, ...
                 conductivity_kernel, conductivity_integral, config);

%% Performance Summary
fprintf('\n=== Performance Summary ===\n');
fprintf('Direct Laplacian:     %.2f seconds\n', time_direct);
fprintf('Kernel Enhancement:   %.2f seconds\n', time_kernel);
fprintf('Surface Integral:     %.2f seconds\n', time_integral);

fprintf('\nAnalysis complete! Check generated figures for results.\n');