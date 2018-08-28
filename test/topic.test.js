var Topic = artifacts.require("Topic");
var Question = artifacts.require("Question");
var Answer = artifacts.require("Answer");


contract('Topic', function(accounts) {
    const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

    context('with a new topic', async function() {
        beforeEach(async function() {
            this.newTopic = await Topic.new(ZERO_ADDRESS, 1000,
                {from: accounts[0], value: 100000});
        }); 

        // Test basic creation and data retreival 
        it("should create a contract and store value and data", async function() {
            const owner = await this.newTopic.owner();
            assert.equal(owner, accounts[0], "Owner should be set");
            const questionPrice = await this.newTopic.questionPrice();
            assert.equal(questionPrice, 1000, "Question price should be set")
            const ownerIsAdmin = await this.newTopic.isAdmin(accounts[0]);
            assert.equal(ownerIsAdmin, true, "Owner should be an admin");
            const ownerHoldings = await this.newTopic.checkHoldings(accounts[0]);
            assert.equal(ownerHoldings.valueOf(), 100000, "Owner should have deposited value");
        });

        it("should halt the topic", async function() {
            await this.newTopic.haltTopic({from: accounts[0]});
            const halted = await this.newTopic.halted();
            await this.newTopic.withdrawFunds({from: accounts[0]});
            const ownerHoldings = await this.newTopic.checkHoldings(accounts[0]);
            assert.equal(halted, true, "Topic should be halted");
            assert.equal(ownerHoldings, 100000, "Cannot withdraw funds during halt");
        });
        
        it("should allow user to withdraw funds", async function() {
            // const oldOwnerBalance = await web3.eth.getBalance(accounts[0]).valueOf();
            await this.newTopic.withdrawFunds({from: accounts[0]});
            const ownerHoldings = await this.newTopic.checkHoldings(accounts[0]).valueOf();
            // const newOwnerBalance = await web3.eth.getBalance(accounts[0]).valueOf();
            assert.equal(ownerHoldings, 0, "Owners holdings should have been withdrawn");
            // Not true because of the gas cost
            //assert(newOwnerBalance > oldOwnerBalance, "Owners balance should be increased");
        });

        it("should allow users to make questions", async function() {
            await this.newTopic.makeQuestion("Test Q", "This is a test question", "A longer description of the test question here",
                {from: accounts[1], value: 2000});
            const questionAddresses = await this.newTopic.getQuestionAddresses();
            this.newQuestion = await web3.eth.contract(Question.abi).at(questionAddresses[0]);
            const questionTitle = await this.newQuestion.getTitle();
            assert.equal(questionTitle, "This is a test question");
        });

        it("should allow the owner to add an admin", async function() {
            await this.newTopic.addAdmin(accounts[1], {from: accounts[0]});
            const userIsAdmin = await this.newTopic.isAdmin(accounts[1]);
            assert.equal(userIsAdmin, true, "User should be an admin");
            await this.newTopic.removeAdmin(accounts[1], {from: accounts[0]});
            const userIsntAdmin = await this.newTopic.isAdmin(accounts[1]);
            assert.equal(userIsntAdmin, false, "User should not be an admin")
        });
    });
});