import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Sprout, DollarSign, CloudRain, Thermometer } from "lucide-react";
import YieldPredictionCard from "./YieldPredictionCard";

const FarmDashboard = () => {
  const farmStats = [
    {
      title: "Total Fields",
      value: "12",
      icon: Sprout,
      trend: "+2 this season",
      color: "text-farm-crop"
    },
    {
      title: "Available Credit",
      value: "$245K",
      icon: DollarSign,
      trend: "Based on predictions",
      color: "text-accent"
    },
    {
      title: "Avg Rainfall",
      value: "24mm",
      icon: CloudRain,
      trend: "This week",
      color: "text-farm-sky"
    },
    {
      title: "Temperature",
      value: "22°C",
      icon: Thermometer,
      trend: "Optimal range",
      color: "text-farm-wheat"
    }
  ];

  const yieldPredictions = [
    {
      cropType: "🌽 Corn",
      field: "North Field A",
      predictedYield: 12.4,
      confidence: 94,
      isEncrypted: false,
      status: "verified" as const
    },
    {
      cropType: "🌾 Wheat",
      field: "East Field B",
      predictedYield: 8.7,
      confidence: 89,
      isEncrypted: true,
      status: "processing" as const
    },
    {
      cropType: "🥔 Potatoes",
      field: "South Field C",
      predictedYield: 15.2,
      confidence: 92,
      isEncrypted: true,
      status: "pending" as const
    },
    {
      cropType: "🌻 Sunflower",
      field: "West Field D",
      predictedYield: 3.8,
      confidence: 87,
      isEncrypted: false,
      status: "verified" as const
    }
  ];

  return (
    <div className="space-y-8">
      {/* Farm Statistics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {farmStats.map((stat, index) => (
          <Card key={index} className="farm-card">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium text-muted-foreground">
                {stat.title}
              </CardTitle>
              <stat.icon className={`h-4 w-4 ${stat.color}`} />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold text-foreground">{stat.value}</div>
              <p className="text-xs text-muted-foreground mt-1">{stat.trend}</p>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Yield Predictions */}
      <div>
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-2xl font-bold text-foreground">Yield Predictions</h2>
          <Badge variant="outline" className="bg-gradient-field">
            Oracle Network Active
          </Badge>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
          {yieldPredictions.map((prediction, index) => (
            <YieldPredictionCard key={index} {...prediction} />
          ))}
        </div>
      </div>

      {/* Privacy Notice */}
      <Card className="yield-prediction border-accent/20">
        <CardContent className="pt-6">
          <div className="text-center space-y-2">
            <h3 className="font-semibold text-foreground">Confidential Computing Active</h3>
            <p className="text-sm text-muted-foreground">
              Your crop data is encrypted and processed securely. Predictions are verified by our oracle network before being revealed to prevent market speculation.
            </p>
          </div>
        </CardContent>
      </Card>
    </div>
  );
};

export default FarmDashboard;