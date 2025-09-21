import FarmHeader from "@/components/FarmHeader";
import FarmFooter from "@/components/FarmFooter";
import YieldPredictionCard from "@/components/YieldPredictionCard";
import { Badge } from "@/components/ui/badge";

const YieldPredictions = () => {
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
    },
    {
      cropType: "🍅 Tomatoes",
      field: "Central Field E",
      predictedYield: 18.6,
      confidence: 91,
      isEncrypted: true,
      status: "processing" as const
    },
    {
      cropType: "🫐 Blueberries",
      field: "North Field F",
      predictedYield: 5.2,
      confidence: 88,
      isEncrypted: false,
      status: "verified" as const
    }
  ];

  return (
    <div className="min-h-screen bg-background">
      <FarmHeader />
      <main className="container mx-auto px-4 py-12">
        <div className="mb-8">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className="text-3xl font-bold text-foreground mb-2">Yield Predictions</h1>
              <p className="text-muted-foreground">AI-powered crop yield forecasting with oracle verification</p>
            </div>
            <Badge variant="outline" className="bg-gradient-field">
              Oracle Network Active
            </Badge>
          </div>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {yieldPredictions.map((prediction, index) => (
            <YieldPredictionCard key={index} {...prediction} />
          ))}
        </div>
      </main>
      <FarmFooter />
    </div>
  );
};

export default YieldPredictions;