pragma solidity ^0.4.24;

import Topic from "./Topic.sol"
import Question from "./Question.sol"
import Answer from "./Answer.sol"

contract ForumManager {
    
    // Forum Management
    address private owner;
    mapping(address => bool) public admins;
    uint16 private numAdmins;

    address[] public topics;
    mapping(address => bytes24) public topicNames;

    // User informaton
    mapping(address => bytes32) public usernames;
    mapping(address => uint8) public activeQuestions;
    mapping(address => uint256) public ratings;
    mapping(address => uint256) private holdings;

    mapping(address => bool) private blacklist;
    mapping(address => bool) private probationList;

    // Question cost determination
    uint256 public numQuestions;
    uint256 public questionValue;

    uint16 public baseValueRatio;
    uint16 public baseUrgentRate;

    // Misc cost determination
    uint16 public topicRatio;
    uint16 public newUserFee;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender].length;
        _;
    }

    modifier onlyUser() {
        require(usernames[msg.sender].length > 0);
        _;
    }

    function makeTopic(bytes24 topicName) public payable onlyUser {
        require(msg.value >= topicPrice());
        address newTopic = (new Topic).value(msg.value)();
        topics.push(newTopic);
        topicNames[newTopic] = topicName;
    }

    function seeTopics() public view {

    }

    function checkHoldings() public view returns( uint256 userHoldings ) {

    }

    function makeAdmin() public onlyOwner {

    }

    function removeAdmin() public onlyOwner {

    }

    function killTopic(bytes24 topicName, bool graceful) public onlyAdmin {

    }

    function approveKill(bytes24 topicName) public onlyAdmin {

    }

    function blacklistUser(address userAddress, bool graceful) public onlyAdmin {

    }

    function clearUser(address userAddress) public onlyAdmin {

    }

    function killForum() public onlyOwner {

    }

    function questionPrice() public view returns(uint256) {
        // Average question cost * multiplier
        return (questionValue / numQuestions) * (baseValueRation / 100)
    }

    function urgentPrice() public view returns(uint256) {
        // Average question cost * multiplier
        return questionPrice() * baseUrgentRate;
    }

    function topicPrice() public view returns(uint256) {
        return questionPrice() * topicRatio;
    }

    function joiningFee() public view returns(uint256) {
        return questionPrice() * newUserFee;
    }
}