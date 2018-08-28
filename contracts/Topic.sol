pragma solidity ^0.4.24;

import {Question} from "./Question.sol";
import {Answer} from "./Answer.sol";

/*
    @title Topic 
    @dev This contract is inteded to be a factory for questions, in addition to managing some overhead information
    @dev Not all functions are commented
*/
contract Topic {
    address public owner;
    address public forum;
    bool public halted;
    uint256 public questionPrice;
    
    mapping(address => bool) public admins;
    mapping(address => uint256) private holdings;

    address[] public questions;
    address[] public urgentQuestions;
    address[] public contestedQuestions;

    mapping(address => bytes24) questionNames;
    mapping(address => uint256) questionIndex;
    mapping(address => uint256) urgentIndex;
    mapping(address => uint256) contestedIndex;

    modifier onlyOwner() {
        if (msg.sender == owner) _;
    }

    modifier onlyAdmin() {
        if (admins[msg.sender]) _;
    }

    modifier onlyQuestion() {
        require(questionNames[msg.sender].length >= 0, "Calling address must be a question");
        _;
    }

    modifier ifNotHalted() {
        if (!halted) _;
    }

    /*
        * @dev a (payable) function writtin to create a new topic and initialize some basic values
        * @param _forum Currently not in use, as the ForumManager contract was very buggy
        * @param _questionPrice the base price a new question requires 
    */
    constructor(address _forum, uint256 _questionPrice) public payable {
        owner = msg.sender;
        questionPrice = _questionPrice;
        admins[owner] = true;
        holdings[owner] = msg.value;
        forum = _forum;
        halted = false;
    }

  /*
        * @dev a (payable) function writtin to create a new question under this topic
        * @param name a short name for the question
        * @param title the title of the given question
        * @param description the body of the question, containing most of the question details
    */
    function makeQuestion(bytes24 name, string title, string description) public payable ifNotHalted {
        require(msg.value >= questionPrice, "Not enough value sent to create a question");
        address newQuestion = (new Question).value(msg.value)(forum, this, title, description);
        questionIndex[newQuestion] = questions.push(newQuestion) - 1;
        questionNames[newQuestion] = name;
    }

    // Only to be called from web3
    function getQuestionAddresses() public view returns(address[]) {
        return questions;
    } 

    function addAdmin(address newAdmin) public onlyOwner {
        admins[newAdmin] = true;
    }

    function removeAdmin(address adminToRemove) public onlyOwner { 
        admins[adminToRemove] = false;
    }

    function isAdmin(address adminAddress) public view returns(bool) {
        return admins[adminAddress];
    }

    function haltTopic() public onlyAdmin {
        halted = true;
    }

    function unhaltTopic() public onlyAdmin {
        halted = false;
    }

    function addContested() public onlyQuestion ifNotHalted {
        contestedIndex[msg.sender] = contestedQuestions.push(msg.sender) - 1;
    }

    function checkHoldings(address userToCheck) public view returns(uint256) {
        return holdings[userToCheck];
    }

    /*
        * @dev the function for users to withdraw their value from this forum
        * only executes if the contract is not halted
        * currently, users can only withdraw all of their stored value
    */
    function withdrawFunds() public ifNotHalted {
        uint256 amountToWithdraw = holdings[msg.sender];
        holdings[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }
}