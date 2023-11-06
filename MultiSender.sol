//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;



import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract MultiSender is Ownable (msg.sender){
    using SafeMath for uint256;
    using SafeMath for uint16;
    using Address for address;

    receive() external payable {}

    /*SendEthEqually
    */

    function SendEthEqually(address payable[] calldata _address)
        external
        payable
        returns (bool)
    {
        uint16 length = uint16(_address.length);
        uint sendValue = msg.value.div(length);
        for (uint16 i; i < length; ++i) {
            _address[i].transfer(sendValue);
        }

        return true;
    }

    /*SendEthEquallyByValue
    */

    function SendEthEquallyByValue(
        address payable[] calldata _address,
        uint256 _value
    ) external payable returns (bool) {
        uint16 length = uint16(_address.length);
        for (uint16 i; i < length; ++i) {
            _address[i].transfer(_value);
        }

        return true;
    }

    /*SendEthByValue

    */

    function SendEthByValue(
        address payable[] calldata _address,
        uint256[] calldata _value
    ) external payable returns (bool) {
        uint16 length = uint16(_address.length);
        uint16 valueLength = uint16(_value.length);
        require(length == valueLength, "Address & Value Length mismatched");
        for (uint16 i; i < length; ++i) {
            _address[i].transfer(_value[i]);
        }

        return true;
    }




    // Get the balance of all the ETH present in this smart contract

    function ETHBalance() external view returns (uint256 balance) {
        balance = address(this).balance;
        return balance;
    }

}