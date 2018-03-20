function [ g ] = gfactor( map, Rx, Ry )
%UNTITLED Summary of this function goes here
% Calculate the g-factor  when undersampling in x and/or y dimensions

    [Nx, Ny, L] = size(map);
    Nrx = Nx/Rx;
    Nry = Ny/Ry;
    
    
    g = zeros(Nrx, Nry);
    for ii = 1:Nx
        for jj = 1:Ny
            if abs(map(ii,jj,1))<1e-6
                g(ii,jj) = 0;
            else 
                for Lx = 0:Rx - 1
                    for Ly = 0:Ry - 1 
                        ndx = mod(ii - 1 + Lx*Nrx, Nx) + 1;
                        ndy = mod(jj - 1 + Ly*Nry, Ny) + 1;
                        CT = map(ndx, ndy, :);
                        CT = CT(:);
                        if (Lx == 0 & Ly == 0)
                            s = CT;
                        else
                            if (abs(CT(1))>1e-6)
                                s = [s CT];
                            end
                        end
                    end
                end
                scs = s'*s;
                scsi = inv(scs);
                g(ii,jj) = sqrt(scs(1,1)*scsi(1,1));  
            end
        end
    end

end

