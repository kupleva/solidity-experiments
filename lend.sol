pragma solidity ^0.4.21;

contract Lend {
    address lender;
    mapping (address => uint) lended;

    event CreatorSaved(address creator);
    event LentMoney(address lender, address borrower, uint amount);
    event ReturnedMoney(address lender, address borrower, uint amount);
    event LenderNotCreator(address creator, address lender);
    event LenderIsBorrower(address lender);
    event ReturningTooMuch(address lender, address borrower, uint lent, uint returning);

    function Lend() public {
        lender = msg.sender;
        emit CreatorSaved(lender);
    }

    function lendMoney(address borrower, uint amount) public {
        if (msg.sender != lender) {
            emit LenderNotCreator(lender, msg.sender);
            return;
        }
        if (lender == borrower) {
            emit LenderIsBorrower(lender);
            return;
        }
        lended[borrower] = lended[borrower] + amount;
        emit LentMoney(lender, borrower, amount);
    }

    function returnMoney(uint amount) public {
        if (msg.sender == lender) {
            emit LenderIsBorrower(lender);
            return;
        }
        if (lended[msg.sender] < amount) {
            emit ReturningTooMuch(lender, msg.sender, lended[msg.sender], amount);
            return;
        }
        lended[msg.sender] = lended[msg.sender] - amount;
        emit ReturnedMoney(lender, msg.sender, amount);
    }
}
