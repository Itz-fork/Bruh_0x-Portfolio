#!usr/bin/env


# ------------------ Variables ------------------#
PKGM="pnpm"
GHP_BRANCH="gh-pages"
UPSTREAM_NM="ghupstream"
REPO_URL="https://github.com/Itz-fork/itz-fork.github.io.git"
BUILD_START=$(date +%Y-%m-%d-%H-%M-%S)
FLAGS=""

# ------------------ Constants ------------------#
CURDIR="./${PWD##*/}/."
TMPDIR="./pages_build/"

# ------------------ Colors codes ------------------#
WHITE="\033[1;37m"
CYAN="\033[1;36m"
BLACK="\033[1;30m"
YELLOW="\033[1;93m"
GREEN="\033[1;92m"
RED="\033[1;31m"
CYAN_BACK="\033[1;46m"
GREEN_BACK="\033[1;42m"
RESET="\033[0m"

# ------------------ Output functions ------------------#
say_sh() {
    echo -e "${CYAN}$1${RESET}\n"
}
info_sh() {
    echo -e "   ${WHITE}$1${RESET}\n"
}
warn_sh() {
    echo -e "${RED}WARNING !\n $1${RESET}\n"
}



say_sh "> Setting up build environment..."
cd ..
mkdir $TMPDIR
cp -a $CURDIR $TMPDIR
cd $TMPDIR


say_sh "> Creating build branch - ${GHP_BRANCH}"
git checkout $GHP_BRANCH &> /dev/null || git checkout -b $GHP_BRANCH


say_sh "> Building site..."
if [ ! -d "node_modules" ]; then
    warn_sh "node_modules folder doesn't exist"
    info_sh "> Installing dependencies..."
    $PKGM install
fi
$PKGM build $FLAGS


say_sh "> Preparing to publish..."
mkdir nodel
mv dist nodel
mv .git nodel
find ./ -mindepth 1 ! -regex '^./nodel\(/.*\)?' -delete
mv nodel/dist/* ./
mv nodel/.git ./
rm -rf nodel


say_sh "> Publishing your branch to ${REPO_URL}"
if [ ! -d ".git" ]; then
    warn_sh "Git folder doesn't exist"
    info_sh "> Initializing a new project..."
    git init
fi
git add .
git commit -m "feat: new build"
git checkout $GHP_BRANCH &> /dev/null || git checkout -b $GHP_BRANCH &> /dev/null
git remote -v
git remote add "${UPSTREAM_NM}" "${REPO_URL}"
git push -u "${UPSTREAM_NM}" "${GHP_BRANCH}" --force


say_sh "> Switching back to working dir"
cd ..
rm -rf $TMPDIR
cd $CURDIR


say_sh "> Done"
