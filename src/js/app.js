App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },
  initWeb3: function() {
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        window.ethereum.enable();
      } catch (error) {
        console.error("User denied account access")
      }
    } else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    } else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
    }
    web3 = new Web3(App.web3Provider);
    return App.initContract();
  },
  initContract: function() {
    $.getJSON('LegoCertificationStore.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var LegoCertificationStoreArtifact = data;
      App.contracts.LegoCertificationStore = TruffleContract(LegoCertificationStoreArtifact);
    
      // Set the provider for our contract
      App.contracts.LegoCertificationStore.setProvider(App.web3Provider);
    
      // Use our contract to retrieve and mark the adopted pets
      return App;//.markAdopted();
    });
    return App.bindEvents();
  },
  bindEvents: function() {
    //$(document).on('click', '.btn-adopt', App.handleAdopt);
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
