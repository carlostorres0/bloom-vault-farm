import { Button } from "@/components/ui/button";
import { Shield, Wallet, TrendingUp } from "lucide-react";
import farmHero from "@/assets/farm-hero.jpg";

const FarmHero = () => {
  return (
    <section className="relative min-h-[80vh] flex items-center justify-center overflow-hidden">
      {/* Background Image */}
      <div 
        className="absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: `url(${farmHero})` }}
      >
        <div className="absolute inset-0 bg-gradient-to-r from-background/80 via-background/40 to-transparent"></div>
      </div>
      
      {/* Content */}
      <div className="container mx-auto px-4 relative z-10">
        <div className="max-w-2xl">
          <div className="space-y-6">
            <div className="space-y-2">
              <h1 className="text-4xl md:text-6xl font-bold text-foreground leading-tight">
                Confidential
                <span className="bg-gradient-harvest bg-clip-text text-transparent block">
                  Agricultural Finance
                </span>
              </h1>
              <p className="text-xl text-muted-foreground max-w-lg">
                Farm yield predictions encrypted until verified by oracle, reducing speculation risk.
              </p>
            </div>

            <div className="flex flex-wrap gap-4">
              <div className="flex items-center gap-2 text-sm text-foreground bg-card/80 backdrop-blur-sm rounded-lg px-3 py-2">
                <Shield className="h-4 w-4 text-accent" />
                Zero-Knowledge Proofs
              </div>
              <div className="flex items-center gap-2 text-sm text-foreground bg-card/80 backdrop-blur-sm rounded-lg px-3 py-2">
                <TrendingUp className="h-4 w-4 text-primary" />
                Oracle Verified Data
              </div>
            </div>

            <div className="flex flex-col sm:flex-row gap-4">
              <Button size="lg" className="bg-primary hover:bg-primary-glow text-primary-foreground">
                <Wallet className="h-5 w-5 mr-2" />
                Connect Wallet & Start
              </Button>
              <Button variant="outline" size="lg" className="border-primary/20 hover:bg-primary/5">
                View Demo Dashboard
              </Button>
            </div>

            <div className="grid grid-cols-3 gap-6 pt-8">
              <div className="text-center">
                <div className="text-2xl font-bold text-accent">$2.4M+</div>
                <div className="text-sm text-muted-foreground">Secured Loans</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-primary">1,200+</div>
                <div className="text-sm text-muted-foreground">Farms Protected</div>
              </div>
              <div className="text-center">
                <div className="text-2xl font-bold text-farm-crop">94%</div>
                <div className="text-sm text-muted-foreground">Accuracy Rate</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Floating Elements */}
      <div className="absolute top-20 right-10 animate-bounce">
        <div className="crop-sway text-4xl">🌾</div>
      </div>
      <div className="absolute bottom-40 right-20 animate-bounce" style={{ animationDelay: '1s' }}>
        <div className="crop-sway text-3xl">🌽</div>
      </div>
    </section>
  );
};

export default FarmHero;