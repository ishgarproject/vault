include .env

build	:; forge build

deploy	:; forge create IshgarVault --constructor-args $(STARKNET_CORE) --constructor-args $(ISHGAR_L2_ADDRESS) --private-key $(PRIVATE_KEY) --rpc-url $(PROVIDER_URI)
deploy-bayc :; forge create MockERC721 --private-key $(PRIVATE_KEY) --constructor-args "BoredApeYatchClub" --constructor-args "BAYC" --constructor-args "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/" --rpc-url $(PROVIDER_URI)
deploy-azuki :; forge create MockERC721 --private-key $(PRIVATE_KEY) --constructor-args "Azuki" --constructor-args "AZUKI" --constructor-args "https://ikzttp.mypinata.cloud/ipfs/QmQFkLSQysj94s5GvTHPyzTxrawwtjgiiYS2TBLgrvw8CW/" --rpc-url $(PROVIDER_URI)

update-ishgar-l2-address :; cast send $(ISHGAR_VAULT_ADDRESS) "updateIshgarL2Address(uint256)" $(ISHGAR_L2_ADDRESS) --private-key $(PRIVATE_KEY) --rpc-url $(PROVIDER_URI)
