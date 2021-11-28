pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

contract BuildCollective is Ownable {

//------------------User-------------------

  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  mapping(address => User) private users;
  address[] public userAddresses;
  event UserSignedUp(address indexed userAddress, User indexed user);


  function transfer(address payable pay, uint256 amount) public payable returns (bool){
    bool success = pay.send(amount);
    return success;
  }

  function deposit() public payable returns (bool) {

          users[msg.sender].balance += uint256(msg.value);
          enterprises[msg.sender].balance += uint256(msg.value);

          return true;
      }

  function withdraw(uint256 val) public returns (bool) {
        require(users[msg.sender].balance >= val, "Insuficient funds to withdraw");
        
        users[msg.sender].balance -= val;
        enterprises[msg.sender].balance -= val;

        address payable wal = address(uint256(msg.sender));
        wal.transfer(val);
    }

  function AtoB(address payable B,uint256 val) public returns (bool) {
        require(users[msg.sender].balance >= val, "Insuficient funds to transfer");
        
        users[msg.sender].balance -= val;
        enterprises[msg.sender].balance -= val;
        users[B].balance += val;
        enterprises[B].balance += val;


  }
  function getUser(address userAddress) public view returns (User memory) {
    require(users[userAddress].registered);
    return users[userAddress];
  }

  function getUsers() external view returns (address[] memory) {
    return userAddresses;
  }

  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username,0,true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
    userAddresses.push(msg.sender);
    return users[msg.sender];
  }


//------------------Enterprise-------------------

  struct Enterprise {
    string name;
    address owner;
    address[] membersAddress;
    uint256 balance;
  }
  mapping(address => Enterprise) private enterprises; 
  event EnterpriseSignedUp(address indexed ownerAddress, Enterprise indexed enterprise);
  
  function getEnterprise(address enterpriseAddress) public view returns (Enterprise memory) {
    require(users[enterpriseAddress].registered);
    return enterprises[enterpriseAddress];
  }

  function CreateEntreprise(string memory name, address[] memory address_members) public returns (Enterprise memory) {
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    enterprises[msg.sender] = Enterprise(name, msg.sender, address_members, 0);
    emit EnterpriseSignedUp(msg.sender, enterprises[msg.sender]);
    return enterprises[msg.sender];
  }
 
//------------------Project-------------------

  struct Project {
    uint256 id;
    string name;
    string url;
    address owner; 
    bool ownedByUser; 
    address[] contributorsAddress;
    uint256 balance;
  }
  mapping(address => Project[]) private projects; 
  uint256 internal ProjectId;
  event ProjectCreate(address indexed ownerAddress, Project indexed project);

  function getProjects1(address ownerAddress) public view returns (Project[] memory){
    require(users[ownerAddress].registered);
    return projects[ownerAddress];
  }

  function getProjects2(address ownerAddress, uint256 id) public view returns (Project memory) {
    require(users[ownerAddress].registered);
    Project[] memory ownerProjects = getProjects1(ownerAddress);
    for (uint i = 0; i < ownerProjects.length; i++){
      if (ownerProjects[i].id == id){
        return ownerProjects[i];
      }
    }
    return ownerProjects[0];
  }

  function projectCreate(string memory name, string memory url, bool ownedByUser, address[] memory address_contributors) public returns (Project memory){
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    ProjectId ++;
    Project memory project = Project(ProjectId, name, url, msg.sender, ownedByUser, address_contributors, 0);
    projects[msg.sender].push(project);
    emit ProjectCreate(msg.sender, project);
    return project;
  }

  function sponsor(address projectOwnerAddress, uint256 idProject, uint256 amountToken) public returns (bool) {
    require(users[projectOwnerAddress].registered);
    for (uint i = 0; i < projects[projectOwnerAddress].length; i++){
      if (projects[projectOwnerAddress][i].id == idProject){
        require(users[msg.sender].balance >= (amountToken*1000000000000000000), "Insuficient funds to sponsor");
        users[msg.sender].balance -= (amountToken*1000000000000000000);
        projects[projectOwnerAddress][i].balance += (amountToken*1000000000000000000);
        return true;
      }
    }
    return false;
  }

//------------------Issue-------------------

  struct Issue {
    uint256 id;
    string title;
    string description;
    string url; 
    address issuer; 
    address fixer; 
    uint256 reward; 
    bool closed; 
  }
  mapping(uint => Issue[]) private issues; 
  uint256 internal IssueId;
  event IssueCreate(address indexed issuerAddress, Issue indexed issue);

  function getIssues(uint256 projectId) public view returns (Issue[] memory) {
    return issues[projectId];
  }
  function createIssue(address projectOwnerAddress, uint256 projectId, string memory title, string memory description, string memory link, uint256 reward) public returns (Issue memory){
    require(users[projectOwnerAddress].registered);
    require(users[msg.sender].registered);
    require(bytes(title).length > 0);
    IssueId++;
    Issue memory issue = Issue(IssueId, title, description, link, msg.sender, address(0), (reward*1000000000000000000), false);
    issues[projectId].push(issue);
    users[msg.sender].balance-=(reward*1000000000000000000);
    emit IssueCreate(msg.sender, issue);
    return issue;
  }  


  function fixIssue(uint256 projectId, uint256 issueId) public  returns (Issue memory){
    for (uint i = 0; i < issues[projectId].length; i++){
      if (issues[projectId][i].id == issueId) {
            Issue memory issue = Issue(issues[projectId][i].id, issues[projectId][i].title, issues[projectId][i].description,issues[projectId][i].url, issues[projectId][i].issuer, msg.sender, issues[projectId][i].reward, true);

            users[msg.sender].balance += issues[projectId][i].reward;

            delete issues[projectId][i];
            issues[projectId].length--;

            issues[projectId].push(issue);
            emit IssueCreate(msg.sender, issue);

        return issue;
      }
    }
  }

  // fallback
  function () external payable{}
}
