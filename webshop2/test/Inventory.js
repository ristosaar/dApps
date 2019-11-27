var Inventory = artifacts.require("./Inventory.sol");

contract('Inventory', function (accounts) {
    it('adds new item to itemList', function () {
        return Inventory.deployed().then(function(instance){
            invInstance = instance;
            return invInstance.lastItemId();
        }).then(function(lastId){
            lastItemId = lastId.toNumber();
            return invInstance.addNewItem('Motoroller 050','HixHW9T.png',2,500000);
        }).then(function(receipt){
            assert.equal(receipt.logs.length, 1, 'triggers one event');
            assert.equal(receipt.logs[0].event, 'NewItem', 'triggers "NewItem" event');
            return invInstance.lastItemId();
        }).then(function(lastId){
            assert.equal(lastItemId+1, lastId.toNumber(), 'lastItemId increased by 1');
        }); 
    }); 
});