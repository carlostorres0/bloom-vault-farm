// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { SepoliaConfig } from "@fhevm/solidity/config/ZamaConfig.sol";
import { euint32, externalEuint32, euint8, ebool, FHE } from "@fhevm/solidity/lib/FHE.sol";

contract YieldPrediction is SepoliaConfig {
    using FHE for *;
    
    struct PredictionModel {
        euint32 modelId;
        euint32 accuracy;
        euint32 version;
        bool isActive;
        string modelName;
        string algorithm;
        address creator;
        uint256 timestamp;
    }
    
    struct PredictionData {
        euint32 dataId;
        euint32 cropType;
        euint32 soilQuality;
        euint32 weatherScore;
        euint32 irrigationLevel;
        euint32 fertilizerAmount;
        euint32 predictedYield;
        euint32 confidence;
        bool isVerified;
        string metadata;
        address farmer;
        uint256 timestamp;
    }
    
    struct PredictionResult {
        euint32 resultId;
        euint32 actualYield;
        euint32 predictedYield;
        euint32 accuracy;
        bool isCompleted;
        string notes;
        address farmer;
        uint256 timestamp;
    }
    
    mapping(uint256 => PredictionModel) public predictionModels;
    mapping(uint256 => PredictionData) public predictionData;
    mapping(uint256 => PredictionResult) public predictionResults;
    mapping(address => euint32) public farmerPredictionAccuracy;
    mapping(address => euint32) public totalPredictions;
    
    uint256 public modelCounter;
    uint256 public dataCounter;
    uint256 public resultCounter;
    
    address public owner;
    address public verifier;
    
    event PredictionModelCreated(uint256 indexed modelId, address indexed creator, string modelName);
    event PredictionDataAdded(uint256 indexed dataId, address indexed farmer, uint32 cropType);
    event PredictionResultAdded(uint256 indexed resultId, address indexed farmer, uint32 accuracy);
    event ModelVerified(uint256 indexed modelId, bool isVerified);
    event AccuracyUpdated(address indexed farmer, uint32 accuracy);
    
    constructor(address _verifier) {
        owner = msg.sender;
        verifier = _verifier;
    }
    
    function createPredictionModel(
        string memory _modelName,
        string memory _algorithm,
        externalEuint32 _accuracy,
        externalEuint32 _version,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_modelName).length > 0, "Model name cannot be empty");
        require(bytes(_algorithm).length > 0, "Algorithm cannot be empty");
        
        uint256 modelId = modelCounter++;
        
        euint32 internalAccuracy = FHE.fromExternal(_accuracy, inputProof);
        euint32 internalVersion = FHE.fromExternal(_version, inputProof);
        
        predictionModels[modelId] = PredictionModel({
            modelId: FHE.asEuint32(0), // Will be set properly later
            accuracy: internalAccuracy,
            version: internalVersion,
            isActive: true,
            modelName: _modelName,
            algorithm: _algorithm,
            creator: msg.sender,
            timestamp: block.timestamp
        });
        
        emit PredictionModelCreated(modelId, msg.sender, _modelName);
        return modelId;
    }
    
    function addPredictionData(
        externalEuint32 _cropType,
        externalEuint32 _soilQuality,
        externalEuint32 _weatherScore,
        externalEuint32 _irrigationLevel,
        externalEuint32 _fertilizerAmount,
        externalEuint32 _predictedYield,
        externalEuint32 _confidence,
        string memory _metadata,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(bytes(_metadata).length > 0, "Metadata cannot be empty");
        
        uint256 dataId = dataCounter++;
        
        euint32 internalCropType = FHE.fromExternal(_cropType, inputProof);
        euint32 internalSoilQuality = FHE.fromExternal(_soilQuality, inputProof);
        euint32 internalWeatherScore = FHE.fromExternal(_weatherScore, inputProof);
        euint32 internalIrrigationLevel = FHE.fromExternal(_irrigationLevel, inputProof);
        euint32 internalFertilizerAmount = FHE.fromExternal(_fertilizerAmount, inputProof);
        euint32 internalPredictedYield = FHE.fromExternal(_predictedYield, inputProof);
        euint32 internalConfidence = FHE.fromExternal(_confidence, inputProof);
        
        predictionData[dataId] = PredictionData({
            dataId: FHE.asEuint32(0), // Will be set properly later
            cropType: internalCropType,
            soilQuality: internalSoilQuality,
            weatherScore: internalWeatherScore,
            irrigationLevel: internalIrrigationLevel,
            fertilizerAmount: internalFertilizerAmount,
            predictedYield: internalPredictedYield,
            confidence: internalConfidence,
            isVerified: false,
            metadata: _metadata,
            farmer: msg.sender,
            timestamp: block.timestamp
        });
        
        // Update farmer's total predictions
        totalPredictions[msg.sender] = FHE.add(totalPredictions[msg.sender], FHE.asEuint32(1));
        
        emit PredictionDataAdded(dataId, msg.sender, 0); // Crop type will be decrypted off-chain
        return dataId;
    }
    
    function addPredictionResult(
        uint256 _dataId,
        externalEuint32 _actualYield,
        string memory _notes,
        bytes calldata inputProof
    ) public returns (uint256) {
        require(predictionData[_dataId].farmer == msg.sender, "Only farmer can add result");
        require(predictionData[_dataId].isVerified, "Prediction data must be verified");
        
        uint256 resultId = resultCounter++;
        
        euint32 internalActualYield = FHE.fromExternal(_actualYield, inputProof);
        euint32 predictedYield = predictionData[_dataId].predictedYield;
        
        // Calculate accuracy: |actual - predicted| / predicted * 100
        euint32 accuracy = FHE.div(
            FHE.mul(
                FHE.sub(internalActualYield, predictedYield),
                FHE.asEuint32(100)
            ),
            predictedYield
        );
        
        predictionResults[resultId] = PredictionResult({
            resultId: FHE.asEuint32(0), // Will be set properly later
            actualYield: internalActualYield,
            predictedYield: predictedYield,
            accuracy: accuracy,
            isCompleted: true,
            notes: _notes,
            farmer: msg.sender,
            timestamp: block.timestamp
        });
        
        // Update farmer's prediction accuracy
        farmerPredictionAccuracy[msg.sender] = FHE.add(
            farmerPredictionAccuracy[msg.sender],
            accuracy
        );
        
        emit PredictionResultAdded(resultId, msg.sender, 0); // Accuracy will be decrypted off-chain
        return resultId;
    }
    
    function verifyPredictionData(uint256 _dataId, bool _isVerified) public {
        require(msg.sender == verifier, "Only verifier can verify data");
        require(predictionData[_dataId].farmer != address(0), "Data does not exist");
        
        predictionData[_dataId].isVerified = _isVerified;
    }
    
    function verifyModel(uint256 _modelId, bool _isVerified) public {
        require(msg.sender == verifier, "Only verifier can verify models");
        require(predictionModels[_modelId].creator != address(0), "Model does not exist");
        
        predictionModels[_modelId].isActive = _isVerified;
        emit ModelVerified(_modelId, _isVerified);
    }
    
    function updateFarmerAccuracy(address _farmer, euint32 _accuracy) public {
        require(msg.sender == verifier, "Only verifier can update accuracy");
        require(_farmer != address(0), "Invalid farmer address");
        
        farmerPredictionAccuracy[_farmer] = _accuracy;
        emit AccuracyUpdated(_farmer, 0); // FHE.decrypt(_accuracy) - will be decrypted off-chain
    }
    
    function getPredictionModelInfo(uint256 _modelId) public view returns (
        string memory modelName,
        string memory algorithm,
        uint8 accuracy,
        uint8 version,
        bool isActive,
        address creator,
        uint256 timestamp
    ) {
        PredictionModel storage model = predictionModels[_modelId];
        return (
            model.modelName,
            model.algorithm,
            0, // FHE.decrypt(model.accuracy) - will be decrypted off-chain
            0, // FHE.decrypt(model.version) - will be decrypted off-chain
            model.isActive,
            model.creator,
            model.timestamp
        );
    }
    
    function getPredictionDataInfo(uint256 _dataId) public view returns (
        uint8 cropType,
        uint8 soilQuality,
        uint8 weatherScore,
        uint8 irrigationLevel,
        uint8 fertilizerAmount,
        uint8 predictedYield,
        uint8 confidence,
        bool isVerified,
        string memory metadata,
        address farmer,
        uint256 timestamp
    ) {
        PredictionData storage data = predictionData[_dataId];
        return (
            0, // FHE.decrypt(data.cropType) - will be decrypted off-chain
            0, // FHE.decrypt(data.soilQuality) - will be decrypted off-chain
            0, // FHE.decrypt(data.weatherScore) - will be decrypted off-chain
            0, // FHE.decrypt(data.irrigationLevel) - will be decrypted off-chain
            0, // FHE.decrypt(data.fertilizerAmount) - will be decrypted off-chain
            0, // FHE.decrypt(data.predictedYield) - will be decrypted off-chain
            0, // FHE.decrypt(data.confidence) - will be decrypted off-chain
            data.isVerified,
            data.metadata,
            data.farmer,
            data.timestamp
        );
    }
    
    function getPredictionResultInfo(uint256 _resultId) public view returns (
        uint8 actualYield,
        uint8 predictedYield,
        uint8 accuracy,
        bool isCompleted,
        string memory notes,
        address farmer,
        uint256 timestamp
    ) {
        PredictionResult storage result = predictionResults[_resultId];
        return (
            0, // FHE.decrypt(result.actualYield) - will be decrypted off-chain
            0, // FHE.decrypt(result.predictedYield) - will be decrypted off-chain
            0, // FHE.decrypt(result.accuracy) - will be decrypted off-chain
            result.isCompleted,
            result.notes,
            result.farmer,
            result.timestamp
        );
    }
    
    function getFarmerPredictionStats(address _farmer) public view returns (
        uint8 accuracy,
        uint8 totalPredictions
    ) {
        return (
            0, // FHE.decrypt(farmerPredictionAccuracy[_farmer]) - will be decrypted off-chain
            0  // FHE.decrypt(totalPredictions[_farmer]) - will be decrypted off-chain
        );
    }
}
