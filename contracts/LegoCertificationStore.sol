pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract LegoCertificationStore is Ownable {
    using SafeMath for uint256;
    event NewCertificate(uint certificateId, string name, string number,
        string theme, string subtheme, string descritpion, string bricksJsonData, uint dna);

    uint public dnaDigits = 16;
    uint public dnaModulus = 10 ** dnaDigits;

    struct LegoCertificate {
        string name;
        string number;
        string theme;
        string subtheme;
        string descritpion;
        string bricksJsonData;
        uint dna;
    }

    constructor() public {
        //certificates = new storage LegoCertificate[](0);
    }

    LegoCertificate[] public certificates;
    mapping (uint => address) private certificateToOwner;
    mapping (address => uint) private ownedCertificatesCount;

    function createNewCertificate(string memory _name,
        string memory  _number,
        string memory _theme,
        string memory _subtheme,
        string memory _descritpion,
        string memory _bricksJsonData, string[] memory _bricks, string[] memory _registers) public {
        uint randDna = _generateRandomDna(_name, _descritpion, _bricksJsonData);
        _createCertificate(_name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, randDna);
    }

    function _createCertificate(string memory _name,
        string memory _number,
        string memory _theme,
        string memory _subtheme,
        string memory _descritpion,
        string memory _bricksJsonData,
        uint _dna) internal {
        uint id = certificates.push(
            LegoCertificate(_name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, _dna)) - 1;
        certificateToOwner[id] = msg.sender;
        ownedCertificatesCount[msg.sender]++;
        emit NewCertificate(id, _name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, _dna);
    }

    function  getOwnedCertificatesCount(address _address) public view returns (uint _count) {
        return ownedCertificatesCount[_address];
    }

    function getCertificatesLength() public view returns(uint){
        return certificates.length;
    }

    function  getOwnedCertificates(address _address) public view returns (LegoCertificate[] memory) {
        // LegoCertificate[] memory _certificates = new LegoCertificate[](0);
        // uint lenght = getCertificatesLength();
        // for (uint i = 0; i < lenght; i++) {
        //     if(certificateToOwner[i] == _address)
        //     {
        //         _certificates = certificates[i];
        //     }
        // }
        // return _certificates;

        LegoCertificate[] memory _certificates = new LegoCertificate[](certificates.length);
        uint counter = 0;
        uint length = getCertificatesLength();
        for(uint i = 0; i < length; i++){
            if(_address == certificateToOwner[i])
            {
                _certificates[counter] = certificates[i];
            }
            counter++;
        }
        return _certificates;
    }

    function _generateRandomDna(string memory _str1, string memory _str2, string memory _str3) private view returns (uint _dna) {
        uint rand1 = uint(keccak256(abi.encodePacked(_str1)));
        uint rand2 = uint(keccak256(abi.encodePacked(_str2)));
        uint rand3 = uint(keccak256(abi.encodePacked(_str3)));
        return (rand1 + rand2 - rand3) % dnaModulus;
    }
}