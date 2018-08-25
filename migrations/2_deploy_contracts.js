var ForumManager = artifacts.require("./ForumManager.sol"); 

module.exports = function(deployer) {
  deployer.deploy(ForumManager, 20, 3, 10, 5);
};
