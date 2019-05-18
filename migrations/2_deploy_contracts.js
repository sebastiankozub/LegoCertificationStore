var LegoCertificationStore = artifacts.require("./LegoCertificationStore.sol");

module.exports = function(deployer) {
  deployer.deploy(LegoCertificationStore);
};