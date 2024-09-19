// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

// 02
// 实现一个 WETH，将 ETH 包装成 ERC20

// WETH (Wrapped ETH) 是 ETH 的包装版本。由于以太币本身并不符合 ERC20 标准，导致与其他代币之间的互操作性较弱，难以用于去中心化应用程序（dApps）。

// 本练习要求实现一个符合 ERC20 标准的 WETH ，它比普通的 ERC20 多了两个功能：存款和取款，通过这两个功能，WETH 可以 1:1 兑换ETH。

contract WETH is ERC20 {
    // 事件：存款和取款
    event Deposit(address indexed dst, uint256 wad);

    event Withdrawal(address indexed src, uint256 wad);

    constructor() ERC20("WETHTEST", "WTHT") {}

    //回调函数，当用户往weth合约转账ETH时，会出发deposit()函数
    fallback() external payable {
        deposit();
    }

    //回调函数，当用户往weth合约转账ETH时，会出发deposit()函数
    receive() external payable {
        deposit();
    }

    //    存款函数，当用户村ETH时，给他铸造等量weth
    function deposit() public payable {
        _mint(msg.sender, msg.value);

        emit Deposit(msg.sender, msg.value);
    }
    //提款 函数，用户销毁 weth，取回等量的eth
    function withdraw(uint amount) public {
        require(balanceOf(msg.sender)>=amount, "Amount Must than less msg.sender");
        _burn(msg.sender, amount);
        payable (msg.sender).transfer( amount);

        emit Withdrawal(msg.sender, amount);
    }
}