pragma solidity ^0.4.24;

import {ForumManager} from "./ForumManager.sol";
import {Question} from "./Question.sol";
import {Answer} from "./Answer.sol";


contract Topic {
    address public owner;
    address public forum;
    bool public halted;

    mapping(address => bool) public admins;

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

    constructor(address _forum) public payable {
        owner = msg.sender;
        admins[owner] = true;
        forum = _forum;
        halted = false;
    }

    function makeQuestion(bytes24 name, string title, string description) public payable ifNotHalted {
        require(msg.value >= (ForumManager)(forum).topicPrice(), "Not enough value sent to create a question");
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

    function haltTopic() public onlyAdmin {
        halted = true;
    }

    function unhaltTopic() public onlyAdmin {
        halted = false;
    }

    function addUrgent() public onlyQuestion ifNotHalted {
        urgentIndex[msg.sender] = urgentQuestions.push(msg.sender) - 1;
    }

    // function removeUrgent() public ifNotHalted {

    // }

    function addContested() public onlyQuestion ifNotHalted {
        contestedIndex[msg.sender] = contestedQuestions.push(msg.sender) - 1;
    }

    // function removeContested() public onlyQuestion ifNotHalted {

    // }
}