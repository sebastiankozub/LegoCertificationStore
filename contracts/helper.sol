pragma solidity ^0.5.2;

library Helper {

    function generateRandomDna(string memory _str1, string memory _str2, string memory _str3, uint _dnaModulus)
        private pure returns (uint _dna) {
        uint rand1 = uint(keccak256(abi.encodePacked(_str1)));
        uint rand2 = uint(keccak256(abi.encodePacked(_str2)));
        uint rand3 = uint(keccak256(abi.encodePacked(_str3)));
        return ((rand1 + rand2 - rand3) * rand3) % _dnaModulus;
    }
}
