const CrappToken = artifacts.require("./CrappToken");

module.exports = function(deployer) {
  deployer.deploy(CrappToken,1000000);
};
