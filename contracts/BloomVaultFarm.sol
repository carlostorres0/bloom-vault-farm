// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { SepoliaConfig } from "@fhevm/solidity/config/ZamaConfig.sol";
import { euint32, externalEuint32, euint8, ebool, FHE } from "@fhevm/solidity/lib/FHE.sol";

contract BloomVaultFarm is SepoliaConfig {
    using FHE for *;
    
    struct FarmOperation {
        euint32 operationId;
        euint32 cropType;
        euint32 area;
        euint32 expectedYield;
        euint32 actualYield;
        euint32 cost;
        euint32 revenue;
        bool isActive;
        bool isVerified;
        string description;
        address farmer;
        uint256 timestamp;
    }
    
    struct FinancialRecord {
        euint32 recordId;
        euint32 amount;
        euint32 category; // 1: Income, 2: Expense, 3: Investment
        bool isEncrypted;
        string description;
        address owner;
        uint256 timestamp;
    }
    
    struct YieldPrediction {
        euint32 predictionId;
        euint32 cropType;
        euint32 area;
        euint32 predictedYield;
        euint32 confidence;
        bool isActive;
        string modelVersion;
        address farmer;
        uint256 timestamp;
    }
    
    mapping(uint256 => FarmOperation) public farmOperations;
    mapping(uint256 => FinancialRecord) public financialRecords;
    mapping(uint256 => YieldPrediction) public yieldPredictions;
    mapping(address => euint32) public farmerReputation;
    mapping(address => euint32) public totalEarnings;
    mapping(address => euint32) public totalExpenses;
    
    uint256 public operationCounter;
    uint256 public financialCounter;
    uint256 public predictionCounter;
    
    address public owner;
    address public verifier;
    
    event FarmOperationCreated(uint256 indexed operationId, address indexed farmer, string description);
    event FinancialRecordAdded(uint256 indexed recordId, address indexed owner, uint32 category);
    event YieldPredictionCreated(uint256 indexed predictionId, address indexed farmer, uint32 cropType);
    event OperationVerified(uint256 indexed operationId, bool isVerified);
    event ReputationUpdated(address indexed farmer, uint32 reputation);
    
    constructor(address _verifier) {
        owner = msg.sender;
        verifier = _verifier;
    }
    
    function createFarmOperation(
        string memory _description,
        externalEuint32 _cropType,
        externalEuint32 _area,
        externalEuint32 _expectedYield,
        externalEuint32 _cost,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_description).length > 0, "Description cannot be empty");
        
        uint256 operationId = operationCounter++;
        
        // Convert external values to internal encrypted values
        euint32 internalCropType = FHE.fromExternal(_cropType, inputProof);
        euint32 internalArea = FHE.fromExternal(_area, inputProof);
        euint32 internalExpectedYield = FHE.fromExternal(_expectedYield, inputProof);
        euint32 internalCost = FHE.fromExternal(_cost, inputProof);
        
        farmOperations[operationId] = FarmOperation({
            operationId: FHE.asEuint32(0), // Will be set properly later
            cropType: internalCropType,
            area: internalArea,
            expectedYield: internalExpectedYield,
            actualYield: FHE.asEuint32(0),
            cost: internalCost,
            revenue: FHE.asEuint32(0),
            isActive: true,
            isVerified: false,
            description: _description,
            farmer: msg.sender,
            timestamp: block.timestamp
        });
        
        emit FarmOperationCreated(operationId, msg.sender, _description);
        return operationId;
    }
    
    function updateFarmOperation(
        uint256 _operationId,
        externalEuint32 _actualYield,
        externalEuint32 _revenue,
        bytes calldata inputProof
    ) public {
        require(farmOperations[_operationId].farmer == msg.sender, "Only farmer can update");
        require(farmOperations[_operationId].isActive, "Operation must be active");
        
        euint32 internalActualYield = FHE.fromExternal(_actualYield, inputProof);
        euint32 internalRevenue = FHE.fromExternal(_revenue, inputProof);
        
        farmOperations[_operationId].actualYield = internalActualYield;
        farmOperations[_operationId].revenue = internalRevenue;
    }
    
    function addFinancialRecord(
        string memory _description,
        externalEuint32 _amount,
        externalEuint32 _category,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_description).length > 0, "Description cannot be empty");
        
        uint256 recordId = financialCounter++;
        
        euint32 internalAmount = FHE.fromExternal(_amount, inputProof);
        euint32 internalCategory = FHE.fromExternal(_category, inputProof);
        
        financialRecords[recordId] = FinancialRecord({
            recordId: FHE.asEuint32(0), // Will be set properly later
            amount: internalAmount,
            category: internalCategory,
            isEncrypted: true,
            description: _description,
            owner: msg.sender,
            timestamp: block.timestamp
        });
        
        // Update farmer's financial totals
        if (FHE.decrypt(internalCategory) == 1) { // Income
            totalEarnings[msg.sender] = FHE.add(totalEarnings[msg.sender], internalAmount);
        } else if (FHE.decrypt(internalCategory) == 2) { // Expense
            totalExpenses[msg.sender] = FHE.add(totalExpenses[msg.sender], internalAmount);
        }
        
        emit FinancialRecordAdded(recordId, msg.sender, 0); // Category will be decrypted off-chain
        return recordId;
    }
    
    function createYieldPrediction(
        externalEuint32 _cropType,
        externalEuint32 _area,
        externalEuint32 _predictedYield,
        externalEuint32 _confidence,
        string memory _modelVersion,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_modelVersion).length > 0, "Model version cannot be empty");
        
        uint256 predictionId = predictionCounter++;
        
        euint32 internalCropType = FHE.fromExternal(_cropType, inputProof);
        euint32 internalArea = FHE.fromExternal(_area, inputProof);
        euint32 internalPredictedYield = FHE.fromExternal(_predictedYield, inputProof);
        euint32 internalConfidence = FHE.fromExternal(_confidence, inputProof);
        
        yieldPredictions[predictionId] = YieldPrediction({
            predictionId: FHE.asEuint32(0), // Will be set properly later
            cropType: internalCropType,
            area: internalArea,
            predictedYield: internalPredictedYield,
            confidence: internalConfidence,
            isActive: true,
            modelVersion: _modelVersion,
            farmer: msg.sender,
            timestamp: block.timestamp
        });
        
        emit YieldPredictionCreated(predictionId, msg.sender, 0); // Crop type will be decrypted off-chain
        return predictionId;
    }
    
    function verifyOperation(uint256 _operationId, bool _isVerified) public {
        require(msg.sender == verifier, "Only verifier can verify operations");
        require(farmOperations[_operationId].farmer != address(0), "Operation does not exist");
        
        farmOperations[_operationId].isVerified = _isVerified;
        emit OperationVerified(_operationId, _isVerified);
    }
    
    function updateFarmerReputation(address _farmer, euint32 _reputation) public {
        require(msg.sender == verifier, "Only verifier can update reputation");
        require(_farmer != address(0), "Invalid farmer address");
        
        farmerReputation[_farmer] = _reputation;
        emit ReputationUpdated(_farmer, 0); // FHE.decrypt(_reputation) - will be decrypted off-chain
    }
    
    function getFarmOperationInfo(uint256 _operationId) public view returns (
        string memory description,
        uint8 cropType,
        uint8 area,
        uint8 expectedYield,
        uint8 actualYield,
        uint8 cost,
        uint8 revenue,
        bool isActive,
        bool isVerified,
        address farmer,
        uint256 timestamp
    ) {
        FarmOperation storage operation = farmOperations[_operationId];
        return (
            operation.description,
            0, // FHE.decrypt(operation.cropType) - will be decrypted off-chain
            0, // FHE.decrypt(operation.area) - will be decrypted off-chain
            0, // FHE.decrypt(operation.expectedYield) - will be decrypted off-chain
            0, // FHE.decrypt(operation.actualYield) - will be decrypted off-chain
            0, // FHE.decrypt(operation.cost) - will be decrypted off-chain
            0, // FHE.decrypt(operation.revenue) - will be decrypted off-chain
            operation.isActive,
            operation.isVerified,
            operation.farmer,
            operation.timestamp
        );
    }
    
    function getFinancialRecordInfo(uint256 _recordId) public view returns (
        uint8 amount,
        uint8 category,
        bool isEncrypted,
        string memory description,
        address owner,
        uint256 timestamp
    ) {
        FinancialRecord storage record = financialRecords[_recordId];
        return (
            0, // FHE.decrypt(record.amount) - will be decrypted off-chain
            0, // FHE.decrypt(record.category) - will be decrypted off-chain
            record.isEncrypted,
            record.description,
            record.owner,
            record.timestamp
        );
    }
    
    function getYieldPredictionInfo(uint256 _predictionId) public view returns (
        uint8 cropType,
        uint8 area,
        uint8 predictedYield,
        uint8 confidence,
        bool isActive,
        string memory modelVersion,
        address farmer,
        uint256 timestamp
    ) {
        YieldPrediction storage prediction = yieldPredictions[_predictionId];
        return (
            0, // FHE.decrypt(prediction.cropType) - will be decrypted off-chain
            0, // FHE.decrypt(prediction.area) - will be decrypted off-chain
            0, // FHE.decrypt(prediction.predictedYield) - will be decrypted off-chain
            0, // FHE.decrypt(prediction.confidence) - will be decrypted off-chain
            prediction.isActive,
            prediction.modelVersion,
            prediction.farmer,
            prediction.timestamp
        );
    }
    
    function getFarmerStats(address _farmer) public view returns (
        uint8 reputation,
        uint8 totalEarnings,
        uint8 totalExpenses
    ) {
        return (
            0, // FHE.decrypt(farmerReputation[_farmer]) - will be decrypted off-chain
            0, // FHE.decrypt(totalEarnings[_farmer]) - will be decrypted off-chain
            0  // FHE.decrypt(totalExpenses[_farmer]) - will be decrypted off-chain
        );
    }
}
