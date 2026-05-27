# jsrc.sh
#
# run this first to read in the jsource

cd `dirname "$(realpath $0)"`
rm -rf jsource
git clone --branch 9.7 --single-branch --depth 1 git@github.com:jsoftware/jsource.git jsource
rm -rf jsource/.git

