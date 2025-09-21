// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { SepoliaConfig } from "@fhevm/solidity/config/ZamaConfig.sol";
import { euint32, externalEuint32, euint8, ebool, FHE } from "@fhevm/solidity/lib/FHE.sol";

contract FinancialTracker is SepoliaConfig {
    using FHE for *;
    
    struct FinancialTransaction {
        euint32 transactionId;
        euint32 amount;
        euint32 category; // 1: Income, 2: Expense, 3: Investment, 4: Loan
        euint32 subcategory; // Detailed categorization
        bool isEncrypted;
        bool isVerified;
        string description;
        string metadata;
        address farmer;
        uint256 timestamp;
    }
    
    struct LoanRecord {
        euint32 loanId;
        euint32 principalAmount;
        euint32 interestRate;
        euint32 remainingBalance;
        euint32 monthlyPayment;
        bool isActive;
        bool isPaidOff;
        string loanType;
        address farmer;
        address lender;
        uint256 startDate;
        uint256 endDate;
    }
    
    struct InvestmentRecord {
        euint32 investmentId;
        euint32 amount;
        euint32 expectedReturn;
        euint32 actualReturn;
        euint32 riskLevel;
        bool isActive;
        bool isCompleted;
        string investmentType;
        string description;
        address farmer;
        uint256 startDate;
        uint256 maturityDate;
    }
    
    struct FinancialReport {
        euint32 reportId;
        euint32 totalIncome;
        euint32 totalExpenses;
        euint32 netProfit;
        euint32 totalAssets;
        euint32 totalLiabilities;
        bool isVerified;
        string period;
        address farmer;
        uint256 timestamp;
    }
    
    mapping(uint256 => FinancialTransaction) public transactions;
    mapping(uint256 => LoanRecord) public loans;
    mapping(uint256 => InvestmentRecord) public investments;
    mapping(uint256 => FinancialReport) public reports;
    mapping(address => euint32) public totalIncome;
    mapping(address => euint32) public totalExpenses;
    mapping(address => euint32) public totalAssets;
    mapping(address => euint32) public totalLiabilities;
    mapping(address => euint32) public creditScore;
    
    uint256 public transactionCounter;
    uint256 public loanCounter;
    uint256 public investmentCounter;
    uint256 public reportCounter;
    
    address public owner;
    address public verifier;
    address public lender;
    
    event TransactionAdded(uint256 indexed transactionId, address indexed farmer, uint32 category);
    event LoanCreated(uint256 indexed loanId, address indexed farmer, uint32 amount);
    event InvestmentMade(uint256 indexed investmentId, address indexed farmer, uint32 amount);
    event ReportGenerated(uint256 indexed reportId, address indexed farmer, string period);
    event TransactionVerified(uint256 indexed transactionId, bool isVerified);
    event CreditScoreUpdated(address indexed farmer, uint32 score);
    
    constructor(address _verifier, address _lender) {
        owner = msg.sender;
        verifier = _verifier;
        lender = _lender;
    }
    
    function addTransaction(
        string memory _description,
        externalEuint32 _amount,
        externalEuint32 _category,
        externalEuint32 _subcategory,
        string memory _metadata,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_metadata).length > 0, "Metadata cannot be empty");
        
        uint256 transactionId = transactionCounter++;
        
        euint32 internalAmount = FHE.fromExternal(_amount, inputProof);
        euint32 internalCategory = FHE.fromExternal(_category, inputProof);
        euint32 internalSubcategory = FHE.fromExternal(_subcategory, inputProof);
        
        transactions[transactionId] = FinancialTransaction({
            transactionId: FHE.asEuint32(0), // Will be set properly later
            amount: internalAmount,
            category: internalCategory,
            subcategory: internalSubcategory,
            isEncrypted: true,
            isVerified: false,
            description: _description,
            metadata: _metadata,
            farmer: msg.sender,
            timestamp: block.timestamp
        });
        
        // Update farmer's financial totals
        if (FHE.decrypt(internalCategory) == 1) { // Income
            totalIncome[msg.sender] = FHE.add(totalIncome[msg.sender], internalAmount);
        } else if (FHE.decrypt(internalCategory) == 2) { // Expense
            totalExpenses[msg.sender] = FHE.add(totalExpenses[msg.sender], internalAmount);
        }
        
        emit TransactionAdded(transactionId, msg.sender, 0); // Category will be decrypted off-chain
        return transactionId;
    }
    
    function createLoan(
        externalEuint32 _principalAmount,
        externalEuint32 _interestRate,
        externalEuint32 _monthlyPayment,
        string memory _loanType,
        uint256 _duration,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_loanType).length > 0, "Loan type cannot be empty");
        require(_duration > 0, "Duration must be positive");
        
        uint256 loanId = loanCounter++;
        
        euint32 internalPrincipal = FHE.fromExternal(_principalAmount, inputProof);
        euint32 internalInterestRate = FHE.fromExternal(_interestRate, inputProof);
        euint32 internalMonthlyPayment = FHE.fromExternal(_monthlyPayment, inputProof);
        
        loans[loanId] = LoanRecord({
            loanId: FHE.asEuint32(0), // Will be set properly later
            principalAmount: internalPrincipal,
            interestRate: internalInterestRate,
            remainingBalance: internalPrincipal,
            monthlyPayment: internalMonthlyPayment,
            isActive: true,
            isPaidOff: false,
            loanType: _loanType,
            farmer: msg.sender,
            lender: lender,
            startDate: block.timestamp,
            endDate: block.timestamp + _duration
        });
        
        // Update farmer's liabilities
        totalLiabilities[msg.sender] = FHE.add(totalLiabilities[msg.sender], internalPrincipal);
        
        emit LoanCreated(loanId, msg.sender, 0); // Amount will be decrypted off-chain
        return loanId;
    }
    
    function makeInvestment(
        externalEuint32 _amount,
        externalEuint32 _expectedReturn,
        externalEuint32 _riskLevel,
        string memory _investmentType,
        string memory _description,
        uint256 _maturityDate,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_investmentType).length > 0, "Investment type cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(_maturityDate > block.timestamp, "Maturity date must be in the future");
        
        uint256 investmentId = investmentCounter++;
        
        euint32 internalAmount = FHE.fromExternal(_amount, inputProof);
        euint32 internalExpectedReturn = FHE.fromExternal(_expectedReturn, inputProof);
        euint32 internalRiskLevel = FHE.fromExternal(_riskLevel, inputProof);
        
        investments[investmentId] = InvestmentRecord({
            investmentId: FHE.asEuint32(0), // Will be set properly later
            amount: internalAmount,
            expectedReturn: internalExpectedReturn,
            actualReturn: FHE.asEuint32(0),
            riskLevel: internalRiskLevel,
            isActive: true,
            isCompleted: false,
            investmentType: _investmentType,
            description: _description,
            farmer: msg.sender,
            startDate: block.timestamp,
            maturityDate: _maturityDate
        });
        
        // Update farmer's assets
        totalAssets[msg.sender] = FHE.add(totalAssets[msg.sender], internalAmount);
        
        emit InvestmentMade(investmentId, msg.sender, 0); // Amount will be decrypted off-chain
        return investmentId;
    }
    
    function generateFinancialReport(
        string memory _period,
        externalEuint32 _totalIncome,
        externalEuint32 _totalExpenses,
        externalEuint32 _totalAssets,
        externalEuint32 _totalLiabilities,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_period).length > 0, "Period cannot be empty");
        
        uint256 reportId = reportCounter++;
        
        euint32 internalTotalIncome = FHE.fromExternal(_totalIncome, inputProof);
        euint32 internalTotalExpenses = FHE.fromExternal(_totalExpenses, inputProof);
        euint32 internalTotalAssets = FHE.fromExternal(_totalAssets, inputProof);
        euint32 internalTotalLiabilities = FHE.fromExternal(_totalLiabilities, inputProof);
        euint32 netProfit = FHE.sub(internalTotalIncome, internalTotalExpenses);
        
        reports[reportId] = FinancialReport({
            reportId: FHE.asEuint32(0), // Will be set properly later
            totalIncome: internalTotalIncome,
            totalExpenses: internalTotalExpenses,
            netProfit: netProfit,
            totalAssets: internalTotalAssets,
            totalLiabilities: internalTotalLiabilities,
            isVerified: false,
            period: _period,
            farmer: msg.sender,
            timestamp: block.timestamp
        });
        
        emit ReportGenerated(reportId, msg.sender, _period);
        return reportId;
    }
    
    function verifyTransaction(uint256 _transactionId, bool _isVerified) public {
        require(msg.sender == verifier, "Only verifier can verify transactions");
        require(transactions[_transactionId].farmer != address(0), "Transaction does not exist");
        
        transactions[_transactionId].isVerified = _isVerified;
        emit TransactionVerified(_transactionId, _isVerified);
    }
    
    function updateCreditScore(address _farmer, euint32 _score) public {
        require(msg.sender == verifier, "Only verifier can update credit score");
        require(_farmer != address(0), "Invalid farmer address");
        
        creditScore[_farmer] = _score;
        emit CreditScoreUpdated(_farmer, 0); // FHE.decrypt(_score) - will be decrypted off-chain
    }
    
    function getTransactionInfo(uint256 _transactionId) public view returns (
        uint8 amount,
        uint8 category,
        uint8 subcategory,
        bool isEncrypted,
        bool isVerified,
        string memory description,
        string memory metadata,
        address farmer,
        uint256 timestamp
    ) {
        FinancialTransaction storage transaction = transactions[_transactionId];
        return (
            0, // FHE.decrypt(transaction.amount) - will be decrypted off-chain
            0, // FHE.decrypt(transaction.category) - will be decrypted off-chain
            0, // FHE.decrypt(transaction.subcategory) - will be decrypted off-chain
            transaction.isEncrypted,
            transaction.isVerified,
            transaction.description,
            transaction.metadata,
            transaction.farmer,
            transaction.timestamp
        );
    }
    
    function getLoanInfo(uint256 _loanId) public view returns (
        uint8 principalAmount,
        uint8 interestRate,
        uint8 remainingBalance,
        uint8 monthlyPayment,
        bool isActive,
        bool isPaidOff,
        string memory loanType,
        address farmer,
        address lender,
        uint256 startDate,
        uint256 endDate
    ) {
        LoanRecord storage loan = loans[_loanId];
        return (
            0, // FHE.decrypt(loan.principalAmount) - will be decrypted off-chain
            0, // FHE.decrypt(loan.interestRate) - will be decrypted off-chain
            0, // FHE.decrypt(loan.remainingBalance) - will be decrypted off-chain
            0, // FHE.decrypt(loan.monthlyPayment) - will be decrypted off-chain
            loan.isActive,
            loan.isPaidOff,
            loan.loanType,
            loan.farmer,
            loan.lender,
            loan.startDate,
            loan.endDate
        );
    }
    
    function getInvestmentInfo(uint256 _investmentId) public view returns (
        uint8 amount,
        uint8 expectedReturn,
        uint8 actualReturn,
        uint8 riskLevel,
        bool isActive,
        bool isCompleted,
        string memory investmentType,
        string memory description,
        address farmer,
        uint256 startDate,
        uint256 maturityDate
    ) {
        InvestmentRecord storage investment = investments[_investmentId];
        return (
            0, // FHE.decrypt(investment.amount) - will be decrypted off-chain
            0, // FHE.decrypt(investment.expectedReturn) - will be decrypted off-chain
            0, // FHE.decrypt(investment.actualReturn) - will be decrypted off-chain
            0, // FHE.decrypt(investment.riskLevel) - will be decrypted off-chain
            investment.isActive,
            investment.isCompleted,
            investment.investmentType,
            investment.description,
            investment.farmer,
            investment.startDate,
            investment.maturityDate
        );
    }
    
    function getFinancialReportInfo(uint256 _reportId) public view returns (
        uint8 totalIncome,
        uint8 totalExpenses,
        uint8 netProfit,
        uint8 totalAssets,
        uint8 totalLiabilities,
        bool isVerified,
        string memory period,
        address farmer,
        uint256 timestamp
    ) {
        FinancialReport storage report = reports[_reportId];
        return (
            0, // FHE.decrypt(report.totalIncome) - will be decrypted off-chain
            0, // FHE.decrypt(report.totalExpenses) - will be decrypted off-chain
            0, // FHE.decrypt(report.netProfit) - will be decrypted off-chain
            0, // FHE.decrypt(report.totalAssets) - will be decrypted off-chain
            0, // FHE.decrypt(report.totalLiabilities) - will be decrypted off-chain
            report.isVerified,
            report.period,
            report.farmer,
            report.timestamp
        );
    }
    
    function getFarmerFinancialStats(address _farmer) public view returns (
        uint8 totalIncome,
        uint8 totalExpenses,
        uint8 totalAssets,
        uint8 totalLiabilities,
        uint8 creditScore
    ) {
        return (
            0, // FHE.decrypt(totalIncome[_farmer]) - will be decrypted off-chain
            0, // FHE.decrypt(totalExpenses[_farmer]) - will be decrypted off-chain
            0, // FHE.decrypt(totalAssets[_farmer]) - will be decrypted off-chain
            0, // FHE.decrypt(totalLiabilities[_farmer]) - will be decrypted off-chain
            0  // FHE.decrypt(creditScore[_farmer]) - will be decrypted off-chain
        );
    }
}
