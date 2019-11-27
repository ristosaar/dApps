App = {
  web3Provider: null,
  contracts: {},
  colors: ['Black', 'Blue', 'Red', 'Green'],
  initialized: false,
  phonePrices: [],
  init: async function () {
    return await App.initWeb3();
  },

  initWeb3: async function () {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      alert("Metamask not found. Please install Metamask to continue. https://metamask.io/")
      console.error("Metamask not found")
     // App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function () {
    $.getJSON('Inventory.json', function (data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var InventoryArtifact = data;
      App.contracts.Inventory = TruffleContract(InventoryArtifact);

      // Set the provider for our contract
      App.contracts.Inventory.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.markBought();
    });

    return App.bindEvents();
  },

  bindEvents: function () {
    $(document).on('click', '.btn-buy', App.handleBuy);
  },

  markBought: function (adopters, account) {
    var inventoryInstance;

    function getItemDetails(id) {
      return inventoryInstance.itemList.call(id);
    }

    function getStaticUrl() {
      return inventoryInstance.staticUrl.call();
    }

    function getItemOwners() {
      return inventoryInstance.getItemOwners.call();
    }

    App.contracts.Inventory.deployed().then(function (instance) {
      inventoryInstance = instance;

      return inventoryInstance.getItemCount.call();
    }).then(function (maxItems) {
      getStaticUrl().then(function (url) {
        var productsRow = $('#productsRow');
        var productTemplate = $('#productTemplate');
        for (i = 0; i < maxItems; i++) {
          let index = i;
          if(!App.initialized){
            getItemDetails(i).then(function (item) {
              productTemplate.find('.card-title').children(":first").text(item[0]);
              productTemplate.find('img').attr('src', url + item[1]);
              productTemplate.find('.product-color').text(App.colors[item[3]]);
              productTemplate.find('h5').text(parseFloat(item[4]) / Math.pow(10, 18) + ' ETH');
              productTemplate.find('.btn-buy').attr('data-id', item[2]);
              App.phonePrices[item[2]] = item[4];
              productsRow.append(productTemplate.html());
            });
            productTemplate.remove();
          }
          

          getItemOwners().then(function (bought) {
            
            
            if (bought[index] !== '0x0000000000000000000000000000000000000000') {
             console.log($("#productsRow").find("[data-id='" + index + "']"));
             
              $("#productsRow").find("[data-id='" + index + "']").text('Sold out').attr('disabled', true);
            }
          });
        }

        App.initialized = true;

        
      });

    }).catch(function (err) {
      console.log(err.message);
    });
  },

  handleBuy: function (event) {
    event.preventDefault();
    var phoneId = parseInt($(event.target).data('id'));
    var price = App.phonePrices[phoneId];

    var inventoryInstance;

    web3.eth.getAccounts(function (error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Inventory.deployed().then(function (instance) {
        inventoryInstance = instance;

        return inventoryInstance.buyItem(phoneId, { from: account, value: price });
      }).then(function (result) {
        return App.markBought();
      }).catch(function (err) {
        console.log(err.message);
      });
    });

  }

};

$(function () {
  $(window).on('load', function () {
    App.init();
  });
});
