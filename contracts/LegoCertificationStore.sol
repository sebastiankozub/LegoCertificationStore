pragma solidity ^0.5.2;
pragma experimental ABIEncoderV2;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract LegoCertificationStore is Ownable {
    using SafeMath for uint256;

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

    LegoCertificate[] public certificates;

    mapping (uint => address) private certificateToOwner;
    mapping (address => uint) private ownedCertificatesCount;

    uint public dnaDigits = 256;
    uint public dnaModulus = (2 ** dnaDigits) - 1;

    constructor() Ownable() public {
        certificates.length = 0;
    }

    //"gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg","gdsfgdsfg",["gdsfgdsfg"],["gdsfgdsfg"]

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
        uint id = certificates.push(LegoCertificate(_name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, _dna)) - 1;
        certificateToOwner[id] = msg.sender;
        ownedCertificatesCount[msg.sender]++;
        emit NewCertificate(id, _name, _number, _theme, _subtheme, _descritpion, _bricksJsonData, _dna);
    }

    function getOwnedCertificatesCount(address _address) public view returns (uint _count) {
        return ownedCertificatesCount[_address];
    }

    function getCertificatesLength() public view returns(uint){
        return certificates.length;
    }

    function  getOwnedCertificates(address _address) public view returns (LegoCertificate[] memory _certificates) {
        uint length = getCertificatesLength();
        uint counter = 0;
        for(uint i = 0; i < length; i++){
            if(_address == certificateToOwner[i])
            {
                counter++;
            }
        }
        _certificates = new LegoCertificate[](counter);
        for(uint i = 0; i < length; i++){
            if(_address == certificateToOwner[i])
            {
                _certificates[i] = certificates[i];
            }
        }
        return _certificates;
    }

    function  getOwnedCertificatesIds(address _address) public view returns (uint[] memory _ids) {
        uint length = getCertificatesLength();
        uint counter = 0;
        for (uint i = 0; i < length; i++) {
            if(_address == certificateToOwner[i])
            {
                counter++;
            }
        }
        _ids = new uint[](counter);
        for (uint i = 0; i < length; i++) {
            if(_address == certificateToOwner[i])
            {
                _ids[i] = i;
            }
        }
        return _ids;
    }

    function _generateRandomDna(string memory _str1, string memory _str2, string memory _str3) private view returns (uint _dna) {
        uint rand1 = uint(keccak256(abi.encodePacked(_str1)));
        uint rand2 = uint(keccak256(abi.encodePacked(_str2)));
        uint rand3 = uint(keccak256(abi.encodePacked(_str3)));
        return ((rand1 + rand2 - rand3) * rand3) % dnaModulus;
    }
}