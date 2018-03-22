
function [ mr,msed ] = uspirit(ma,mc,Nk,Ni)
    % Takes an undersampled k-space data set and a calibration data set,
    % and computes the SPIRiT reconstruction.
    %
    % ma -- undersampled k-space data
    % sk -- SPIRiT kernel
    %
    % mr -- Reconstructed k-space data
    % msed -- Energy difference between iterations
    
    % Let's make a kernel
    sk = spirit_kernel(mc,Nk);
    
    % Initialize output
    mr = ma;
    mrp = mr;
    msed = zeros(Ni,1);
    
    % Create masks
    known_data = (mr ~= 0);
    unknown_data = (mr == 0);
    
    
    for n = 1:Ni
        mr = apply_spirit(mr,sk);
        
        % Enforce data consistency
        mr = (ma.*known_data) + mr.*unknown_data;
        
        % Find the energy difference
        msed(n) = sum(sum(sum(abs(mr - mrp).^2)));
        
        % Update prev values
        mrp = mr;
    end
    
    
end