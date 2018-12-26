pragma solidity ^0.4.23;

import "./IGameManager.sol";
import "./IGame.sol";
import "./ITRC20.sol";
import "./GameRole.sol";

contract GameManager is GameRole, IGameManager {

    function createBet(address game, address player, uint refUserId, bytes32[] data) public payable {
        require(games[game]);
        IGame(game).createBet(msg.sender, player, msg.value, refUserId, data);
    }

    function transferTo(address player, uint amount) public onlyGame {
        require(player != address(0));
        player.transfer(amount);
    }

    function transferTokenTo(address token, address to, uint amount) public onlyGame {
        ITRC20(token).transfer(to, amount);
    }

}
