var Topic = artifacts.require("Topic");
var Question = artifacts.require("Question");
var Answer = artifacts.require("Answer");


contract('Question', function(accounts) {
    const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

    context('with a new question', async function() {
        beforeEach(async function() {
            this.newQuestion = await Question.new(ZERO_ADDRESS, 
                ZERO_ADDRESS, 
                "This cool title", 
                "Description of question", 
                {from: accounts[0], value: 10000}
            );
        }); 

        // Test basic creation and data retreival 
        it("should create a contract and store value and data", async function() {
            const balance = await web3.eth.getBalance(this.newQuestion.address);
            const title = await this.newQuestion.getTitle();
            const desc = await this.newQuestion.getDescription();
            assert.equal(balance, 10000, "it should store the balance correctly");
            assert.equal(title, "This cool title", "it should store the title correctly");
            assert.equal(desc, "Description of question", "it should store the description correctly");
        });

        // Test upvoting (adding value to question)
        it("should take upvotes and update value", async function() {
            this.newQuestion.upvoteQuestion({from: accounts[1], value: 1000});
            const newValue = await this.newQuestion.getValue().valueOf();
            const balance = await web3.eth.getBalance(this.newQuestion.address).valueOf();
            assert.equal(balance, 11000, 'The contract\'s balance should update');
            assert.equal(newValue, 11000, 'The contract should update it\'s stored value');
        });
    });

    context('in a full application', async function() {
        beforeEach(async function() {
            // this.forum = await ForumManager.new(20, 3, 10, 5, {from: accounts[0], value: 100000000, gas: 500000, gasPrice: 100000000000});
            // this.forum.enrollUser(accounts[0], "User 0", {from: accounts[0], value: 1000, gas: 10000});
            // this.forum.enrollUser(accounts[1], "User 1", {from: accounts[1], value: 1000, gas: 10000});
            // this.forum.enrollUser(accounts[2], "User 2", {from: accounts[2], value: 1000, gas: 10000});

            // this.forum.makeTopic("Test Topic", {from: accounts[0], value: 10000});
            // this.topicAddress = await this.forum.getTopicAddresses()[0];
            // this.topic = web3.eth.contract(Topic.abi).at(this.topicAddress);

            // this.topic.makeQuestion("Test", "Test Question", "Question Description", {from: accounts[1], value: 1000});
            // this.questionAddress = await this.topic.getQuestionAddresses()[0];
            // this.question = web3.eth.contract(Question.abi).at(this.questionAddress);
        });

        // // Test answer selection
        // it("should accept and reject answers", async function() {
        // });

        // // Test making the question urgent
        // it("should make a question urgent", async function() {
        // });

        // it("should not make a question urgent without payment", async function() {
        // });

        // // Test retrieving the answer's value
        // it("should retrieve stored answer value", async function() {
        // });
    });
});