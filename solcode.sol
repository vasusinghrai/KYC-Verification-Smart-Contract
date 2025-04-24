// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYCVerification {
    address public admin;

    struct User {// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYCVerification {
    address public admin;

    struct User {
        string name;
        string documentHash;
        bool isVerified;
    }

    mapping(address => User) public users;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addUser(address userAddress, string memory name, string memory documentHash) public onlyAdmin {
        users[userAddress] = User(name, documentHash, false);
    }

    function verifyUser(address userAddress) public onlyAdmin {
        require(bytes(users[userAddress].name).length != 0, "User not found");
        users[userAddress].isVerified = true;
    }

    function getUser(address userAddress) public view returns (string memory, string memory, bool) {
        User memory u = users[userAddress];
        return (u.name, u.documentHash, u.isVerified);
    }
}

        string name;
        string documentHash;
        bool isVerified;
    }

    mapping(address => User) public users;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addUser(address userAddress, string memory name, string memory documentHash) public onlyAdmin {
        users[userAddress] = User(name, documentHash, false);
    }

    function verifyUser(address userAddress) public onlyAdmin {
        require(bytes(users[userAddress].name).length != 0, "User not found");
        users[userAddress].isVerified = true;
    }

    function getUser(address userAddress) public view returns (string memory, string memory, bool) {
        User memory u = users[userAddress];
        return (u.name, u.documentHash, u.isVerified);
    }
}
