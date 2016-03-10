function [~] = pathSeed( path )
%%input the path to the "home" directory for a script

home = path;

addpath(path);
cd(path);



end

