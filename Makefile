include .env

build	:; forge build
deploy	:; forge create IshgarVault --constructor-args $(STARKNET_CORE) --constructor-args $(ISHGAR_L2_ADDRESS) --private-key $(PRIVATE_KEY) --rpc-url $(PROVIDER_URI)
deploy-mock :; forge create MockERC721 --private-key $(PRIVATE_KEY) --rpc-url $(PROVIDER_URI)
update-ishgar-l2-address :; cast send $(ISHGAR_VAULT_ADDRESS) "updateIshgarL2Address(uint256)" $(ISHGAR_L2_ADDRESS) --private-key $(PRIVATE_KEY) --rpc-url $(PROVIDER_URI)
