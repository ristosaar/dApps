pragma solidity >=0.4.21 <0.6.0;

contract CrappToken{
    string public name = "Crapp Token";
    string public symbol = "CRAT";
    string public standard = "Crapp Token v1.0";

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;

    constructor(uint256 _initalSupply) public {
        totalSupply = _initalSupply;
        balanceOf[msg.sender] = _initalSupply;
    }

    function transfer(address _to, uint256 _value) public returns(bool success){
       require(balanceOf[msg.sender] >= _value,'insufficient balance');
       
       balanceOf[msg.sender] -= _value;
       balanceOf[_to] += _value;

       emit Transfer(msg.sender,_to,_value);

       return true;
    }
}