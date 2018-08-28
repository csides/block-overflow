pragma solidity ^0.4.24;

import {Topic} from "./Topic.sol";
import {Question} from "./Question.sol";
import {Answer} from "./Answer.sol";

/*
    Forum Manager contract:
        The original design was to include a forum manager which would keep track of topics, users, admins, etc
        This caused numerous issues during testing due to contract size, cost of operations, and several unknown errors
        This contract should not be graded
*/

contract ForumManager {
    
    // // Forum Management
    // address private owner;
    // bool public activeHalted;
    // bool public withdrawalHalted;
    // mapping(address => bool) public admins;
    // uint16 private numAdmins;

    // address[] public topics;
    // mapping(address => bytes24) public topicNames;

    // // User informaton
    // mapping(address => bytes32) public usernames;
    // mapping(address => uint8) public activeQuestions;
    // mapping(address => uint256) public ratings;
    // mapping(address => uint256) private holdings;

    // mapping(address => bool) private blacklist;

    // // Question cost determination
    // uint256 public numQuestions;
    // uint256 public questionTotalValue;

    // uint16 public baseValueRatio;
    // uint16 public baseUrgentRate;

    // // Misc cost determination
    // uint16 public topicRatio;
    // uint16 public newUserFee;

    // constructor(uint16 valueRate, uint16 urgentRate, uint16 topicRate, uint16 newUserRate) public payable {
    //     owner = msg.sender;
    //     holdings[msg.sender] = msg.value;
    //     usernames[msg.sender] = "owner";
    //     admins[owner] = true;
    //     numAdmins += 1;
    //     activeHalted = false;
    //     withdrawalHalted = false;
    //     baseValueRatio = valueRate;
    //     baseUrgentRate = urgentRate;
    //     topicRatio = topicRate;
    //     newUserFee = newUserRate;
    //     questionTotalValue = 10;
    //     numQuestions = 1;
    // }

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "Only the owner may access this function");
    //     _;
    // }

    // modifier onlyAdmin() {
    //     require(admins[msg.sender], "Only admins may access this function");
    //     _;
    // }

    // modifier onlyUser() {
    //     require(usernames[msg.sender].length > 0 && !(blacklist[msg.sender]), "Only users may access this function");
    //     _;
    // }

    // function makeTopic(bytes24 topicName) public payable onlyUser {
    //     require(msg.value >= topicPrice(), "Not enough value sent to create a topic");
    //     address newTopic = (new Topic).value(msg.value)(this);
    //     topics.push(newTopic);
    //     topicNames[newTopic] = topicName;
    // }

    // // Only to be called from web3
    // function getTopicName(address questionAddress) public view returns(bytes24) {
    //     return topicNames[questionAddress];
    // }

    // // Only to be called from web3
    // function getTopicAddresses() public view returns(address[]) {
    //     return topics;
    // } 

    // function getUsername(address user) public view returns(bytes32) {
    //     return usernames[user];
    // }

    // function checkAdmin(address admin) public view returns(bool) {
    //     return admins[admin];
    // }

    // function checkHoldings() public view onlyUser returns(uint256) {
    //     return holdings[msg.sender];
    // }

    // // function withdrawHoldings() public onlyUser {
    // //     uint256 amountToSend = holdings[msg.sender];
    // //     holdings[msg.sender] = 0;
    // //     msg.sender.transfer(amountToSend);
    // // }

    // function enrollUser(address newUser, bytes32 username) public payable {
    //     // They have sent a joining fee and are not already enrolled
    //     require(msg.value >= joiningFee(), "Not enough value sent to create user");
    //     require(usernames[newUser].length == 0, "User with this name already enrolled");
    //     usernames[newUser] = username;
    //     holdings[newUser] += msg.value;
    // }

    // function makeAdmin(address newAdmin) public onlyOwner {
    //     // User should already be enrolled
    //     require(usernames[newAdmin].length > 0, "User must be enrolled before they can be an admin");
    //     admins[newAdmin] = true;
    //     numAdmins += 1;
    // }

    // function removeAdmin(address toRemove) public onlyOwner {
    //     require(admins[toRemove], "Address to remove must be an admin");
    //     admins[toRemove] = false;
    // }

    // function isAdmin(address toCheck) public view returns(bool) {
    //     return admins[toCheck];
    // }

    // function haltTopic(address topicToHalt) public onlyAdmin {
    //     Topic(topicToHalt).haltTopic();
    // }

    // function blacklistUser(address userAddress, bool maliciousUser) public onlyAdmin {
    //     blacklist[userAddress] = true;
    //     if (maliciousUser) holdings[userAddress] = 0;
    // }

    // function clearUser(address userAddress) public onlyAdmin {
    //     blacklist[userAddress] = false;
    // }

    // function haltForum() public onlyOwner {
    //     activeHalted = true;
    // }

    // function haltAll() public onlyOwner {
    //     activeHalted = true;
    //     withdrawalHalted = true;
    // }

    // function unhaltAll() public onlyOwner {
    //     activeHalted = false;
    //     withdrawalHalted = false;
    // }

    // function questionPrice() public view returns(uint256) {
    //     // Average question cost * multiplier
    //     return uint256((100*questionTotalValue/numQuestions) * (baseValueRatio/100) / 100);
    // }

    // function urgentPrice() public view returns(uint256) {
    //     // Average question cost * multiplier
    //     return questionPrice() * baseUrgentRate;
    // }

    // function topicPrice() public view returns(uint256) {
    //     return questionPrice() * topicRatio;
    // }

    // function joiningFee() public view returns(uint256) {
    //     return questionPrice() * newUserFee;
    // }
}