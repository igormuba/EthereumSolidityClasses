var testContract = artifacts.require("./testContract.sol");

const number = 3;

module.exports = function(deployer) {
  deployer.deploy(testContract, number);
};
