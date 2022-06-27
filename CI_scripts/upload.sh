cd out/target/product/${DEVICE}
curl -sL $OUTFILE https://git.io/file-transfer | sh
./transfer wet *.img
