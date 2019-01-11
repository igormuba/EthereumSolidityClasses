var OurErc20 = artifacts.require("./ourErc20.sol");//changed to our contract

module.exports = function(deployer) {
    const _name = "Our ERC20"; //name of our token
    const _symbol = "OUR"; //code of our token
    const _decimals = 2; //how many decimals it has
    deployer.deploy(OurErc20, _name, _symbol, _decimals); //sending the variables as constructor arguments
};