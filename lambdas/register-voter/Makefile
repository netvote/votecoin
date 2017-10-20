
build:
	cp ../../build/contracts/RegisterableElection.json .
	-rm *zip
	mv node_modules /tmp/node_modules_mac
	mv package.json /tmp/package-mac.json
	cp -R linux_node_modules/node_modules .
	cp linux_node_modules/package.json .
	mv linux_node_modules /tmp/linux_node_modules
	zip -r register-voter.zip .
	rm -rf node_modules
	rm package.json
	mv /tmp/node_modules_mac node_modules
	mv /tmp/package-mac.json package.json
	mv /tmp/linux_node_modules linux_node_modules