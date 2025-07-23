function conductivity = direct_laplacian_method(phase_data, config)
%% Direct Laplacian-based Conductivity Calculation
% Simple implementation using MATLAB's built-in del2 function
%
% Inputs:
%   phase_data - 3D phase array from MRI
%   config     - Configuration parameters
%
% Output:
%   conductivity - 3D conductivity map (S/m)

fprintf('Computing Laplacian using built-in del2...\n');

% Calculate Laplacian using finite differences
laplacian = del2(phase_data);

% Convert to conductivity using physical constants
conductivity = laplacian / (config.w * config.mu0);

fprintf('Direct Laplacian calculation completed\n');

end