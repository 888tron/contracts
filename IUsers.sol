pragma solidity ^0.4.23;

interface IUsers {
    function getUserIdToAddress(uint _userId) external view returns (address);
}