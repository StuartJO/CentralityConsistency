function [Z, D, Hclusters, DB_vals] = runCentralityClustering(dataMatrix)

if length(dataMatrix) < 50
    numclust = length(dataMatrix);
else
numclust = 50;
end

Hclusters = zeros(size(dataMatrix,1),numclust);

Z = linkage(dataMatrix,'ward','euclidean');

Y = pdist(dataMatrix,'euclidean');
p = squareform(Y);

D = p;

for x = 1:numclust
  Hclusters(:,x) = cluster(Z,'MaxClust',x); 
end   

hevaDB_d = evalclusters(dataMatrix,Hclusters,'DaviesBouldin');

DB_vals = hevaDB_d.CriterionValues;