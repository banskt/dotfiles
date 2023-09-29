#! /bin/bash
git_projects="pyrobase auvyon"

source ~/.bashrc
micromamba activate py27
PYTHON=$( which python )
LDPATH=$( micromamba info | grep "env location" | cut -d":" -f2 | tr -d [:space:] )
export LD_LIBRARY_PATH=${LDPATH}:${LD_LIBRARY_PATH}

set -e
PROJECT_ROOT="$(command cd $(dirname "$0") >/dev/null && pwd)"
cd "$PROJECT_ROOT"
echo "Installing into $PWD"

test -f ./bin/activate && vpy=$PWD/bin/python || vpy=$PYTHON
echo "Using $vpy"
cat << EOF | $vpy
import sys
print("Using Python %s" % sys.version)
assert sys.version_info >= (2, 7), "Use Python 2.7! Read the docs."
assert sys.version_info < (3,), "Use Python 2.7! Read the docs."
EOF

echo "Updating your installation..."

# Bootstrap if script was downloaded...
if test -d .git; then
    git pull --ff-only
    source "$PROJECT_ROOT/util.sh"
    test -f bin/activate || install_venv --never-download
    update_venv ./bin/pip

    # Get base packages initially, for old or yet incomplete installations
    for project in $git_projects; do
        test -d $project || { echo "Getting $project..."; git clone "git@github.com:pyroscope/$project.git" $project; }
    done

    # Update source
    source bin/activate
    for project in $git_projects; do
        ( builtin cd $project && git pull -q --ff-only )
    done
    source bootstrap.sh
    for project in $git_projects; do
        ( builtin cd $project && ../bin/python -m pip -q install -e . )
    done

    ln -nfs python ./bin/python-pyrocore

else
    echo "Run from github root."
fi
