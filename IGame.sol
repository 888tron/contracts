pragma solidity ^0.4.23;

interface IGame {
    function createBet(address from, address to, uint amount, uint refUserId, bytes32[] data) external;
}