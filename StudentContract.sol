// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface ToE{
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed tokenSpender, uint256 tokens); 
    function name() view external returns(string memory);
    function symbol() view external returns(string memory);
    function decimal() view external returns(uint8);
    function totalSupply() view external returns(uint);
    function balanceOf(address _userAddress) external view returns (uint256);
    function transfer(address _receiver, uint256 _tokens) external returns (bool);
    function approve(address _spender, uint _tokens) external returns(bool);
    function allowance(address _owner, address _spender) external view returns(uint);
    function transferFrom(address _owner, address _receipient, uint _tokens) external returns (bool);
}

contract StudentContract {

    ToE private Token;
    constructor(address tokenAddress){
        Token = ToE(tokenAddress);
    }
    struct Student {
        uint256 id;
        string name;
        string course;
        Deliverable[] deliverables;
    }

    struct Deliverable {
        uint256 id;
        address author;
        string url;
    }

    mapping(uint256 => Student) private students;
    uint256 private std_count = 0;

    //MODIFIERS
    modifier validCreate(uint256 _studentId) {
        require(students[_studentId].id == 0, "Student already exist");
        require(_studentId > 0, "Id must be greater than 0");
        _;
    }

    modifier isStudentExist(uint256 _studentId) {
        require(students[_studentId].id != 0, "Student not exist");
        _;
    }

    modifier idDeliverableExist(uint _studentId, uint _deliverableId){
        Deliverable[] memory deliverables = students[_studentId].deliverables;
        for (uint i = 0 ; i < deliverables.length; i++){
            require(deliverables[i].id != _deliverableId, "Deliverable id alredy exist");
        }
        _;
    }

    //FUNCTIONS
    function addStudent(
        uint256 _studentId,
        string memory _name,
        string memory _course
    ) public validCreate(_studentId) {
        Student storage newStudent = students[_studentId];
        newStudent.id = _studentId;
        newStudent.name = _name;
        newStudent.course = _course;
        std_count++;
    }

    function getStudent(uint256 _studentId)
        public
        view
        isStudentExist(_studentId)
        returns (string memory _name, string memory _course)
    {
        _name = students[_studentId].name;
        _course = students[_studentId].course;
    }

    function submitDeliverable(
        uint256 _deliverableId,
        uint256 _studentId,
        string memory _url
    ) public isStudentExist(_studentId)
    idDeliverableExist(_studentId, _deliverableId) returns (bool){
        students[_studentId].deliverables.push(
            Deliverable(_deliverableId, msg.sender, _url)
        );
        Token.transfer(msg.sender, 5);
        return true;
    }

    function getDeliverables(uint _studentId) public view isStudentExist(_studentId) returns(Deliverable[] memory){
        return students[_studentId].deliverables;
    }

    function getStudentCount() public view returns(uint){
        return std_count;
    }
}

//0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
//0x617F2E2fD72FD9D5503197092aC168c91465E7f2