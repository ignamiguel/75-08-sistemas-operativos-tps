rm -rf workdir
rm -rf grupo03.tgz
rm -rf download/grupo03.tgz
make
mkdir workdir
cp grupo03.tgz download/grupo03.tgz
tar -xzf grupo03.tgz -C workdir
