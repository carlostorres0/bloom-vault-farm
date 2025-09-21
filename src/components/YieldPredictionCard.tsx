import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Eye, EyeOff, Shield, TrendingUp } from "lucide-react";
import { useState } from "react";

interface YieldPredictionCardProps {
  cropType: string;
  field: string;
  predictedYield: number;
  confidence: number;
  isEncrypted: boolean;
  status: "pending" | "verified" | "processing";
}

const YieldPredictionCard = ({ 
  cropType, 
  field, 
  predictedYield, 
  confidence, 
  isEncrypted, 
  status 
}: YieldPredictionCardProps) => {
  const [showData, setShowData] = useState(!isEncrypted);

  const getStatusColor = (status: string) => {
    switch (status) {
      case "verified": return "bg-primary text-primary-foreground";
      case "processing": return "bg-accent text-accent-foreground";
      default: return "bg-muted text-muted-foreground";
    }
  };

  const formatYield = (yieldValue: number) => {
    return showData ? `${yieldValue.toFixed(1)} tons/hectare` : "••• tons/hectare";
  };

  const formatConfidence = (confidence: number) => {
    return showData ? `${confidence}%` : "••%";
  };

  return (
    <Card className="farm-card hover:shadow-lg transition-all duration-300">
      <CardHeader className="pb-3">
        <div className="flex items-center justify-between">
          <CardTitle className="text-lg flex items-center gap-2">
            <div className="crop-sway">{cropType}</div>
            {isEncrypted && <Shield className="h-4 w-4 text-accent" />}
          </CardTitle>
          <Badge className={getStatusColor(status)}>
            {status}
          </Badge>
        </div>
        <p className="text-sm text-muted-foreground">{field}</p>
      </CardHeader>
      
      <CardContent className="space-y-4">
        <div className={`relative ${!showData && isEncrypted ? 'encrypted-data' : ''}`}>
          <div className="grid grid-cols-2 gap-4">
            <div>
              <p className="text-sm text-muted-foreground">Predicted Yield</p>
              <p className="text-2xl font-bold text-primary flex items-center gap-1">
                {formatYield(predictedYield)}
                <TrendingUp className="h-4 w-4" />
              </p>
            </div>
            <div>
              <p className="text-sm text-muted-foreground">Confidence</p>
              <p className="text-2xl font-bold text-foreground">
                {formatConfidence(confidence)}
              </p>
            </div>
          </div>
          
          {!showData && isEncrypted && (
            <div className="absolute inset-0 encrypted-overlay rounded flex items-center justify-center">
              <div className="bg-card/90 backdrop-blur-sm rounded-lg p-3 text-center">
                <Shield className="h-6 w-6 mx-auto mb-2 text-accent" />
                <p className="text-xs text-muted-foreground">Encrypted until verified</p>
              </div>
            </div>
          )}
        </div>

        {isEncrypted && (
          <Button 
            variant="outline" 
            size="sm" 
            onClick={() => setShowData(!showData)}
            className="w-full"
          >
            {showData ? (
              <>
                <EyeOff className="h-4 w-4 mr-2" />
                Hide Data
              </>
            ) : (
              <>
                <Eye className="h-4 w-4 mr-2" />
                Decrypt Preview
              </>
            )}
          </Button>
        )}
      </CardContent>
    </Card>
  );
};

export default YieldPredictionCard;