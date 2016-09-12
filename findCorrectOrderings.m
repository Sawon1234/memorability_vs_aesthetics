% ------------------------------------------------------------------------
function [T,C] = findCorrectOrderings(L,H)
% We expect that ideally all entries in H are greater than all entries in L
% We will move the lower length array across the higher length array 
% This is an optimized version which caluclates pairwise ranking in nearly
% O(n) with the help of MATLAB vectorization, instead of the naive O(n^2)
% Author : Sukrit Shankar 
% ------------------------------------------------------------------------

%% Check the lengths - We assume H to be shorter than L, else swap 
% Always check using the invertSign
% B is always shorter than A, and moves across A 
if (length(L) >= length(H)) % Normal Case
    A = L; 
    B = H; 
    invertSign = 1; 
else
   A = H; 
   B = L; 
   invertSign = -1; 
end

%% Get the total number of orderings to compare 
T = length(L) * length(H); 

%% Get the correct number of orderings 
% Move B across A till it aligns in the first index 
C = 0; 
for i = 1:1:length(B)-1
    temp = sign(B(end-i+1:end) - A(1:i));
    C = C + numel(find(temp == invertSign)); 
    clear temp; 
end

% Now B is aligned with A and move it till it starts getting out 
for i = 1:1:length(A)-length(B) + 1
    temp = sign(B(1:end) - A(i:i+length(B)-1)); 
    C = C + numel(find(temp == invertSign)); 
    clear temp; 
end

% Now B is starting to get out of A from the end 
for i = 1:1:length(B)
    temp = sign(B(1:end-i) - A(end-length(B)+i+1:end));  
    C = C + numel(find(temp == invertSign)); 
    clear temp; 
end










    