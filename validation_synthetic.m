%% Synthetic Data Validation for QCM Algorithms
% Generates polynomial test data with known Laplacian values

clear all; close all; clc;

%% Generate Synthetic 3D Polynomial Data
fprintf('Generating synthetic polynomial data for validation...\n');

% Define spatial grid
nx = 64; ny = 64; nz = 32;
x = linspace(-0.05, 0.05, nx);
y = linspace(-0.05, 0.05, ny);  
z = linspace(-0.02, 0.02, nz);
[X, Y, Z] = ndgrid(x, y, z);

% Random polynomial coefficients
% f(x,y,z) = ax² + by² + cz² + dxy + eyz + fzx + gx + hy + iz + j
coeffs = rand(10,1) * 10 - 5; % Random coefficients between -5 and 5
a = coeffs(1); b = coeffs(2); c = coeffs(3);
d = coeffs(4); e = coeffs(5); f = coeffs(6);
g = coeffs(7); h = coeffs(8); i = coeffs(9); j = coeffs(10);

% Generate polynomial phase data
phase_synthetic = a*X.^2 + b*Y.^2 + c*Z.^2 + d*X.*Y + e*Y.*Z + f*Z.*X + ...
                 g*X + h*Y + i*Z + j;

% Theoretical Laplacian: ∇²f = 2a + 2b + 2c
theoretical_laplacian = 2*a + 2*b + 2*c;

fprintf('Generated polynomial with theoretical Laplacian = %.6f\n', theoretical_laplacian);

%% Test Algorithm Accuracy
config = struct();
config.w = 2*pi*128e6;
config.mu0 = 4*pi*1e-7;
config.kernel_size = [5, 5, 5];
config.quality_threshold = 0.30;
config.poly_degree = 2;

% Create synthetic magnitude (uniform)
mag_synthetic = ones(size(phase_synthetic));

% Test direct method
conductivity_direct = direct_laplacian_method(phase_synthetic, config);
mean_direct = nanmean(conductivity_direct(:));

% Test kernel method  
conductivity_kernel = kernel_laplacian_method(phase_synthetic, mag_synthetic, config);
mean_kernel = nanmean(conductivity_kernel(:));

% Theoretical conductivity
theoretical_conductivity = theoretical_laplacian / (config.w * config.mu0);

%% Display Results
fprintf('\n=== Validation Results ===\n');
fprintf('Theoretical Conductivity: %.6e S/m\n', theoretical_conductivity);
fprintf('Direct Method Average:    %.6e S/m (Error: %.2f%%)\n', ...
        mean_direct, abs(mean_direct-theoretical_conductivity)/theoretical_conductivity*100);
fprintf('Kernel Method Average:    %.6e S/m (Error: %.2f%%)\n', ...
        mean_kernel, abs(mean_kernel-theoretical_conductivity)/theoretical_conductivity*100);

%% Visualization
figure('Name', 'Synthetic Data Validation');
subplot(2,2,1);
imagesc(x, y, phase_synthetic(:,:,end/2));
colorbar; title('Synthetic Phase Data');
xlabel('X Position (m)'); ylabel('Y Position (m)');

subplot(2,2,2);
imagesc(x, y, conductivity_direct(:,:,end/2));
colorbar; title('Direct Laplacian Result');
xlabel('X Position (m)'); ylabel('Y Position (m)');

subplot(2,2,3);
imagesc(x, y, conductivity_kernel(:,:,end/2));
colorbar; title('Kernel Method Result');
xlabel('X Position (m)'); ylabel('Y Position (m)');

subplot(2,2,4);
plot(1:3, [theoretical_conductivity, mean_direct, mean_kernel], 'o-', 'LineWidth', 2);
set(gca, 'XTick', 1:3, 'XTickLabel', {'Theoretical', 'Direct', 'Kernel'});
ylabel('Conductivity (S/m)'); title('Method Comparison');
grid on;

sgtitle('QCM Algorithm Validation with Synthetic Data');