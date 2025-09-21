import FarmHeader from "@/components/FarmHeader";
import FarmFooter from "@/components/FarmFooter";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { TrendingUp, BarChart3, PieChart, Activity } from "lucide-react";

const Analytics = () => {
  const analyticsData = [
    {
      title: "Yield Accuracy",
      value: "94.2%",
      icon: TrendingUp,
      trend: "+2.1% vs last season",
      color: "text-farm-crop"
    },
    {
      title: "Oracle Verifications",
      value: "1,247",
      icon: Activity,
      trend: "This month",
      color: "text-primary"
    },
    {
      title: "Data Points",
      value: "15.6K",
      icon: BarChart3,
      trend: "Processed securely",
      color: "text-farm-sky"
    },
    {
      title: "Prediction Confidence",
      value: "89.7%",
      icon: PieChart,
      trend: "Average across fields",
      color: "text-accent"
    }
  ];

  const fieldPerformance = [
    { field: "North Field A", crop: "🌽 Corn", predicted: 12.4, actual: 12.1, accuracy: 97.6 },
    { field: "East Field B", crop: "🌾 Wheat", predicted: 8.7, actual: 8.9, accuracy: 97.7 },
    { field: "South Field C", crop: "🥔 Potatoes", predicted: 15.2, actual: 14.8, accuracy: 97.4 },
    { field: "West Field D", crop: "🌻 Sunflower", predicted: 3.8, actual: 3.6, accuracy: 94.7 }
  ];

  const monthlyTrends = [
    { month: "Jan", predictions: 45, verifications: 42, accuracy: 93.3 },
    { month: "Feb", predictions: 52, verifications: 50, accuracy: 96.2 },
    { month: "Mar", predictions: 61, verifications: 58, accuracy: 95.1 },
    { month: "Apr", predictions: 58, verifications: 55, accuracy: 94.8 },
    { month: "May", predictions: 67, verifications: 64, accuracy: 95.5 },
    { month: "Jun", predictions: 71, verifications: 69, accuracy: 97.2 }
  ];

  return (
    <div className="min-h-screen bg-background">
      <FarmHeader />
      <main className="container mx-auto px-4 py-12">
        <div className="mb-8">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h1 className="text-3xl font-bold text-foreground mb-2">Analytics Dashboard</h1>
              <p className="text-muted-foreground">Performance insights and prediction analytics</p>
            </div>
            <Badge variant="outline" className="bg-gradient-field">
              Real-time Analytics
            </Badge>
          </div>
        </div>

        {/* Key Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          {analyticsData.map((metric, index) => (
            <Card key={index} className="farm-card">
              <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                <CardTitle className="text-sm font-medium text-muted-foreground">
                  {metric.title}
                </CardTitle>
                <metric.icon className={`h-4 w-4 ${metric.color}`} />
              </CardHeader>
              <CardContent>
                <div className="text-2xl font-bold text-foreground">{metric.value}</div>
                <p className="text-xs text-muted-foreground mt-1">{metric.trend}</p>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Field Performance */}
        <Card className="farm-card mb-8">
          <CardHeader>
            <CardTitle className="text-foreground">Field Performance Analysis</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="border-b border-border">
                    <th className="text-left py-2 text-sm font-medium text-muted-foreground">Field</th>
                    <th className="text-left py-2 text-sm font-medium text-muted-foreground">Crop</th>
                    <th className="text-right py-2 text-sm font-medium text-muted-foreground">Predicted (tons/ha)</th>
                    <th className="text-right py-2 text-sm font-medium text-muted-foreground">Actual (tons/ha)</th>
                    <th className="text-right py-2 text-sm font-medium text-muted-foreground">Accuracy</th>
                  </tr>
                </thead>
                <tbody>
                  {fieldPerformance.map((field, index) => (
                    <tr key={index} className="border-b border-border/50">
                      <td className="py-3 text-sm font-medium text-foreground">{field.field}</td>
                      <td className="py-3 text-sm text-foreground">{field.crop}</td>
                      <td className="py-3 text-sm text-right text-foreground">{field.predicted}</td>
                      <td className="py-3 text-sm text-right text-foreground">{field.actual}</td>
                      <td className="py-3 text-sm text-right">
                        <Badge variant="outline" className={field.accuracy > 96 ? "text-farm-crop border-farm-crop/20" : "text-farm-wheat border-farm-wheat/20"}>
                          {field.accuracy}%
                        </Badge>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </CardContent>
        </Card>

        {/* Monthly Trends */}
        <Card className="farm-card">
          <CardHeader>
            <CardTitle className="text-foreground">Monthly Prediction Trends</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
              {monthlyTrends.map((month, index) => (
                <div key={index} className="text-center p-4 rounded-lg bg-card/50 border border-border/50">
                  <div className="text-lg font-bold text-foreground">{month.month}</div>
                  <div className="text-sm text-muted-foreground mt-1">
                    {month.predictions} predictions
                  </div>
                  <div className="text-sm text-muted-foreground">
                    {month.verifications} verified
                  </div>
                  <div className="mt-2">
                    <Badge variant="outline" className="text-xs">
                      {month.accuracy}%
                    </Badge>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </main>
      <FarmFooter />
    </div>
  );
};

export default Analytics;