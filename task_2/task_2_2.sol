// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


// 使用 Solidity 实现一个 NFT Swap

// 利用智能合约搭建一个零手续费的去中心化 NFT 交易所，主要逻辑：

// - 卖家：出售 NFT 的一方，可以挂单 list、撤单 revoke、修改价格 update。

// - 买家：购买 NFT 的一方，可以购买 purchase。

// - 订单：卖家发布的 NFT 链上订单，一个系列的同一 tokenId 最多存在一个订单，其中包含挂单价格 price 和持有人 owner 信息。当一个订单交易完成或被撤单后，其中信息清零。

// NFT Swap
contract NFTSwap is IERC721Receiver {
event List(
address indexed sellet,
address indexed nftAddr,
uint256 indexed tokenId,
uint256 price
);
event Purchase(
address indexed buyer,
address indexed nftAddr,
uint256 indexed tokenId,
uint256 price
);
event Revoke(
address indexed sellet,
address indexed nftAddr,
uint256 indexed tokenId
);
event Update(
address indexed sellet,
address indexed nftAddr,
uint256 indexed tokenId,
uint256 newPrice
);
// 定义结构体
struct Order {
address owner;
uint256 price;
}
//NFT. Order 映射
mapping(address => mapping(uint256 => Order)) public nfgList;

fallback() external payable {}

// 挂单:卖家上海nft，合约地址为 _nftAddr, tokenId为_tokenId， 价格_price为以太坊（单位说wei）
function list(
address _nftAddr,
uint256 _tokenId,
uint256 _price
) public {
IERC721 _nft = IERC721(_nftAddr); //声明 ERC721节课合约变量
require(_nft.getApproved(_tokenId) == address(this), "Need Approval");
require(_price > 0, "Price Must than less 0");

Order storage _order = nfgList[_nftAddr][_tokenId]; //设置nfg持有人和价格
_order.owner = msg.sender;
_order.price = _price;

//将nft转账到合约
_nft.safeTransferFrom(msg.sender, address(this), _tokenId);
//释放List事件
emit List(msg.sender, _nftAddr, _tokenId, _price);
}

// 购买：买家购买nft，合约为——nftAddr ，tokenId为——tokenId，调用函数时要附带ETH
function purchase(address _nftAddr, uint256 _tokenId) public payable {
Order storage _order = nfgList[_nftAddr][_tokenId];
require(_order.price > 0, "Invalid Price"); //nft价格大雨0
require(msg.value >= _order.price, "Increase price"); //购买价格大雨标价
//声明 IERC721接口合约变量
IERC721 _nft = IERC721(_nftAddr);
require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); //nf在合约中

//将nft转给买家
_nft.safeTransferFrom(address(this), msg.sender, _tokenId);
//将ETH转给卖家，多余eth给卖家退款
payable(_order.owner).transfer(_order.price);
payable(msg.sender).transfer(msg.value - _order.price);

delete nfgList[_nftAddr][_tokenId];

emit Purchase(msg.sender, _nftAddr, _tokenId, _order.price);
}

//撤单：卖家取消挂单
function revoke(address _nftAddr, uint256 _tokenId) public {
Order storage _order = nfgList[_nftAddr][_tokenId];
require(_order.owner == msg.sender, "Not owner");
//声明 IERC721接口合约变量
IERC721 _nft = IERC721(_nftAddr);
require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); //nf在合约中

_nft.safeTransferFrom(address(this), msg.sender, _tokenId);
delete nfgList[_nftAddr][_tokenId]; //删除order
// 释放 Revoke事件
emit Revoke(msg.sender, _nftAddr, _tokenId);
}

//调整价格
function Updatea(
address _nftAddr,
uint256 _tokenId,
uint256 _newPrice
) public {
require(_newPrice > 0, "Invalid Price"); //nft价格大雨0
Order storage _order = nfgList[_nftAddr][_tokenId];
require(_order.owner == msg.sender, "Not owner");
//声明 IERC721接口合约变量
IERC721 _nft = IERC721(_nftAddr);
require(_nft.ownerOf(_tokenId) == address(this), "Invalid Order"); //nf在合约中

//调整nft价格
_order.price = _newPrice;
emit Update(msg.sender, _nftAddr, _tokenId, _newPrice);
}

// 实现 IERC721Receiver的 onERC721Received,能够加收erc721代币
function onERC721Received(
address operator,
address from,
uint256 tokenId,
bytes calldata data
) external override returns (bytes4) {
return IERC721Receiver.onERC721Received.selector;
}
}




// ERC721合约
contract DERC721 is ERC721 {
uint public MAX_APES = 10000; // 总量


constructor() ERC721("YellowFirstNFt1", "YFN1") {}

// 铸造函数
function mint(address to, uint tokenId) external {
require(tokenId >= 0 && tokenId < MAX_APES, "tokenId out of range");
_mint(to, tokenId);
}

//BaseURL
function _baseURI() internal view virtual override returns (string memory) {
return "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";
}
}