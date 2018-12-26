pragma solidity ^0.4.23;

interface IGameManager {
    function transferTo(address player, uint amount) external;

    function transferTokenTo(address token, address to, uint amount) external;
}