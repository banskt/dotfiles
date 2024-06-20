#!/usr/bin/env bash

# environment-modules
source /opt/environment-modules/init/bash

# TexLive source
TEXLIVESRC="/opt/texlive/2020"


function lemp() {
    __command=${1}
    if [ "${__command}" == "start" ]; then
        echo "Starting NGINX and MySQL."
        sudo systemctl start php8.1-fpm
        sudo systemctl start nginx
        sudo systemctl start mysql
    elif [ "${__command}" == "stop" ]; then
        echo "Stopping NGINX and MySQL."
        sudo systemctl stop php8.1-fpm
        sudo systemctl stop nginx
        sudo systemctl stop mysql
    fi
    sudo systemctl status php8.1-fpm
    sudo systemctl status nginx
    sudo systemctl status mysql
}

# Launch MyCrypto Wallet
alias mycrypto="/home/saikat/Downloads/apps/crypto/mycrypto/linux-x86-64_1.7.13_MyCrypto.AppImage"
# Load enviroments
alias load-Rmkl='module load gcc/10.2.0 intel/mkl/2020/4.304 R/mkl/4.0.3 RStudio/1.4.1106'
alias unload-Rmkl='module unload RStudio/1.4.1106 R/mkl/4.0.3'
alias load-Ropenblas='module load gcc/10.2.0 openblas/gcc/0.3.10 R/openblas/4.0.3 RStudio/1.4.1106'
alias unload-Ropenblas='module unload RStudio/1.4.1106 R/mkl/4.0.3'
alias load-env='export LD_LIBRARY_PATH="/opt/R/mkl/4.0.3/lib/R/lib:${LD_LIBRARY_PATH}"; load-Rmkl; conda activate py39mkl'

# Torrent related
alias btn-getfeed="rsync -avz feral:/media/sdt/banskt/usr/apps/btn-automagic/data/btn_db.json /home/saikat/Documents/piracy/btn-automagic/data/"
alias mountferal="sshfs feral:uploads /home/saikat/feralDrive -o idmap=user"
alias umountferal="fusermount -u /home/saikat/feralDrive"
alias mountashwini="sshfs ashwini:data /home/saikat/ashwiniDrive -o idmap=user"
alias umountashwini="fusermount -u /home/saikat/ashwiniDrive"
alias mountlemon="sshfs whatbox:data /home/saikat/whatboxDrive -o idmap=user"
alias mountlemonwatch="sshfs whatbox:watch /home/saikat/whatboxDrive -o idmap=user"
alias umountlemon="fusermount -u /home/saikat/whatboxDrive"
alias xcopy="xclip -selection clipboard <"
alias tmm="/home/saikat/Downloads/apps/tinyMediaManager/tinyMediaManager/tinyMediaManager"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

