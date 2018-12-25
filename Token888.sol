pragma solidity 0.4.23;

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract TRC20Interface {
    function totalSupply() public view returns (uint);

    function balanceOf(address tokenOwner) public view returns (uint balance);

    function allowance(address tokenOwner, address spender) public view returns (uint remaining);

    function transfer(address to, uint value) public returns (bool success);

    function approve(address spender, uint value) public returns (bool success);

    function transferFrom(address from, address to, uint value) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed tokenOwner, address indexed spender, uint value);
}

contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 value, address token, bytes memory data) public;
}

contract Ownable {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract Token888 is TRC20Interface, Ownable {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint8 public decimals;
    uint _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    event Burn(uint256 value);

    constructor() public {
        symbol = "888";
        name = "888Tron";
        decimals = 6;
        _totalSupply = 100 * 1000000 * 10 ** uint(decimals);
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint value) public returns (bool success) {
        require(to != address(0));

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint value) public returns (bool success) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool success) {
        require(to != address(0));

        balances[from] = balances[from].sub(value);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
        balances[to] = balances[to].add(value);
        emit Transfer(from, to, value);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint value, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, value, address(this), data);
        return true;
    }

    function() external payable {
        revert();
    }

    function transferAnyTRC20Token(address tokenAddress, uint value) public onlyOwner returns (bool success) {
        return TRC20Interface(tokenAddress).transfer(owner, value);
    }

    function burn(uint256 value) public onlyOwner returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(value);
        _totalSupply = _totalSupply.sub(value);
        emit Burn(value);
        return true;
    }
}