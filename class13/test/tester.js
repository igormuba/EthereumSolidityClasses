const testContract = artifacts.require("testContract");

contract("Testing testContract", async number =>{
    it("Number should be 1", async () =>{
        let instance = await testContract.deployed();
        let numberValue = await instance.number();
        assert.equal(numberValue.valueOf(), 1);
    });
});