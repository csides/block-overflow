pragma solidity ^0.4.24;

import {Question} from "./Question.sol";
import {Answer} from "./Answer.sol";


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

    constructor(address _forum, uint256 _questionPrice) public payable {
        owner = msg.sender;
        questionPrice = _questionPrice;
        admins[owner] = true;
        holdings[owner] = msg.value;
        forum = _forum;
        halted = false;
    }

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
    
    // function deleteQuestion(address deletedQuestion) public {

    // }

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

    function withdrawFunds() public ifNotHalted {
        uint256 amountToWithdraw = holdings[msg.sender];
        holdings[msg.sender] = 0;
        msg.sender.transfer(amountToWithdraw);
    }
}