





Multiple regression is widely used in genetic applications including, but not  limited to, the identification of genotypes that are significantly  associated with phenotypes, and the prediction of phenotypic values based on genotypic information. The past two decades have witnessed rapid growth in the  size of molecular genetic datasets. Cohorts like UK Biobank consists of genetic data from over 90 million genetic variants and phenotype data from thousands of  phenotypes in over 500,000 individuals. In such high-dimensional  regression problems, often a relatively small subset of the features are relevant for predicting the outcome, requiring methods that impose sparsity on the solution. Recently, Stephens and coworkers  have shown that Bayesian methods using an adaptive shrinkage (ASH) prior distribution of the regression coefficients has several advantages over traditional sparse multiple regression methods, including robust  selection of variables and self-tuning to avoid overfitting. They  developed a stepwise coordinate ascent algorithm using variational empirical Bayes (VEB) formulation. 

In several concurrent projects, we are developing alternative algorithms  for sparse multiple regression using the ASH prior, with the goal of  application to large-scale datasets. We proposed two algorithms: (1) a  quasi-Newton optimization (limited memory BFGS) algorithm using an  objective function derived from an alternative formulation of the  posterior mean as a penalized linear regression (PLR) problem, and (2) a stepwise coordinate ascent algorithm using the variational empirical Bayes formulation of the problem with a hierarchical prior that mimics the ASH prior on the regression  coefficients. To explore the strengths and weaknesses of sparse  regression algorithms, we developed a parallelized simulation pipeline  using Dynamic Statistical Comparisons (DSC) -- a framework for managing  computational benchmarking experiments. Alongside, we looked at the  feasibility of applying our methods to trend-filtering problems. We  extended the variational empirical Bayes algorithms of sparse regression to application on  generalized linear models using two separate approximations: (1)  restricting the factorized distributions in the VEB formulation to be a  mixture of Gaussian distributions, and (2) restricting the posterior  probability of the model to a Gaussian distribution. All methods mentioned above are open-source and available online. 



Trans-acting expression quantitative trait loci (trans-eQTLs) are  genetic variants affecting the expression of distant genes. They account for ≥70% expression heritability and could therefore facilitate  uncovering mechanisms underlying the origination of complex diseases.  However, unlike cis-eQTLs, identifying trans-eQTLs is challenging  because of small effect sizes, tissue-specificity, and the severe  multiple-testing burden. Trans-eQTLs affect multiple target genes, but  aggregating evidence over individual SNP-gene associations is hampered  by strong gene expression correlations resulting in correlated p-values. Our method Tejaas predicts trans-eQTLs by performing L2-regularized  'reverse' multiple regression of each SNP on all genes, aggregating  evidence from many small trans-effects while being unaffected by the  strong expression correlations. Combined with a novel non-linear,  unsupervised k-nearest-neighbor method to remove confounders, Tejaas  predicted 18851 unique trans-eQTLs across 49 tissues from GTEx. They are enriched in open chromatin, enhancers and other regulatory regions.  Many overlap with disease-associated SNPs, pointing to tissue-specific  transcriptional regulation mechanisms. 



Research objective.

The objective of my research is to develop our understanding of the human genome and the genetics of human diseases using computational approaches to study large-scale functional and comparative genomics datasets. A primary focus is to tackle problems where novel statistical methods are required. A  key feature of my strategy will be to integrate multiple genomic datasets, such as transcriptome data, epigenetic data, and biological networks. This integrated approach could combine signals in different datasets to increase the power of studies, and shed light on the mechanism connecting genetic changes to phenotypes. One of my long term research goals is to develop a complete understanding of how genetic variants control the transcriptional regualtion -- which may lead to novel diagnostic, prophylactic and therapeutic targets for a host of complex human diseases including cardiovascular diseases, neurodegenerative diseases, cancer, etc.

Scope of research in the future

The past two decades have witnessed rapid growth in the size of molecular genetic datasets and more are being collected. New technologies such as single-cell RNA-Seq techniques have been developed and many other techniques are currently are in the pipeline. Developing proper methods and tools to query and understand these diverse datasets will continue to be an active area of research over the next decades.





My long term research goal is to contribute to the effort of biophysical engineering of life by taking across-disciplinary approach at the interface of physical chemistry and biology.



However, development of proper tools and methods for these datasets is essential for querying and understanding these datasets. 



Cohorts like UK Biobank consists of genetic data from over 90 million genetic variants and phenotype data from thousands of  phenotypes in over 500,000 individuals. In such high-dimensional  regression problems, often a relatively small subset of the features are relevant for predicting the outcome, requiring methods that impose sparsity on the solution.



My lab uses computational approaches to  study the genetics of human diseases, including cancer. A primary focus  of our research is to develop novel tools for mapping risk genes of  complex diseases from genome wide association studies (GWAS), sequencing studies or somatic mutations in the case of cancer. These tools are  often been used in close collaboration with experimental biologists. A  key feature of our strategy is the integration of multiple genomic  datasets, such as transcriptome data, epigenetic data, and biological  networks. This integrated approach could combine signals in different  datasets to increase the power of studies, and shed light on the  mechanism connecting genetic changes to phenotypes. We are also interested in computational questions in regulatory  genomics. How do cis-regulatory sequences interpret the information in  cellular environments to drive spatial-temporal gene expression  patterns? How do variations of regulatory sequences shape phenotypic  variation and evolution? We believe a better understanding of these  questions will also help the study of human genetics, specifically by  improving our ability to interpret variations in non-coding sequences.   



The objective of my independent research career is to understand how complex biological behavior arises from molecularinteractions, using concepts from thermodynamics, statistical mechanics and soft matter, which are powerful concepts intraversing scales and investigating collective phenomena. My motivation to work in the field of biochemistry has beenalways driven by the idea that deeper understanding of cellular processes can be developed using tools from chemical andphysical sciences. My long term research goal is to contribute to the effort of biophysical engineering of life by taking across-disciplinary approach at the interface of physical chemistry and biology.



Our group at MIT aims to further our understanding of the human genome by computational integration of large-scale functional and comparative genomics datasets. (1) We use comparative genomics of multiple related species to recognize evolutionary signatures of protein-coding genes, RNA structures, microRNAs, regulatory motifs, and individual regulatory elements. (2) We use combinations of epigenetic modifications to define chromatin states associated with distinct functions, including promoter, enhancer, transcribed, and repressed regions, each with distinct functional properties.  (3) We use dynamics of functional elements across many cell types to link regulatory regions to their target genes, predict activators and repressors, and cell type specific regulatory action. (4) We combine these evolutionary, chromatin, and activity signatures to dramatically expand the annotation of the non-coding genome, elucidate the regulatory circuitry of the human and fly genomes, and to revisit previously uncharacterized disease-associated variants, providing mechanistic insights into their likely molecular roles.



My lab works on a wide variety of problems at the interface of Statistics and Genetics. We often tackle problems where novel statistical methods are required, or can learn something new compared with existing approaches. Thus, much of our research involves developing new statistical methodology, many of which have a non-trivial computational component. People in my lab tend to come from a quantitative background (e.g., Math, Statistics, Computer Science), with varying levels of formal or informal Biology training.