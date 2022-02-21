// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "solmate/tokens/ERC721.sol";
import "./interfaces/IStarknetCore.sol";
import "./utils/Ownable.sol";

contract IshgarVault is Ownable {
    struct NFTDeposit {
        address depositor;
        address erc721;
        uint256 tokenId;
    }

    address public starknetCoreAddress;

    uint256 public ishgarL2Address;
    uint256 public constant DEPOSIT_NFT_SELECTOR =
        1523363669770796724904282918361620777908202468599035418579302836818670410372;
    uint256 public constant DEPOSIT_ETHER_SELECTOR =
        936308572258894397301517214131817559150073589475529971327981418939726877891;

    mapping(address => uint256) public balances;
    // erc721 => tokenId => NFTDeposit
    mapping(address => mapping(uint256 => NFTDeposit)) public deposits;

    constructor(address starknetCoreAddress_, uint256 ishgarL2Address_) {
        require(starknetCoreAddress_ != address(0), "Ishgar: starknet is address(0)");
        require(ishgarL2Address_ != 0, "Ishgar: l2 address is 0");
        starknetCoreAddress = starknetCoreAddress_;
        ishgarL2Address = ishgarL2Address_;
    }

    event DepositNFT(address indexed depositor, address indexed erc721, uint256 indexed tokenId);
    event DepositEther(address indexed depositor, uint256 indexed amount);
    event UpdateIshgarL2Address(uint256 indexed previousAddress, uint256 indexed newAddress);

    function depositNFT(address erc721Address, uint256 tokenId) public {
        require(!_exists(erc721Address, tokenId), "Ishgar: already deposited");

        ERC721 erc721 = ERC721(erc721Address);
        erc721.transferFrom(_msgSender(), address(this), tokenId);

        NFTDeposit memory deposit = NFTDeposit(_msgSender(), erc721Address, tokenId);
        deposits[erc721Address][tokenId] = deposit;

        uint256[] memory payload = new uint256[](3);
        payload[0] = _addressToUint(_msgSender());
        payload[1] = _addressToUint(erc721Address);
        payload[2] = tokenId;

        IStarknetCore starknetCore = IStarknetCore(starknetCoreAddress);
        starknetCore.sendMessageToL2(ishgarL2Address, DEPOSIT_NFT_SELECTOR, payload);

        emit DepositNFT(_msgSender(), erc721Address, tokenId);
    }

    function depositEther() public payable {
        require(msg.value > 0, "Ishgar: wrong value sent");

        balances[_msgSender()] += msg.value;

        uint256[] memory payload = new uint256[](2);
        payload[0] = _addressToUint(_msgSender());
        payload[1] = msg.value;

        IStarknetCore starknetCore = IStarknetCore(starknetCoreAddress);
        starknetCore.sendMessageToL2(ishgarL2Address, DEPOSIT_ETHER_SELECTOR, payload);

        emit DepositEther(_msgSender(), msg.value);
    }

    function updateIshgarL2Address(uint256 newAddress) public onlyOwner {
        require(newAddress != 0, "Ishgar: address is address(0)");
        emit UpdateIshgarL2Address(ishgarL2Address, newAddress);
        ishgarL2Address = newAddress;
    }

    function _addressToUint(address value) private pure returns (uint256) {
        return uint256(uint160(value));
    }

    function _exists(address erc721Address, uint256 tokenId) public view returns (bool) {
        require(erc721Address != address(0), "Ishgar: address(0)");
        return deposits[erc721Address][tokenId].depositor != address(0);
    }
}
