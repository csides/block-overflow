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
        // This will also test that making an answer works
        beforeEach(async function() {
            this.newQuestion = await Question.new(ZERO_ADDRESS, 
                ZERO_ADDRESS, 
                "This real question", 
                "What could the answer be?", 
                {from: accounts[0], value: 200000}
            );
            await this.newQuestion.makeAnswer("Answer!", 
                "This will solve your problem!", 
                {from: accounts[1], value: 60000}
            );
            await this.newQuestion.makeAnswer("Haha Spam!", 
                "I will waste your time",
                {from: accounts[2], value: 20000}
            );
        });

        // Correctly list questions
        it("should correctly list answers", async function() {
            this.answerAddresses = await this.newQuestion.listAnswers();
            assert.equal(this.answerAddresses.length, 2, "There should be two quest addresses returned");
            assert(this.answerAddresses[0] != ZERO_ADDRESS, "Should return a real address");
            assert(this.answerAddresses[1] != ZERO_ADDRESS, "Should return a real address")
        });

        // Test making accepting and rejecting answers
        it("should accept and reject questions", async function() {
            // Simply testing that there are no reverts here.
            // We test the full functionality of this in the answer integration tests
            this.answerAddresses = await this.newQuestion.listAnswers();
            await this.newQuestion.rejectAnswer(this.answerAddresses[1], {from: accounts[0]});
            await this.newQuestion.acceptAnswer(this.answerAddresses[0], {from: accounts[0]});
        });

        // Test retrieving the answer's value (both accepted and rejected)
        it("should retrieve stored answer value", async function() {
            this.answerAddresses = await this.newQuestion.listAnswers();
            await this.newQuestion.rejectAnswer(this.answerAddresses[1], {from: accounts[0]});
            await this.newQuestion.acceptAnswer(this.answerAddresses[0], {from: accounts[0]});

            await this.newQuestion.collectAnswerFunds(this.answerAddresses[0], {from: accounts[0]});
            await this.newQuestion.collectAnswerFunds(this.answerAddresses[1], {from: accounts[0]});
            const answer0Balance = await web3.eth.getBalance(this.answerAddresses[0]).valueOf();
            const answer1Balance = await web3.eth.getBalance(this.answerAddresses[1]).valueOf();
            const questionBalance = await web3.eth.getBalance(this.newQuestion.address).valueOf();
            assert.equal(answer0Balance, 0, "The answer's balance should have been withdrawn");
            assert.equal(answer1Balance, 0, "The answer's balance should have been withdrawn");
            assert.equal(questionBalance, 280000, "The question's balance should have been updated with both questions");
        });
    });
});