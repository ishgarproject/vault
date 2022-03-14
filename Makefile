include .env

build	:; forge build

deploy	:; forge create IshgarVault --constructor-args $(STARKNET_CORE) --constructor-args $(ISHGAR_L2_ADDRESS) --private-key $(PRIVATE_KEY) --rpc-url $(PROVIDER_URI)
deploy-azuki :; forge create MockERC721 --private-key $(PRIVATE_KEY) --constructor-args "Azuki" --constructor-args "AZUKI" --constructor-args "https://ikzttp.mypinata.cloud/ipfs/QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/" --rpc-url $(PROVIDER_URI)
deploy-clonex :; forge create MockERC721 --private-key $(PRIVATE_KEY) --constructor-args "CloneX" --constructor-args "CloneX" --constructor-args "https://clonex-assets.rtfkt.com/" --rpc-url $(PROVIDER_URI)
deploy-meebits :; forge create MockERC721 --private-key $(PRIVATE_KEY) --constructor-args "Meebits" --constructor-args "Meebits" --constructor-args "https://meebits.larvalabs.com/meebit/" --rpc-url $(PROVIDER_URI)
deploy-doodles :; forge create MockERC721 --private-key $(PRIVATE_KEY) --constructor-args "Doodles" --constructor-args "DOODLE" --constructor-args "ipfs://QmPMc4tcBsMqLRuCQtPmPe84bpSjrC3Ky7t3JWuHXYB4aS/" --rpc-url $(PROVIDER_URI)

update-ishgar-l2-address :; cast send $(ISHGAR_VAULT_ADDRESS) "updateIshgarL2Address(uint256)" $(ISHGAR_L2_ADDRESS) --private-key $(PRIVATE_KEY) --rpc-url $(PROVIDER_URI)
