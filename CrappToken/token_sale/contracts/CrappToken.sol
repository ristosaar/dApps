pragma solidity >=0.4.21 <0.6.0;

contract CrappToken{
    string public name = "CrApp Token";
    string public symbol = "CRAT";
    string public standard = "CrApp Token v1.1";

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

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

    function approve(address _spender, uint256 _value) public returns (bool success) {
       allowance[msg.sender][_spender] = _value;

       emit Approval(msg.sender,_spender,_value);

       return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success){
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        allowance[_from][msg.sender]-=_value;
        emit Transfer(_from,_to,_value);
        return true;
    }


}