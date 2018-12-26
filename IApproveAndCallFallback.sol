pragma solidity ^0.4.23;

interface IApproveAndCallFallback {
    function receiveApproval(address _from, uint _value, address _token, bytes _data) external;
}