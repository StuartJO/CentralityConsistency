# CentralityConsistency

The files in this directory are able to rerun all analyses performed in Oldham et al., 2018. Consistency and differences between centrality metrics across distinct classes of networks.

If you have questions please contact Stuart by [email](mailto:stuart.oldham@monash.edu)

Dependencies:
[Brain Connectivity Toolbox](https://sites.google.com/site/bctnet/), Version 2017-15-01.

MainAnalysisScript.m will run all analyses performed in the paper. Running this script as is will take a very long time especially for the running of centrality measures and generation of nulls/synthetic networks. If you have access to a cluster I recommend the analysis of individual networks across computers.

FigureGeneration.m will reproduce all figures from the paper.
