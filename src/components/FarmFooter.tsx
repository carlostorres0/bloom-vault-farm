import { Tractor } from "lucide-react";
import tractorImg from "@/assets/tractor.png";

const FarmFooter = () => {
  return (
    <footer className="relative bg-farm-earth/90 border-t border-border overflow-hidden">
      {/* Animated tractors */}
      <div className="absolute bottom-0 left-0 w-full h-16 pointer-events-none">
        <div className="tractor-animation absolute bottom-2">
          <img src={tractorImg} alt="Tractor" className="h-12 w-auto opacity-60" />
        </div>
        <div className="tractor-animation absolute bottom-2" style={{ animationDelay: '-10s' }}>
          <Tractor className="h-8 w-8 text-farm-earth opacity-40" />
        </div>
      </div>
      
      {/* Digital field pattern */}
      <div className="absolute inset-0 opacity-10">
        <div className="w-full h-full bg-gradient-to-r from-transparent via-farm-crop to-transparent"></div>
      </div>
      
      <div className="container mx-auto px-4 py-12 relative z-10">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          <div>
            <h3 className="font-semibold text-card mb-4">AgriSecure</h3>
            <p className="text-sm text-card/80">
              Confidential agricultural finance platform with encrypted yield predictions.
            </p>
          </div>
          
          <div>
            <h4 className="font-medium text-card mb-3">Platform</h4>
            <ul className="space-y-2 text-sm text-card/70">
              <li><a href="#" className="hover:text-card transition-colors">Dashboard</a></li>
              <li><a href="#" className="hover:text-card transition-colors">Yield Predictions</a></li>
              <li><a href="#" className="hover:text-card transition-colors">Oracle Network</a></li>
            </ul>
          </div>
          
          <div>
            <h4 className="font-medium text-card mb-3">Finance</h4>
            <ul className="space-y-2 text-sm text-card/70">
              <li><a href="#" className="hover:text-card transition-colors">Lending</a></li>
              <li><a href="#" className="hover:text-card transition-colors">Insurance</a></li>
              <li><a href="#" className="hover:text-card transition-colors">Risk Management</a></li>
            </ul>
          </div>
          
          <div>
            <h4 className="font-medium text-card mb-3">Privacy</h4>
            <ul className="space-y-2 text-sm text-card/70">
              <li><a href="#" className="hover:text-card transition-colors">Encryption</a></li>
              <li><a href="#" className="hover:text-card transition-colors">Confidential Computing</a></li>
              <li><a href="#" className="hover:text-card transition-colors">Oracle Verification</a></li>
            </ul>
          </div>
        </div>
        
        <div className="border-t border-border mt-8 pt-8 text-center">
          <p className="text-sm text-card/70">
            © 2024 AgriSecure. Cultivating the future of confidential agricultural finance.
          </p>
        </div>
      </div>
    </footer>
  );
};

export default FarmFooter;