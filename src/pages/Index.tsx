import FarmHeader from "@/components/FarmHeader";
import FarmHero from "@/components/FarmHero";
import FarmFooter from "@/components/FarmFooter";

const Index = () => {
  return (
    <div className="min-h-screen bg-background">
      <FarmHeader />
      <main>
        <FarmHero />
      </main>
      <FarmFooter />
    </div>
  );
};

export default Index;
