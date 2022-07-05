[Switching BLAS implementation in Conda](https://conda-forge.org/docs/maintainer/knowledge_base.html#blas)

The BLAS implementation can be switched using

```bash
conda install "libblas=*=*mkl"
conda install "libblas=*=*openblas"
conda install "libblas=*=*blis"
conda install "libblas=*=*netlib"
```



For example,

```bash
conda install numpy scipy statsmodels matplotlib jupyter scikit-learn pandas "libblas=*=*mkl" -c conda-forge
```

