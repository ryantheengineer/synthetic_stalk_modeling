function flip_notches(Flip_Indices,ChooseSectionsOutput,FlippedOutputName)
% FILENAME: find_flip_notches.m
% AUTHOR: Ryan Larson
% DATE: 6/18/19
%
% PURPOSE: 
% 
% 
% INPUTS:
%       flip_sections - The vector of 1s and empties that identifies the
%       cross-sections needing to be flipped 180 degrees
%
%       ChooseSectionsOutput - A .mat file produced by ChooseSections.m
%
%       SaveName - The name for the output .mat file. Make sure to end the
%       name with FLIPPED for consistency.
%       
% OUTPUTS:
%       
%
% NOTES:
%       Make sure to name the output .mat file with a FLIPPED extension
%       for consistency
% 
% 
% VERSION HISTORY:
% V1 - Made into a function that works with the updated process flow
% V2 - 
% V3 - 
%
% -------------------------------------------------------------------------

load(ChooseSectionsOutput);
load(Flip_Indices);

ext_rho = [];
int_rho = [];
% ext_X = ext_X;
% ext_Y = ext_Y;
% int_X = int_X;
% int_Y = int_Y;
T = ext_T(:,1)';
N = size(ext_X,2);

flipped = []; % Hold the indices of the flipped sections
for i = 1:N
    if flip_sections(i) == 1 
        flipped = [flipped; i];
        
        % Rotate and reorder external and internal points
        [~, ~, ~, ~, ~, ~, xp_ext, yp_ext, ~, ~] = reorder_V2(ext_X(:,i), ext_Y(:,i), pi);
        [~, ~, ~, ~, ~, ~, xp_int, yp_int, ~, ~] = reorder_V2(int_X(:,i), int_Y(:,i), pi);
        
        [~, ~, x_ext, y_ext, ~, ~, ~, ~, ~, ~] = reorder_V2(xp_ext, yp_ext, 0);
        [~, ~, x_int, y_int, ~, ~, ~, ~, ~, ~] = reorder_V2(xp_int, yp_int, 0);
        
        % Redefine the appropriate row in the main XY data
        ext_X(:,i) = x_ext;
        ext_Y(:,i) = y_ext;
        int_X(:,i) = x_int;
        int_Y(:,i) = y_int;
    end
end

% % Plot the cross sections that should be flipped to verify that the notches
% % are all on the left side
% for i = 1:length(flipped)
%     for j = 1:length(T)
%         plot(ext_X(1:j,flipped(i)),ext_Y(1:j,flipped(i)));
%         hold on
%         plot(int_X(1:j,flipped(i)),int_Y(1:j,flipped(i)));
%         axis equal
%         hold off
% %         pause(0.01);
%     end
%     pause();
% end


% Convert data from Cartesian to polar
for i = 1:N
    for j = 1:length(T)
        ext_Rho(i,j) = sqrt(ext_X(j,i)^2 + ext_Y(j,i)^2);
        int_Rho(i,j) = sqrt(int_X(j,i)^2 + int_Y(j,i)^2);
    end
end

% Transpose rho arrays so they are the same orientation as the other
% variables
ext_rho = ext_rho';
int_rho = int_rho';

% Save data as mat file
FolderName = pwd;
SaveFile = fullfile(FolderName, FlippedOutputName);
save(SaveFile,'ext_X','ext_Y','int_X','int_Y','ext_Rho','int_Rho','ext_T','int_T','avg_rind_thick','flip_sections','npoints');

end