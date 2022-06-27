source $CONFIG
cd ~
cd $SYNC_PATH

cd out/target/product/${DEVICE}
curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet recovery.tar
