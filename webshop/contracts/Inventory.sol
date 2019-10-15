pragma solidity ^0.5.0;

contract Inventory {

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

    uint lastItemId = 0;
    
    event NewItem(uint id, string name, uint price);

    constructor() public // create some sample products
    {
        itemList.push(ShopItem('Motoroller 050','HixHW9T.png',0,2,500 finney)) - 1;
        itemList.push(ShopItem('Somesong S23','PTcEHuo.png',1,0,1000 finney)) - 1;
        lastItemId = itemList.push(ShopItem('NoGia 2sa','YOVHJfT.png',2,1,700 finney)) - 1;
        itemOwners[0]=0x1777450459b864D05e31782b51129da4721e579C;
    }

    function getItemCount() external view returns(uint){
        return itemList.length;
    }

    function getItemOwners() public view returns (address[16] memory) {
        return itemOwners;
    }

    function buyItem(uint _id) external payable returns(uint){
        require(_id >= 0 && _id <= 15);
        require(msg.value == itemList[_id].price);
        itemOwners[_id] = msg.sender;
        return _id;
    }

}