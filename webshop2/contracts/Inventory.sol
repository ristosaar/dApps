pragma solidity ^0.5.0;

import "@openzeppelin/contracts/ownership/Ownable.sol";

contract Inventory is Ownable {

    address[16] public itemOwners;
    string public staticUrl = 'https://i.imgur.com/';

    struct ShopItem{
        string name;
        string picUrl;
        uint id;
        uint color;
        uint price;
    }

    ShopItem[] public itemList;

    uint public lastItemId = 0;
    
    event NewItem(
        uint id,
        string name, 
        uint price
    );

    constructor() public // create some sample products
    {
        itemList.push(ShopItem('Motorola test 1','HixHW9T.png',0,2,500 finney)) - 1;
    }

    function getItemCount() external view returns(uint){
        return itemList.length;
    }

    function getItemOwners() public view returns (address[16] memory) {
        return itemOwners;
    }

    function addNewItem(string calldata name, string calldata imgFile, uint color, uint price) external onlyOwner{
        lastItemId = itemList.push(ShopItem(name,imgFile,lastItemId + 1,color,price)) - 1;
        emit NewItem(lastItemId,name,price);
    }

    function buyItem(uint _id) external payable returns(uint){
        require(_id >= 0 && _id <= 15);
        require(msg.value == itemList[_id].price);
        itemOwners[_id] = msg.sender;
        return _id;
    }

}