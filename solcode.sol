// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYCVerification {
    address public admin;

    struct User {
        string name;
        string documentHash;
        bool isVerified;
    }

    mapping(address => User) public users;
    address[] public userAddresses;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addUser(address userAddress, string memory name, string memory documentHash) public onlyAdmin {
        require(bytes(users[userAddress].name).length == 0, "User already exists");
        users[userAddress] = User(name, documentHash, false);
        userAddresses.push(userAddress);
    }

    function verifyUser(address userAddress) public onlyAdmin {
        require(bytes(users[userAddress].name).length != 0, "User not found");
        users[userAddress].isVerified = true;
    }

    function removeUser(address userAddress) public onlyAdmin {
        require(bytes(users[userAddress].name).length != 0, "User not found");
        delete users[userAddress];

        // Remove address from the array
        for (uint i = 0; i < userAddresses.length; i++) {
            if (userAddresses[i] == userAddress) {
                userAddresses[i] = userAddresses[userAddresses.length - 1];
                userAddresses.pop();
                break;
            }
        }
    }

    function updateUser(address userAddress, string memory newName, string memory newDocumentHash) public onlyAdmin {
        require(bytes(users[userAddress].name).length != 0, "User not found");
        users[userAddress].name = newName;
        users[userAddress].documentHash = newDocumentHash;
    }

    function isUserVerified(address userAddress) public view returns (bool) {
        return users[userAddress].isVerified;
    }

    function getUser(address userAddress) public view returns (string memory, string memory, bool) {
        User memory u = users[userAddress];
        return (u.name, u.documentHash, u.isVerified);
    }

    function getAllUsers() public view returns (address[] memory) {
        return userAddresses;
    }
}
