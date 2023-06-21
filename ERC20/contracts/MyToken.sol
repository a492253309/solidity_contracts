// SPDX-License-Identifier: GPL-3.0
//一个简单的中文注释的 ERC20代币合约代码
pragma solidity ^0.8.0;

// 定义ERC20标准
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ERC20合约实现
contract MyToken is IERC20 {
    string public constant name = "My Token"; // 代币名称
    string public constant symbol = "MTK"; // 代币简称
    uint8 public constant decimals = 18; // 小数位数，默认为18
    uint256 private constant _totalSupply = 1000000 * 10**uint256(decimals); // 总发行量

    mapping (address => uint256) private _balances; // 记录每个账户余额
    mapping (address => mapping (address => uint256)) private _allowances; // 允许第三方代理转账的额度
    
    constructor() {
        _balances[msg.sender] = _totalSupply; // 初始时，将所有代币都分配给合约创建者
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    
    // 返回总发行量
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    // 返回指定账户余额
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    // 转移代币到指定账户
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        address sender = msg.sender;
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] -= amount; // 减少发送者余额
        _balances[recipient] += amount; // 增加接收者余额
        emit Transfer(sender, recipient, amount); // 触发Transfer事件
        return true;
    }
    
    // 返回第三方代理转移的额度
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    // 允许第三方代理转移指定额度的代币
    function approve(address spender, uint256 amount) public override returns (bool) {
        address owner = msg.sender;
        _allowances[owner][spender] = amount; // 记录允许额度
        emit Approval(owner, spender, amount); // 触发Approval事件
        return true;
    }
 
    // 第三方代理从发送者账户转移代币到接收者账户
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        address owner = sender;
        require(owner != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(amount <= _balances[owner], "ERC20: transfer amount exceeds balance");
        require(amount <= _allowances[owner][msg.sender], "ERC20: transfer amount exceeds allowance");

        _balances[owner] -= amount; // 减少发送者的余额
        _balances[recipient] += amount; // 增加接收者的余额
        _allowances[owner][msg.sender] -= amount; // 减少第三方代理的额度
        emit Transfer(owner, recipient, amount); // 触发Transfer事件
        return true;
    }
}
