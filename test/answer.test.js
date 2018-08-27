var Topic = artifacts.require("Topic");
var Question = artifacts.require("Question");
var Answer = artifacts.require("Answer");


contract('Answer', function(accounts) {
    const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

    context('with a new answer', async function() {
        beforeEach(async function() {
            this.newAnswer = await Answer.new("Yup yup", "Correct answer", ZERO_ADDRESS, ZERO_ADDRESS,
                {from: accounts[0], value: 5000});
        }); 

        // Test basic creation and data retreival 
        it("should create a contract and store value and data", async function() {
            const balance = web3.eth.getBalance(this.newAnswer.address);
            const title = await this.newAnswer.getTitle();
            const desc = await this.newAnswer.getDescription();
            assert.equal(balance, 5000, "it should store the balance correctly");
            assert.equal(title, "Yup yup", "it should store the title correctly");
            assert.equal(desc, "Correct answer", "it should store the description correctly");
        });

        // Test upvoting (adding value to the answer)
        it("should take upvotes and update value", async function() {
            await this.newAnswer.upvoteAnswer({from: accounts[1], value: 1000});
            await this.newAnswer.upvoteAnswer({from: accounts[2], value: 2000});
            const newValue = await this.newAnswer.getValue().valueOf();
            const balance = await web3.eth.getBalance(this.newAnswer.address).valueOf();
            assert.equal(balance, 8000, 'The contract\'s balance should update')
            assert.equal(newValue, 8000, 'The contract should update it\'s stored value');
        });
    });

    context('with a parent question', async function() {
        beforeEach(async function() {
            this.newQuestion = await Question.new(ZERO_ADDRESS, 
                ZERO_ADDRESS, 
                "This real question", 
                "What could the answer be?", 
                {from: accounts[0], value: 200000}
            );
            await this.newQuestion.makeAnswer("Answer!", 
                "This will solve your problem!", 
                {from: accounts[1], value: 40000}
            );
            await this.newQuestion.makeAnswer("Haha Spam!", 
                "I will waste your time",
                {from: accounts[2], value: 30000}
            );
            this.answerAddresses = await this.newQuestion.listAnswers();
            this.correctAnswer = await web3.eth.contract(Answer.abi).at(this.answerAddresses[0]);
            this.wrongAnswer = await web3.eth.contract(Answer.abi).at(this.answerAddresses[1]);
        });

        // Test answer selection
        it("should be accepted", async function() {
            await this.newQuestion.acceptAnswer(this.correctAnswer.address, {from: accounts[0]});
            const accepted = await this.correctAnswer.isAccepted();
            assert.equal(accepted, true, "Answer should have been acceptedt");
            const rejected = await this.correctAnswer.isRejected();
            assert.equal(rejected, false, "Answer should not have been rejected");
        });

        it("should be rejected", async function() {
            await this.newQuestion.rejectAnswer(this.wrongAnswer.address, {from: accounts[0]});
            const accepted = await this.wrongAnswer.isAccepted();
            assert.equal(accepted, false, "Answer should not have been acceptedt");
            const rejected = await this.wrongAnswer.isRejected();
            assert.equal(rejected, true, "Answer should be rejected");
        });

        // Test contesting the rejection
        it("should contest the rejection", async function() {
            await this.newQuestion.rejectAnswer(this.correctAnswer.address, {from: accounts[0]});
            await this.correctAnswer.contestRejection({from: accounts[1]});
            const contested = await this.correctAnswer.isContested();
            assert.equal(contested, true, "The answer was contested after rejection")
            const accepted = await this.correctAnswer.isAccepted();
            assert.equal(accepted, false, "Answer should not have been acceptedt (it is contested)");
            const rejected = await this.correctAnswer.isRejected();
            assert.equal(rejected, true, "Answer should have been rejected (it is contested)");
        });

        // Test retrieving the answer's value
        it("should transfer stored value", async function() {
            await this.newQuestion.acceptAnswer(this.correctAnswer.address, {from: accounts[0]});
            await this.newQuestion.collectAnswerFunds(this.correctAnswer.address, {from: accounts[0]});
            const answerBalance = await web3.eth.getBalance(this.correctAnswer.address).valueOf();
            const questionBalance = await web3.eth.getBalance(this.newQuestion.address).valueOf();
            assert.equal(answerBalance, 0, "The answer's balance should have been withdrawn");
            assert.equal(questionBalance, 240000, "The question's balance should have been updated");
        });
    });
});