import FarmHeader from "@/components/FarmHeader";
import FarmFooter from "@/components/FarmFooter";
import FarmDashboard from "@/components/FarmDashboard";

const Dashboard = () => {
  return (
    <div className="min-h-screen bg-background">
      <FarmHeader />
      <main className="container mx-auto px-4 py-12">
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-foreground mb-2">Farm Dashboard</h1>
          <p className="text-muted-foreground">Monitor your farm operations and key metrics</p>
        </div>
        <FarmDashboard />
      </main>
      <FarmFooter />
    </div>
  );
};

export default Dashboard;