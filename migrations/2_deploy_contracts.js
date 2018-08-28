var Question = artifacts.require("./Question.sol"); 

module.exports = function(deployer) {
  deployer.deploy(Question, 
    '0x0000000000000000000000000000000000000000', 
    '0x0000000000000000000000000000000000000000', 
    "Hello World Question!", 
    "Ooooh, and a description toooo");
};
