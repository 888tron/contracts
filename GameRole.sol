pragma solidity ^0.4.23;
import "./Ownable.sol";

contract GameRole is Ownable {

    modifier onlyGame {
        require(games[msg.sender]);
        _;
    }

    mapping(address => bool) public games;

    function addGame(address game) public onlyOwner {
        games[game] = true;
    }

    function removeGame(address game) public onlyOwner {
        games[game] = false;
    }
}