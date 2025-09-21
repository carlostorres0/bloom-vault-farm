import FarmHeader from "@/components/FarmHeader";
import FarmFooter from "@/components/FarmFooter";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { DollarSign, TrendingUp, Shield, Clock, CheckCircle, AlertCircle } from "lucide-react";

const Finance = () => {
  const loanApplications = [
    {
      id: "LOAN-001",
      amount: "$50,000",
      purpose: "Seed & Equipment",
      status: "approved",
      apr: "4.5%",
      term: "12 months"
    },
    {
      id: "LOAN-002", 
      amount: "$75,000",
      purpose: "Irrigation System",
      status: "pending",
      apr: "4.2%",
      term: "18 months"
    },
    {
      id: "LOAN-003",
      amount: "$25,000", 
      purpose: "Fertilizer & Pesticides",
      status: "processing",
      apr: "4.8%",
      term: "6 months"
    }
  ];

  const creditMetrics = [
    {
      title: "Available Credit",
      value: "$245,000",
      icon: DollarSign,
      trend: "+15% this quarter",
      color: "text-accent"
    },
    {
      title: "Credit Score",
      value: "847",
      icon: TrendingUp,
      trend: "Excellent rating",
      color: "text-farm-crop"
    },
    {
      title: "Active Loans",
      value: "3",
      icon: Shield,
      trend: "On-time payments",
      color: "text-primary"
    }
  ];

  const getStatusIcon = (status: string) => {
    switch (status) {
      case "approved":
        return <CheckCircle className="h-4 w-4 text-farm-crop" />;
      case "pending":
        return <Clock className="h-4 w-4 text-farm-wheat" />;
      case "processing":
        return <AlertCircle className="h-4 w-4 text-farm-sky" />;
      default:
        return <Clock className="h-4 w-4" />;
    }
  };

  const getStatusColor = (status: string) => {
    switch (status) {
      case "approved":
        return "bg-farm-crop/10 text-farm-crop border-farm-crop/20";
      case "pending":
        return "bg-farm-wheat/10 text-farm-wheat border-farm-wheat/20";
      case "processing":
        return "bg-farm-sky/10 text-farm-sky border-farm-sky/20";
      default:
        return "bg-muted text-muted-foreground";
    }
  };

  return (
    <div className="min-h-screen bg-background">
      <FarmHeader />
      <main className="container mx-auto px-4 py-12">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-foreground mb-2">Agricultural Finance</h1>
          <p className="text-muted-foreground">Secure loans based on confidential yield predictions</p>
        </div>

        {/* Credit Metrics */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          {creditMetrics.map((metric, index) => (
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

        {/* Loan Applications */}
        <div className="mb-8">
          <div className="flex items-center justify-between mb-6">
            <h2 className="text-2xl font-bold text-foreground">Loan Applications</h2>
            <Button className="bg-primary hover:bg-primary-glow">
              <DollarSign className="h-4 w-4 mr-2" />
              Apply for New Loan
            </Button>
          </div>

          <div className="grid gap-4">
            {loanApplications.map((loan) => (
              <Card key={loan.id} className="farm-card">
                <CardContent className="pt-6">
                  <div className="flex items-center justify-between">
                    <div className="space-y-2">
                      <div className="flex items-center gap-3">
                        <h3 className="font-semibold text-foreground">{loan.id}</h3>
                        <Badge className={getStatusColor(loan.status)}>
                          {getStatusIcon(loan.status)}
                          <span className="ml-1 capitalize">{loan.status}</span>
                        </Badge>
                      </div>
                      <p className="text-sm text-muted-foreground">{loan.purpose}</p>
                      <div className="flex gap-4 text-sm">
                        <span className="text-muted-foreground">Amount: <span className="font-medium text-foreground">{loan.amount}</span></span>
                        <span className="text-muted-foreground">APR: <span className="font-medium text-foreground">{loan.apr}</span></span>
                        <span className="text-muted-foreground">Term: <span className="font-medium text-foreground">{loan.term}</span></span>
                      </div>
                    </div>
                    <Button variant="outline" size="sm">
                      View Details
                    </Button>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Privacy Notice */}
        <Card className="yield-prediction border-accent/20">
          <CardContent className="pt-6">
            <div className="text-center space-y-2">
              <h3 className="font-semibold text-foreground">Confidential Credit Assessment</h3>
              <p className="text-sm text-muted-foreground">
                Your yield predictions remain encrypted during the loan approval process. Credit decisions are made using zero-knowledge proofs to protect your agricultural data from competitors.
              </p>
            </div>
          </CardContent>
        </Card>
      </main>
      <FarmFooter />
    </div>
  );
};

export default Finance;