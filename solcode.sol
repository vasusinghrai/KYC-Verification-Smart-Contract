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

    // ✅ Get all verified users
    function getVerifiedUsers() public view returns (address[] memory) {
        uint count = 0;
        for (uint i = 0; i < userAddresses.length; i++) {
            if (users[userAddresses[i]].isVerified) {
                count++;
            }
        }

        address[] memory verifiedUsers = new address[](count);
        uint index = 0;

        for (uint i = 0; i < userAddresses.length; i++) {
            if (users[userAddresses[i]].isVerified) {
                verifiedUsers[index] = userAddresses[i];
                index++;
            }
        }

        return verifiedUsers;
    }

    // ✅ Transfer admin role
    function transferAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid address");
        admin = newAdmin;
    }

    // ✅ Check if user exists
    function isUserExists(address userAddress) public view returns (bool) {
        return bytes(users[userAddress].name).length != 0;
    }

    // ✅ Get total user count
    function getUserCount() public view returns (uint) {
        return userAddresses.length;
    }

    // ✅ Get unverified users
    function getUnverifiedUsers() public view returns (address[] memory) {
        uint count = 0;
        for (uint i = 0; i < userAddresses.length; i++) {
            if (!users[userAddresses[i]].isVerified) {
                count++;
            }
        }

        address[] memory unverifiedUsers = new address[](count);
        uint index = 0;

        for (uint i = 0; i < userAddresses.length; i++) {
            if (!users[userAddresses[i]].isVerified) {
                unverifiedUsers[index] = userAddresses[i];
                index++;
            }
        }

        return unverifiedUsers;
    }
}
