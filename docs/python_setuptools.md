`python setup.py install`  runs `setuptools.install.run()` but `pip install` does not.



## Setup GWDG cluster for work / development in R and Python

### R

```bash
tar -xf R-4.0.4.tar.gz
mv R-4.0.4 R-4.0.4-src-build
cd R-4.0.4-src-build
mkdir build-2021-04-29 
cd build-2021-04-29
cp ../../r-compiler.sh .
module load gcc/9.3.0 intel-parallel-studio/cluster.2020.4
source r-compiler.sh
make -j16
make install
```

Change the default library location in `/cbscratch/sbanerj/software/R/R-4.0.4/lib64/R/etc/Renviron`.

Finally, create the module file, and **set `R_HOME` environment variable for Python `rpy2`**

```tcl
#%Module -- tcl --
##
## modulefile
##
proc ModulesHelp { } {

 puts stderr "\tAdds R/4.0.4 to your environment variables"

}
module-whatis "Adds R/4.0.4 to your environment variables"
prepend-path    PATH    /cbscratch/sbanerj/software/R/R-4.0.4/bin
```

GWDG has moved to `LMOD` , so the `lua` module file would be:

```lua
-- -*- lua -*-
-- Module file written by Saikat Banerjee on 2021-04-29 16:35
-- 
-- Contact: bnrj.saikat@gmail.com
--
-- R-4.0.4 compiled with gcc/10.2.0 and intel-parallel-studio/cluster.2020.4 (MKL)
--

whatis([[Name : r]])
whatis([[Version : 4.0.4]])
whatis([[Target : haswell]])
whatis([[Short description : R is 'GNU S', a freely available language and environment for statistical computing and graphics which provides a wide variety of statistical and graphical techniques: linear and nonlinear modelling, statistical tests, time series analysis, classification, clustering, etc. Please consult the R project homepage for further information.]])
whatis([[Configure options : CPPFLAGS="-DMKL_ILP64 -m64 -I${MKLROOT}/include -O3" LDPATH="-L${PREFIX_DIR}/lib64/R/lib -Wl,-rpath,${PREFIX_DIR}/lib64/R/lib" ../configure --prefix=${PREFIX_DIR} --libdir="${PREFIX_DIR}/lib64" --with-blas="-L${MKLROOT}/lib/intel64 -Wl,--no-as-needed -lmkl_intel_ilp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl" --with-lapack --with-cairo --with-jpeglib --with-readline --with-tcltk --enable-R-shlib --enable-R-profiling --enable-memory-profiling --with-x=no]])

help([[R is 'GNU S', a freely available language and environment for
statistical computing and graphics which provides a wide variety of
statistical and graphical techniques: linear and nonlinear modelling,
statistical tests, time series analysis, classification, clustering,
etc. Please consult the R project homepage for further information.]])


if not isloaded("gcc/9.3.0") then
    load("gcc/9.3.0")
end

if not isloaded("intel-parallel-studio/cluster.2020.4") then
    load("intel-parallel-studio/cluster.2020.4")
end

prepend_path("PATH", "/cbscratch/sbanerj/software/R/R-4.0.4/bin", ":")
prepend_path("LIBRARY_PATH", "/cbscratch/sbanerj/software/R/R-4.0.4/lib64/R/lib", ":")
prepend_path("LD_LIBRARY_PATH", "/cbscratch/sbanerj/software/R/R-4.0.4/lib64/R/lib", ":")
prepend_path("CPATH", "/cbscratch/sbanerj/software/R/R-4.0.4/lib64/R/include", ":")
prepend_path("CMAKE_PREFIX_PATH", "/cbscratch/sbanerj/software/R/R-4.0.4/", ":")
setenv("R_ROOT", "/cbscratch/sbanerj/software/R/R-4.0.4")
setenv("R_HOME", "/cbscratch/sbanerj/software/R/R-4.0.4/lib64/R")
```

Install some packages

```
parallel::detectCores()
options(Ncpus = 48)
install.packages(c("devtools", "ggplot2"))
install.packages(c("glmnet", "L0Learn", "BGLR", "ncvreg"))
```

### Python

```bash
module load gcc/9.3.0 intel-parallel-studio/cluster.2020.4 R/4.0.4
conda create -p /cbscratch/sbanerj/software/python/envs/py39 --copy python=3.9 -y
conda activate /cbscratch/sbanerj/software/python/envs/py39
# Install some essential packages
conda install --copy --yes scipy numpy pandas scikit-learn numexpr h5py hdf5 statsmodels matplotlib jupyter
conda install --copy --yes pip git
# Install pymir in edit mode, so I can pull from git anytime and do not need to reinstall
cd /cbscratch/sbanerj/software/
git clone git@github.com:banskt/pymir.git
cd pymir
pip install -e .
```

Install and verify `rpy2`

```bash
conda install --copy pytest jinja2 pytz tzlocal cffi
pip install rpy2
python -m rpy2.situation
python
>> import rpy2.robjects as robj
```

**Uninstall**

```bash
conda remove -p /cbscratch/sbanerj/software/python/envs/py39 --all
```

### Install DSC

Install prerequisites with conda

```bash
load-env # alias in bashrc to load modules and activate conda
conda install --copy --yes sympy pyarrow sqlalchemy tzlocal
cd ~/packages
git clone git@github.com:stephenslab/dsc.git
cd dsc
pip install .
```

`Successfully installed PTable-0.9.2 decorator-4.4.2 dsc-0.4.3.5 fasteners-0.16 msgpack-python-0.5.6 networkx-2.5.1 psutil-5.8.0 pydot-1.4.2 pydotplus-2.0.2 pyyaml-5.4.1 sos-0.22.5 sos-pbs-0.20.8 tqdm-4.60.0 xxhash-2.0.2`

Check installation

```
dsc --version
dsc-query --version
```

Finally, install the `dscrutils` 

```R
install.packages('devtools')
setwd('/usr/users/sbanerj/packages/dsc/dscrutils')
getwd()
devtools::install_local('.')
system("dsc-query --version")
```