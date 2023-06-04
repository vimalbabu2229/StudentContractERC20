// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//address: 0x9D65f65Ab34D98c6174a06cd30225bbB944AA369
interface ToE{
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed tokenSpender, uint256 tokens); 
    function name() view external returns(string memory);
    function symbol() view external returns(string memory);
    function decimal() view external returns(uint8);
    function totalSupply() view external returns(uint);
    function balanceOf(address _userAddress) external view returns (uint256);
    function transfer(address _receiver, uint256 _tokens) external returns (bool);
    function approve(address _spender, uint _tokens) external returns(bool);
    function allowance(address _owner, address _spender) external view returns(uint);
    function transferFrom(address _owner, address _receipient, uint _tokens) external returns (bool);
}

contract TokenOfExcellence is ToE{

    string public constant name = "Token of Excellence";
    string public constant symbol = "ToE";
    uint8 public constant decimal = 18;
    uint256 public totalSupply; /* Here public is used to replace the totalSupply() function since using public in this way 
    provides a getter function by default */

    mapping(address => uint256) balance;
    mapping(address => mapping(address => uint256)) allowed; /* here the first address indicates the owner and the second 
address indicates the spender . uint is to store the value that the spender is allowed to transfer from the owners account */


    /*constructor is used to initialize the token count that cannot be changed there after */
    constructor(uint256 _totalSupply) {
        totalSupply = _totalSupply;
        balance[msg.sender] = _totalSupply;
    }

    //FUNCTIONS

    function balanceOf(address _userAddress) public view returns (uint256) {
        return balance[_userAddress];
    }

    function transfer(address _receiver, uint256 _tokens)
        public
        returns (bool)
    {
        require(_tokens <= balance[msg.sender], "Insufficient Balance for Transfer");
        balance[msg.sender] -= _tokens;
        balance[_receiver] += _tokens;
        emit Transfer(msg.sender, _receiver, _tokens);
        return true;
    }

    /* the approve function is typically called by the token owner to grant permission to a spender to transfer tokens
     on their behalf. The token owner specifies the spender's address and the maximum amount of tokens they are allowed 
     to transfer*/
    function approve(address _spender, uint _tokens) public returns(bool){
        allowed[msg.sender][_spender] = _tokens;
        emit Approval(msg.sender, _spender, _tokens);
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns(uint){
        return allowed[_owner][_spender];
    }

/*The spender can then call the transferFrom function, specifying the token owner's address, the recipient's address, and
 the amount of tokens to transfer.*/
    function transferFrom(address _owner, address _receipient, uint _tokens) public returns (bool){
        require(_tokens <= allowed[_owner][msg.sender], "Insufficient Allowance");
        require(_tokens <= balance[_owner]);
        balance[_receipient] += _tokens;
        balance[_owner] -= _tokens;
        allowed[_owner][msg.sender] -= _tokens;
        emit Transfer(_owner, _receipient, _tokens);
        return  true;
    }
}