
# Installation of encoding stack on Kalindi

## Vaporsynth

```bash
git clone git@github.com:vapoursynth/vapoursynth.git
cd vaporsynth
git tag -l # list the tags
git checkout tags/R64 -b release_R64 # checkout latest tag and create a branch
./autogen.sh
```

Now, I am ready to configure but first, I have to get the dependencies.


 - **Autoconf, Automake, and Libtool, probably recent versions.**  Already installed on kalindi.
 - **pkg-config** Already installed on kalindi
 - **GCC 4.8 or newer, or Clang** `module load gcc/10.2.0`
 - **zimg** see installation below, and then `module load zimg/3.0.5`
 - **Python 3** `conda activate pyrip; PKG_CONFIG_PATH="/home/saikat/.conda/envs/pyrip/lib/pkgconfig:${PKG_CONFIG_PATH}"`
 - **Cython 0.28 or later installed in your Python 3 environment** `conda install cython`
 - Sphinx for the documentation (optional)

Once, all the dependencies are satisfied, it is a generic configure and install:
```bash
LD_LIBRARY_PATH="/home/saikat/.conda/envs/pyrip/lib:${LD_LIBRARY_PATH}"
./configure --prefix=/opt/encoding/vapoursynth/r64 --disable-static --enable-shared
make -j16
sudo make install
```

But, the module is not conventional,
```tcl
#%Module1.0

proc ModulesHelp { } {
    global version

    puts stderr "\tLoads VapourSynth $version for common environment variables"
    puts stderr "\tand make it available for pkg-config."
}

module-whatis	"appends VapourSynth paths in common environment variables"

# requires

# for Tcl script use only
set	version		R64
set	prefix		{/opt/encoding/vapoursynth/r64}

prepend-path 	PATH  			$prefix/bin
prepend-path 	PYTHONPATH  		$prefix/lib/python3.9/site-packages
prepend-path 	LD_LIBRARY_PATH 	/home/saikat/.conda/envs/py39/lib
prepend-path    LD_LIBRARY_PATH 	$prefix/lib
prepend-path    LD_RUN_PATH	 	$prefix/lib
prepend-path    LIBRARY_PATH 		$prefix/lib
prepend-path	CPATH			$prefix/include
prepend-path	PKG_CONFIG_PATH		$prefix/lib/pkgconfig
```

### zimg

```bash
git clone git@github.com:sekrit-twc/zimg.git
cd zimg
git tag -l
git checkout tags/release-3.0.5 -b release-3.0.5
git submodule update --init --recursive
./autogen.sh
./configure --prefix=/opt/encoding/zimg/3.0.5 --disable-static --enable-shared
make -j16
sudo make install
```

Create relevant modulefile.

## Yuuno

```
pip install --upgrade-strategy only-if-needed yuuno
```
