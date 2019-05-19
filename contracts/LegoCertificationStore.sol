pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/ownership/Secondary.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./helper.sol";

contract Callee {
    function getValue(uint initialValue) external returns(uint);
    function storeValue(uint value) external;
    function getValues() external returns(uint);
}

contract LegoCertificationStore is Ownable {

    using SafeMath for uint256;
    using Helper for uint256;

    struct LegoCertificate {
        string name;
        string number;
        string theme;
        string subtheme;
        string descritpion;
        string bricksJsonData;
        uint dna;
    }

    event NewCertificate(uint certificateId, string name, string number,
        string theme, string subtheme, string descritpion, string bricksJsonData, uint dna);

    Callee linkedContract;

    LegoCertificate[] public certificates;

    mapping (uint => address) private certificateToOwner;
    mapping (address => uint) private ownedCertificatesCount;

    uint public dnaDigits = 256;
    uint public dnaModulus = (2 ** dnaDigits) - 1;

    constructor(address addr) Ownable() public {
        certificates.length = 0;
        linkedContract = Callee(addr);
    }

    function  someAction() private returns(uint) {
        return linkedContract.getValue(100);
    }

    function storeAction(address addr) private returns(uint) {
        Callee c = Callee(addr);
        c.storeValue(100);
        return c.getValues();
    }

    function someUnsafeAction(address addr) private {
        bool status;
        bytes memory result;
        (status, result) = addr.call(
            abi.encode(bytes4(keccak256("storeValue(uint256)")), 100)
            );
    }

    function delegatedCalculation(uint firstNumber, uint secondNumber) public {
        bool status;
        bytes memory result;
        (status, result) = address(linkedContract).delegatecall(
            abi.encodePacked(bytes4(keccak256("calculate(uint256,uint256)")), firstNumber, secondNumber)
            );
    }

    //"gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg",["gdsfgdsfg"],["gdsfgdsfg"]

    function createNewCertificate(string memory _name,
        string memory  _number,
        string memory _theme,
        string memory _subtheme,
        string memory _descritpion,
        string memory _bricksJsonData,
        string[] memory _bricks,
        string[] memory _registers) public {
        // IF dnaModulus == (2 ** dnaDigits) - 1; DOES NOT CUT THE NUMBER
        uint randDna;
        uint = randDna.generateRandomDna(_name, _descritpion, _bricksJsonData, dnaModulus);
        _createCertificate(_name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, randDna);
    }

    function _createCertificate(string memory _name,
        string memory _number,
        string memory _theme,
        string memory _subtheme,
        string memory _descritpion,
        string memory _bricksJsonData,
        uint _dna) internal {
        uint id = certificates.push(LegoCertificate(_name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, _dna)) - 1;
        certificateToOwner[id] = msg.sender;
        ownedCertificatesCount[msg.sender]++;
        emit NewCertificate(id, _name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, _dna);
    }

    function getOwnedCertificatesCountByAddress(address _address) public view returns (uint _count) {
        return ownedCertificatesCount[_address];
    }

    function getOwnedCertificatesCount() public view returns (uint _count) {
        return ownedCertificatesCount[msg.sender];
    }

    function getCertificatesCount() public view returns(uint){
        return certificates.length;
    }

    function  getOwnedCertificates(address _address) public view returns (LegoCertificate[] memory _certificates) {
        uint length = getCertificatesCount();
        _certificates = new LegoCertificate[](getOwnedCertificatesCountByAddress(_address));
        for(uint i = 0; i < length; i++){
            if(_address == certificateToOwner[i])
            {
                _certificates[i] = certificates[i];
            }
        }
        return _certificates;
    }

    function  getOwnedCertificatesIds(address _address) public view returns (uint[] memory _ids) {
        uint length = getCertificatesCount();
        _ids = new uint[](getOwnedCertificatesCountByAddress(_address));
        for (uint i = 0; i < length; i++) {
            if(_address == certificateToOwner[i])
            {
                _ids[i] = i;
            }
        }
        return _ids;
    }
}